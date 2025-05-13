class RenderingCacher
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

private

  def clear_payloads_on_new_request
    ActiveSupport::Notifications.subscribe("start_processing.action_controller") do |event|
      @transaction_id = ""
      @payloads = []
    end
  end

  def remember_rendering_payloads
    ActiveSupport::Notifications.subscribe("render_partial.action_view") do |event|
      @payloads << event.payload
    end

    ActiveSupport::Notifications.subscribe("render_template.action_view") do |event|
      @payloads << event.payload
    end

    ActiveSupport::Notifications.subscribe("render_layout.action_view") do |event|
      @payloads << event.payload
      @transaction_id = event.transaction_id
      persist_to_disk
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
