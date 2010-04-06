class RemoveAmPmFromComplexDate < ActiveRecord::Migration
  def self.up
    remove_column :complex_dates, :am_pm_id
    remove_column :complex_dates, :am_pm_certainty_id
  end

  def self.down
    add_column :complex_dates, :am_pm_id, :integer
    add_column :complex_dates, :am_pm_certainty_id, :integer
  end
end
