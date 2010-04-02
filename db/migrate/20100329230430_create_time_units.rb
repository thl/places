class CreateTimeUnits < ActiveRecord::Migration
  def self.up
    create_table :time_units do |t|
      t.integer :date_id
      t.integer :start_date_id
      t.integer :end_date_id
      t.integer :calendar_id
      t.boolean :is_range
      t.integer :dateable_id
      t.string :dateable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :time_units
  end
end
