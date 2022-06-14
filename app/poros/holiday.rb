class Holiday
  attr_reader :name, :date
  def initialize(attrs)
    @name = attrs[:name]
    @date = attrs[:date]
  end
end
