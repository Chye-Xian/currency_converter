class ConvertsController < ApplicationController
  #require 'rubygems'
  #require 'exchange'
  
  def index
  end
  
  def show
    render 'app/views/layouts/widget.js.erb'
  end
  
  def create
    require 'exchange'
    @amount = params[:amount].to_f
    @date = params[:date].split("-")
    @result = @amount.in(params[:fromCurr].to_sym, at: Time.gm(@date[0],@date[1],@date[2]))
              .to(params[:toCurr].to_sym).to_f
    render
  end
end
