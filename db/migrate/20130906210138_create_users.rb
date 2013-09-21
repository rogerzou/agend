class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :net_id
      t.string :ldapkey
      t.string :display_name
      t.string :givenName
      t.string :sn
    	t.string :password_digest
    	t.string :remember_token
    	t.boolean :instructor, default: false
      t.text :student_courses

      t.timestamps
    end

    add_index :users, :net_id
		add_index :users, :remember_token, unique: true
  end

end
