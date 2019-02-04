filein "mvd_json_exporter.ms"
filein "mvd_components.ms"
filein "mvd_utils.ms"

-- Determine geometry layer names and other definitions in this file header
global layer_colliders = "colliders"

-- Class used to export the meshes as .obj or binary files
struct MeshManager (
	
	fs = MVDJson(),           
	
	-- Method to export mesh in .obj format
	fn exportItem obj epath = (
		
		select obj
		local full_path = (mesh_path + obj.name + ".obj")
		exportFile epath #noprompt selectedOnly:true #noprompt
		return full_path
	),
	
	-- Method to export a mesh in binary format
	fn exportItemBinary obj epath = (
		
		-- Export the mesh using byte chunks
		-- Export vertices, faces and other needed data as bytes
		-- TO-DO
	)
)

-- Class used to export materials and textures
struct MaterialManager (
	
	fs = MVDJson(),    
	fs_tex = MVDJson(), 	
	tech = "pbr.tech",
	shadows = true,
	gen_mat = true,
	gen_tex = true,
	
	-- Export the texture of the given map
	fn exportMap emap ename = (
		
		-- Build the json and export the texture
		local f_name = filenameFromPath emap.filename
		local full_path = (project_path + tex_path + f_name)
		fs_tex.add ename full_path
		
		-- Check if full_path exists, if not, copy texture there
		if not doesFileExist full_path and gen_tex == true then (
			format "Copying file from % to %\n" emap.filename full_path
			copyFile emap.filename full_path
		)
	),
	
	-- Export the material given, parameters and texture definition
	fn exportItem emat = (
		
		fs.add "tech" tech
		fs.add "shadows" (shadows as integer)
		local short_path = (mats_path + emat.name + ".mtl")
		local full_path = (project_path + short_path)
		
		-- Save and print the textures that belong to the material
		-- TO-DO
		
		fs.add "textures" fs_tex
		if gen_mat == true then (fs.writeDisk full_path)
		
		return short_path
	)
)

-- Collider manager
-- Used to generate collider meshes and types
struct ColliderManager (
	
	col_layer,
	
	-- Method to export the collider as a mesh
	fn exportItem obj epath = (
		
		mesh_exporter = MeshManager()
		mesh_exporter.exportItemBinary obj epath
	),
	
	-- Generate basic collider
	fn generateBasic obj = (
		
		addComponent obj "collider"
	),
	
	-- Generate complex mesh collider
	fn generateTriangle obj = (

		col_layer = getLayerByName layer_colliders
		
		-- Create a triangle mesh collider
		-- Associate this collider to the original object
		-- TO-DO

		col_layer.addnode cloned_mesh 		
		addComponent obj "collider"
	),
	
	-- Generate convex mesh collideer
	fn generateConvex obj = (
		
		col_layer = getLayerByName layer_colliders
		
		local cvx_hull = nvpx.CreateConvexHull obj.mesh 100 0
		local cloned_mesh = box name:"cloned_collider"
		local conv_obj = convertToMesh cloned_mesh

		-- Add the data needed to associate the new collider mesh to the object
		-- TO-DO
		
		col_layer.addnode cloned_mesh
		addComponent obj "collider"
	),
	
		
	-- Generate the colliding mesh depending on the type
	fn generateType obj type = (
		
		case type of
		(
			1: generateBasic obj
			2: generateConvex obj
			3: generateTriangle obj
			default: generateBasic obj
		)
	)
)