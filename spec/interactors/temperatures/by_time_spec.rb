require 'rails_helper'

RSpec.describe Temperatures::ByTime::Organize do
  let(:valid_timestamp) { 1656388630 }
  let(:invalid_timestamp) { 0 }
  let(:end_24_hours) { '2022-06-28 17:00:00 UTC'.to_time }

  describe '.call' do
    context 'with existing temperature' do
      it 'returns temperature at given time' do
        VCR.use_cassette 'weather/historical_24' do
          Temperatures::RegisterPast24Hours::Organize.call
          result = Temperatures::ByTime::Organize.call(timestamp: valid_timestamp)
          expect(result.temperature.value).to eq 30.1
        end
      end
    end

    context 'without existing temperature' do
      context 'time found' do
        it 'returns temperature at given time' do
          VCR.use_cassette 'weather/historical_24' do
            Time.stub(:current) { end_24_hours }
            result = Temperatures::ByTime::Organize.call(timestamp: valid_timestamp)
            expect(result.temperature.value).to eq 30.1
          end
        end
      end

      context 'no time found' do
        it 'returns failed result' do
          VCR.use_cassette 'weather/historical_24' do
            result = Temperatures::ByTime::Organize.call(timestamp: invalid_timestamp)
            expect(result.success?).to be_falsey
          end
        end
      end
    end
  end
end
