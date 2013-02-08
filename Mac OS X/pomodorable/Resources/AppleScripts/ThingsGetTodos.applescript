tell application "Things"
    tell list "Today"
        get {id, name, name of tag, status} of every to do
    end tell
end tell