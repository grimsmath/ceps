class Requirement < Content
  include Mongoid::Document
  include Mongoid::Timestamps

  field :course_id,     type: String
  field :corequirement, type: Boolean
  field :constraint,    type: Integer,  default: 0
  field :weight,        type: Float,    default: 0.5

  def self.import(file, semester_id, worksheet_id)
    spreadsheet = open_spreadsheet(file)

    spreadsheet.default_sheet = spreadsheet.sheets[worksheet_id]

    # accommodate the header
    header = spreadsheet.row(1)

    # Begin the import
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      # look for existing course, if not found, create a new one, otherwise use existing
      course = Course.find_by(semester_id: semester_id, number: row["course"]) || new

      # 1st Corequisite
      coreq1 = row["coreq1"]
      unless coreq1.nil?
        course = Course.where(number: coreq1).first
        unless course.nil?
          req = Requirement.new
          req.corequirement = true
          course.requirements << req
        end
      end

      # 2nd Corequisite
      coreq2 = row["coreq2"]
      unless coreq2.nil?
        course = Course.where(number: coreq2).first
        unless course.nil?
          req = Requirement.new
          req.course_id = course.id
          req.corequirement = true
          req.constraint = row["condition1"]
          course.requirements << req
        end
      end

      # 1st Pre-requisite
      prereq1 = row["prereq1"]
      unless prereq1.nil?
        course = Course.where(number: prereq1).first
        unless course.nil?
          req = Requirement.new
          req.course_id = course.id
          course.requirements << req
        end
      end

      # 2nd Pre-requisite
      prereq2 = row["prereq2"]
      unless prereq2.nil?
        course = Course.where(number: prereq2).first
        unless course.nil?
          req = Requirement.new
          req.course_id = course.id
          req.constraint = row["condition2"]
          course.requirements << req
        end
      end

      # 3rd Pre-requisite
      prereq3 = row["prereq3"]
      unless prereq3.nil?
        course = Course.where(number: prereq3).first.id
        unless course.nil?
          req = Requirement.new
          req.course_id = course.id
          course.requirements << req
        end
      end

      # 4th Pre-requisite
      prereq4 = row["prereq4"]
      unless prereq4.nil?
        course = Course.where(number: prereq4).first
        unless course.nil?
          req = Requirement.new
          req.course_id = course.id
          req.constraint = row["condition3"]
          course.requirements << req
        end
      end

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
