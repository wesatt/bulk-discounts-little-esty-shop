require 'rails_helper'

RSpec.describe HolidayService do
  it "does the thing" do
    service = HolidayService.new

    expect(service).to be_a(HolidayService)
    expect(service.holidays).to be_a(Array)
    expect(service.holidays).to_not be_empty
  end
end
