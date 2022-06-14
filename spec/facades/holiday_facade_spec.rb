require 'rails_helper'

RSpec.describe HolidayFacade do
  it "exists and, presumably, has holidays" do
    facade = HolidayFacade.new
    expect(facade).to be_a(HolidayFacade)
    expect(facade.upcoming_holidays).to be_a(Array)
    expect(facade.upcoming_holidays).to_not be_empty
  end
end
