class Semester
  include Mongoid::Document
  include Mongoid::Timestamps

  paginates_per 10

  belongs_to :catalog
  has_many :courses

  field :title,       type: String,   default: ""
  field :is_locked,   type: Boolean,  default: false

end