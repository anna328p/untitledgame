# frozen_string_literal: true

##
# Handle various game events
module EventHandler
  def handle(event)
    warn event.inspect
    case event
    when SDL2::Event::Quit
      quit_event
    end
  end

  def quit_event
    p @rs
    @rs.window.destroy
    @rs.active = false
  end
end
