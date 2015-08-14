class ParserWorker
  include Sidekiq::Worker
  def perform
    Utils::RecordParser.new.run
  end
end