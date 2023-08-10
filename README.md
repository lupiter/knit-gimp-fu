# knit-gimp-fu
Scripts for GIMP to streamline the making of machine knitting patterns

## How to Install

1. Click the "Code" button above, and choose "Download ZIP" from the dropdown.
2. Extract the ZIP. Now you have a copy of everything here.
3. Open up GIMP, and [follow the official instructions](https://docs.gimp.org/en/install-script-fu.html) to find and install Script-Fu scripts.

In particular, on Mac...

1. Go to the Finder, click the Go menu, and hold down the Option key on your keyboard. An extra option called "Library" will appear. You want that one.
2. Open the folder "Application Support", then "GIMP", then the version of GIMP you're running (mine is 2.10).
3. If there's already a folder called "scripts", open it. If it's not there, make a new folder and call it "scripts" (no quotes) and open it.
4. Copy all the files from the ZIP *that end in .scm* into the "scripts" folder
5. In GIMP, go to the Filters menu, choose Script-Fu and then Refresh Scripts.
6. Open the Filters menu again, and a new Knitting item will have appeared. All the scripts from here will be there.

## How to Use

### Color Separator

This automates the colour separation process for two-colour knit/tuck designs described by Alessandrina in [their blog post](https://alessandrina.com/2022/12/22/gimp-update-for-mac-3/). There's no UI, it works on the current image. 

This *only* works on Grayscale images. If you find it's disabled, then you need to use Image > Colour Management > Convert to Colour Profile to make it grayscale.