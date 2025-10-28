# Audio Assets

This folder is for audio files used in the app.

## Required Audio Files (Optional)

To enhance the user experience, you can add the following audio files:

1. **ambient_garden.mp3** - Background ambient music
2. **plant_growth.mp3** - Sound when plant grows
3. **water.mp3** - Watering sound when completing a habit
4. **success.mp3** - Success chime for achievements
5. **gentle_bell.mp3** - Gentle notification sound

## Audio Requirements

- Format: MP3 or OGG
- Size: Keep files under 1MB each
- Quality: 128kbps is sufficient for ambient sounds

## Free Audio Resources

- **Freesound.org** - Creative Commons audio
- **ZapSplat** - Free sound effects
- **YouTube Audio Library** - Royalty-free music

## Note

The app works perfectly without audio files. Audio hooks are already in place in `lib/services/audio_service.dart`. Simply add the files and uncomment the play commands.
