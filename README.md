# Stranger Things Christmas Lights for Tidbyt

A Tidbyt app that recreates Joyce Byers' iconic Christmas lights alphabet wall from Stranger Things Season 1.

![Preview](stranger_things.gif)

## Features

- 3 rows of letters (A-H, I-Q, R-Z) with colored Christmas lights above each
- Flickering animation - lights flash before staying lit to spell out your message
- Configurable message - defaults to "RUN" but you can customize it
- Classic Christmas light colors - red, green, blue, yellow, orange, pink

## Requirements

- [Pixlet](https://tidbyt.dev/docs/build/installing-pixlet) - Tidbyt's development tool

## Usage

### Preview in browser

```bash
pixlet serve stranger_things.star
```

Then open http://localhost:8080 to see the app and configure the message.

### Render with a custom message

```bash
pixlet render stranger_things.star message="HELP"
```

### Push to your Tidbyt

```bash
pixlet push <your-device-id> stranger_things.star
```

To find your device ID, check the Tidbyt mobile app under Settings.

## Configuration

| Option | Description | Default |
|--------|-------------|---------|
| `message` | The message to spell out with the lights (letters only) | `RUN` |

## Examples

```bash
# Spell out "HELP"
pixlet render stranger_things.star message="HELP"

# Spell out "RUN"
pixlet render stranger_things.star message="RUN"

# Spell out a name
pixlet render stranger_things.star message="MIKE"
```
