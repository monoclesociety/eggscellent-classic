tell application "Things"
    repeat with todoComplete in (to dos whose id is equal to "¡")
        set status of todoComplete to ¡
        set name of todoComplete to "¡"
    
        if status of todoComplete is equal to open then
            move todoComplete to list "Today"
        end if
    end repeat
end tell