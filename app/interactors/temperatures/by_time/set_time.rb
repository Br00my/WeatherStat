class Temperatures::ByTime::SetTime
  include Interactor

  def call
    context.time = Time.at(context.timestamp)
  end
end
