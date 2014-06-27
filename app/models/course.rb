require "roo"

class Course
  include Mongoid::Document
  include Mongoid::Timestamps

  paginates_per 10

  belongs_to :semester

  embeds_many :sections, cascade_callbacks: true
  accepts_nested_attributes_for :sections, :allow_destroy => true

  embeds_many :requirements, cascade_callbacks: true
  accepts_nested_attributes_for :requirements, :allow_destroy => true

  field :title,       type: String,   default: ""
  field :number,      type: String,   default: ""
  field :description, type: String,   default: ""
  field :credits,     type: Integer,  default: 0
  field :url,         type: String,   default: ""
  field :is_locked,   type: Boolean,  default: false

  scope :by_semester, -> (semester_id) { where(semester_id: semester_id) }
  scope :by_number, -> (number) { where(number: number) }

  def self.unique_courses
    map = %Q{
      function () {
        emit(this.number, {course : this});
      }
    }

    reduce = %Q{
      function (key, values) {
        var ret = {
          course:[]
        };

        var course = {};

        values.forEach(function (value) {
          if (!course[value.course.number]) {
            ret.course.push(value.course);
            course[value.course.number] = true;
          }
        });

        return ret;
      }
    }

    Course.all.map_reduce(map, reduce).out(inline: true).to_a
  end

  def name_with_number
    "#{number} - #{title}"
  end

  def self.import(file, semester_id, worksheet_id)
    spreadsheet = open_spreadsheet(file)

    spreadsheet.default_sheet = spreadsheet.sheets[worksheet_id]

    # accommodate the header
    header = spreadsheet.row(1)

    # Begin the import
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      # look for existing course, if not found, create a new one, otherwise use existing
      course = Course.find_by(semester_id: semester_id, number: row["number"]) || new

      # update existing section details
      section = Section.new
      section.crn = row["crn"]
      section.enr_cap = row["enr_cap"]
      section.enr_act = row["enr_act"]
      section.wait_cap = row["wait_cap"]
      section.wait_act = row["wait_act"]

      # update the course details
      course.title = row["title"]
      course.number = row["number"]
      course.credits = row["credits"]
      course.semester_id = semester_id
      course.sections << section

      # save the document
      course.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end
end