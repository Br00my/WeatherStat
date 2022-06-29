class Temperatures::RegisterPast24Hours::Organize
  include Interactor::Organizer

  organize Temperatures::RegisterPast24Hours::SetTemperatures,
           Temperatures::RegisterPast24Hours::SetHours,
           Temperatures::RegisterPast24Hours::CreateMissingTemperatures
end
