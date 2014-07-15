class Template < Content
  include Mongoid::Document
  include Mongoid::Timestamps

  field :course_title,  type: String, default: ""
  field :course_number, type: String, default: ""

  embeds_many :requirements, cascade_callbacks: true
  accepts_nested_attributes_for :requirements, :allow_destroy => true
end