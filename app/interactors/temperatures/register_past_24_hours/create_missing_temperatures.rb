class Temperatures::RegisterPast24Hours::CreateMissingTemperatures
  include Interactor

  def call
    return unless context.hours

    context.temperatures = WeatherCover.send("past_#{context.hours}_hours").map do |hour_temperature|
      time = hour_temperature['LocalObservationDateTime']
      temperature = Temperature.find_by(time: time)

      temperature || Temperature.create(time: time, value: hour_temperature['Temperature']['Metric']['Value'])
    end
  end
end
