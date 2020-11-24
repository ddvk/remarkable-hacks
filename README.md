# Binary patches for the rM

## Versions 1.8.1.1-2.4.1.30
Those are features that I find useful/wanted for me to have. If someone else would like to try them, they are welcome.


## Disclaimer
*The files are offered without any warranty and you will be violating the reMarkable AS EULA by using them.
There may be bugs, you may lose data, your device may crash, etc.*

*The only guarantee is, that there is no ill intended code*

I am not affiliated with reMarkable AS in anyway

## Demo

![Screenshot1](docs/images/screenshot_2020_bookmarks.png)
![Screenshot1](docs/images/screenshot_2011_numpad.png)
![Screenshot1](docs/images/screenshot_share.png)
![Screenshot1](docs/images/screenshot_recent_files.png)

## Changes
- rm2 [2.4.1.30](patches/24130_rm2/readme.md)
- rm1 [2.4.1.30](patches/24130_rm1/readme.md)
- rm2 [2.4.0.27](patches/24027_rm2/readme.md)
- rm1 [2.4.0.27](patches/24027_rm1/readme.md)
- rm2 [2.3.1.27](patches/23127/readme.md)
- rm2 [2.3.0.23](patches/23023/readme.md)
- rm1 [2.3.0.16](patches/23016/readme.md)
- rm2 [2.2.1.82](patches/22182/readme.md)
- [2.2.0.48](patches/22048/readme.md)
- [2.1.1.3](patches/2113/readme.md)
- [2.0.2.0](patches/2020/readme.md)
- [1.8.1.1](patches/1811/readme.md)


## Quick Doc

Note: the reMarkable 2 does not have buttons

#### Gestures
- pinch to zoom in/out
- swipe down to toggle side-menu
- swipe down from the top edge to close document (existing rM gesture, not a hack)
- two finger swipe down to switch to previous document
- two finger swipe up *or* long press home button for recent files
    - long press on a recent file that was deleted but not synced to restore it

#### Bookmarks
- tap upper right (or left for lefthanders) corner to bookmark a page
- long press on bookmark to edit its description (also works in bookmark list in side-menu)

#### Zen Mode
- Enter/Exit: left & right buttons simultaneously *or* long press on the "toggle menu" (uppermost)
- Gestures
    - left *or* right button toggles pen/eraser
    - long press left *or* right button to undo

#### Reading Mode
- Enter: home & right buttons simultaneously *or* tap M in the side-menu "Document Menu" (bottommost)
- Exit: left & right buttons simultaneously *or* open side-menu and long press on the "toggle menu" (uppermost)
- Gestures:
    - tap left or right side of screen to change pages

## Extras
- email and hwr for scribbles on pdfs
- extract scribbles from pdfs into new notebook
- clock (check the Timezones)

## Known issues
- had to remove the tooltips / tutorial

# Installation
Find the ssh password (**write it down and keep it safe**)  

in the newest version:
    Settings->Help->Copyright and Licenses (under GPLv3 Compliance)
versions < 2.3:
    Settings->About->Copyright->General Information


**It is really important to have the password somewhere, in case something goes wrong**



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

**Make sure the device has Internet connectivity i.e. Wifi is ON and connected**

Paste the following and press enter:
```
sh -c "$(wget https://raw.githubusercontent.com/ddvk/remarkable-hacks/master/patch.sh -O-)" 
```
to try a different patch:

```
sh -c "$(wget https://raw.githubusercontent.com/ddvk/remarkable-hacks/master/patch.sh -O-)" _ patch_xxx 
```
where xxx is the patch number

The app should start, play with it, but press **CTRL-C** (Hold the Control key and press C) to stop it when done **DON'T LEAVE IT JUST RUNNING** and follow the instructions after pressing CTRL-C

**Should Press 'Y' and then Enter when asked to make it permanent**

# Notes
patches are cumulative (the last one contains all previous changes and gets updated with bugfixes)
a patch can be applied more than once, it's more of a snapshot really, you can go back to a previous version


## Timezones
The time is in UTC. In order to have the right time, the right timezone should be set (which has things like Daylight Saving Time, utc offsets etc).

Check the list of timezones in [Timezones](docs/timezones.md)  
To set a timezone, run this on the device, by setting one that matches your location e.g.  
`timedatectl set-timezone "Europe/Paris"` or  
`timedatectl set-timezone "America/Denver"`

The device doesn't have all possible timezones. If yours is missing from the list, find a linux distro and copy the missing time zone to `/usr/share/zoneinfo/` then execute the above command with the new zone.

## Extra fonts (e.g Japanese)
The rootfs doesn't have enough space, so you can do  
```
mv /usr/share/fonts/ttf ~/ttf
ln -sf /home/root/ttf /usr/share/fonts/ttf
```
for japanese: HanaMinA.ttf and HanaMinB.ttf seem ok  
put new fonts in `/home/root/ttf`,  do `fc-cache` and restart xochitl


## Making it permanent
You should have typed 'Y' when asked

## Revert in case things go terribly wrong
ssh
```
systemctl stop xochitl
rm -fr .cache/remarkable/xochitl/qmlcache/*
cp /home/rmhacks/xochitl.version /usr/bin/xochitl #where version is the current device version
systemctl start xochitl
```


# Features compiled by u/TheTomatoes2

reMarkable Hack brings extra and useful features to your rM. It is regularly updated and improved (most recent patch).

This file details all additional features and modifications included in the latest patch.

The best features are marked as **[BEST]**.


## Tools (in the side-menu, listed top-down)
 - Additional writing tools: Pencil v1 & Paintbrush v1
 - GoToPage: Indicates the page count and opens a number pad that allows 
   navigating to the corresponding page
 - Bookmarks List tool: opens the list of bookmarks. Click to jump to 
   bookmarked page, long-press to edit bookmark (see Bookmark tool 
   below)

 - Navigator: Quickly navigate between pages accessed through GoToPage
 - [BEST] In PDFs: Table of Content
 - Additional options in Shortcut menu: Disable WiFI, Disable Swipes, 
   Disable Bookmark button
 - Layer visibility: Click to hide all but 1 layer, click again to cycle 
   through layers
 - Recent files: get a list of recently opened files to quickly switch 
   to them

## **[BEST]** Bookmarks
- To bookmark a page, click the upper right corner (touch not pen)
- To edit the bookmark name, long-press the upper right corner (touch not pen)
- To see the Bookmarks Lists, click the icon (see Tools above)
You can rename bookmarks by long-pressing them.


## **[BEST]** Modes

### In all modes 

#### Swipes and Buttons
 - **[BEST]** Swipe down to toggle side-menu
 - Click upper right corner to bookmark current page.
 - Long-press upper right corner to rename bookmark of current page.
 - **[BEST]** Long-press middle button to open Recent files list
 - 2 finger swipe down to switch to the previous document

### In Normal (default) Mode

#### Swipes and Buttons
 - Long-press left/right button to go to 1st/Last page


### **[BEST]** In Zen Mode

To toggle Zen Mode: long-press menu icon *or* long-press Left+Right buttons.

#### Swipes and Buttons

- **[BEST]** Press left (right if left-handed) button to cycle between Writing and Eraser tool
- Long-press left (right if left-handed) button to Undo

 NOTE: use swipes to move between pages
#### UI
- Menu icon is replaced by the icon of the current tool and the thickness (number)

### In Reading Mode
To enter Reading Mode: Center+Right buttons

To exit:               Left+Right buttons

NOTE: inverted for left-handers

#### Swipes and Buttons
- Tap left or right to change page (in addition to swiping)

#### UI
- Menu icon is hidden (use the swipe down gesture to open it)

## Other
- **[BEST]** When a new notebook is created, the last used writing tool and its thickness are pre-selected.
 - Keyboards layout: EN, RU, NO, DE
 - Sleep disabled when rM plugged in
- **[BEST]** Restore recently deleted files by long-pressing them in the Recent Files list
- On the homescreen: open the side-menu to see Recent Files list.


## FAQ

#### How do you make the patches?
I wrote some tools, I change the code, I patch

#### Why is this not open source?
I don't own the source, the legality is dubious, not in reMarkable AS's best interest due to various reasons, etc

#### Can you add this or that feature?
Some things are hard, very time consuming or even impossible for my skill level. I prefer to take a more pragmatic approach and add things that are easy, but from which most users can benefit.
