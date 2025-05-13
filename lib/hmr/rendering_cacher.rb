class RenderingCacher
  # Example Payload:
  #       "identifier": "/home/user/project/app/views/home/index.html.erb",
  #       "layout": "layouts/application",
  #       "locals": {}
  attr_reader :payloads, :transaction_id

  def initialize
    clear_payloads_on_new_request
    remember_rendering_payloads
  end

  def payload_contains?(filename)
    @payloads.any? do |payload|
      payload[:identifier] == filename
    end
  end

  def template
    # [ "home", "user", "project", "app", "views", "home", "index.html.erb"]
    template_path = @template[:identifier].split("/")

    # "index.html.erb" -> "index"
    template_file_name = template_path[-1].split(".").first

    # "home/index"
    "#{template_path[-2]}/#{template_file_name}"
  end

  def template_locals
    @template[:locals]
  end

private

  def clear_payloads_on_new_request
    ActiveSupport::Notifications.subscribe("start_processing.action_controller") do
      @template = nil
      @transaction_id = ""
      @payloads = []
      @request_cycle_active = true
    end
  end

  def remember_rendering_payloads
    ActiveSupport::Notifications.subscribe("render_partial.action_view") do |event|
      if @request_cycle_active
        @payloads << event.payload
      end
    end

    ActiveSupport::Notifications.subscribe("render_template.action_view") do |event|
      if @request_cycle_active
        @template = event.payload
        @payloads << event.payload
      end
    end

    ActiveSupport::Notifications.subscribe("render_layout.action_view") do |event|
      if @request_cycle_active
        @payloads << event.payload
        @transaction_id = event.transaction_id
        persist_to_disk
        @request_cycle_active = false
      end
    end
  end

  def subscribe_to_everything
    ActiveSupport::Notifications.subscribe(/.*/) do |event|
      puts "Received event: #{event.name}"
    end
  end

  def persist_to_disk
    File.open("#{Rails.root}/tmp/render_cache.json", "w") do |file|
      file.write(JSON.pretty_generate(attrs_as_object))
    end
  end

  def attrs_as_object
    {
      transaction_id: @transaction_id,
      payloads: @payloads
    }
  end
end
