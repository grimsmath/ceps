class Content
  include Mongoid::Document

  embedded_in :course

  field :content, type: String
end
