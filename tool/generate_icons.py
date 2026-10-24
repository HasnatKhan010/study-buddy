"""Generate the Study Buddy launcher icons from the app's teal sun mark."""

from math import cos, pi, sin
from pathlib import Path

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parents[1]
SIZE = 1024
image = Image.new("RGB", (SIZE, SIZE), "#117C78")
draw = ImageDraw.Draw(image)
center = SIZE // 2

for index in range(12):
    angle = 2 * pi * index / 12
    x1 = center + 236 * cos(angle)
    y1 = center + 236 * sin(angle)
    x2 = center + 280 * cos(angle)
    y2 = center + 280 * sin(angle)
    draw.line((x1, y1, x2, y2), fill="#FFFFFF", width=36)
    for x, y in ((x1, y1), (x2, y2)):
        draw.ellipse((x - 18, y - 18, x + 18, y + 18), fill="#FFFFFF")

draw.ellipse((center - 174, center - 174,
              center + 174, center + 174), fill="#FFFFFF")

outputs = {
    ROOT / "web" / "favicon.png": 32,
    ROOT / "web" / "icons" / "Icon-192.png": 192,
    ROOT / "web" / "icons" / "Icon-512.png": 512,
    ROOT / "web" / "icons" / "Icon-maskable-192.png": 192,
    ROOT / "web" / "icons" / "Icon-maskable-512.png": 512,
}
for density, pixels in (("mdpi", 48), ("hdpi", 72), ("xhdpi", 96),
                        ("xxhdpi", 144), ("xxxhdpi", 192)):
    outputs[ROOT / "android" / "app" / "src" / "main" / "res" /
            f"mipmap-{density}" / "ic_launcher.png"] = pixels

for path, pixels in outputs.items():
    path.parent.mkdir(parents=True, exist_ok=True)
    image.resize((pixels, pixels), Image.Resampling.LANCZOS).save(path)
