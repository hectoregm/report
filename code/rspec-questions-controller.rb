require 'spec_helper'

describe QuestionsController do
  before :each do
    @building = mock_model(Building, id: "building_1",
                           placed_at_account_id: 1,
                           service_location_account_id: 1,
                           recommendations_valid: true,
                           locations: [])
    Building.stub(:find) { @building }
    @bpa = mock_model(BuildingProfileAnswer, id: "bpa_1", to_partial_path: "questions/text")
    PEATEngine.stub(:next_question) { @bpa }
  end

  describe "GET 'next'" do
    it "gets the next question" do
      PEATEngine.should_receive(:next_question).and_return(@bpa)
      get :next, { building_id: "building_id"}
    end
  end
  
  # ...
end