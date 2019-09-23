class Catalog
  include Mongoid::Document
  include Mongoid::Timestamps

  paginates_per 20

  has_many :semesters
  has_many :templates

  embeds_many :templates, cascade_callbacks: true
  accepts_nested_attributes_for :templates, :allow_destroy => true

  field :title,         type: String,   default: ""
  field :web_link,      type: String,   default: ""
  field :is_locked,     type: Boolean,  default: false
  field :course_count,  type: Integer,  default: 0

  def total_courses
    return course_count

    # counter = 0
    # semesters.each do |s|
    #   counter += Course.where(semester_id: s.id).all.count
    # end
    #
  end

  def total_enrolled
    return 0

    # enrolled = 0
    # semesters.each do |s|
    #   Course.where(semester_id: s.id).each do |c|
    #     enrolled += c.enr_act
    #   end
    # end
    #
    # return enrolled
  end

  def total_waitlisted
    return 0
    # waitlisted = 0
    # semesters.each do |s|
    #   Course.where(semester_id: s.id).each do |c|
    #     waitlisted += c.wait_act
    #   end
    # end
    #
    # return waitlisted
  end
end
