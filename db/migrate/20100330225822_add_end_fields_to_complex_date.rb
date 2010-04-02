class AddEndFieldsToComplexDate < ActiveRecord::Migration
  def self.up
    add_column :complex_dates, :year_end, :integer
    add_column :complex_dates, :season_end_id, :integer
    add_column :complex_dates, :month_end, :integer
    add_column :complex_dates, :day_end, :integer
    add_column :complex_dates, :day_of_week_end_id, :integer
    add_column :complex_dates, :time_of_day_end_id, :integer
    add_column :complex_dates, :hour_end, :integer
    add_column :complex_dates, :minute_end, :integer
    add_column :complex_dates, :rabjung_end_id, :integer
    add_column :complex_dates, :intercalary_month_end_id, :integer
    add_column :complex_dates, :intercalary_day_end_id, :integer
  end

  def self.down
    remove_column :complex_dates, :year_end
    remove_column :complex_dates, :season_end_id
    remove_column :complex_dates, :month_end
    remove_column :complex_dates, :day_end
    remove_column :complex_dates, :day_of_week_end_id
    remove_column :complex_dates, :time_of_day_end_id
    remove_column :complex_dates, :hour_end
    remove_column :complex_dates, :minute_end
    remove_column :complex_dates, :intercalary_month_end_id
    remove_column :complex_dates, :intercalary_day_end_id
  end
end
