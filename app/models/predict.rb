class Predict

  def self.predict_enrollment(course, start_semester_id, end_semester_id)
    start_semester = Semester.where(id: start_semester_id)
    end_semester = Semester.where(id: end_semester_id)

    prerequisites = []

    if course.requirements.exists?
      prerequisites = course[:requirements]
    end






    return prerequisites, start_semester, end_semester
  end

end