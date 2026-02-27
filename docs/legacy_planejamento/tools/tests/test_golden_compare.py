import os
from PIL import Image
import numpy as np
import subprocess
import json


def make_image(path, color, size=(100, 100)):
    img = Image.new('RGBA', size, color)
    img.save(path)


def test_identical_images(tmp_path):
    base = tmp_path / 'base.png'
    cur = tmp_path / 'cur.png'
    diff = tmp_path / 'diff.png'
    make_image(base, (255, 0, 0, 255))
    make_image(cur, (255, 0, 0, 255))

    cmd = ['python3', os.path.join('..', 'golden_compare.py'), '--baseline', str(base), '--current', str(cur), '--output-diff', str(diff)]
    p = subprocess.run(cmd, cwd=os.path.dirname(__file__), capture_output=True, text=True)
    assert p.returncode == 0
    out = json.loads(p.stdout)
    assert out['passed'] is True
    assert out['similarity'] >= 0.999
