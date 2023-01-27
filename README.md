# Hextopal

### What? What is this?
Hextopal is a Bash script born from the inconvenience experienced from going back and forth from GIMP just to get specific color codes for desktop/application theming... Yes, seriously. I would like the end product to be a script that spits out a configurable grid of colors in the terminal which can be easily copied and pasted from.

### What's up with the project name?
"Hextopal" is a concatenation of the original project name "hex-to-palette", which makes the project more memorable and interesting sounding compared to the former. Thanks to my accent, I pronounce the name of this project as "hecks-toe-pull", but please feel free to pronounce it however you'd like.

## Goals and constraints
Below is a list of goals and constraints for this script and what I want to achieve:
- [ ] ~Create an "object" system which uses arrays to store variables.~
- [x] Automatically convert an inputted hexadecimal RGB value into a decimal RGB value.
- [ ] Create color blocks which display both hexadecimal and decimal RGB values with the block being the actual color itself.
- [ ] Automatically generate a color palette from 1 inputted hexadecimal RGB value (hue shifting).
- [ ] Automatically generate 4 steps of lighter tones from the generated color palette (brightness increase).
- [ ] Automatically generate 4 steps of darker tones from the generated color palette (brightness decrease).
- [ ] Write the script using Bash commands only (no third party commands e.g. bc, imagemagick, etc).
