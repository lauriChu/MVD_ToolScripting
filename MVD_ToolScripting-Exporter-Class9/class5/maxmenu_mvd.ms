rollout rolloutmvd "Untitled" width:380 height:176
(
	editText 'edt1' "" pos:[36,44] width:239 height:26 align:#left
	button 'btn1' "..." pos:[288,43] width:33 height:26 align:#left
	button 'btn2' "Button" pos:[38,107] width:280 height:34 align:#left
	
	-- Open the folder dialog
	on btn1 pressed do (
		edt1.text = getSavepath initialDir:(GetDir #maxroot)
	)
	
	-- Call c++ methods from here
	on btn2 pressed do (
		
		-- This is the function that we have declared on max SDK C++
		ExportScene edt1.text
		print edt1.text + " scene exported"
	)
)

createDialog rolloutmvd
