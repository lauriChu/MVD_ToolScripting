filein "mvd_json_exporter.ms"
filein "mvd_components.ms"
filein "mvd_utils.ms"

global base_path = "data/assets/"
global scenes_path = base_path + "scenes/"
global prefabs_path = base_path + "prefabs/"
global mesh_path = base_path + "meshes/"
global mats_path = base_path + "materials/"
global cols_path = base_path + "colliders/"
global tex_path = base_path + "textures/"
global curve_path = base_path + "curves/"   
global parent_path = ""
global project_path = ""

-- Determine geometry layer names and other definitions in this file header
global layer_colliders = "colliders"

struct TMeshSubGroup (
	first_idx,
	num_indices,
	material_index,
	user_material_id
)

-- Class used to export the meshes as .obj or binary files
struct MeshManager (
	
	fs = MVDJson(),           
	vtxs = #(),
	idxs = #(),
	subgroups = #(),
	type = "PosNUvUvT",
	
	-- Method to export mesh in .obj format
	fn exportItem obj epath = (
		
		-- Export mesh as .obj format
		-- Check maxscript to .obj export settings
		-- TO-DO
		
		-- https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_624D3D05_B15D_4A97_9F15_DA35CDB0DDD2_htm
		local prev_pos = obj.pos
		local prev_rot = obj.rotation 
		
		obj.pos = [0,0,0]
		obj.rotation = eulerangles 0 0 0
		
		select obj
		local full_path = (mesh_path + obj.name + ".obj")
		exportFile epath #noprompt selectedOnly:true #noprompt
		
		obj.rotation = prev_rot
		obj.pos = prev_pos
		
		return full_path
	),
	
	-- Private
	fn exportBinaryFetch obj = (
	
		-- Get the data from vertices and ids here
		-- Check also materials in order to get vertices indexed.
		-- TO-DO
		
		
	),
	
	-- Private 
	fn exportBinaryFile obj epath = (

		-- Write mesh data as bytes to stream
		-- TO-DO
		
		
	),
	
	-- Method to export a mesh in binary format
	fn exportItemBinary obj epath = (
		
		-- Convert the given object to triangular mesh
		-- Make a deep copy of it to prevent modifiyng the original one
		local given_obj = obj
		if classof obj != TriMesh then (
			given_obj = copy obj
			given_obj.name = obj.name
			convertToMesh given_obj
		)
		
		exportBinaryFetch given_obj
		exportBinaryFile given_obj epath
		
		-- Remove copied item if necessary
		if given_obj != obj then delete given_obj

		return epath
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
		
		local final_name = filenameFromPath emap.filename 
		local full_path = project_path + tex_path + final_name
		local short_path = tex_path + final_name
		fs_tex.add ename short_path
		
		-- copy texture from original folder to new one.
		copyfile emap.filename full_path

	),
	
	-- Export the material given, parameters and texture definition
	fn exportItem emat = (
		
		fs.add "tech" tech
		fs.add "shadows" (shadows as integer)
		local short_path = (mats_path + emat.name + ".mtl")
		local full_path = (project_path + short_path)
		
		-- Atleast default diffuse needed
		if emat.diffusemap != undefined then (
			exportMap emat.diffusemap "diffuse"
		) else (
			fs_tex.add "diffuse" (tex_path + "default.dds")
		)
		
		-- Atleast default normal needed
		if emat.bumpMap != undefined then (
			exportMap emat.bumpMap "normal"
		) else (
			fs_tex.add "normal" (tex_path + "null_normal.dds")
		)
		
		if emat.ambientMap != undefined then (
			exportMap emat.ambientMap "lightmap"
		)		
		
		if emat.specularMap != undefined then (
			exportMap emat.specularMap "metallic"
		)	
		
		if emat.glossinessMap != undefined then (
			exportMap emat.glossinessMap "roughness"
		)	
		
		if emat.displacementMap != undefined then (
			exportMap emat.displacementMap "height"
		)
		
		if emat.selfIllumMap != undefined then (
			exportMap emat.selfIllumMap "emissive"
		)
		
		if emat.refractionMap != undefined then (
			exportMap emat.refractionMap "aocclusion"
		)
		
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
		
		-- Generate basic collider information
		-- TO-DO
		
		addComponent obj "collider"
	),
	
	-- Generate complex mesh collider
	fn generateTriangle obj = (

		col_layer = getLayerByName layer_colliders
		
		cloned_mesh = copy obj
		cloned_mesh.rotation = obj.rotation
		cloned_mesh.pos = obj.pos
		cloned_mesh.name = "collider_" + obj.name
		cloned_mesh.parent = obj
		
		col_layer.addnode cloned_mesh 		
		addComponent cloned_mesh "collider"
	),
	
	-- Generate convex mesh collideer
	fn generateConvex obj = (
		
		col_layer = getLayerByName layer_colliders
		
		local cvx_hull = nvpx.CreateConvexHull obj.mesh 100 0
		local cloned_mesh = box name:"cloned_collider"
		local conv_obj = convertToMesh cloned_mesh
		cloned_mesh.mesh = cvx_hull
		cloned_mesh.rotation = obj.rotation
		cloned_mesh.pos = obj.pos
		cloned_mesh.name = "collider_" + obj.name
		cloned_mesh.parent = obj
		
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