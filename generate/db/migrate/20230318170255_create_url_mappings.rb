class CreateUrlMappings < ActiveRecord::Migration[7.0]
  def change
    create_table :url_mappings do |t|
      t.string :target_url
      t.string :short_id

      t.timestamps
    end

    add_index :url_mappings, :short_id, unique: true
  end
end
