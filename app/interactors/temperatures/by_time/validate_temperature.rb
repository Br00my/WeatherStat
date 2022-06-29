class Temperatures::ByTime::ValidateTemperature
  include Interactor

  def call
    return context.temperature if context.temperature

    if context.time.between?(24.hour.ago, Time.current)
      Temperatures::RegisterPast24Hours::Organize.call

      context.temperature = Temperature.find_by(time: context.time.beginning_of_hour..context.time.end_of_hour)
    else
      context.fail!
    end
  end
end
