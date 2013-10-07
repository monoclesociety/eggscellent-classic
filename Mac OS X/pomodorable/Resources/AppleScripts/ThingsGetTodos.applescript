tell application "Things"
    tell list "Today"
        get {id, name, status} of every to do
    end tell
end tell