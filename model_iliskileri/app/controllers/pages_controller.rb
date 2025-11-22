class PagesController < ApplicationController
  skip_before_action :authenticate_request

  def hello
    render json: { message: 'HELLO WORLD', time: Time.zone.now }
  end
end

