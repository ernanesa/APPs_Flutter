#!/usr/bin/env python3
"""
golden_compare.py

Compare duas imagens (baseline x current) com uma métrica fuzzy (SSIM quando possível) e gera um heatmap de diferença.
Saída: JSON com similarity (0.0-1.0) e arquivo de diff salvo.
Exit code: 0 se similarity >= threshold, 2 se imagens incompatíveis, 1 se similarity < threshold.
"""

import argparse
import json
import os
import sys
from PIL import Image
import numpy as np


def load_image(path):
    img = Image.open(path).convert('RGBA')
    return np.asarray(img)


def compute_ssim(a, b):
    try:
        from skimage.metrics import structural_similarity as ssim
        # convert to grayscale
        from skimage.color import rgb2gray
        if a.shape[-1] == 4:
            a_rgb = a[..., :3]
            b_rgb = b[..., :3]
        else:
            a_rgb = a
            b_rgb = b
        a_gray = rgb2gray(a_rgb.astype(np.float64) / 255.0)
        b_gray = rgb2gray(b_rgb.astype(np.float64) / 255.0)
        score, diff = ssim(a_gray, b_gray, full=True)
        diff_img = (1.0 - diff)  # differences where 1 means very different
        return float(score), (diff_img * 255).astype(np.uint8)
    except Exception:
        return None, None


def compute_rms_similarity(a, b):
    # Simple fallback: root mean square normalized similarity
    a3 = a[..., :3].astype(np.int32)
    b3 = b[..., :3].astype(np.int32)
    diff = (a3 - b3).astype(np.int64)
    sq = np.sum(diff * diff, axis=2)
    mse = np.mean(sq) / (255.0 * 255.0 * 3)
    rms = np.sqrt(mse)
    similarity = max(0.0, 1.0 - rms)
    # produce diff heatmap
    heat = (np.clip(np.sqrt(sq) / (np.sqrt(3) * 255.0), 0, 1) * 255).astype(np.uint8)
    return float(similarity), heat


def save_heatmap(heat, out_path):
    # heat is 2D uint8 array
    from PIL import Image
    img = Image.fromarray(heat)
    img = img.convert('L').resize((heat.shape[1], heat.shape[0]))
    img.save(out_path)


def main():
    parser = argparse.ArgumentParser(description='Compare baseline and current golden images')
    parser.add_argument('--baseline', required=True)
    parser.add_argument('--current', required=True)
    parser.add_argument('--threshold', type=float, default=0.998)
    parser.add_argument('--output-diff', required=True)
    args = parser.parse_args()

    if not os.path.exists(args.baseline):
        print(json.dumps({'error': 'baseline_missing', 'path': args.baseline}))
        return 2
    if not os.path.exists(args.current):
        print(json.dumps({'error': 'current_missing', 'path': args.current}))
        return 2

    a = load_image(args.baseline)
    b = load_image(args.current)

    if a.shape != b.shape:
        print(json.dumps({'error': 'size_mismatch', 'baseline_shape': a.shape, 'current_shape': b.shape}))
        return 2

    ssim_score, ssim_diff = compute_ssim(a, b)
    if ssim_score is not None:
        similarity = ssim_score
        # ssim_diff is float [0..1], convert to heatmap
        heat = (ssim_diff * 255).astype(np.uint8)
    else:
        similarity, heat = compute_rms_similarity(a, b)

    os.makedirs(os.path.dirname(args.output_diff), exist_ok=True)
    save_heatmap(heat, args.output_diff)

    result = {
        'baseline': args.baseline,
        'current': args.current,
        'similarity': similarity,
        'threshold': args.threshold,
        'passed': similarity >= args.threshold,
        'diff_path': args.output_diff,
    }

    print(json.dumps(result))
    if similarity >= args.threshold:
        return 0
    else:
        return 1


if __name__ == '__main__':
    sys.exit(main())
