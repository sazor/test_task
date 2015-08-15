class Record < ActiveRecord::Base
  validates :uid, uniqueness: true

  searchable do
    text    :name, :city, :country, :credential
    boolean :status
    date    :earned
  end
end
