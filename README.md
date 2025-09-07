# Renewable Fireflies - Don't Starve Together Mod

A simple Don't Starve Together mod that makes fireflies respawn at their original location after being picked up, provided the area is clear of objects.

## Features

- Fireflies respawn after a configurable delay (5-30 days)
- Respawn only occurs if the area is clear of objects
- Configurable clear area radius (Small/Medium/Large)
- Debug mode for testing and troubleshooting
- Multiplayer compatible

## Installation

1. Subscribe to this mod on Steam Workshop
2. Launch Don't Starve Together
3. Enable the mod in the Mods menu
4. Configure respawn settings if desired

## Configuration Options

- **Respawn Time**: How many days before fireflies respawn
  - 5 Days
  - 10 Days (default: 20 Days)
  - 30 Days
- **Clear Area Radius**: Size of area that must be clear for respawn
  - Small (1 tile)
  - Medium (2 tiles) - default
  - Large (3 tiles)
- **Debug Mode**: Enable debug messages in console (Off by default)

## How It Works

1. When a firefly is picked up, the mod records its original position
2. After the configured respawn time, the mod checks if the area is clear
3. If clear, a new firefly spawns at the original location
4. The process repeats indefinitely, making fireflies truly renewable

## Development

### Testing
Run tests with: `docker compose up tests`
