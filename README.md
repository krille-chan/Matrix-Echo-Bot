# Matrix Echo Bot

A dead simple echo bot for testing.

## Prerequisites

- [Dart SDK](https://dart.dev/get-dart) (^3.1.0)
- [Rust toolchain](https://rustup.rs/) (for building vodozemac)
- Git

## Building

1. Clone the repository:
```bash
git clone https://github.com/krille-chan/matrix-dart-chatgpt.git
cd matrix-dart-chatgpt
```

2. Install Dart dependencies:
```bash
dart pub get
```

3. Build vodozemac:
```bash
mkdir -p build
cd build
git clone https://github.com/famedly/dart-vodozemac.git
mv ./dart-vodozemac/rust ./
rm -rf dart-vodozemac
cd rust
cargo build --release
cd ../..
```

4. Compile the bot:
```bash
dart compile exe ./bin/matrix_echo_bot.dart --output ./build/matrix_echo_bot.exe
```

## Configuration

1. Copy the sample configuration file:
```bash
cp config.sample.json config.json
```

2. Edit `config.json` and fill in your credentials:
   - `matrixId`: Your Matrix ID (e.g., @user:matrix.org)
   - `password`: Your Matrix password (or use `accessToken` instead)
   - `accessToken`: Alternative to password - a Matrix access token
   - `homeserver`: Your Matrix homeserver URL (default: https://matrix.org)
   - `allowList`: Optional list of Matrix IDs allowed to interact with the bot (empty = allow all)
   - `passphrase`: Optional passphrase for encrypted rooms
   - `welcomeMessage`: Optional custom welcome message sent when users first interact with the bot or sends "help"

## Running

### Development mode:
```bash
dart run bin/matrix_echo_bot.dart
```

### Production mode (after building):
```bash
./build/matrix_echo_bot.exe
```

Make sure the `config.json` file is in the same directory as the executable, or in the current working directory.