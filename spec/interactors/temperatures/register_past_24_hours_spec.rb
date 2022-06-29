require 'rails_helper'

RSpec.describe Temperatures::RegisterPast24Hours::Organize do
  describe '.call' do
    context 'missing 7-24 hours in database' do
      it 'creates missing temperatures' do
        VCR.use_cassette 'weather/historical_24' do
          expect { Temperatures::RegisterPast24Hours::Organize.call }.to change(Temperature, :count).by(24)
        end
      end
    end

    context 'missing 1-6 hours in database' do
      it 'creates missing temperatures' do
        18.times { |n| create(:temperature, time: 23.hour.ago + n.hour) }
        VCR.use_cassette 'weather/historical_6' do
          expect { Temperatures::RegisterPast24Hours::Organize.call }.to change(Temperature, :count).by(6)
        end
      end
    end

    context 'no missing hours' do
      it 'does not create temperature' do
        24.times { |n| create(:temperature, time: 23.hour.ago + n.hour) }
        expect { Temperatures::RegisterPast24Hours::Organize.call }.to_not change(Temperature, :count)
      end
    end
  end
end
