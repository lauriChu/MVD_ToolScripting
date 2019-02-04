rayPicker_primitive = box

tool rayPicker
(
	on mousePoint clickno do
	(
		ry = mapScreenToWorldRay mouse.pos
		myray= ray ry.pos ry.dir
		local intersect = intersectRayScene myray
		
		if intersect.count > 0 do
		(
			rayPicker_primitive name:"test" pos:intersect[1][2].pos
		)
	)
)

rollout unnamedRollout "Test tool" width:245 height:106
(
	button 'btn1' "Apply" pos:[11,63] width:220 height:29 align:#left
dropDownList 'ddl1' "DropDownList" pos:[11,11] width:219 height:40 align:#left items:#("sphere","box")
	
	on btn1 pressed do (
		case ddl1.selection of
		(
			1: rayPicker_primitive = sphere
			2: rayPicker_primitive = box
			default: box
		)
		
		stopTool rayPicker
		startTool rayPicker
	)
	
)

createDialog unnamedRollout

