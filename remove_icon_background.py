#!/usr/bin/env python3
"""
Script to remove black background from app icons and make it transparent.
Requires Pillow: pip install Pillow
"""

import os
from PIL import Image
import sys

def remove_black_background(input_path, output_path, threshold=30):
    """
    Remove black background from image and make it transparent.
    
    Args:
        input_path: Path to input image
        output_path: Path to save output image
        threshold: Color threshold for black detection (0-255)
    """
    try:
        # Open the image
        img = Image.open(input_path)
        
        # Convert to RGBA if not already
        if img.mode != 'RGBA':
            img = img.convert('RGBA')
        
        # Get image data
        data = img.getdata()
        
        # Create new image data with transparent background
        new_data = []
        for item in data:
            # Check if pixel is black (or very dark)
            # Using threshold to catch near-black pixels
            if item[0] <= threshold and item[1] <= threshold and item[2] <= threshold:
                # Make transparent
                new_data.append((255, 255, 255, 0))
            else:
                # Keep original pixel
                new_data.append(item)
        
        # Update image with new data
        img.putdata(new_data)
        
        # Save the image
        img.save(output_path, 'PNG')
        print(f"✓ Processed: {input_path} -> {output_path}")
        return True
        
    except Exception as e:
        print(f"✗ Error processing {input_path}: {e}")
        return False

def main():
    # Base directory for Android resources
    base_dir = "android/app/src/main/res"
    
    # Mipmap directories
    mipmap_dirs = [
        "mipmap-mdpi",
        "mipmap-hdpi",
        "mipmap-xhdpi",
        "mipmap-xxhdpi",
        "mipmap-xxxhdpi"
    ]
    
    success_count = 0
    total_count = 0
    
    for mipmap_dir in mipmap_dirs:
        icon_path = os.path.join(base_dir, mipmap_dir, "ic_launcher.png")
        
        if os.path.exists(icon_path):
            total_count += 1
            # Process in place (overwrite original)
            if remove_black_background(icon_path, icon_path, threshold=30):
                success_count += 1
        else:
            print(f"⚠ File not found: {icon_path}")
    
    print(f"\n{'='*50}")
    print(f"Processed {success_count}/{total_count} icon files")
    print(f"{'='*50}")

if __name__ == "__main__":
    try:
        from PIL import Image
    except ImportError:
        print("Error: Pillow is not installed.")
        print("Please install it using: pip install Pillow")
        sys.exit(1)
    
    main()

