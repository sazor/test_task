require "rails_helper"

describe Utils::RecordParser do
  context "when executing parser" do
    before(:all) { Utils::RecordParser.run }
    it "creates new persons" do
      expect(Utils::Record.find_by_name("Anand Kumar B")).not_to be_nil
    end
  end
end