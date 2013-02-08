tell application "Skype"
    send command "SET USERSTATUS DND" script name "pomodorable"
    send command "SET PROFILE MOOD_TEXT %@" script name "pomodorable"
end tell