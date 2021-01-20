# frozen_string_literal: true

##
# Handle various game events
module EventHandler
  def process_events
    while (event = SDL2::Event.poll)
      handle(event)
    end
  end

  def handle(event)
    warn event.inspect
    case event
    when SDL2::Event::KeyDown, SDL2::Event::KeyUp
      key_event(event)
    when SDL2::Event::Quit
      quit_event
    end
  end

  def key_event(event)
    case event
    when SDL2::Event::KeyDown
      key_down_event(event)
    when SDL2::Event::KeyUp
      key_up_event(event)
    end
  end

  def key_down_event(_); end
  def key_up_event(_); end

  def quit_event
    p @rs
    @rs.window.destroy
    @rs.active = false
  end
end
