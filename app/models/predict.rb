class Predict

  def self.predict_enrollment(course, start_semester_id, end_semester_id)

    start_semester = Semester.where(id: start_semester_id).first
    end_semester = Semester.where(id: end_semester_id).first

    prerequisites = course.requirements

    return start_semester, end_semester, prerequisites
  end

end