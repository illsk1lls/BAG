# BAG - A command that uses its own wrapper to store/extract files.


Drag and drop items onto 'BAG.cmd' to place them inside the bag. Double click 'BAG.cmd' to empty the bag.

Dropping multiple files at once into the BAG is supported. Multiple drops are supported. You can fill up the BAG up to ~950mb.

BAG uses Powershell to convert any file to BASE64 and add it to itself. It then deletes the original file.

When the BAG is emptied the files inside are converted from BASE64 back to their original state with their original names, extraction time is ~3min when completely full.

(*Folders and empty files are not supported and will be ignored/skipped if dropped onto the bag)

**Windows 10+ supported
