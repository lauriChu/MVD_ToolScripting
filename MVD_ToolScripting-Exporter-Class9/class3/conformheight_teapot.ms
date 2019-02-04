delete $hitpoint*

for i = 1 to 1000 do (
	seed i
	random_dir = random [-1,-1,-1] [1,1,1] -- [random -1 1, random -1 1, random -1 1]
	
	ray_dir = Ray (random_dir*10000) -random_dir
	ray_int = intersectRay $Teapot001  ray_dir
	
	if ray_int != undefined do (
		obj  =sphere name:"hitpoint" scale:[0.025,0.025,0.025]
		obj.pos = ray_int.pos
		
		local strength = 5
		local grav_vec = [0,0,-1]
		
		Animate on for t = 1 to 300 by 5 do 
		At time t
		(
			obj.pos = obj.pos + (random_dir + grav_vec * 0.1)
			grav_vec = [grav_vec[1],grav_vec[2], grav_vec[3] - 1]
		)
		
	)
)

