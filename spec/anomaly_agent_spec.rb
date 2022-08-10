require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::AnomalyAgent do
  before(:each) do
    @valid_options = Agents::AnomalyAgent.new.default_options
    @checker = Agents::AnomalyAgent.new(:name => "AnomalyAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!
  end

  describe "#working?" do
    describe "when expected_receive_period_in_days is set" do
      it "returns false when more than expected_receive_period_in_days have passed since the last event was received" do
        @agent.options['expected_receive_period_in_days'] = 1
        @agent.save!
        expect(@agent).not_to be_working
        Agents::JavaScriptAgent.async_receive @agent.id, [events(:bob_website_agent_event).id]
        expect(@agent.reload).to be_working
        two_days_from_now = 2.days.from_now
        allow(Time).to receive(:now) { two_days_from_now }
        expect(@agent.reload).not_to be_working
      end
    end
  end

  describe "#receive" do
    describe "when anomalies exist" do
      it "outputs appropriate events" do
        Agents::JavaScriptAgent.async_receive @agent.id, [events(:bob_website_agent_event).id]
        expect(@agent.reload).to be_working
        two_days_from_now = 2.days.from_now
        allow(Time).to receive(:now) { two_days_from_now }
        expect(@agent.reload).not_to be_working
      end
    end
  end

  def test_data
    CSV.table("spec/support/data.csv").map(&:to_h)
  end

  def numeric_data
    test_data.map { |v| [v[:num1], v[:num2]] }
  end

end
