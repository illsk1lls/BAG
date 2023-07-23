# BAG - A command that uses its own wrapper to store/extract files. (Compression Enabled - GZip)

*Warning* When you drop a file into the BAG, the original is deleted.. because that is the point, you are putting it in the BAG. Do NOT use original copies! Make a copy of the file(s) and drop that in. I've done everything I can to make BAG as reliable as possible but if an error occurs the file is gone. Use caution. ;)

Drag and drop items onto 'BAG.cmd' to place them inside the bag. Double click 'BAG.cmd' to empty the bag. 

Dropping multiple files at once into the BAG is supported. Multiple drops are supported. You can add new items to BAG until it reaches ~500mb. (It may go over this on its own.)

BAG uses Powershell to convert any file into a compressed BASE64 string, and adds it to itself. It then deletes the original file.

When the BAG is emptied, the compressed BASE64 strings inside are converted back into the original files. Extraction time is a very long ~4-5min when completely full.

(*Folders and empty files are not supported and will be ignored/skipped if dropped onto the bag)

**Windows 10+ supported
