class AddTsVectorColumnToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :tsv, :tsvector
    add_index :articles, :tsv, using: 'gin'
  end
end
