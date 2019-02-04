### 3DSMax Exporter
- Add transform component to be exported correctly
- Add render component to be exported correctly
	· Export mesh, materials and textures as files and also into the json
	· Support multimaterial (engine not supported yet)
- Add light component to be exported correctly. Support multiple light types.
- Add collider component to be exported correctly. Support three types of colliders
- Add collider component parameters and automatic generation of its values.
- Add custom component exporter, export two types of custom components
- Add support to export mesh, curves and prefabs.

### C++ Importer
- Add support to load a new scene 
- Add support to load scene with resource management
- Add support to load prefabs
- Add support to load custom components (rotator, tags...)

### Notes
- Be careful with local and global coordinates.
- Be careful with .obj coordinates
- Order of vertices matters!

### Upgrade
- Move asset loading to custom components
- Create a component to move an object from point to point (platform)