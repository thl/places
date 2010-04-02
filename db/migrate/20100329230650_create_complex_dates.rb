class CreateComplexDates < ActiveRecord::Migration
  def self.up
    create_table :complex_dates do |t|
      t.integer :year
      t.integer :year_certainty_id
      t.integer :season_id
      t.integer :season_certainty_id
      t.integer :month
      t.integer :month_certainty_id
      t.integer :day
      t.integer :day_certainty_id
      t.integer :day_of_week_id
      t.integer :day_of_week_certainty_id
      t.integer :am_pm_id
      t.integer :am_pm_certainty_id
      t.integer :time_of_day_id
      t.integer :time_of_day_certainty_id
      t.integer :hour
      t.integer :hour_certainty_id
      t.integer :minute
      t.integer :minute_certainty_id
      t.integer :animal_id
      t.integer :animal_certainty_id
      t.integer :calendrical_id
      t.integer :calendrical_certainty_id
      t.integer :element_certainty_id
      t.integer :element_id
      t.integer :gender_id
      t.integer :gender_certainty_id
      t.integer :intercalary_month_id
      t.integer :intercalary_day_id
      t.integer :rabjung_id
      t.integer :rabjung_certainty_id

      t.timestamps
    end
  end

  def self.down
    drop_table :complex_dates
  end
end
