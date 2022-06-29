class Temperatures::RegisterPast24Hours::SetTemperatures
  include Interactor

  def call
    context.temperatures = Temperature.where(time: 24.hour.ago..Time.current)
  end
end
