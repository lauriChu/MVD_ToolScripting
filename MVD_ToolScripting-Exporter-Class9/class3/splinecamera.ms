
function interpolate_camera cam inputSpline total_steps = (

	Animate on for t = 1 to total_steps by 5 do 
	At time t
	(
		pos = pathInterp inputSpline (t/total_steps as float)
		cam.position = pos
		print cam.position
	)
)

interpolate_camera $Camera001 $Line001 100