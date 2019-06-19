class ApplicationController < ActionController::API

  def render_json response, code
    render json: response, status: code
  end
end
