class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table(:people, :force => true) { |t| t.string :fullname, :null => false }
    add_index :people, :fullname, :unique => true
    User.reset_column_information
    User.all.each do |u|
      u.create_person(:fullname => u.fullname)
      u.save
    end
    change_table(:users) { |t| t.remove :fullname }
    change_column :users, :person_id, :integer, :null => false
    drop_table :open_id_authentication_associations
    drop_table :open_id_authentication_nonces
  end

  def self.down
    change_table(:users) { |t| t.string :fullname }
    User.reset_column_information
    User.all.each { |user| user.fullname = user.person.fullname }
    change_column :users, :person_id, :integer
    drop_table :people
  end
end