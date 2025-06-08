# Watches requests and records necessary info required to render
# an identical-looking template later.
class RenderingCacher
  # Example Payload:
  #       "identifier": "/home/user/project/app/views/home/index.html.erb",
  #       "layout": "layouts/application",
  #       "locals": {}
  attr_reader :payloads, :transaction_id, :session_info, :controller, :env

  def initialize
    init_class_attributes
    clear_payloads_on_new_request
    remember_rendering_payloads
    remember_request_info
  end

  def payload_contains?(filename)
    @payloads.any? do |payload|
      payload[:identifier] == filename
    end
  end

  def template
    # Example
    # [ "home", "user", "project", "app", "views", "home", "index.html.erb"]
    template_path = @template[:identifier].split("/")

    # Example
    # "index.html.erb" -> "index"
    template_file_name = template_path[-1].split(".").first

    # Example
    # "home/index"
    "#{template_path[-2]}/#{template_file_name}"
  end

  def template_locals
    @template[:locals]
  end

private

  def init_class_attributes
    @template = nil
    @transaction_id = ""
    @payloads = []
    @session_info = {}
    @controller = {}
    @env = {}
  end

  def clear_payloads_on_new_request
    ActiveSupport::Notifications.subscribe("start_processing.action_controller") do
      @template = nil
      @transaction_id = ""
      @payloads = []
      @request_cycle_active = true
    end
  end

  def remember_request_info
    remember_session_info
    remember_controller_info
    remember_request_env
  end

  def remember_session_info
    ActiveSupport::Notifications.subscribe("request.action_dispatch") do |event|
      @session_info = {
        session_id: event.payload[:request].session[:session_id],
        _csrf_token: event.payload[:request].session[:_csrf_token]
      }
    end
  end

  def remember_controller_info
    ActiveSupport::Notifications.subscribe("process_action.action_controller") do |event|
      @controller = {
        name: event.payload[:controller],
        action: event.payload[:action],
        instance_variables: marshalled_instance_variables_for_controller(event.payload)
      }
    end
  end

  def marshalled_instance_variables_for_controller(payload)
    controller = payload[:request].env["action_controller.instance"]
    non_private_instance_variables = controller.instance_variable_names.filter do |var|
      !var.starts_with?("@_")
    end

    {
      instance_variable_names: non_private_instance_variables,
      marshalled_variables: non_private_instance_variables.map do |var|
        Marshal.dump(controller.instance_variable_get(var))
      end
    }
  end

  def remember_request_env
    ActiveSupport::Notifications.subscribe("process_action.action_controller") do |event|
      @env = event.payload[:request].env
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
      puts event.payload
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
      payloads: @payloads,
      session_info: @session_info,
      controller: @controller,
      env: @env
    }
  end
end
