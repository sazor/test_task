class RecordsController < ActionController::Base
  def index
    if params[:search]
      @records = search(params).results
    else
      @records = Record.page(params[:page])
    end
    render layout: "application"
  end

  def import
    ParserWorker.perform_async
  end

  private
  def search(params)
    Record.search do
      fulltext params[:search]
      paginate page: params[:page]
    end
  end
end