# Binary patches for the rM

## Versions 1.8.1.1-2.1.1.3
Those are features that I find useful/wanted for me to have. If someone else would like to try them, they are welcome.


## Disclaimer
*The files are offered without any warranty and you will be violating the reMarkable SA EULA by using them.
There may be bugs, you may lose data, your device may crash, etc.*

*The only guarantee is, that there is no ill intended code*

I am not affiliated with reMarkable AS in anyway

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
- bookmark pages by clicking the upper right (or left for lefthanders) corner
- long press on a bookmark or upper left/right corner to edit it
- some menus to toggle swipes and bookmarks are in the "Share Menu" (rectangle with an arrow pointing out)
- there is an exit button in the "Document Menu" (bottommost)
- left & right button simultaneously to toggle zen mode
- long press on the "toggle menu" (uppermost) to toggle zen mode
    zen mode:
        - left/right toggles pen/eraser
        - left/right long press to undo
- home & right button simultaneously to enter reading mode (use the shortcut for zen mode)
- swipe down to toggle the menu
- long press home button to show Recent Files
- long press on a recent file that was deleted but not synced to restore it
- 2 finger swipe up to close the document

## Known issues
- had to remove the tooltips / tutorial

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
- To bookmark a page, click the upper right corner
- To edit the bookmark name, long-press the upper right corner
- To see the Bookmarks Lists, click the icon (see Tools above)
You can rename bookmarks by long-pressing them.


## **[BEST]** Modes

### In all modes 

#### Swipes and Buttons
 - **[BEST]** Swipe down to toggle side-menu
 - Click upper right corner to bookmark current page.
 - Long-press upper right corner to rename bookmark of current page.
 - **[BEST]** Long-press middle button to open Recent files list

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
I don't own the source, the legality is dubious, not in reMarkable SA's best interest due to various reasons, etc

#### Can you add this or that feature?
Some things are hard, very time consuming or even impossible for my skill level. I prefer to take a more pragmatic approach and add things that are easy, but from which most users can benefit.
