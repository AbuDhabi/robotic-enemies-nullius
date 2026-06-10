-- Acid stream, ground puddles, and slowdown stickers for the player acidthrower turret.

-- Splatter reads ~#706f06 with ACID_TINT on acid-splash art; stream uses the same art family, slightly brighter.
local ACID_TINT = { r = 0.86, g = 0.76, b = 0.05 }
local SPLASH_TINT = { r = ACID_TINT.r, g = ACID_TINT.g, b = ACID_TINT.b, a = 1 }
local STICKER_TINT = { r = 0.88, g = 0.78, b = 0.07, a = 0.75 }
local STREAM_BRIGHTNESS = 1.18
local STREAM_TINT = {
  r = math.min(ACID_TINT.r * STREAM_BRIGHTNESS, 1),
  g = math.min(ACID_TINT.g * STREAM_BRIGHTNESS, 1),
  b = math.min(ACID_TINT.b * STREAM_BRIGHTNESS, 1),
}
local GROUND_PATCH_SCALE = 0.65
local PATCH_TINT_MULTIPLIER = 0.7
local STREAM_GRAPHICS_SCALE = 0.55

local function acid_splash_pictures(tint, ground_scale)
  local patch_tint = util.multiply_color(tint, PATCH_TINT_MULTIPLIER)
  return {
    {
      layers = {
        {
          filename = "__base__/graphics/entity/acid-splash/acid-splash-1.png",
          draw_as_glow = true,
          line_length = 8,
          width = 210,
          height = 224,
          frame_count = 26,
          shift = util.mul_shift(util.by_pixel(-12, -8), ground_scale),
          tint = tint,
          scale = 0.5 * ground_scale,
        },
        {
          filename = "__base__/graphics/entity/acid-splash/acid-splash-1-shadow.png",
          line_length = 8,
          width = 266,
          height = 188,
          frame_count = 26,
          shift = util.mul_shift(util.by_pixel(2, 2), ground_scale),
          draw_as_shadow = true,
          scale = 0.5 * ground_scale,
        },
      },
    },
    {
      layers = {
        {
          filename = "__base__/graphics/entity/acid-splash/acid-splash-2.png",
          draw_as_glow = true,
          line_length = 8,
          width = 174,
          height = 150,
          frame_count = 29,
          shift = util.mul_shift(util.by_pixel(-9, -17), ground_scale),
          tint = patch_tint,
          scale = 0.5 * ground_scale,
        },
        {
          filename = "__base__/graphics/entity/acid-splash/acid-splash-2-shadow.png",
          line_length = 8,
          width = 238,
          height = 266,
          frame_count = 29,
          shift = util.mul_shift(util.by_pixel(6, 29), ground_scale),
          draw_as_shadow = true,
          scale = 0.5 * ground_scale,
        },
      },
    },
    {
      layers = {
        {
          filename = "__base__/graphics/entity/acid-splash/acid-splash-3.png",
          draw_as_glow = true,
          line_length = 8,
          width = 236,
          height = 208,
          frame_count = 29,
          shift = util.mul_shift(util.by_pixel(22, -16), ground_scale),
          tint = patch_tint,
          scale = 0.5 * ground_scale,
        },
        {
          filename = "__base__/graphics/entity/acid-splash/acid-splash-3-shadow.png",
          line_length = 8,
          width = 214,
          height = 140,
          frame_count = 29,
          shift = util.mul_shift(util.by_pixel(17, 2), ground_scale),
          draw_as_shadow = true,
          scale = 0.5 * ground_scale,
        },
      },
    },
    {
      layers = {
        {
          filename = "__base__/graphics/entity/acid-splash/acid-splash-4.png",
          draw_as_glow = true,
          line_length = 8,
          width = 252,
          height = 154,
          frame_count = 24,
          shift = util.mul_shift(util.by_pixel(17, -19), ground_scale),
          tint = patch_tint,
          scale = 0.5 * ground_scale,
        },
        {
          filename = "__base__/graphics/entity/acid-splash/acid-splash-4-shadow.png",
          line_length = 8,
          width = 248,
          height = 160,
          frame_count = 24,
          shift = util.mul_shift(util.by_pixel(18, -16), ground_scale),
          draw_as_shadow = true,
          scale = 0.5 * ground_scale,
        },
      },
    },
  }
end

-- Dark amber stream tint (flamethrower sprites read orange without this).
local STREAM_SPINE_TINT = { r = 0.42, g = 0.32, b = 0.06, a = 0.38 }
local STREAM_PARTICLE_TINT = { r = 0.48, g = 0.34, b = 0.08, a = 0.42 }

data:extend({
  {
    type = "sticker",
    name = "nullius-acid-sticker",
    flags = { "not-on-map" },
    hidden = true,
    animation = {
      filename = "__base__/graphics/entity/acid-sticker/acid-sticker.png",
      draw_as_glow = true,
      line_length = 5,
      width = 30,
      height = 34,
      frame_count = 50,
      animation_speed = 0.5,
      tint = STICKER_TINT,
      shift = util.by_pixel(1.5, 0),
      scale = 0.5,
    },
    duration_in_ticks = 120,
    target_movement_modifier_from = 0.5,
    target_movement_modifier_to = 1,
    vehicle_speed_modifier_from = 0.5,
    vehicle_speed_modifier_to = 1,
    vehicle_friction_modifier_from = 1.5,
    vehicle_friction_modifier_to = 1,
  },
  {
    type = "fire",
    name = "nullius-acid-splash-fire",
    localised_name = { "entity-name.nullius-acid-splash-fire" },
    flags = { "placeable-off-grid", "not-on-map" },
    hidden = true,
    damage_per_tick = { amount = 0, type = "acid" },
    maximum_damage_multiplier = 3,
    damage_multiplier_increase_per_added_fuel = 1,
    damage_multiplier_decrease_per_tick = 0.005,
    uses_alternative_behavior = true,
    limit_overlapping_particles = true,
    initial_render_layer = "object",
    render_layer = "lower-object-above-shadow",
    secondary_render_layer = "higher-object-above",
    secondary_picture_fade_out_start = 30,
    secondary_picture_fade_out_duration = 60,
    spread_delay = 300,
    spread_delay_deviation = 180,
    maximum_spread_count = 100,
    particle_alpha = 0.6,
    particle_alpha_blend_duration = 300,
    add_fuel_cooldown = 10,
    fade_in_duration = 1,
    fade_out_duration = 30,
    initial_lifetime = 1920,
    lifetime_increase_by = 0,
    lifetime_increase_cooldown = 4,
    maximum_lifetime = 1800,
    delay_between_initial_flames = 10,
    initial_flame_count = 1,
    burnt_patch_lifetime = 0,
    on_damage_tick_effect = {
      type = "direct",
      ignore_collision_condition = true,
      trigger_target_mask = { "ground-unit" },
      filter_enabled = true,
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "create-sticker",
            sticker = "nullius-acid-sticker",
            show_in_tooltip = true,
          },
          {
            type = "damage",
            damage = { amount = 0.2, type = "acid" },
            apply_damage_to_trees = false,
          },
        },
      },
    },
    pictures = acid_splash_pictures(SPLASH_TINT, GROUND_PATCH_SCALE),
  },
  {
    type = "stream",
    name = "nullius-acid-stream",
    flags = { "not-on-map" },
    hidden = true,
    particle_buffer_size = 90,
    particle_spawn_interval = 2,
    particle_spawn_timeout = 8,
    particle_vertical_acceleration = 0.003,
    particle_horizontal_speed = 0.225,
    particle_horizontal_speed_deviation = 0.0035,
    particle_start_alpha = 0.45,
    particle_end_alpha = 0.7,
    particle_start_scale = 0.2,
    particle_loop_frame_count = 15,
    particle_fade_out_threshold = 0.95,
    particle_fade_out_duration = 2,
    particle_loop_exit_threshold = 0.25,
    oriented_particle = true,
    shadow_scale_enabled = true,
    action = {
      {
        type = "area",
        radius = 2.5,
        action_delivery = {
          type = "instant",
          target_effects = {
            {
              type = "create-sticker",
              sticker = "nullius-acid-sticker",
              show_in_tooltip = true,
            },
            {
              type = "damage",
              damage = { amount = 3, type = "acid" },
              apply_damage_to_trees = false,
            },
          },
        },
      },
      {
        type = "direct",
        action_delivery = {
          type = "instant",
          target_effects = {
            {
              type = "create-fire",
              entity_name = "nullius-acid-splash-fire",
              show_in_tooltip = true,
            },
          },
        },
      },
    },
    spine_animation = {
      filename = "__base__/graphics/entity/acid-projectile/acid-projectile-tail.png",
      draw_as_glow = true,
      line_length = 5,
      width = 132,
      height = 20,
      frame_count = 15,
      shift = util.mul_shift(util.by_pixel(0, -1), STREAM_GRAPHICS_SCALE),
      tint = STREAM_TINT,
      priority = "high",
      scale = 0.5 * STREAM_GRAPHICS_SCALE,
      animation_speed = 1,
    },
    shadow = {
      filename = "__base__/graphics/entity/acid-projectile/acid-projectile-shadow.png",
      line_length = 15,
      width = 42,
      height = 164,
      frame_count = 15,
      shift = util.mul_shift(util.by_pixel(-2, 31), STREAM_GRAPHICS_SCALE),
      draw_as_shadow = true,
      priority = "high",
      scale = 0.5 * STREAM_GRAPHICS_SCALE,
      animation_speed = 1,
    },
    particle = {
      filename = "__base__/graphics/entity/acid-projectile/acid-projectile-head.png",
      draw_as_glow = true,
      line_length = 5,
      width = 42,
      height = 164,
      frame_count = 15,
      shift = util.mul_shift(util.by_pixel(-2, 31), STREAM_GRAPHICS_SCALE),
      tint = STREAM_TINT,
      priority = "high",
      scale = 0.5 * STREAM_GRAPHICS_SCALE,
      animation_speed = 1,
    },
  },
})
