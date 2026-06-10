# Nullius: Hostile Incursion

Robotic enemy outposts for [Nullius](https://github.com/GregorSamsanite/nullius) on Nauvis.

Nullius removes vanilla biters and most combat. This mod adds a hostile von Neumann civilization that reached Nauvis before your terraforming mission: subsurface installations watch for **technological signatures** (`ren-data`) and dispatch walled surface outposts against intruders.

Outposts include laser and flamethrower turrets, land mines, power infrastructure, and mobile units—scouts, raiders, assault tanks, harriers, and walkers—that **stay near their base** until signature pollution triggers an attack. Hostile attack damage scales with Nauvis evolution (1× at zero, **4× at full evolution**). Monitoring nodes heal slowly; mobile units do not regenerate on their own.

Factory machines emit `ren-data` only when their recipes recursively require electronics; plain power draw does not count. Enemy entities never emit pollution or signatures.

On the player side, Nullius demolition gear is realigned to vanilla combat values, a five-tier **Projectile improvements** research chain boosts bullet weapons, and new countermeasure tech unlocks grenades, firearms, gun and acidthrower turrets, laser turrets, and an early stone wall.

**Homepage:** https://github.com/AbuDhabi/robotic-enemies-nullius

## Requirements

- Factorio 2.0
- [Nullius](https://github.com/GregorSamsanite/nullius) 2.0.0 or newer

## Settings

- **Enable hostile incursions on Nauvis** (`ren-enable-robotic-enemies`, default on) — disable to skip enemy base generation.
- **Enable anti-hostile targeting** (`ren-enable-auto-targeting`, default on) — Nullius guns and missiles acquire hostile units; when off, demolition weapons keep Nullius ground-targeting behavior. Requires restart.

## Status

This mod is **purely vibe-coded** — built iteratively with AI assistance rather than a formal design doc or test suite.

Version **0.2.25** is the first public release. Balance, spawning, and edge cases are still being figured out; if you are playing with it, you are a playtester.

**Please report bugs and share suggestions** on the [GitHub issue tracker](https://github.com/AbuDhabi/robotic-enemies-nullius/issues). Reproduction steps, save files, and screenshots help a lot.

## Inspirations

Mechanics and atmosphere are adapted from the Castra family of mods:

- **[Planet Castra](https://mods.factorio.com/mod/castra)** — original concept by Bartz24 and LogicDolphin
- **[Castra Prime](https://github.com/pauldennis2/castra-prime)** — fork maintained by erronius and pauldennis2; primary source for enemy-base logic ported here

[Nullius](https://github.com/GregorSamsanite/nullius) provides the progression and setting this mod is built to fit.

## License

This mod is released under the **GNU General Public License v3.0 (GPL-3.0)**.

That is required, not optional: substantial game logic and structure are derived from **Castra Prime**, which is GPL-3.0. Under the GPL, derivative works must be distributed under the same license. See `LICENSE` and `changelog.txt` for attribution details.
