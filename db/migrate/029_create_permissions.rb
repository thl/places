class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions, :force => true do |t|
      t.column :title, :string, :limit => 60, :null => false
      t.column :description, :text
    end
    add_index :permissions, :title, :unique => true
    role = Role.find(1)
    p = Permission.create :title => 'roles/index'
    role.permissions << p
    p = Permission.create :title => 'roles/show'
    role.permissions << p
    p = Permission.create :title => 'roles/edit'
    role.permissions << p
    p = Permission.create :title => 'roles/update'
    role.permissions << p
    p = Permission.create :title => 'main/admin'
    role.permissions << p
  end

  def self.down
    drop_table :permissions
  end
end
