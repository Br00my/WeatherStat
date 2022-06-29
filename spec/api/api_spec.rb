require 'rails_helper'

RSpec.describe API do
  let(:valid_timestamp) { 1656388630 }
  let(:invalid_timestamp) { 0 }

  describe 'GET /health' do
    before { send :get, '/health' }

    it 'returns OK response' do
      expect(response.body).to eq '"OK"'
    end

    it 'returns status 200' do
      expect(response.status).to eq 200
    end
  end

  describe 'GET /weather/current' do
    before do
      VCR.use_cassette 'weather/current' do
        send :get, '/weather/current'
      end
    end

    it 'returns current time temperature' do
      expect(response.body).to eq '28.3'
    end

    it 'return 200 status' do
      expect(response.status).to eq 200
    end
  end

  describe 'GET /weather/historical' do
    before do
      VCR.use_cassette 'weather/historical_24' do
        send :get, '/weather/historical'
      end
    end

    it 'returns temperatures within past 24 hours' do
      expect(response.body).to eq Entities::Temperature.represent(Temperature.all).to_json
    end

    it 'return 200 status' do
      expect(response.status).to eq 200
    end
  end

  describe 'GET /weather/by_time' do
    context 'valid params' do
      before do
        VCR.use_cassette 'weather/historical_24' do
          Temperatures::RegisterPast24Hours::Organize.call
          send :get, '/weather/by_time', params: { timestamp: valid_timestamp }
        end
      end

      it 'returns temperature at given time' do
        expect(JSON.parse(response.body)['value']).to eq 30.1
      end

      it 'returns 200 status' do
        expect(response.status).to eq 200
      end
    end

    context 'invalid params' do
      before do
        VCR.use_cassette 'weather/historical_24' do
          send :get, '/weather/by_time', params: { timestamp: invalid_timestamp }
        end
      end

      it 'returns temperature at given time' do
        expect(JSON.parse(response.body)['message']).to eq 'No time found'
      end

      it 'returns 200 status' do
        expect(response.status).to eq 404
      end
    end
  end

  describe 'GET /weather/historical/min' do
    before do
      VCR.use_cassette 'weather/historical_24' do
        send :get, '/weather/historical/min'
      end
    end

    it 'returns min temperature' do
      expect(response.body).to eq '28.0'
    end

    it 'returns 200 status' do
      expect(response.status).to eq 200
    end
  end

  describe 'GET /weather/historical/max' do
    before do
      VCR.use_cassette 'weather/historical_24' do
        send :get, '/weather/historical/max'
      end
    end

    it 'returns max temperature' do
      expect(response.body).to eq '34.0'
    end

    it 'returns 200 status' do
      expect(response.status).to eq 200
    end
  end

  describe 'GET /weather/historical/avg' do
    before do
      VCR.use_cassette 'weather/historical_24' do
        send :get, '/weather/historical/avg'
      end
    end

    it 'returns average temperature' do
      expect(response.body).to eq '30.4'
    end

    it 'returns 200 status' do
      expect(response.status).to eq 200
    end
  end
end
