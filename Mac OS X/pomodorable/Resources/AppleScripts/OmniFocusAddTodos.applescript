tell application "OmniFocus"
    tell default document
set newTask to make new inbox task with properties {name:"%@", flagged:true}
    end tell
end tell
