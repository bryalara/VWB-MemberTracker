require 'rails_helper'

RSpec.describe User, :type => :model do
	subject {
		described_class.new(email: "test@tamu.edu",
							role: 0,
							firstName: "John",
							lastName: "Doe",
                            phoneNumber: "1234567890",
                            classification: "Freshman",
                            tShirtSize: "M",
                            optInEmail: true,
                            participationPoints: 5,
                            approved: true)
	}
    it "is valid with valid attributes" do
		expect(subject).to be_valid
	end

	it "is not valid without a email" do
		subject.email = nil
		expect(subject).to_not be_valid
	end

	it "is not valid without role" do
		subject.role = nil
		expect(subject).to_not be_valid
	end

	it "is not valid with out of range role" do
		subject.role = 3
		expect(subject).to_not be_valid
	end

	it "is not valid with out first name" do
		subject.firstName = nil
		expect(subject).to_not be_valid
	end

	it "is not valid with out last name" do
		subject.lastName = nil
		expect(subject).to_not be_valid
	end

	it "is not valid with out phone number" do
		subject.phoneNumber= nil
		expect(subject).to_not be_valid
	end

	it "is not valid with out full 10 digit phone number" do
		subject.phoneNumber= "123456789"
		expect(subject).to_not be_valid
	end

	it "is not valid with out classification" do
		subject.classification= nil
		expect(subject).to_not be_valid
	end

	it "is not valid with out t-shirt size" do
		subject.tShirtSize= nil
		expect(subject).to_not be_valid
	end

	it "is not valid with out optInEmail" do
		subject.optInEmail= nil
		expect(subject).to_not be_valid
	end

	it "is not valid with out points" do
		subject.participationPoints= nil
		expect(subject).to_not be_valid
	end

	it "is not valid with negative points" do
		subject.participationPoints= -1
		expect(subject).to_not be_valid
	end

	it "is valid with 0 points" do
		subject.participationPoints= 0
		expect(subject).to be_valid
	end
end
    