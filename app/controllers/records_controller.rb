class RecordsController < ActionController::Base
  def index
    @records = Record.page(params[:page])
    render layout: "application"
  end

  def import
    ParserWorker.perform_async
  end
end