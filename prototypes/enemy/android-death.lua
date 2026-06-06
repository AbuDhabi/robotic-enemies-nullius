-- Unit dying_explosion only reliably runs created_effect; spawn a visible burst separately.
data:extend({
  {
    type = "explosion",
    name = "ren-android-die",
    flags = { "not-on-map" },
    hidden = true,
    subgroup = "explosions",
    animations = util.empty_sprite(),
    created_effect = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = {
          {
            type = "create-explosion",
            entity_name = "inserter-explosion",
          },
          {
            type = "create-entity",
            entity_name = "small-scorchmark-tintable",
            check_buildability = true,
          },
        },
      },
    },
  },
})
