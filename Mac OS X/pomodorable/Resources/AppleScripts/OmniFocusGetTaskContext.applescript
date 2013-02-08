tell application "OmniFocus"
    tell default document
        get name of context of every flattened task whose id is "%@"
    end tell
end tell