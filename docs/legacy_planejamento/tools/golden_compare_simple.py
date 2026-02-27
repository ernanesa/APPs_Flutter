#!/usr/bin/env python3
"""
Simple Golden Image Comparator - No heavy dependencies

Uses basic image comparison without external libraries.
Falls back to file hash comparison if PIL not available.
"""

import sys
import hashlib
import json
from pathlib import Path

def compute_file_hash(image_path: str) -> str:
    """Compute SHA256 hash of file."""
    sha256 = hashlib.sha256()
    with open(image_path, 'rb') as f:
        while True:
            data = f.read(65536)  # 64KB chunks
            if not data:
                break
            sha256.update(data)
    return sha256.hexdigest()

def compare_by_hash(baseline: str, current: str) -> dict:
    """Compare images by file hash (exact match only)."""
    baseline_hash = compute_file_hash(baseline)
    current_hash = compute_file_hash(current)

    match = baseline_hash == current_hash

    return {
        "baseline": baseline,
        "current": current,
        "match": match,
        "method": "sha256_hash",
        "similarity": 100.0 if match else 0.0,
        "baseline_hash": baseline_hash,
        "current_hash": current_hash
    }

def compare_images(baseline_path: str, current_path: str, threshold: float = 99.8) -> dict:
    """
    Compare two images.

    Args:
        baseline_path: Path to baseline (expected) image
        current_path: Path to current (actual) image
        threshold: Similarity threshold percentage (default 99.8%)

    Returns:
        Dictionary with comparison results
    """
    baseline = Path(baseline_path)
    current = Path(current_path)

    if not baseline.exists():
        return {
            "error": f"Baseline not found: {baseline_path}",
            "match": False
        }

    if not current.exists():
        return {
            "error": f"Current not found: {current_path}",
            "match": False
        }

    # Simple hash-based comparison
    # In production, use golden_compare.py with SSIM for fuzzy matching
    result = compare_by_hash(str(baseline), str(current))

    # Check against threshold
    result["threshold"] = threshold
    result["passed"] = result["similarity"] >= threshold

    return result

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 golden_compare_simple.py <baseline.png> <current.png> [threshold]")
        print("\nExample:")
        print("  python3 golden_compare_simple.py baseline/01_home.png current/01_home.png 99.8")
        sys.exit(1)

    baseline = sys.argv[1]
    current = sys.argv[2]
    threshold = float(sys.argv[3]) if len(sys.argv) > 3 else 99.8

    result = compare_images(baseline, current, threshold)

    # Print JSON output
    print(json.dumps(result, indent=2))

    # Exit code
    if result.get("match") or result.get("passed"):
        print(f"\n✅ Images match", file=sys.stderr)
        sys.exit(0)
    else:
        print(f"\n❌ Images differ", file=sys.stderr)
        if "error" in result:
            print(f"   Error: {result['error']}", file=sys.stderr)
        sys.exit(1)
