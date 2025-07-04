class DocsController < ApplicationController
  def index
    flash.now[:alert] = "display an alert"
  end
end
