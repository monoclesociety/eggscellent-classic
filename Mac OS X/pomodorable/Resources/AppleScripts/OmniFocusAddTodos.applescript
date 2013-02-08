tell application "OmniFocus"
    tell default document
        set newTask to make new inbox task with properties {name:"%@"}
    end tell
end tell
