class SwitchAuthorsFromUsersToPeople < ActiveRecord::Migration
  def self.up
    change_table :authors_descriptions do |t|
      t.rename :author_id, :user_id
      t.references :author
    end
    change_table :authors_notes do |t|
      t.rename :author_id, :user_id
      t.references :author
    end
    User.all.each do |u|
      p = u.person
      Description.connection.execute("UPDATE authors_descriptions SET author_id = #{p.id} WHERE user_id = #{u.id}")
      Note.connection.execute("UPDATE authors_notes SET author_id = #{p.id} WHERE user_id = #{u.id}")
    end
    change_table(:authors_descriptions) { |t| t.remove :user_id }
    change_table(:authors_notes) { |t| t.remove :user_id }
    change_column(:authors_descriptions, :author_id, :integer, :null => false)
    change_column(:authors_notes, :author_id, :integer, :null => false)
  end

  def self.down
    change_table :authors_descriptions do |t|
      t.rename :author_id, :person_id
      t.references :author
    end
    change_table :authors_notes do |t|
      t.rename :author_id, :person_id
      t.references :author
    end
    Person.all.each do |p|
      u = p.user
      Description.connection.execute("UPDATE authors_descriptions SET author_id = #{u.id} WHERE person_id = #{p.id}")
      Note.connection.execute("UPDATE authors_notes SET author_id = #{u.id} WHERE person_id = #{p.id}")
    end
    change_table(:authors_descriptions) { |t| t.remove :person_id }
    change_table(:authors_notes) { |t| t.remove :person_id }
    change_column(:authors_descriptions, :author_id, :integer, :null => false)
    change_column(:authors_notes, :author_id, :integer, :null => false)
  end
end
