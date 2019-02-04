rollout rolloutExport "Untitled" width:237 height:130
(
	button 'btn1' "Export" pos:[18,75] width:200 height:22 align:#left
	button 'btn2' "..." pos:[200,42] width:19 height:17 align:#left
	editText 'edt1' "" pos:[14,41] width:178 height:18 align:#left

	on btn2 pressed do (
		
		dir = getSavePath caption:"Select Folder" initialDir:#images
		edt1.text = dir
	)
	
	on btn1 pressed do (
	
		ExportScene edt1.text
	)
)

