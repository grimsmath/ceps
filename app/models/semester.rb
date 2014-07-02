class Semester
  include Mongoid::Document
  include Mongoid::Timestamps

  paginates_per 10

  belongs_to :catalog
  has_many :courses, after_add: :inc_course_count, after_remove: :dec_course_count

  field :title,       type: String,   default: ""
  field :is_locked,   type: Boolean,  default: false

  def total_sections
    courses.each do |course|
      counter += course.sections.count
    end
  end

  def inc_course_count(course)
    p course.title + ' inc_course_count called'
    catalog = Catalog.where(id: catalog_id).first
    catalog.inc(course_count: 1)
  end

  def dec_course_count(course)
    p course.title + ' dec_course_count called'
    catalog = Catalog.where(id: catalog_id).first
    catalog.inc(course_count: -1)
  end
end