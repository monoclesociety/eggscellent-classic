tell application "Things"
    set newToDo to make new to do with properties {name:"%@"} at end of list "Today"
end tell