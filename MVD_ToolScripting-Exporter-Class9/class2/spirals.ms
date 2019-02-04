gc()
delete $objects

function createCircle = (

	r = 40
	step = 5
	total_amount = 360 / step

	for i = 1 to total_amount do (
		
		local out_angle = i *step;
				x = r * cos(out_angle);
				y = r * sin(out_angle);
		sphere name:("itr" + i as string) pos:[x,y,0] radius:1
	)
)

rollout unnamedRollout "Untitled" width:162 height:129
(
	dropDownList 'ddl1' "Spiral Type" pos:[15,19] width:118 height:40 align:#left items:#( "Circle", "Elipse", "Euler Spiral", "Hiperbolic Spiral")
	button 'btn1' "Generate" pos:[15,79] width:117 height:19 align:#left
	
	on btn1 pressed do (
		case ddl1.selection of
		(
			1: createCircle()
			2: print "elipse"
			3: print "euler"
			4: print "hiperbolic"
			default: "none"
		)
	)
)

createDialog unnamedRollout "Test Dialog"
