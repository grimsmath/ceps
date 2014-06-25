class Section < Content
  include Mongoid::Document
  include Mongoid::Timestamps

  field :crn,       type: String,   default: ""
  field :enr_cap,   type: Integer,  default: 0
  field :enr_act,   type: Integer,  default: 0
  field :wait_cap,  type: Integer,  default: 0
  field :wait_act,  type: Integer,  default: 0
end
