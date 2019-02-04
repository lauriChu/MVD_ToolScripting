--delete $objects
delete selection

boxes = #()
for i = 0 to 25 do (
	for x = 0 to 25 do (
		b = box name:(i as string + "_" + x as string) pos:[i*100,x*100,0] 
		append boxes b
	)
)

--print boxes
select boxes

for obj in selection do (

	ray_dir = Ray obj.pos [0,0,-1]
	ray_int = intersectRay $Plane001  ray_dir
	
	if ray_int != undefined do 
		obj.pos = ray_int.pos
)
