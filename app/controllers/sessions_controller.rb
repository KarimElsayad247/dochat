class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ new create ]
  layout "signed_out"

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_to root_path, notice: "Signed in successfully"
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: "Wrong email or password"
    end
  end

  def destroy
    @session = Current.user.sessions.find(params[:id])
    @session.destroy; redirect_to(sessions_path, notice: "That session has been logged out")
  end
end
