property today_events : {}

tell application "TaskPaper"
repeat with _doc in documents
    repeat with _entry in entries of _doc
        if exists (tag named "today" of _entry) then set end of today_events to properties of _entry
    end repeat
end repeat
end tell

return today_events