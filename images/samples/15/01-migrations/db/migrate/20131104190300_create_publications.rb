class CreatePublications < ActiveRecord::Migration[5.2]
    def change
        create_table :publications do |t|
            t.string :title
            t.text :description
            t.references :publication_type
            t.integer :publisher_id
            t.string :publisher_type
            t.boolean :single_issue

            t.timestamps
        end
    end
end
