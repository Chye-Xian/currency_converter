class ConvertsController < ApplicationController
  #require 'exchange'
  
  protect_from_forgery :except => :create
  before_filter :set_response_header
  
  def index
    render :layout => 'widget.js.erb', :content_type => 'application/javascript'
  end
  
  def show
    render :layout => 'widget.js.erb', :content_type => 'application/javascript'
  end
  
  def create
    require 'exchange'
    @amount = params[:amount].to_f
    @date = params[:date].split("-")
    @result = @amount.in(params[:fromCurr].to_sym, at: Time.gm(@date[0],@date[1],@date[2]))
              .to(params[:toCurr].to_sym).to_f
              
    render :layout => 'widget.js.erb', :content_type => 'application/javascript'
  end
  
  def set_response_header
      response.headers['Access-Control-Allow-Origin'] = '*'
    end
end
