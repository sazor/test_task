class AddUidColumnToRecords < ActiveRecord::Migration
  def change
    add_column :records, :uid, :string, length: 32, uniq: true
  end
end
