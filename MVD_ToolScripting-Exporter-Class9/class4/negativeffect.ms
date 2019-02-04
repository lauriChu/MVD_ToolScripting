plugin renderEffect myNegative
name:"myNegative"
classID:#(0xb7aa794c, 0xc3bd78ab)
(
  parameters main rollout:params
  (
    Color type:#color default:blue ui:Color
  )
  rollout params "Negative Parameters"
  (
    colorpicker Color "Base color: " align:#center
  )
  on apply bmp do
  (
    for h=0 to (bmp.height-1) do
    (
      local sline = getPixels bmp [0,h] bmp.width
      for i=1 to sline.count do sline[i] = Color - sline[i]
      setPixels bmp [0,h] sline
    )
  )
)