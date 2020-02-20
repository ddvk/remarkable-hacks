### patch_223
- add recent files history / faster file switching
### patch_222
- add currentLayer / background visibility toggle button (the page has to have modifications to work)
- reduce show menu button and change position 

### patch_221
- moved the bookmark button to the top (right/left) corner
- long press in the corner bookmarks the page and opens the bookmark edit dialog
- bookmarks not really deleted on toggle (cleanup after document load)
- visual indicator on the bookmark for the current page

### patch_220
- add a toggle for swipe enable/disable
- change GoToPage icon to current/number of pages
- fix keyboard losing focus on bookmark edit (scroll disabled may impact file exporting)
- do not display current page in the footer (goto page icon)
- fix: do not write on toc dialog
- add naming of bookmarks (press and hold the bookmark in the list)
- removed the close button
- toggle wifi button in the share menu (for easy on/off)
- gotopage (custom numpad input) 
- bookmark for the last page (go to last page)
- (bugfix) go to bookmarked folder in list mode
- Bookmarks (persistent, saved beside the original file with .bookm extension)
- jump forth and back (toc, goto page or bookmark)
- UI button size reduced by 16% (in order to pack more buttons) + some alignment issues
- show always the first page (cover) in Overview
- remove the thumbnails in listview
- reduce the height of the items in listview
- toc button
- scroll by a whole page in toc and listview
- (bugfix) do not reset the table of contents everytime it is shown

## Known issues
- bookmark position stays the same in landscape mode
- numpad does not validate the input (0 = first page, > pagecount = last page)
- listview scrolling is buggy
- had to remove the tooltips / tutorial
