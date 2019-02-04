clearListener()

global nodeBase = undefined
	
function replaceItem nodebase = (
	
	ObjSubstitucion = nodebase
	local cloned_nodes = #()
	
	for obj in selection do
	(
		maxOps.cloneNodes ObjSubstitucion expandHierarchy:true cloneType:#instance newNodes:&nnl #nodialog
		cloned_nodes = nnl
		nnl.name = "clone-" + i as string
		nnl.position = obj.position
		nnl.rotation = obj.rotation
	)
	
	-- delete the objects afterwards
)

rollout baseRollout "Untitled" width:307 height:88
(
	pickbutton 'btn1' "Replace [Object Name]" pos:[27,24] width:117 height:31 align:#left
	button 'btn4' "Replace" pos:[163,24] width:118 height:31 align:#left
	
	on btn1 picked obj do (
		if isValidNode obj do (
			btn1 .tooltip = "You picked " + obj.name
			btn1.text = obj.name	
			nodeBase = getnodebyname obj.name
		)
	)
	
	on btn4 pressed do (
			
		replaceItem nodeBase
		--replaceItem nodeBase
	)
)

createDialog baseRollout