# frozen_string_literal: true

puts "Loading HMR Class"

class Hmr
  CHANNEL_NAME = "rails_hmr"

  # Time to wait before sending rendered HTML to the client.
  # Defaults to 0.1 (100ms).
  #
  # When Vite is compiling CSS files, there can be a brief moment
  # where an HTML Element will have Tailwind class that's not included
  # in the bundle previously served to the browser, during which the element
  # will appear as though the class was removed, and when the updated
  # css reaches the browser through HMR, the element will get the desired style.
  #
  # This results in what feels like a flash of unstyled content,
  # which is jarring. Having a delay helps smooth this bump.
  attr_accessor :delay

  # `opts` is the Options hash for the HMR instance. So far, it can only
  # contain :cacher_opts, which is a hash of options to pass to the
  # RenderingCacher instance. :cacher_opts takes:
  #   - persist_to_disk: boolean, defaults to false. If true, the cacher
  #     will attempt to write cached information to disk. Useful for debugging.
  #     This procedure may result in an error because the information contains
  #     marshaled objects, which contain ASCII-8 data, resulting in a JSON
  #     generation error: JSON::GeneratorError ("\xA6" from ASCII-8BIT to UTF-8)
  def initialize(opts = {})
    @cacher = RenderingCacher.new(opts[:cacher_opts])
    @before_render = nil
    @delay = 0.1

    listener = Listen.to("#{Rails.root}/app/views") do |modified, _added, removed|
      puts "modified #{modified}"
      process_modifications(modified)
      process_deletions(removed)
    end

    listener.start
    puts "Listening for View changes"
  end

  # Actions to perform after instantiating a controller instance,
  # and right before rendering HTML. the controller instance is
  # passed to the block.
  def before_render(&block)
    @before_render = block
  end

private

  def process_modifications(modified_files)
    relevant_files_found = false
    modified_files.each do |filename|
      if relevant?(filename)
        puts "Found Relevant Modified file #{filename}"
        FileUtils.touch(Rails.root.join("app", "javascript", "entrypoints", "application.css"))
        relevant_files_found = true
      end
    end

    if relevant_files_found
      sleep @delay
      send_update_to_client(render_to_string)
    end
  end

  def render_to_string
    instance = rebuild_application_controller
    instance.lookup_context.disable_cache do
      instance.render_to_string(
        template: @cacher.template,
        assigns: @cacher.template_locals
      )
    end
  end

  def rebuild_application_controller
    env_for_request = @cacher.env
    request = ActionDispatch::Request.new(env_for_request)
    controller = @cacher.controller[:name].constantize
    request.routes = controller._routes

    instance = controller.new
    instance.set_request! request
    instance.set_response! controller.make_response!(request)

    recorded_instance_variables = @cacher.controller[:instance_variables]
    recorded_instance_variables[:instance_variable_names].each_with_index do |var_name, index|
      unmarshalled_object = Marshal.load(recorded_instance_variables[:marshalled_variables][index])
      instance.instance_variable_set(var_name, unmarshalled_object)
    end

    @before_render.call(instance) if @before_render.present?

    instance
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
