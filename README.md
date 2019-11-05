# Binary patches for the rM
This are features that I find useful/wanted for me. If someone else would like to try them, they are welcome.

## Disclaimer
*The files are offered without any warranty and you will be violating the reMarkable SA EULA by using them.
There may be bugs, you may loose data, etc.*

*The only guarantee is that there is no code with ill intent included*


## Changes patch_01
- show always the first page (cover) in Overview
- remove the thumbnails in listview
- reduce the height of the items in listview
- undo/redo buttons latency
- toc button
- gotopage button
- jump list with back button (on page change by toc or gotopage)
- scroll by a whole page in toc and listview
- (kinda bugfix) do not reset the table of contents everytime it is shown


## TODO
- bookmarks
- change the default tool


## Things that I would like to do but are hard
- pdf link navigation
- djvu support


## Installation
on the device (Rm->About->Copyright->General Information) write down, remember the password shown


## Linux
You got this


# Windows 10
open a command line prompt (Win-R, type cmd, enter)
ssh root@10.11.99.1 (type the password)
or install Putty and enter 10.11.99.1 as address and root for username

# macOS
open Spotlight (Cmd-Space) type Terminal, enter
ssh root@10.11.99.1 (type the password)

paste the following and press enter:
```
wget https://raw.githubusercontent.com/ddvk/remarkable-hacks/master/patch.sh -O- | sh
```
