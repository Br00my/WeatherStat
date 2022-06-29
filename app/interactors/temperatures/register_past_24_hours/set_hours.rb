class Temperatures::RegisterPast24Hours::SetHours
  include Interactor

  def call
    if context.temperatures.size < 18
      context.hours = 24
    elsif context.temperatures.size < 24
      context.hours = 6
    else
      context.hours = nil
    end
  end
end
