# BAG - A command that uses its own wrapper to store/extract files.



Drag and drop an item onto 'emptyBAG.cmd' to place it inside the bag. Double click 'fullBAG.cmd' to empty the bag.

Single file only (can be anything)

BAG uses Powershell to convert any file to BASE64 and add it to itself. It then deletes the original file and renames itself to 'fullBAG.cmd'

The process works in reverse for fullBAG.cmd 

When fullBAG.cmd is clicked, the file is converted from BASE64 back to its original state with its original name, and fullBAG.cmd
exports itself back into emptyBAG.cmd and deletes itself.

Also:

Single line BAG is just for fun and a frivolous puzzle. A waste of time.. How much of the multi-line BAG can we get to run on a single line?? We may never know ;P
*For single line bag, at present NO SPACES OR SPECIAL CHARS ("()!@#$%^&*-+;:') in filenames/paths allowed.
