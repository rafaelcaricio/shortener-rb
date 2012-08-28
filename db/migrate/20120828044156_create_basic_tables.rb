class CreateBasicTables < ActiveRecord::Migration
  def up
    create_table :shortened_urls do |t|
      t.string :original_url
      t.timestamps
    end
    add_index :shortened_urls, :original_url

    create_table :access_to_urls do |t|
      t.string :browser_name
      t.integer :shortened_url_id
      t.timestamps
    end
    add_index :access_to_urls, :shortened_url_id
  end

  def down
    drop_table :shortened_urls
    drop_table :access_to_urls
  end
end
