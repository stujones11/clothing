#!/bin/bash
cd ../textures/
## Optimize images - requires OptiPNG ##

for i in *.png; do optipng -o5 -quiet -preserve "$i"; done
