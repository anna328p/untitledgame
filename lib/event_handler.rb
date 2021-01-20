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
    kc = SDL2::Key.keycode_from_scancode(event.scancode)

    case event
    when SDL2::Event::KeyDown
      @cs.keys_down.add kc
    when SDL2::Event::KeyUp
      @cs.keys_down.delete kc
    end
  end

  def quit_event
    @rs.window.destroy
    @rs.active = false
  end
end
