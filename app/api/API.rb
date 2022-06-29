class API < Grape::API
  format :json

  desc 'Sends OK response'
  get :health do
    'OK'
  end

  namespace :weather do
    desc 'Returns current time temperature'
    get :current do
      temperature = WeatherCover.current[0]
      temperature['Temperature']['Metric']['Value']
    end

    desc 'Returns temperatures within past 24 hours'
    get :historical do
      result = Temperatures::RegisterPast24Hours::Organize.call
      present result.temperatures, with: Entities::Temperature
    end

    desc 'Returns temeprature at given timestamp'
    params do
      requires :timestamp, type: Integer, documentation: { example: 1656388630 }
    end
    get :by_time do
      result = Temperatures::ByTime::Organize.call(timestamp: params[:timestamp])

      if result.success?
        present result.temperature, with: Entities::Temperature
      else
        error!({ message: 'No time found' }, 404)
      end
    end

    namespace :historical do
      before do
        @temperatures = Temperatures::RegisterPast24Hours::Organize.call.temperatures
      end

      desc 'Returns max temperature within past 24 hours'
      get :max do
        @temperatures.max_by { |temperature| temperature.value }.value
      end

      desc 'Returns min temperature within past 24 hours'
      get :min do
        @temperatures.min_by { |temperature| temperature.value }.value
      end

      desc 'Returns avg temperature within past 24 hours'
      get :avg do
        (@temperatures.sum(&:value) / @temperatures.size).round(1)
      end
    end
  end

  add_swagger_documentation \
    mount_path: 'swagger/weather',
    info: {
      title: '/weather API',
      description: 'Weather resurce'
    }
end
