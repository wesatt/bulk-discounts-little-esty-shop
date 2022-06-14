class HolidayFacade

  def upcoming_holidays
    service.holidays.map do |holiday|
      Holiday.new(holiday)
    end
  end
  
private
  def service
    HolidayService.new
  end
end
