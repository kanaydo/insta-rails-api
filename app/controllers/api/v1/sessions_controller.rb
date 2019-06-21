class Api::V1::SessionsController < ApplicationController

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      status = :ok
      response = {
        status: 200,
        message: "Successfully Login as #{user.username}",
        user: user.attributes.merge(avatar: user.avatar.url)
      }
    else
      status = :unprocessable_entity
      response = {
        status: 422,
        message: "Failed to login because username or password wrong",
        user: User.new.attributes.merge(avatar: nil)
      }
    end
    render json: response, status: status
  end

end
