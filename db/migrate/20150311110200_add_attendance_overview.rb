class AddAttendanceOverview < ActiveRecord::Migration
  def self.up
    add_column :users, :attendance_overview, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :attendance_overview
  end
end