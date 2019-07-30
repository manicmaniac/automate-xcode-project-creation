on makeSingleViewAppBuilder for anAppName
	script SingleViewAppBuilder
		property product : ""
		property organization : {name:"", identifier:""}
		property useCoreData : false
		property includeUnitTests : false
		property includeUITests : false
		property _appName : anAppName
		property _tmpDir : POSIX file (system attribute "TMPDIR")
		property _timestamp : do shell script "date +%s"
		
		on build at destination
			tell application "Finder"
				set buildDir to (make new folder at _tmpDir with properties {name:"SingleViewAppBuilder" & _timestamp}) as text
			end tell
			_createProject at buildDir
			set productDir to buildDir's POSIX path & my product
			try
				do shell script "mv " & (quoted form of productDir) & " " & (quoted form of destination's POSIX path)
				do shell script "rmdir " & (quoted form of buildDir's POSIX path)
			on error errorStr number errorNumber
				do shell script "rm -rf " & (quoted form of buildDir's POSIX path)
				error errorStr number errorNumber
			end try
		end build
		
		on _createProject at buildDir
			tell application _appName to activate
			try
				_manipulateSystemEventsToCreateProject at buildDir's POSIX path
				tell application _appName to quit
			on error errorStr number errorNumber
				tell application "System Events"
					tell application process "Xcode"
						tell front window to keystroke escape
						tell front window to keystroke escape
						tell front window to keystroke escape
					end tell
				end tell
				tell application _appName to quit
				error errorStr number errorNumber
			end try
		end _createProject
		
		on _manipulateSystemEventsToCreateProject at buildDirString
			tell application "System Events"
				tell application process "Xcode"
					set frontmost to true
					click menu item "Project…" of menu 1 of menu item "New" of menu 1 of menu bar item "File" of menu bar 1
					tell front window
						tell sheet 1
							tell group 1
								click radio button "iOS" of radio group 1
								tell text field 1 to keystroke "Single"
								keystroke return
								delay 2.0
								set value of text field "Product Name:" to my product
								set value of text field "Organization Name:" to my organization's name
								set value of text field "Organization Identifier:" to my organization's identifier
								tell checkbox "Use Core Data"
									if its value is not my useCoreData as integer then click it
								end tell
								tell checkbox "Include Unit Tests"
									if its value is not my includeUnitTests as integer then click it
								end tell
								tell checkbox "Include UI Tests"
									if its value is not my includeUITests as integer then click it
								end tell
								tell pop up button "Team:"
									if it exists then
										click it
										click menu item "None" of menu 1
									end if
								end tell
								tell pop up button "Language:"
									if it exists then
										click it
										click menu item "Swift" of menu 1
									end if
								end tell
							end tell
							click button "Next"
						end tell
						keystroke "G" using {command down}
						delay 0.5
						keystroke buildDirString
						delay 1.0
						keystroke return
						delay 0.5
						click button "Create" of sheet 1 of sheet 1
					end tell
				end tell
			end tell
		end _manipulateSystemEventsToCreateProject
	end script
end makeSingleViewAppBuilder

on run argv
	set {appName, product, organizationName, organizationIdentifier, destination} to argv
	set builder to makeSingleViewAppBuilder for appName
	tell builder
		set its product to product
		set its organization's name to organizationName
		set its organization's identifier to organizationIdentifier
		set its includeUnitTests to true
		build at POSIX file destination
	end tell
end run
