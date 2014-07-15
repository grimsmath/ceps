class Template < Content
  include Mongoid::Document
  include Mongoid::Timestamps

  field :course_title,  type: String, default: ""
  field :course_number, type: String, default: ""
  field :weight,        type: Float,  default: .50
end