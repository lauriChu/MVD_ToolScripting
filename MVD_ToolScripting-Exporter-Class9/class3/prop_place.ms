density = 1000 as float
input_spline = $Line001
-- length interpolation based.

for i = 0 to density do (
	road_point = lengthInterp input_spline (i/density)
	road_tangent = lengthtangent input_spline 1 (i/density)
	road_off_dir = cross road_tangent  [0,0,1]

	new_pos1 = road_point + (random 5 22) * road_off_dir
	new_pos2 = road_point - (random 5 22) * road_off_dir
	b1 = box name:(i as string + "_" + x as string) pos:new_pos1 scale:[0.1,0.1,0.1]
	b2 = box name:(i as string + "_" + x as string) pos:new_pos2 scale:[0.1,0.1,0.1]
	local amount = random 0 4
	
)
