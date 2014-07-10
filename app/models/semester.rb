class Semester
  include Mongoid::Document
  include Mongoid::Timestamps

  paginates_per 10

  belongs_to :catalog
  has_many :courses, after_add: :inc_course_count, after_remove: :dec_course_count

  field :title,       type: String,   default: ""
  field :is_locked,   type: Boolean,  default: false
  field :year,        type: Integer,  default: ""

  def full_title
    "#{title} " + "#{year}"
  end

  def total_sections
    courses.each do |course|
      counter += course.sections.count
    end
  end

  def self.previous_semester(semester_id)
    current = where(id: semester_id).first
    year = current.year - 1
    title = nil

    case current.title
      when 'Fall'
        title = 'Summer'
      when 'Spring'
        title = 'Fall'
      when 'Summer'
        title = 'Spring'
    end

    previous = where(year: year).where(title: title)

    return previous
  end

  def self.next_semester(semester_id)
    current = where(id: semester_id).first
    year = current.year + 1
    title = nil

    case current.title
      when 'Fall'
        title = 'Spring'
      when 'Spring'
        title = 'Summer'
      when 'Summer'
        title = 'Fall'
    end

    previous = where(year: year).where(title: title)

    return previous
  end

  def self.all_sorted(direction)
    Semester.order_by(:year, direction).order_by(:title, desc)
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