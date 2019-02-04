delete $VoxelBox*
rbmp = render outputsize:[128,128] channels:#(#zdepth) vfb:off
z_d = getchannelasmask rbmp #zdepth
progressstart "Rendering Voxels..."

for y = 1 to rbmp.height do
(
	progressupdate (100.0 * y / rbmp.height)
	pixel_line = getpixels rbmp [0,y-1] rbmp.width
	z_line = getpixels z_d [0,y-1] rbmp.width
	for x = 1 to rbmp.width do
	(
		b = box width:10 length:10 height:(z_line[x].value/2)
		b.pos = [x*10,-y*10,0]
		b.wirecolor = pixel_line[x]
		b.name = uniquename "VoxelBox"
	)
)

progressend()
