class Predict

  def self.enrollment(course_number, current_semester_id, start_semester_id, end_semester_id)
    return_hash   = {}
    req_enrolled  = []
    prediction    = {}

    # This array will hold all of enrollment for the course spanning the semesters, this
    # will be one of the arrays used in the prediction model
    course_enrolled = [course_number, Course.all_enrolled_between(course_number, start_semester_id, end_semester_id)]

    #
    # This is the main course object we are concerned about
    #
    my_course = Course.where(number: course_number).and(semester_id: current_semester_id).first

    #
    # Next we need to get all of the pre-requisite enrollment data elements
    #
    if my_course.requirements.exists?
      #
      # Course has requirements, co-req or pre-req or both
      #
      requirements = my_course[:requirements]

      # for each of the requirements, we need to get their respective enrollments for the same timespan
      requirements.each do |req|
        req_course = Course.where(id: req[:course_id]).first
        req_enrolled << [req_course.number, { corequirement: req[:corequirement] },
                         Course.all_enrolled_between(req_course.number, start_semester_id, end_semester_id)]
      end

      #
      # We need to calculate the predicted enrollment based on courses that have pre-reqs/co-reqs
      #
      req_enrolled.each do |req|
        if req[1][:corequirement] == true
          # Co-requisite
          prediction[req] = enrollment_without_requirements(course_enrolled, req)
        else
          # Pre-requisite
          prediction[req] = enrollment_with_requirements(course_enrolled, req)
        end
      end

      #
      # If there are more than 1 pre-req, we need to calculate using the weighting
      #
      creqs = []
      preqs = []
      prediction.each do |pre|
        if pre[0][1][:corequirement] == true
          creqs << [pre[0][0], pre[1][:predicted_enrollment]]
        else
          req = requirements.find { |record| record[:number] == pre[0][0] }
          preqs << [pre[0][0], pre[1][:predicted_enrollment], req[:weight]]
        end
      end

      # get the weighted prediction of all the pre-reqs
      p_result = 0.0
      preqs.each do |pre|
        my_prediction = pre[1] * pre[2]
        p_result += my_prediction
      end

      predicted_enr = 0
      unless creqs.nil?
        unless creqs.empty?
          if creqs.max[1] > p_result
            predicted_enr = creqs.max[1]
          else
            predicted_enr = p_result
          end
        else
          predicted_enr = p_result
        end
      else
        predicted_enr = p_result
      end

      #
      # This is what we are going to return to the
      #
      return_hash = {
        course_id: my_course.id.to_s,
        course_title: my_course.title,
        course_number: my_course.number,
        course_enrollment: course_enrolled,
        course_requirements: requirements,
        prediction_dataset: prediction.to_a,
        predicted_enrollment: predicted_enr.round(2)
      }
    else
      #
      # Course does not have pre-reqs
      #
      prediction = Course.all_enrolled_between(my_course[:number], start_semester_id, end_semester_id)

      enrolled = []

      enr_past = Course.all_enrolled(course_number, start_semester_id)
      enr_current = Course.all_enrolled(course_number, end_semester_id)

      prediction.each do |pre|
        enrolled << pre[1]
      end

      p enrolled

      # growth_rate = (enr_current - enr_past).to_f / enr_past.to_f
      growth_rate = enrolled.growth.wma.round_to(4)
      growth_rate_percent = enrolled.growth.wma.as_percent(3)

      # Need to calculate a better growth rate and then add it
      # to the latest enrollment in the set
      unless growth_rate < 0.25
        predicted_enr = enr_current * growth_rate
      else
        predicted_enr = enrolled.median
      end

      p predicted_enr

      return_hash = {
        course_id: my_course.id.to_s,
        course_title: my_course.title,
        course_number: my_course.number,
        course_enrollment: course_enrolled,
        course_requirements: nil,
        prediction_dataset: prediction.to_a,
        predicted_enrollment: predicted_enr.round(2),
        growth_rate: growth_rate,
        growth_rate_percent: growth_rate_percent
      }
    end

    return return_hash
  end

  protected
    # -----------------------------------------------------------------------------
    # This method calculates the enrollment of a course the does not have a pre-req
    # -----------------------------------------------------------------------------
    def self.enrollment_without_requirements(course_data, req_data)
      course_array  = Array.new
      req_array     = Array.new

      #
      # Sort the hashes accordingly
      #
      course_data[1].each do |record|
        course_array << [catalog: record[0][:catalog],
                         semester_year: record[0][:semester_year],
                         semester_title: record[0][:semester_title],
                         enrollment: record[1]]
      end

      course_array.sort_by! { |record| [record[0][:catalog], record[0][:semester_year]] }

      req_data[2].each do |record|
        req_array << [catalog: record[0][:catalog],
                      semester_year: record[0][:semester_year],
                      semester_title: record[0][:semester_title],
                      enrollment: record[1]]
      end

      req_array.sort_by! { |record| [record[0][:catalog], record[0][:semester_year]] }

      values = []
      course_array.each do |c|
        req = req_array.find { |r| [r[0][:catalog], r[0][:semester_year], r[0][:semester_title]] ==
                                   [c[0][:catalog], c[0][:semester_year], c[0][:semester_title]] }
        values << [course: c[0][:enrollment], req: req[0][:enrollment]]
      end

      coreqs = []
      values.each do |v|
        coreqs << v[0][:req]
      end

      ratios = []
      coreqs.each_slice(2).each do |set|
        ratios << set[1].to_f / set[0].to_f
      end

      growth_factor = ratios.mean

      enr = coreqs.last * growth_factor

      return {
        growth_factor_avg: growth_factor,
        predicted_enrollment: enr
      }

      return enr
    end

    # -----------------------------------------------------------------------------
    # This method calculates the enrollment of a course that has a pre-req
    # -----------------------------------------------------------------------------
    def self.enrollment_with_requirements(course_data, req_data)
      course_array  = Array.new
      req_array     = Array.new

      #
      # Sort the hashes accordingly
      #
      course_data[1].each do |record|
        course_array << [catalog: record[0][:catalog],
                         semester_year: record[0][:semester_year],
                         semester_title: record[0][:semester_title],
                         enrollment: record[1]]
      end

      course_array.sort_by! { |record| [record[0][:catalog], record[0][:semester_year]] }

      req_data[2].each do |record|
        req_array << [catalog: record[0][:catalog],
                      semester_year: record[0][:semester_year],
                      semester_title: record[0][:semester_title],
                      enrollment: record[1]]
      end

      req_array.sort_by! { |record| [record[0][:catalog], record[0][:semester_year]] }

      #
      # Calculate growth factors
      #
      growth_factors  = []
      values          = []

      course_array.each do |c|
        p c
        req = req_array.find { |r| [r[0][:catalog], r[0][:semester_year], r[0][:semester_title]] ==
                                   [c[0][:catalog], c[0][:semester_year], c[0][:semester_title]] }

        unless req.nil?
          values << [course: c[0][:enrollment], req: req[0][:enrollment]]
        end
      end

      courses = []
      prereqs = []
      values.each do |v|
        courses << v[0][:course]
        prereqs << v[0][:req]
      end

      # we don't want the first element in the courses array because we are calculating pre-reqs
      courses.shift

      # We don't want the first element in the prereqs array because we are calculating pre-reqs
      prereqs = prereqs.drop_last

      courses.each_with_index do |item, index|
        growth_factors << item.to_f / prereqs[index].to_f
      end

      growth_factor_average = (growth_factors.sum.to_f / growth_factors.size).round(2)

      predicted_enr = (courses.last.to_f * growth_factor_average).round(2)

      return {
        growth_factor_avg: growth_factor_average,
        predicted_enrollment: predicted_enr
      }
    end

    # -----------------------------------------------------------------------------
    # This method calculates the enrollment of a course that has a pre-req
    # -----------------------------------------------------------------------------
    # def self.course_enrollment(course, begin_semester_id, end_semester_id)
    #   p Course.all_enrolled_between(course[:number], begin_semester_id, end_semester_id)
    # end

    # -----------------------------------------------------------------------------
    # This method calculates the enrollment of a course that has a pre-req
    # -----------------------------------------------------------------------------
    # def self.requirement_enrollment(requirements)
    #   # we may have multiple pre-requisite course data, so iterate each pre-req course
    #   results = {}
    #   requirements.each do |req|
    #     my_array = req.values
    #     results[req] = calculate_enrollment(my_array)
    #   end
    #
    #   return results
    # end
end