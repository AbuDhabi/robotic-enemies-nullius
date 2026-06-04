-- Fusion-reactor sprites bundled under graphics/fusion-reactor/ (from Castra Prime Assets, GPL-3.0).

local PREFIX = "__robotic-enemies-nullius__/graphics/fusion-reactor/"

local M = {}

function M.spawner_graphics_set()
  return {
    animations = {
      {
        layers = {
          {
            filename = PREFIX .. "fusion-reactor-hr-shadow.png",
            priority = "high",
            width = 700,
            height = 600,
            frame_count = 1,
            line_length = 1,
            repeat_count = 60,
            draw_as_shadow = true,
            animation_speed = 0.3,
            scale = 0.5,
          },
          {
            priority = "high",
            width = 400,
            height = 400,
            animation_speed = 0.3,
            scale = 0.5,
            filename = PREFIX .. "fusion-reactor-hr-animation.png",
            frame_count = 60,
            line_length = 8,
          },
          {
            priority = "high",
            width = 400,
            height = 400,
            animation_speed = 0.3,
            scale = 0.5,
            filename = PREFIX .. "fusion-reactor-hr-animation-emission.png",
            frame_count = 60,
            line_length = 8,
            draw_as_glow = true,
            blend_mode = "additive",
          },
        },
      },
    },
    reset_animation_when_frozen = true,
  }
end

function M.spawner_icon()
  return PREFIX .. "fusion-reactor-icon.png"
end

return M
