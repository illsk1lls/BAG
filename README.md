# BAG - A command that uses its own wrapper to store/extract files.



Drag and drop an item onto 'emptyBAG.cmd' to place it inside the bag. Double click 'fullBAG.cmd' to empty the bag.

~70mb max file size allowed. 

Single file only (can be anything)

CAUTION! 
Make sure to only use test COPIES of files and not originals when testing BAG. 
BAG deletes the original file, because thats the point. You are putting the file IN the BAG.
It is possible to lose the file you drop if an error occurs, so DO NOT test with original data that is not backed up.

BAG uses Powershell and CertUtil.exe to convert any file to BASE64 and add it to itself. It then deletes the original file and renames itself to 'fullBAG.cmd'

The process works in reverse for fullBAG.cmd 

When fullBAG is clicked, the file is converted from BASE64 back to its original state with its original name, and fullBAG
exports itself back into emptyBAG.cmd and deletes itself.

Single line BAG is just for fun and a frivolous puzzle. A waste of time.. How much of the multi-line BAG can we get to run on a single line?? We may never know ;P
*For single line bag, at present NO SPACES OR SPECIAL CHARS ("()!@#$%^&*-+;:') in filenames/paths allowed.