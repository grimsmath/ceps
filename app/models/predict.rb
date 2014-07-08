class Predict

  def self.enrollment(course, start_semester_id, end_semester_id)
    req_enrolled = []

    # This array will hold all of enrollment for the course spanning the two semesters, this
    # will be one of the arrays used in the prediction model
    course_enrolled = Course.all_enrolled_between(course.number, start_semester_id, end_semester_id)

    # Next we need to get all of the pre-requisite enrollment data elements
    if course.requirements.exists?
      course[:requirements].each do |req|
        tmp_course = Course.where(number: req[:course_id]).first
        req_enrolled << Course.all_enrolled_between(tmp_course.number, start_semester_id, end_semester_id)
      end
    end

    # The following block removes any entries in the requirements hash that don't exist in the
    # the courses hash, this ensures that we are only using comparable semester data
    items_to_remove = []
    req_enrolled.each do |req|
      req.each_key do |key|
        if course_enrolled.has_key?(key) == false
          items_to_remove << key
        end
      end

      items_to_remove.each do |item|
        req.delete(item)
      end
    end

    # =====================================================================================================
    # Example Data
    # =====================================================================================================
    # Course	|	Term 1	|	Term 2 	| 	Term 3 	|	  Term 4 	|	  Term 5 	|	  Term 6
    # -----------------------------------------------------------------------------------------------------
    # PRE-REQ	|	  35 		|		40 		|		  42 		|	  	38 		|		  41 		|		  ??
    # COURSE	|	  30 		|		37 		|		  39 		|		  42	  | 	  45		|		  ??
    # =====================================================================================================

    # =====================================================================================================
    # Predicting enrollment in PRE-REQ:
    # =====================================================================================================
    # Growth factor = PRE-REQ enrollment in current term / PRE-REQ enrollment in immediately preceding term
    # Calculate growth factor for term 2 through term 5
    # For the above data, they are: 40/35, 42/40, 38/42, 41/38 approx. 1.14, 1.05, 0.90, 1.08
    # Take the average of the growth factors calculated: (1.14+1.05+0.90+1.08)/4 = 1.04
    # Enrollment in Term 6 = Enrollment in Term 5 * average growth factor = 41 * 1.04 = 43
    # =====================================================================================================

    # we may have multiple pre-requisite course data, so iterate each pre-req course
    req_enrolled.each do |req|

      p req.values

      growth_factors = []
      my_array = req.values

      for i in 0..my_array.length
        if my_array[i + 1].nil? == false
          growth_factors << (my_array[i].to_f / my_array[i + 1].to_f).round(2)
        end
      end

      p growth_factors

      growth_factor_average = (growth_factors.sum.to_f / growth_factors.size).round(2)

      p my_array.last * growth_factor_average
    end


    # =====================================================================================================
    # Predicting enrollment in COURSE:
    # =====================================================================================================
    # Growth factor = COURSE enrollment in current term / COURSE enrollment in immediately preceding term
    # Calculate growth factor for term 2 through term 5
    # For the above data, they are: 37/35, 39/40, 42/42, 45/38 approx. 114, 0.98, 1, 1.18
    # Take the average of the growth factors calculated: (1.14+0.98+1+1.18)/4 = 1.08
    # Enrollment in term 6 = Enrollment in Term 5 * average growth factor = 45 * 1.08 = 49
    # =====================================================================================================


    return course_enrolled, req_enrolled
  end
end