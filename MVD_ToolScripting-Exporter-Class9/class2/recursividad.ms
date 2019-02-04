delete $objects
global max_depth =5

function createChildren childAmount depth = (
	
	b = box name:(depth as string) width:1 height:1 length:1
	depth = depth + 1
	
	if depth > max_depth do
		return b
	
	initial = (b.pos.x - childAmount/2) 
	
	for i = 1 to childAmount do (
		child = createChildren childAmount depth
		child.parent = b
		child.pos = [initial, depth, 0]
		initial += i*2
	)

	
	return b
)

createChildren 2 0

