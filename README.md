# Open RTS

![Open RTS](./media/screenshots/screenshot_1400x650.png "Open RTS")

Open Source real-time strategy game made with Godot 4.

Originally created as [godot-open-rts](https://github.com/lampe-games/godot-open-rts) by Lampe Games, this repository tracks that upstream codebase while curating a fork that layers in additional space-themed assets, skyline backdrops, and supporting tools tailored for the *Aliens at War II* setting.

## Purposes of this project

This game is not going to be a very advanced RTS that would compete with other games of this genre. Instead, it will focus on simplicity and clean design so that it can:
 - showcase Godot 4 capabilities in terms of developing RTS games
 - provide an open-source project template for creating RTS games
 - educate game creators on creating RTS game mechanics
 - experiment with community-provided city building assets and tools

## Features

 - [x] 1 species
 - [x] 2 resources
 - [x] terrain and air units
 - [x] deathmatch mode (human vs AI or AI vs AI)
 - [x] runtime player switching
 - [x] basic fog of war
 - [x] units disappearing in fog of war
 - [x] minimap
 - [x] swarm movement to position
 - [x] swarm movement to unit
 - [x] simple UI
 - [ ] polished UI
 - [ ] sounds
 - [ ] music
 - [ ] VFX

## Roadmap

See [ROADMAP.md](ROADMAP.md) for the long-term plan inspired by Beyond All Reason's approach to large-scale RTS development.

## Godot compatibility

This project is compatible with Godot `4.3`.

 - support for Godot `4.2` is available on `godot-4.2-support` branch.
 - support for Godot `4.1` is available on `godot-4.1-support` branch.
 - support for Godot `4.0` is available on `godot-4.0-support` branch.

## Screenshots

![Screenshot 1](./media/screenshots/screenshot_2_1920x1080.png "Screenshot 1")

![Screenshot 2](./media/screenshots/screenshot_3_1920x1080.png "Screenshot 2")

![Screenshot 3](./media/screenshots/screenshot_4_1920x1080.png "Screenshot 3")

## Contributing

Everyone is free to fix bugs or perform refactoring just by opening PR. As for features, please refer to existing issue or create one before starting implementation.

## Credits

### Core contributors
 - Pawel Lampe (Lampe Games)
 
### Contributors

See [contributors](https://github.com/lampe-games/godot-open-rts/graphs/contributors) page.

### Assets
This fork adds and maintains the following third-party asset packs on top of the upstream project:
 - 3D Space Kit by [Kenney](https://www.kenney.nl/assets/space-kit)
 - Modular colonies from [KayKit City Builder Bits 1.0](https://github.com/KayKit-Game-Assets/KayKit-City-Builder-Bits-1.0)
 - Mesh ingestion toolchain powered by [meshy-dev/meshy-godot-plugin](https://github.com/meshy-dev/meshy-godot-plugin)

Previously referenced materials from the Egregoria project have been removed to resolve licensing conflicts.

## Third-party content layout

- `res://assets/kenney_space_kit` - Kenney Space Kit ships, structures, and textures
- `res://assets/kaykit_city_builder` - KayKit City Builder Bits 1.0 meshes and textures ready for import
- `res://addons/meshy` - Meshy Godot editor plugin for rapid mesh previews/imports
- `res://third_party` - upstream snapshots retained for tooling and license review

Each dependency keeps its upstream license file intact. Review upstream repositories for full terms before distributing builds.
