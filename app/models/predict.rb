class Predict


  def self.enrollment(course_number, current_semester_id, start_semester_id, end_semester_id)
    return_hash   = {}
    req_enrolled  = []

    # This array will hold all of enrollment for the course spanning the semesters, this
    # will be one of the arrays used in the prediction model
    course_enrolled = Course.all_enrolled_between(course_number, start_semester_id, end_semester_id)

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
        req_enrolled << Course.all_enrolled_between(req_course.number, start_semester_id, end_semester_id)
      end

      #
      # The following block removes any entries in the requirements hash that don't exist in the
      # the courses hash, this ensures that we are only using comparable semester data
      #
      items_to_remove = []
      req_enrolled.each do |req|
        req.each_key do |key|
          if course_enrolled.has_key?(key) == false
            items_to_remove << key
          end
        end

        # remove the unwanted semesters of data from the array
        items_to_remove.each do |item|
          req.delete(item)
        end
      end

      #
      # We need to calculate the predicted enrollment based on courses that have pre-reqs
      #
      prediction = {}
      req_enrolled.each do |req|
        req_values = req.values
        prediction[req] = enrollment_with_requirements(course_enrolled.values.to_a, req_values)
      end

      #
      # If there are more than 1 pre-req, we need to calculate the average
      #
      average = 0
      prediction.values.each do |value|
        average += value[:predicted_enrollment].to_f
      end

      req_average = (average / prediction.length).round(2)

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
        predicted_enrollment: req_average
      }
    else
      #
      # Course does not have pre-reqs
      #
    end

    return return_hash
  end

  protected
    def self.course_enrollment(dataset)
      return calculate_enrollment(dataset.values.to_a)
    end

    def self.requirement_enrollment(requirements)
      # we may have multiple pre-requisite course data, so iterate each pre-req course
      results = {}
      requirements.each do |req|
        my_array = req.values
        results[req] = calculate_enrollment(my_array)
      end

      return results
    end

    def self.enrollment_without_requirements(dataset)
      growth_factors = []

      for i in 0..dataset.length
        if dataset[i + 1].nil? == false
          growth_factors << (dataset[i].to_f / dataset[i + 1].to_f).round(2)
        end
      end

      growth_factor_average = (growth_factors.sum.to_f / growth_factors.size).round(2)

      p dataset

      predicted_enr = (dataset.last * growth_factor_average).round(2)

      return predicted_enr
    end

    def self.enrollment_with_requirements(course_data, requirement_data)
      growth_factors = []

      course_data.each_with_index do |item, index|
        if index != 0
          growth_factors << item.to_f / requirement_data.fetch(index - 1)
        end
      end

      growth_factor_average = (growth_factors.sum.to_f / growth_factors.size).round(2)

      predicted_enr = (course_data[course_data.count -1].to_f * growth_factor_average).round(2)

      return {
        growth_factor_avg: growth_factor_average,
        predicted_enrollment: predicted_enr
      }
    end
end