# Enra Sans Font Setup

> ℹ️ **See `FONT_FIX_AND_SETUP.md` in the project root for detailed setup instructions!**

## Status: OPTIONAL (Using Inter as Fallback)

✅ **The font asset error has been fixed!** The app is currently configured to use **Inter** (via Google Fonts) for all text. Adding **Enra Sans** is optional for the alpha version.

## Adding Enra Sans (Optional)

To match the Get Right brand guidelines exactly, you can add the **Enra Sans** font files to this directory.

### Steps:

1. **Obtain Enra Sans Font**
   - Download Enra Sans from your font provider
   - You'll need at least the **Bold** weight (700)
   - Optionally, add Regular (400) and other weights

2. **Add Font Files Here**
   Place the font files in this directory:
   ```
   assets/fonts/
   ├── EnraSans-Bold.ttf (Required)
   ├── EnraSans-Regular.ttf (Optional)
   └── README.md (this file)
   ```

3. **File Format**
   - Use `.ttf` (TrueType Font) or `.otf` (OpenType Font)
   - Ensure file names match exactly as specified in `pubspec.yaml`

### Current Configuration (pubspec.yaml)

```yaml
fonts:
  - family: EnraSans
    fonts:
      - asset: assets/fonts/EnraSans-Bold.ttf
        weight: 700
```

### Fallback

If you don't have access to Enra Sans:
- The app currently uses **Inter** (via Google Fonts) as fallback
- You can temporarily use another bold sans-serif font
- Update `text_styles.dart` to use a different font family if needed

### Verification

After adding the font files:
1. Run `flutter clean`
2. Run `flutter pub get`
3. Restart the app
4. Check the Theme Preview screen to see typography

---

**Note:** Enra Sans is used for all headings, titles, and buttons to maintain the Get Right brand identity.

