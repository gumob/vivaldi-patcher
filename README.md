# Vivaldi Patcher

Bash script to apply custom css and javascript files to Vivaldi.<br/>
Works on only Mac OS X.

# Usage

### Specify the directory where patch files are stored

```
$ vi patch-vivaldi.sh

# Edit this line.
patch_path="/Path/to/patch/files/directory"
```

### Edit custom javascript and css files

```
$ vi /Path/to/patch/files/directory/custom.js

# Write custom javascript here

...

$ vi /Path/to/patch/files/directory/custom.css

# Write custom css here

...

```

### Run the bash script to apply patch files

```
$ ./patch-vivaldi.sh
```


# Copyright

Vivaldi Patcher is released under MIT license, which means you can modify it, redistribute it or use it however you like.
