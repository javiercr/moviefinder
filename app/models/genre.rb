class Genre < ActiveRecord::Base
  has_and_belongs_to_many :movies
  default_scope :order => "name ASC"
  def to_s
    name
  end
end