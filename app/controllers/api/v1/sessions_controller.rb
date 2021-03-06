# frozen_string_literal: true

class Api::V1::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  clear_respond_to
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'Logged.', user: resource }, status: :ok
  end

  def respond_to_on_destroy
    current_user ? log_out_success : log_out_failure
  end

  def log_out_success
    head :no_content
  end

  def log_out_failure
    render json: { message: 'Not logged in' }, status: :bad_request
  end
end
