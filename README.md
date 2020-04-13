## Project Tiles Color Palette

* Green: #B5DEC4
* Orange:  #F9CBAC
* Gray: #EEF0F2
* Yellow: #F7E1A9
* Blue:  #B6E2E9
* Purple: #D0B8D1 
* Pink: #F8ADAB

## Asset Optimization

For most vector art assets, PNG compression should be sufficient. It can be further optimized with `pngqaunt`:

```sh
pngquant --skip-if-larger --force --ext .png *.png
```

For photography assets, they should be converted to JPEG and further optimized:

```sh
mogrify -format jpg *.png
jpegoptim --all-progressive -s -m80 *.jpg
```
