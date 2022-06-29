class Temperatures::ByTime::Organize
  include Interactor::Organizer

  organize Temperatures::ByTime::SetTime,
           Temperatures::ByTime::SetTemperature,
           Temperatures::ByTime::ValidateTemperature
end
