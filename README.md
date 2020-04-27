# Binary patches for the rM

## Versions 1.8.1.1-2.1.1.3
Those are features that I find useful/wanted for me to have. If someone else would like to try them, they are welcome.


## Disclaimer
*The files are offered without any warranty and you will be violating the reMarkable SA EULA by using them.
There may be bugs, you may lose data, your device may crash, etc.*

*The only guarantee is, that there is no ill intended code*

## Demo

![Screenshot1](docs/images/screenshot_2020_bookmarks.png)
![Screenshot1](docs/images/screenshot_2011_numpad.png)
![Screenshot1](docs/images/screenshot_share.png)
![Screenshot1](docs/images/screenshot_recent_files.png)

## Changes
- [2.1.1.3](patches/2113/readme.md)
- [2.0.2.0](patches/2020/readme.md)
- [1.8.1.1](patches/1811/readme.md)


## Quick Doc
- some menus to toggle swipes and bookmarks are in the "Share Menu" (rectangle with an arrow pointing out)
- there is an exit button in the "Document Menu" (bottommost)
- long press on a bookmark or upper corent to edit it
- left & right button simultaneously to toggle zen mode
- long press on the "toggle menu" (uppermost) to toggle zen mode
    zen mode:
        - left/right toggles pen/eraser
        - left/right long press to undo
- home  & right button simultaneously to enter reading mode (use the shortcut for zen mode)
- swipe down to toggle the menu
- long press home button to show Recent Files
- long press on a recent file that was deleted but not synced to restore it

## Known issues
- bookmark position stays the same in landscape mode
- numpad does not validate the input (0 = first page, > pagecount = last page)
- listview scrolling is buggy
- had to remove the tooltips / tutorial
- dialog for filename / mesage body no longer scrollable

## Nice to have
- change the default tool on document create (i prefer the fineliner, thickness 1)
- fix the selection box dimensions (vertical or horizonatl straight lines are hard to manage)
- fix palm rejection timeout (cannot swipe pages, button input ignored, for 1-2 seconds after raising the pen)

## Things that I would like to do, but are hard
- pdf link navigation
- djvu support

# Installation
on the device (Rm->About->Copyright->General Information) write down, remember the password shown


## Linux
You got this


## Windows 10
open a command line prompt (Win-R, type cmd, enter)
ssh root@10.11.99.1 (type the password)
or install Putty and enter 10.11.99.1 as address and root for username
paste the automagic line

## macOS
open Spotlight (Cmd-Space) type Terminal, enter
ssh root@10.11.99.1 (type the password)
paste the automagic line

# Automagic
paste the following and press enter:
```
sh -c "$(wget https://raw.githubusercontent.com/ddvk/remarkable-hacks/master/patch.sh -O-)" 
```
to try a different patch:

```
sh -c "$(wget https://raw.githubusercontent.com/ddvk/remarkable-hacks/master/patch.sh -O-)" _ patch_xxx 
```
The app should start, play with it, but press **CTRL-C** to stop it when done (DON'T LEAVE IT JUST RUNNING) and follow the instructions (i.e make it permanent or just start the stock one). 

### Notes
patches are cumulative (the last one contains all previous changes and gets updated with bugfixes)
a patch can be applied more than once, it's more of a snapshot really, you can go back to a previous version


# NB WARNING
Always clear the qml cache before switching/running versions manually (the script already does that). Failing to do so will result in a crash

don't delete the `xochitl.2113` or similar files depending on the version (I know root not the best place) as this is the original binary

## Making it permanent

After making sure everything is ok (i.e. no crashes) if you want to make it permanent (until the next sw update), you can replace the original, before running the original or rebooting (make sure you read the WARNING above)
```
#if you ran a different version
rm -fr .cache/remarkable/xochitl/qmlcache/*

cp xochitl.patched /usr/bin/xochitl
systemctl start xochitl
```


## Revert in case things go terribly wrong
ssh
```
systemctl stop xochitl
rm -fr .cache/remarkable/xochitl/qmlcache/*
cp xochitl.version /usr/bin/xochitl #where version is the current device version
systemctl start xochitl
```
