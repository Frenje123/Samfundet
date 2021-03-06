class ChangeEventsCodewordDefaultToEmptyString < ActiveRecord::Migration[5.1]
  def change
    change_column_default :events, :codeword, ""

    # Code to update existing events
    Event.find_each do |event|
      event.codeword = event.codeword.nil? ? "" : event.codeword
      event.save
    end
  end
end
