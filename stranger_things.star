"""
Stranger Things Christmas Lights
Recreates the iconic alphabet wall from Season 1 where Joyce
communicates with Will through flickering Christmas lights.
"""

load("render.star", "render")
load("schema.star", "schema")

# Valid letters for the alphabet
VALID_LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

# Christmas light colors (classic bulb colors)
LIGHT_COLORS = [
    "#FF0000",  # Red
    "#00FF00",  # Green
    "#0000FF",  # Blue
    "#FFFF00",  # Yellow
    "#FF6600",  # Orange
    "#FF00FF",  # Pink/Magenta
]

# Dim versions for "off" state
DIM_COLOR = "#1a1a1a"

# Background color (dark wall)
WALL_COLOR = "#0a0a0a"

# Letter color (painted on wall)
LETTER_COLOR = "#8B4513"  # Brown, like paint

# Fairy light colors (softer, warmer tones)
FAIRY_COLORS = [
    "#FFD700",  # Warm gold
    "#FF6B6B",  # Soft red
    "#98FB98",  # Pale green
    "#87CEEB",  # Sky blue
    "#FFB6C1",  # Light pink
    "#F0E68C",  # Khaki/warm yellow
]

# Fairy light positions - scattered around the display
# Format: (x, y, color_index)
FAIRY_LIGHTS = [
    # Top edge
    (0, 0, 0), (8, 0, 1), (20, 0, 2), (35, 0, 3), (48, 0, 4), (60, 0, 5),
    # Left edge
    (0, 10, 2), (0, 20, 4), (0, 30, 0),
    # Right edge
    (62, 8, 1), (62, 18, 3), (62, 28, 5),
    # Bottom edge
    (5, 31, 3), (18, 31, 0), (32, 31, 2), (45, 31, 4), (58, 31, 1),
    # Scattered in gaps
    (63, 0, 2), (42, 0, 1), (55, 31, 3),
]

# Default message
DEFAULT_MESSAGE = "RUN"

# Animation timing
FLICKER_FRAMES = 3
LETTER_DISPLAY_FRAMES = 8
PAUSE_FRAMES = 4

def get_light_color(index):
    """Get a consistent color for each light position."""
    return LIGHT_COLORS[index % len(LIGHT_COLORS)]

def create_fairy_lights(frame):
    """Create twinkling fairy lights around the display."""
    children = []

    for i in range(len(FAIRY_LIGHTS)):
        light = FAIRY_LIGHTS[i]
        x = light[0]
        y = light[1]
        color_idx = light[2]

        # Create pseudo-random twinkle pattern based on position and frame
        # Each light has its own twinkle rhythm
        twinkle = (frame + i * 3) % 5

        if twinkle < 3:
            # Light is on
            color = FAIRY_COLORS[color_idx]
        else:
            # Light is dim
            color = "#222222"

        children.append(
            render.Padding(
                pad = (x, y, 0, 0),
                child = render.Box(
                    width = 1,
                    height = 1,
                    color = color,
                ),
            )
        )

    return children

def create_alphabet_row(letters, start_x, y, lit_letter, frame):
    """Create a row of letters with lights above them."""
    children = []
    letter_width = 4
    light_size = 2
    spacing = 1

    for i in range(len(letters)):
        letter = letters[i]
        x = start_x + i * (letter_width + spacing)

        # Determine if this letter's light should be lit
        is_lit = letter == lit_letter

        # Add flickering effect when lit
        if is_lit:
            # Flicker effect: alternate between bright and slightly dim
            if frame % 2 == 0:
                light_color = get_light_color(ord(letter) - ord('A'))
            else:
                light_color = get_light_color(ord(letter) - ord('A'))
        else:
            light_color = DIM_COLOR

        # Light bulb (circle approximation with small box)
        children.append(
            render.Padding(
                pad = (x + 1, y, 0, 0),
                child = render.Box(
                    width = light_size,
                    height = light_size,
                    color = light_color,
                ),
            )
        )

        # Letter below the light
        children.append(
            render.Padding(
                pad = (x, y + 3, 0, 0),
                child = render.Text(
                    content = letter,
                    font = "tom-thumb",
                    color = LETTER_COLOR,
                ),
            )
        )

    return children

def create_frame(lit_letter, frame):
    """Create a single frame with the specified letter lit."""
    children = []

    # Add twinkling fairy lights around the edges
    children.extend(create_fairy_lights(frame))

    # Row 1: A-H (8 letters, 39px wide) - centered at x=12
    row1 = "ABCDEFGH"
    children.extend(create_alphabet_row(row1, 12, 3, lit_letter, frame))

    # Row 2: I-Q (9 letters, 44px wide) - centered at x=10
    row2 = "IJKLMNOPQ"
    children.extend(create_alphabet_row(row2, 10, 12, lit_letter, frame))

    # Row 3: R-Z (9 letters, 44px wide) - centered at x=10
    row3 = "RSTUVWXYZ"
    children.extend(create_alphabet_row(row3, 10, 21, lit_letter, frame))

    return render.Stack(children = children)

def main(config):
    """Main entry point for the Tidbyt app."""
    message = config.str("message", DEFAULT_MESSAGE).upper()

    # Filter to only valid letters
    filtered = []
    for i in range(len(message)):
        c = message[i]
        if c in VALID_LETTERS:
            filtered.append(c)
    message = "".join(filtered)

    if not message:
        message = DEFAULT_MESSAGE

    frames = []
    global_frame = 0

    # Create animation frames
    for i in range(len(message)):
        letter = message[i]
        # Flicker on effect (quick flashes)
        for f in range(FLICKER_FRAMES):
            if f % 2 == 0:
                frames.append(create_frame(letter, global_frame))
            else:
                frames.append(create_frame("", global_frame))
            global_frame += 1

        # Hold the letter lit
        for f in range(LETTER_DISPLAY_FRAMES):
            frames.append(create_frame(letter, global_frame))
            global_frame += 1

        # Brief pause (all lights dim)
        for f in range(PAUSE_FRAMES):
            frames.append(create_frame("", global_frame))
            global_frame += 1

    # Add final pause
    for f in range(PAUSE_FRAMES * 2):
        frames.append(create_frame("", global_frame))
        global_frame += 1

    return render.Root(
        delay = 100,  # 100ms per frame
        child = render.Box(
            color = WALL_COLOR,
            child = render.Animation(children = frames),
        ),
    )

def get_schema():
    """Define the configuration schema for the app."""
    return schema.Schema(
        version = "1",
        fields = [
            schema.Text(
                id = "message",
                name = "Message",
                desc = "The message to spell out with the lights (letters only)",
                icon = "lightbulb",
                default = DEFAULT_MESSAGE,
            ),
        ],
    )
