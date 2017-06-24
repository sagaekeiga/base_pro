class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.text :name
      t.text :image
      t.text :country
      t.text :graduate
      t.text :birth
      t.text :height
      t.text :weight
      t.text :style
      t.text :position
      t.text :draft
      t.text :bar
      t.text :career
      t.text :phonetic
      t.text :team

      t.timestamps null: false
    end
  end
end
