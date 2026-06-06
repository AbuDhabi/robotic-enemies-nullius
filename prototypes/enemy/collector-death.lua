data:extend({
  {
    type = "explosion",
    name = "ren-data-collector-die",
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
            entity_name = "nuclear-reactor-explosion",
          },
          {
            type = "create-entity",
            entity_name = "big-scorchmark-tintable",
            check_buildability = true,
          },
        },
      },
    },
  },
})
