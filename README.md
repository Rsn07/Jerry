# Jerry - AI Dev Assistant (Ultra)

This Flutter project is prepared for cloud build (GitHub Actions). It includes:
- AI-powered generation (OpenRouter / Hugging Face)
- In-app code editor and WebView preview
- Voice input (speech_to_text)
- Project save/export helper

**Important:** API keys are NOT included. Open `lib/services/ai_service.dart` and replace the placeholders:
- YOUR_OPENROUTER_KEY_HERE
- YOUR_HUGGINGFACE_KEY_HERE

Then upload this repo to GitHub and use the included GitHub Actions workflow to build the APK.
