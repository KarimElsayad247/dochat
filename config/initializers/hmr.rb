# Hot Markup Replacement

Rails.application.config.after_initialize do
  Hmr.new
end
