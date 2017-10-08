#!/bin/sh
# A script to ingest and optimise images
#
set -eu

if [ $# -ne 2 ]; then
    echo "Usage: $0 <input dir> <output slug>"
    exit 1
fi

INPUT_DIR=$1
PROJECTS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../assets/projects" && pwd)
OUTPUT_SLUG=$2
OUTPUT_PATH="$PROJECTS_DIR/$OUTPUT_SLUG";

echo ">> $PROJECTS_DIR"
echo ">> $OUTPUT_SLUG"
echo "Generating optimised assets into $OUTPUT_PATH"

mkdir -p "$OUTPUT_PATH";

for file in $INPUT_DIR/*; do
    base_filename=$(basename "$file")
    filename="${base_filename%.*}"
    filename="$(echo "$filename" | sed "s/@2x//" | sed "s/\ /-/g")"
    output_path="$OUTPUT_PATH/$filename.jpg"
    echo "$base_filename -> $output_path"
    convert "$file" -resize '1200>' -strip -define jpeg:extent=100KB "$output_path"
done


# mogrify -path "$OUTPUT_PATH" -filter Triangle -define filter:support=2 \
#      -thumbnail 1200 -unsharp 0.25x0.25+8+0.065  -dither None \
#      -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off \
#      -define png:compression-filter=5 -define png:extent=100KB \
#      -define png:compression-level=9 -define png:compression-strategy=1 \
#      -define png:exclude-chunk=all -interlace none -colorspace sRGB \
#      -strip $INPUT_DIR/*
