tell application "OmniFocus"
    tell default document
        tell (flattened tasks whose id is equal to "¡")
            set completed to ¡
            set name to "¡"
        end tell
    end tell
end tell