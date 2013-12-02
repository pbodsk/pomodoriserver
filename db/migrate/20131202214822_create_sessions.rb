class CreateSessions < ActiveRecord::Migration
  def up    
    create_table :pomodorisessions do |t|
      t.string :username
      t.string :remaining_time
      t.string :status
      t.string :group
      t.timestamp :updated_at
    end
  end

  def down
    drop_table :pomodorisessions
  end
end
