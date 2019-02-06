# MVD_ToolScripting

## Final Work

### 1. Design your own level
My level is inspired in FF7 Shinra Building (https://www.glitterberri.com/content/ff_series/ffvii/prerenders/BLIN63_1a.png)
![Img1](https://github.com/lauriChu/MVD_ToolScripting/blob/master/MVD_ToolScripting-Exporter-Class9/1.png)
![Img2](https://github.com/lauriChu/MVD_ToolScripting/blob/master/MVD_ToolScripting-Exporter-Class9/2.png)
![Img3](https://github.com/lauriChu/MVD_ToolScripting/blob/master/MVD_ToolScripting-Exporter-Class9/3.png)
![Img4](https://github.com/lauriChu/MVD_ToolScripting/blob/master/MVD_ToolScripting-Exporter-Class9/4.png)

### 2. Export scene information into the engine using the tools we created.
Exported correctly into our engine.

### 3. Create a new component
I created a component named Platform wich allows a translation of meshes. This component have parameters like velocity... that can be modifyied. You can add this component into render with the button on inspector menu.
![Img6](https://github.com/lauriChu/MVD_ToolScripting/blob/master/MVD_ToolScripting-Exporter-Class9/6.PNG)
### 4. Complete the renderer debug menu
Taking advantage of current parameters/information of Materials in our GraphicsSystem, I added information about the textures, specular, ambient...

![Img5](https://github.com/lauriChu/MVD_ToolScripting/blob/master/MVD_ToolScripting-Exporter-Class9/5.PNG)

### 5. Add script logic on console editor
I added a command for change the current camera between the both that exists in the engines (first for player, and second for debug with free movements and without colliders). You cange change between then with the command "change_camera" and passing 0/1 for each camera.
I added a command for enable/disable debug system rendering using "switch_debug" and passing 0/1 for enable and disable accordingly.

### 6. Finish loading json in max (scene changes between engine/max). ----

### 7. Add a button to delete entity.
Because I can't remove an entity directly without doing a big workraund in the forms that the engine have been made, I changed the functionality of the button for do a Hidden functionality.
