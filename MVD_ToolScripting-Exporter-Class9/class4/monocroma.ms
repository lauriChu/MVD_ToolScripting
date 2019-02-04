plugin RenderEffect MonoChrome
name:"MonoChrome"
classID:#(0x9e6e9e77, 0xbe815df4)
(
on apply r_image progressCB: do
(
	bmp_w = r_image.width
	bmp_h = r_image.height
	for y = 0 to bmp_h-1 do
	(
		pixel_line = getPixels r_image [0,y] bmp_w
		for x = 1 to bmp_w do
		(
			p_v = pixel_line[x].value
			pixel_line[x] = color p_v p_v p_v pixel_line[x].alpha
		)--end x loop
		setPixels r_image [0,y] pixel_line
	)--end y loop

)--end on apply
)--end plugin
