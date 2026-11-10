"""Check that the game runs in a browser and that the keys work."""
import io
import sys
import time

from PIL import Image
from playwright.sync_api import sync_playwright

URL = "http://localhost:8000/pong_3d.html"


with sync_playwright() as p:
    browser = p.chromium.launch(args=["--use-gl=swiftshader", "--ignore-gpu-blocklist"])
    # About the size of the iframe on the website
    page = browser.new_page(viewport={"width": 600, "height": 300})
    errors = []
    page.on("pageerror", lambda e: errors.append(str(e)))
    page.goto(URL)
    time.sleep(3)
    page.mouse.click(300, 150)
    before = page.screenshot()
    time.sleep(0.5)
    after_wait = page.screenshot()
    for _ in range(3):
        page.keyboard.press("w")
        page.keyboard.press("ArrowDown")
    time.sleep(1)
    after_keys = page.screenshot()
    browser.close()

if errors:
    sys.exit(f"Page errors: {errors}")
if before == after_wait:
    sys.exit("The game is not running: the page did not change")
if after_wait == after_keys:
    sys.exit("Pressing keys did not change the page")
img = Image.open(io.BytesIO(after_keys)).convert("L")
w, h = img.size
edge = [img.getpixel((x, y)) for x in range(w) for y in (0, h - 1)]
edge += [img.getpixel((x, y)) for y in range(h) for x in (0, w - 1)]
if max(edge) > 0:
    sys.exit("The arena does not fit in the window")
print("OK")
