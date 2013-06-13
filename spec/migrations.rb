class UserMigration < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :users
  end
end

class MigrationHelper
  def self.up
    SimpleSurveyMigration.up
    UserMigration.up
  end

  def self.down
    SimpleSurveyMigration.down
    UserMigration.down
  end
end