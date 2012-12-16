# awesome window manager configuration

This is my personalized awesome window manager configuration which may, or may
not be utterly useless for anyone but myself. As it grows there might be useful
tidbits here and there to use as starting point for your own setup :)

## dependencies

- **udisks-glue** : Used for automounting
- **xcompmgr** : to get some transparency eyecandy
- **oocairo** : required by blingbling

## notes

- There is an oocairo package in the ubuntu repos but lua isn't looking for
it in the right places and i am way too lazy to figure out why ; I just copy
it to one of the places reported by the error message in .xsession-errors. Like
/usr/local/lib/lua-5.1/oocairo.so or so.
