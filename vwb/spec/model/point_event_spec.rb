require 'rails_helper'

RSpec.describe PointEvent, :type => :model do
	subject {
		described_class.new(name: "Event Name",
							description: "Sample Description",
							points: 2,
							eventType: "Cowabunga")
	}
	
	it "is valid with valid attributes" do
		expect(subject).to be_valid
	end

	it "is valid without a description" do
		subject.description = nil
		expect(subject).to be_valid
	end

	it "is not valid without a name" do
		subject.name = nil
		expect(subject).to_not be_valid
	end

	it "is not valid without points" do
		subject.points = nil
		expect(subject).to_not be_valid
	end

	it "is valid with 0 points" do
		subject.points = 0
		expect(subject).to be_valid
	end

	it "is not valid with negative points" do
		subject.points = -1
		expect(subject).to_not be_valid
	end

	it "is not valid without an event type" do
		subject.eventType = nil
		expect(subject).to_not be_valid
	end
end