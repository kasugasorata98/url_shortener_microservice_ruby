class CreateRedirectMappings < ActiveRecord::Migration[7.0]
  def change
    create_table :redirect_mappings do |t|
      t.integer :url_mapping_id
      t.string :target_url
      t.string :short_id

      t.timestamps
    end
    add_index :redirect_mappings, :short_id, unique: true
    add_index :redirect_mappings, :url_mapping_id, unique: true
  end
end
