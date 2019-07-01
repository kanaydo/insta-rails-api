class Api::V1::SessionsController < ApplicationController

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      status = :ok
      response = user.session_seccess
    else
      status = :unprocessable_entity
      response = User.session_failed
    end
    render json: response, status: status
  end

end
