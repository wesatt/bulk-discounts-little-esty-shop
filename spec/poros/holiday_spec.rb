require 'rails_helper'

RSpec.describe Holiday do
  it "exists and has attributes" do
    new_year = Holiday.new({name: "New Years Day", date: "22-01-01"})

    expect(new_year).to be_a(Holiday)
    expect(new_year.name).to eq("New Years Day")
    expect(new_year.date).to eq("22-01-01")
  end
end
