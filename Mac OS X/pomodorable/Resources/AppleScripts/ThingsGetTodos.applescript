tell application "Things"
	tell list "Today"
		get {id, name, status, tag names} of every to do
	end tell
end tell