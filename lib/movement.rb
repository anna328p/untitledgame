# frozen_string_literal: true

require 'matrix'

##
# Handle movement keys
module Movement
  ACCEL = 10
  FRICTION = 2
  COEFF = 0.3
  MAX_VEL = 20

  def key_dirs
    dx = dy = 0

    @cs.get_key(:up)    && dy -= 1
    @cs.get_key(:down)  && dy += 1
    @cs.get_key(:left)  && dx -= 1
    @cs.get_key(:right) && dx += 1

    Vector[dx, dy]
  end

  def norm_scale(vec, factor)
    if vec.norm.zero?
      Vector[0, 0]
    else
      vec.normalize * factor
    end
  end

  def motion_vector
    move_dir = norm_scale(key_dirs, ACCEL)
    res = @cs.vel + move_dir
    friction = norm_scale(res, FRICTION) + (res * COEFF)

    move = res - friction

    move.norm < FRICTION ? Vector[0, 0] : move
  end

  def do_movement
    @cs.vel = motion_vector
    @state.pos_x += @cs.vel[0]
    @state.pos_y += @cs.vel[1]

    debug_move_data
  end

  def debug_move_data
    @rs.debug_text += format(
      "vel %6.2f [%6.2f, %6.2f] x %9.2f y %9.2f\n",
      @cs.vel.norm, @cs.vel[0], @cs.vel[1], @state.pos_x, @state.pos_y)
  end
end
