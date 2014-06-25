class Requirement < Content
  include Mongoid::Document
  include Mongoid::Timestamps

  field :course_id, type: String
  field :corequirement, type: Boolean
end
