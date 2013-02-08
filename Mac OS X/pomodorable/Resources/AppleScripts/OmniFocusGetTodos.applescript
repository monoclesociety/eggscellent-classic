tell application "OmniFocus"
    tell default document
        set due_soon to a reference to setting id "DueSoonInterval"
        set due_soon_interval to ((value of due_soon) / days) as integer
        set due_date to (current date) + due_soon_interval * days
        tell (flattened tasks whose completed is false and blocked is false and (due date is less than or equal to due_date) and status of containing project is active)
            set {lstProj, lstTasks, lstTime} to {id, name, estimated minutes}
        end tell
        return {lstProj, lstTasks, lstTime}
    end tell
end tell