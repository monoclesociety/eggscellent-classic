tell application "OmniFocus"
    tell default document
        tell (flattened tasks whose completed is false and blocked is false and flagged is true and status of containing project is active)
            set {lstProj, lstTasks, lstTime} to {id, name, estimated minutes}
        end tell
        return {lstProj, lstTasks, lstTime}
    end tell
end tell