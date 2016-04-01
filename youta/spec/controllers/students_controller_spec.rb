require 'rails_helper'
require 'controllers/helpers'

RSpec.configure do |c|
  c.include ControllerSpecHelpers
end

RSpec.describe StudentsController, :type => :request do
  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:lesson) { FactoryGirl.create(:lesson) }
  let!(:student) { FactoryGirl.create(:ishimoto) }

  describe "#index" do
    it "should display student who subscribes the lesson"
  end

  describe "#create" do
    it "should add 3 new students from csv file"
  end

  describe "#destroy" do
    it "should unsubscribe student but not delete him"
  end

end
