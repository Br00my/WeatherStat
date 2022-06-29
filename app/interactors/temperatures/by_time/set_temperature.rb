class Temperatures::ByTime::SetTemperature
  include Interactor

  def call
    context.temperature = Temperature.find_by(time: context.time.beginning_of_hour..context.time.end_of_hour)
  end
end
