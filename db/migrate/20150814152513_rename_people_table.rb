class RenamePeopleTable < ActiveRecord::Migration
  def change
    rename_table :people, :records
  end
end
