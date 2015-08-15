namespace :records do
  task import: :environment do
    ParserWorker.perform_async
  end
end