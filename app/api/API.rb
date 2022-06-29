class API < Grape::API
  format :json

  get :health do
    'OK'
  end

  namespace :weather do
    get :current do
      temperature = WeatherCover.current[0]
      temperature['Temperature']['Metric']['Value']
    end

    get :historical do
      result = Temperatures::RegisterPast24Hours::Organize.call
      present result.temperatures, with: Entities::Temperature
    end

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

      get :max do
        @temperatures.max_by { |temperature| temperature.value }.value
      end

      get :min do
        @temperatures.min_by { |temperature| temperature.value }.value
      end

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
