#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
app_name="nosave-chat"
target_triple="${1:-aarch64-linux-android}"
build_variant="${2:-debug}"
out_apk="${3:-}"
icon="$root/assets/icon.png"
android_app="$root/target/dx/$app_name/release/android/app"
res_dir="$android_app/app/src/main/res"
out_dir="$root/dist"
default_apk="$out_dir/NoSaveChat-${target_triple}-${build_variant}.apk"

if [[ ! -f "$icon" ]]; then
  echo "Missing icon: $icon" >&2
  echo "Create it with: imagemagick convert or magick (example: convert assets/icon-1024.png -resize 256x256 -alpha off -background transparent -flatten PNG32:assets/icon.png)" >&2
  exit 1
fi

if [[ "$build_variant" != "debug" && "$build_variant" != "release" ]]; then
  echo "Invalid build variant: $build_variant. Use debug or release." >&2
  exit 1
fi

if [[ -z "$out_apk" ]]; then
  out_apk="$default_apk"
fi

cd "$root"

tailwindcss -i ./tailwind.css -o ./assets/tailwind.css
dx bundle --android --release --package-types apk --target "$target_triple"

if [[ ! -d "$res_dir" ]]; then
  echo "Missing generated Android res dir: $res_dir" >&2
  exit 1
fi

declare -A sizes=(
  [mipmap-mdpi]=48
  [mipmap-hdpi]=72
  [mipmap-xhdpi]=96
  [mipmap-xxhdpi]=144
  [mipmap-xxxhdpi]=192
)

for dir in "${!sizes[@]}"; do
  mkdir -p "$res_dir/$dir"
  if command -v magick >/dev/null 2>&1; then
    image_cmd=(magick)
  elif command -v convert >/dev/null 2>&1; then
    image_cmd=(convert)
  else
    echo "ImageMagick is required but neither 'magick' nor 'convert' was found in PATH." >&2
    exit 1
  fi

  "${image_cmd[@]}" "$icon" -resize "${sizes[$dir]}x${sizes[$dir]}" "$res_dir/$dir/ic_launcher.webp"
done

# Dioxus currently emits the default adaptive icon XML. Remove it so Android
# uses the density-specific launcher images above.
rm -rf "$res_dir/mipmap-anydpi-v26"
rm -f "$res_dir/drawable/ic_launcher_background.xml"
rm -f "$res_dir/drawable-v24/ic_launcher_foreground.xml"

cd "$android_app"
./gradlew clean
assemble_task="assemble$(tr '[:lower:]' '[:upper:]' <<< "$build_variant")"
./gradlew "$assemble_task"

mkdir -p "$out_dir"
cp "$android_app/app/build/outputs/apk/$build_variant/app-$build_variant.apk" "$out_apk"

echo "Built $out_apk"
