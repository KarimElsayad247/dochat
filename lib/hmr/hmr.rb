# frozen_string_literal: true

puts "Loading HMR Class"

class Hmr
  CHANNEL_NAME = "rails_hmr"

  def initialize
    @cacher = RenderingCacher.new

    listener = Listen.to("#{Rails.root}/app/views") do |modified, _added, removed|
      puts "modified #{modified}"
      process_modifications(modified)
      process_deletions(removed)
    end

    listener.start
    puts "Listening for View changes"
  end

  def process_modifications(modified_files)
    relevant_files_found = false
    modified_files.each do |filename|
      if relevant?(filename)
        puts "Found Relevant Modified file #{filename}"
        relevant_files_found = true
      end
    end

    if relevant_files_found
      env_for_request = @cacher.env
      request = ActionDispatch::Request.new(env_for_request)
      controller = @cacher.controller[:name].constantize
      request.routes = controller._routes

      instance = controller.new
      instance.set_request! request
      instance.set_response! controller.make_response!(request)
      instance.authenticate
      instance.set_current_request_details

      rendered_html = instance.lookup_context.disable_cache do
        instance.render_to_string(
            template: @cacher.template,
            assigns: @cacher.template_locals
          )
      end
      send_update_to_client(rendered_html)
    end
  end

  def send_update_to_client(new_html)
    ActionCable.server.broadcast CHANNEL_NAME, {
      html: new_html
    }
  end

  def process_deletions(deleted_files)
    deleted_files.each do |filename|
      if relevant?(filename)
        puts "Processing Relevant Deleted file #{filename}"
      end
    end
  end

  def relevant?(filename)
    @cacher.payload_contains?(filename)
  end
end
