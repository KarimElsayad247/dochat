require 'faye/websocket'
Faye::WebSocket.load_adapter('thin')

require 'eventmachine'
require 'filewatcher'
require 'pathname'
require 'json'

App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)
    filewatcher = Filewatcher.new([ "../app/assets/builds/tailwind.css" ])

    @loop = nil
    ws.on :open do |event|
      Thread.new(filewatcher, ws) do |fw, websocket|
        fw.watch do |changes|
          changes.each do |filename, event|
            path = Pathname.new(filename)
            basename = path.basename
            puts "Basename: #{basename}"
            websocket.send(JSON.generate({ event: event, filename: basename }))
          end
        end
      end

      @loop = EM.add_periodic_timer(10) { ws.send("WS Connection alive check") }
    end

    ws.on :message do |event|
      puts "Message received"
      ws.send(event.data)
    end

    ws.on :close do |event|
      puts "Close received"
      EM.cancel_timer(@loop)
      p [ :close, event.code, event.reason ]
      ws = nil
    end

    # Return async Rack response
    ws.rack_response

  else
    # Normal HTTP request
    [ 200, { 'Content-Type' => 'text/plain' }, [ 'Hello' ] ]
  end
end
