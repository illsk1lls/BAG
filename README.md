# BAG - A command that uses its own wrapper to store/extract files.



Drag and drop an item onto 'BAG.cmd' to place it inside the bag. Double click 'BAG.cmd' to empty the bag.

Single file per drop, multiple files supported.

BAG uses Powershell to convert any file to BASE64 and add it to itself. It then deletes the original file.

The process works in reverse when you empty the BAG.

When BAG.cmd is clicked, the file(s) inside is converted from BASE64 back to its original state with its original name.

Also:

Single line BAG is just for fun and a frivolous puzzle. A waste of time.. How much of the multi-line BAG can we get to run on a single line?? We may never know ;P
*For single line bag, at present NO SPACES OR SPECIAL CHARS ("()!@#$%^&*-+;:') in filenames/paths allowed.
