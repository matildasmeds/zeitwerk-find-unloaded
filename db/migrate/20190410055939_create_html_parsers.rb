class CreateHtmlParsers < ActiveRecord::Migration[6.0]
  def change
    create_table :html_parsers do |t|

      t.timestamps
    end
  end
end
