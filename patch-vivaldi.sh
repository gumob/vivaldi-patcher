#!/usr/local/bin/bash

executeCommand () {
	local cmd=$1
	echo "$ $cmd"
    echo
    eval $cmd
	echo
}

function confirmYesOrNo {
	MSG=$1
	while :
	do
		echo -en "${MSG} [Yes/No]: "
		read line
		case $line in
		[yY][eE][sS]) return 1;;
		[nN][oO]) return 0 ;;
 		esac
	done
}

# Variables
custom_bg_color="#171717"

framework_dir="`find /Applications/Vivaldi.app -name Vivaldi\ Framework.framework`"

resource_dir="${framework_dir}/Resources/vivaldi/"
style_dir="${framework_dir}/Resources/vivaldi/style/"

browser_html_path="${framework_dir}/Resources/vivaldi/browser.html"
browser_html_backup_path="${framework_dir}/Resources/vivaldi/browser.html.orig"

# Specify the directory where patch files are stored
patch_path="/Path/to/patch/files/directory"
patch_js_path="${patch_path}/custom.js"
patch_css_path="${patch_path}/custom.css"

# Quit Vivaldi
echo
echo "Closing Vivaldi..."
echo
osascript -e 'quit app "Vivaldi.app"'

# Install gnu-sed
if ! brew ls --versions gnu-sed > /dev/null; then
    echo "GNU sed is not installed."
    echo "Installing gnu-sed..."
    echo
    executeCommand "brew install gnu-sed"
fi

# Copy custom.css and custom.js to Vivaldi resource directories
executeCommand "cp -fv \"${patch_js_path}\" \"${resource_dir}\""
executeCommand "cp -fv \"${patch_css_path}\" \"${style_dir}\""

# Backup original file
if [ ! -f "${browser_html_backup_path}" ]; then
    executeCommand "cp -v \"${browser_html_path}\" \"${browser_html_backup_path}\""
fi

echo "Patching files.."
echo

# Replace background color
gsed -i -e "s|background-color: #d4d4d4;|background-color: ${custom_bg_color};|" "${browser_html_path}"

# Insert custom.css
css_str_src='    <link rel="stylesheet" href="style/common.css" />\n  </head>'
css_str_dst='    <link rel="stylesheet" href="style/common.css" />\n    <link rel="stylesheet" href="style/custom.css" />\n  </head>'
gsed -i -e ":a;N;\$!ba;s|${css_str_src}|${css_str_dst}|g" "${browser_html_path}"

# Insert custom.js
js_str_src='    <script src="bundle.js"></script>\n  </body>'
js_str_dst='    <script src="bundle.js"></script>\n    <script src="custom.js"></script>\n  </body>'
gsed -i -e ":a;N;\$!ba;s|${js_str_src}|${js_str_dst}|g" "${browser_html_path}"

# Open Vivaldi
echo "Opening Vivaldi..."
echo

open /Applications/Vivaldi.app
