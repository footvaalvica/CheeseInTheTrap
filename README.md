# Timchi Global Music Player

## About
This adds a singleton Node to your project that plays music, even across scene changes.

## Usage
1. Install the plugin through the Godot asset manager.
2. Enable the plugin ![Enable Plugin screenshot](/addons/timchi_global_music_player/assets/plugin_enabled.png "Enable Plugin screenshot")
3. Add the node to the Autoload ![Autoload screenshot](/addons/timchi_global_music_player/assets/autoload.png "Autoload screenshot")
4. Music is loaded by default from "res://music". This can be changed with: 
```gdscript
MusicController.TRACKS_LOCATION = "res://your/path/to/music"
MusicController.load_tracks()
```
This does *not* read in tracks from subfolders.

5. Start a track with 
```gdscript
MusicController.switch_track("trackname.ogg|mp3|wav")
```

Tracks loop forever until switched.
Need an example? See [github](https://github.com/atrus6/tgmp_example) for a simple example project.


## Future Roadmap
Right now, the player just plays a single track in a loop. Future plans include

- [ ] Next/Previous track movement
- [ ] Loop/Shuffle/Ordered playthough
- [ ] Track playlists
