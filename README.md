# NoSave Chat

NoSave Chat is a small Android app for starting chats without saving a phone number first. Enter a number with country code, then open it in WhatsApp, Telegram, or Signal.

The app is built with [Dioxus 0.7](https://dioxuslabs.com/) and Tailwind CSS.

## Features

- Open WhatsApp chats with `wa.me` links.
- Open Telegram phone links.
- Open Signal phone links.
- Mobile-first Dioxus layout.
- Catppuccin-inspired Tailwind theme.

## Requirements

- Rust
- Dioxus CLI `0.7`
- Android SDK, NDK, and emulator tooling
- Tailwind CSS CLI

Useful targets:

```sh
rustup target add aarch64-linux-android
rustup target add x86_64-linux-android
```

## Development

Run Tailwind in one terminal:

```sh
tailwindcss -i ./tailwind.css -o ./assets/tailwind.css --watch
```

Run the Android app in another terminal:

```sh
dx serve --android
```

The generated stylesheet is committed at `assets/tailwind.css` because automatic Tailwind generation through `dx serve --android` may not run consistently in this project.

## Build

Build a release Android App Bundle for ARM64 phones:

```sh
dx bundle --android --release --package-types aab --target aarch64-linux-android
```

Build an APK for local install/testing:

```sh
dx bundle --android --release --package-types apk --target aarch64-linux-android
```

For x86_64 emulators, use:

```sh
dx bundle --android --release --package-types apk --target x86_64-linux-android
```

## Project Layout

```text
assets/
  favicon.ico
  tailwind.css
src/
  components/
    hero.rs
  views/
    home.rs
    layout.rs
  main.rs
tailwind.css
Cargo.toml
Dioxus.toml
```

## Notes

This app is currently mobile-only. It does not use Dioxus fullstack features. A future local history feature can be implemented with local device storage and does not require a backend.
