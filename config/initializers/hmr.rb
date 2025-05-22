# Hot Markup Replacement

Rails.application.config.after_initialize do
  hmr = Hmr.new
  hmr.before_render do |controller|
    controller.authenticate
    controller.set_current_request_details
  end
end
