class Requirement < Content
  include Mongoid::Document
  include Mongoid::Timestamps

  field :course_id,     type: String
  field :corequirement, type: Boolean
  field :constraint,    type: Integer,  default: 0
  field :weight,        type: Float,    default: 0.5
end
