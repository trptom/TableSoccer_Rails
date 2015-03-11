class AddAttendanceReminders < ActiveRecord::Migration
  def self.up
    add_column :users, :attendance_reminder, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :attendance_reminder
  end
end