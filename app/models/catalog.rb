class Catalog
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :semesters

  field :title,     type: String,   default: ""
  field :web_link,  type: String,   default: ""
  field :is_locked, type: Boolean,  default: false

  def total_courses
    counter = 0
    semesters.each do |s|
      counter += Course.where(semester_id: s.id).all.count
    end

    return counter
  end

  def total_enrolled
    enrolled = 0
    semesters.each do |s|
      Course.where(semester_id: s.id).each do |c|
        enrolled += c.enr_act
      end
    end

    return enrolled
  end

  def total_waitlisted
    waitlisted = 0
    semesters.each do |s|
      Course.where(semester_id: s.id).each do |c|
        waitlisted += c.wait_act
      end
    end

    return waitlisted
  end

end
