class Record < ActiveRecord::Base
  validates :uid, uniqueness: true
end
