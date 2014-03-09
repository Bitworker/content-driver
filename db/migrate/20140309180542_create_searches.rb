class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string   :request_site
      t.datetime :created_at
    end
  end
end
