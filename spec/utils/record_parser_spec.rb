require "rails_helper"

describe Utils::RecordParser, vcr: { record: :new_episodes } do
  let(:parser) { Utils::RecordParser.new }
  describe "#get_page" do
    it "returns proper page" do
      page = parser.send(:get_page, "B")
      expect(page).to include("Andrey Bykov")
    end
  end

  describe "#run" do
    context "when executing parser" do
      before(:all) do
        VCR.use_cassette "run" do
          Utils::RecordParser.new.run
        end
      end
      it "creates new records" do
        expect(Record.where(name: "Dmitry Victorovich Artemiev").exists?).to be true
      end

      it "creates new records which fields was empty" do
        expect(Record.where("name = 'Vadim Bogdanov' and credential = 'PfMP'").exists?).to be true
        expect(Record.where("name = 'Vadim Bogdanov' and credential = 'PMP'").exists?).to be true
      end

      context "when table is actual" do
        VCR.use_cassette "run" do
          it "doesn't add any records" do
            expect { parser.run }.not_to change(Record, :count)
          end
        end
      end
    end
  end
end