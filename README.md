# BAG - A command that uses its own wrapper to store/extract files.

BAG is a frivolous puzzle. A waste of time.. How much of the multi-line BAG can we get to run on a single line?? We may never know ;P

Drag and drop an item onto 'emptyBAG.cmd' to place it inside the bag. Double click 'fullBAG.cmd' to empty the bag.

IMPORTANT! ~70mb max file size allowed, for single line bag, at present NO SPACES OR SPECIAL CHARS ("()!@#$%^&*-+;:') in filenames/paths allowed.
*Multi-Line BAG supports special chars and spaces. 

Single file only (can be anything)

CAUTION! 
Make sure to only use test COPIES of files and not originals when testing BAG. 
BAG deletes the original file, because thats the point. You are putting the file in the BAG.
It is possible to lose the file you drop if an error occurs, so DO NOT test with original data that is not backed up.


BAG uses Powershell and CertUtil.exe to convert any file to BASE64 and add it to itself. It then deletes the original file and renames itself to 'fullBAG.cmd'

The process works in reverse for fullBAG.cmd 

When fullBAG is clicked, the file is converted from BASE64 back to its original state with its original name, and fullBAG
exports itself back into emptyBAG.cmd and deletes itself.

Extra care and unnecessary stress has been endured to ensure BAG is able to run as a single line of code ;)
