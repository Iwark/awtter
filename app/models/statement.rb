class Statement < ActiveRecord::Base
  validates :contents, length: { maximum: 140 }
end
