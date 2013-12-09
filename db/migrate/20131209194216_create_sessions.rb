class CreateSessions < ActiveRecord::Migration
  def up
    create_table :sessions do |t|
      t.string :username
      t.string :remainingtime
      t.string :status
      t.string :group
      t.timestamps
    end
  end

  def down
    drop_table :sessions
  end
end
