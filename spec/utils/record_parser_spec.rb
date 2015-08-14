require "rails_helper"

describe Utils::RecordParser do
  let(:parser) { Utils::RecordParser.new }
  describe "#get_page" do
    it "returns proper page" do
      page = parser.send(:get_page, "B")
      expect(page).to include("Andrey Bykov")
    end
  end
  context "when executing parser" do
    before(:all) { Utils::RecordParser.run }
    it "creates new persons" do
      expect(Utils::Record.find_by_name("Anand Kumar B")).not_to be_nil
    end
  end
end