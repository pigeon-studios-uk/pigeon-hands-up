# Changelog

All notable changes to Pigeon Hands Up are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html):

- **Major** versions can need changes to your configuration or other resources. Read the **Upgrade notes**.
- **Minor** versions add features without breaking existing setups.
- **Patch** versions fix bugs only.

## [Unreleased]

First release.

### Highlights

- Hands up on a key, walking or standing still
- Kneel with hands behind the head
- No shooting, aiming or melee while surrendering
- A `handsUp` state bag and exports for police resources
- 23 languages

### Added

- Hands up with one key (X by default, which players can change in GTA's key bindings) or `/handsup`, on the upper body so players can walk, or standing still with `Config.WalkWithHandsUp = false`.
- Kneeling with hands behind the head with `/kneel` or a key players choose, getting down and up with GTA's arrest animations.
- Shooting, aiming, melee and the weapon wheel turned off while surrendering, and moving too while kneeling.
- Letting go by itself when the player is knocked over, dies, gets into a vehicle or another animation plays.
- A replicated `handsUp` player state bag (`'up'`, `'kneel'` or `nil`), and `IsHandsUp` and `IsKneeling` client exports.
- Messages and key binding names in 23 languages, following ox_lib's language with `Config.Locale = 'auto'`.
- Update checker from the Pigeon Studios version registry.

[Unreleased]: https://github.com/pigeon-studios-uk/pigeon-hands-up/commits/main
