class RecordsController < ActionController::Base
  def index
    @records = Record.page(params[:page])
    render layout: "application"
  end

  def import
    Utils::RecordParser.new.run
    redirect_to root
  end
end