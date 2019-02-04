delete $hitpoint

function teapotSurfacePlace numItems = (
	
	for i = 0 to numItems do (
		seed i
		random_dir = random [-1,-1,-1] [1,1,1]
		random_pos = 1000*random_dir
		
		ray_dir = Ray random_pos -random_dir
		hit = intersectRay $Teapot001 ray_dir
		
		if hit != undefined do (
			sphere pos:hit.pos scale:[0.1,0.1,0.1]
		)
	)
)

teapotSurfacePlace 200