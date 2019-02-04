filein "mvd_json_exporter.ms"
filein "mvd_geometry_manager.ms"
filein "mvd_utils.ms"

-- Global path definitions for each asset data folder
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

global layer_colliders = "colliders"

-- Global transformation matrices needed
global MaxToMVD = rotateXMatrix  -90
global MVDToMax = rotateXMatrix  90

-- Exporter class used to export scenes into the engine
struct MVDExporter (
	
	fs = MVDJson(), 
	item_name = "Undefined",
	item_path = "Undefined",
	item_format = ".scene",
	
	gen_mat = true,
	gen_tex = true,
	gen_col = true,
	
	-- Components export
	------------------------------------------------------------
	------------------------------------------------------------
	
	-- Export the entity name
	fn exportName jwrite obj = (
		
		jwrite.add "name" obj.name
	),
	
	-- Link the entity to his parent if needed
	fn exportParent jwrite obj = (
		
		if obj.parent != undefined do (
			
			local index = findItem obj.parent selection
		
			if obj.parent != rootScene.world and index != 0 then (
				jwrite.add "parent" obj.parent.name
			)	
		)
	),
	
	-- Export the entity prefab
	fn exportPrefabLink jwrite obj = (
		
		local f_name = getFilenameFile obj.filename 
		local f_path = (prefabs_path + f_name + ".prefab")
		jwrite.add "prefab" f_path
	),
	
	-- Export the transform component
	fn exportTransform jwrite obj = (
		
		local mvd_pos = obj.transform.pos * MaxToMVD
		local mvd_rot = ((QuatToEulerPoint obj.rotation) * MaxToMVD)
		local mvd_scale = obj.transform.scale
		
		comp_transform = MVDJson()
		comp_transform.add "translation" mvd_pos
		comp_transform.add "rotation" mvd_rot
		comp_transform.add "scale" mvd_scale
		
		jwrite.add "transform" comp_transform
	),
	
	-- Export the render component
	fn exportRender jwrite obj = (
		
		-- Export colliders as separate objects with no render if it's the case
		if superclassof obj == GeometryClass and obj.layer.name != layer_colliders then (
			
			obj = convertToPoly obj
			comp_render = MVDJson()
			
			if obj == undefined then (
				print ("Could not export mesh with name " + obj + " wrong object type cannot be converted!")	
			) else (
				
				local fmesh_path = (project_path + mesh_path + obj.name + ".obj")
				
				-- Mesh exporter call
				mesh_exporter = MeshManager()
				local out = mesh_exporter.exportItem obj fmesh_path
				--mesh_exporter.exportItemBinary obj fmesh_path
				comp_render.add "mesh" (mesh_path + obj.name + ".obj")			
				
				-- Material exporter call
				mat_exporter = MaterialManager()
				mat_exporter.gen_mat = gen_mat
				mat_exporter.gen_tex = gen_tex
				
				if classof obj.mat == StandardMaterial then (
					local out = mat_exporter.exportItem obj.mat	
					comp_render.add "materials" #(out)
				) else if classof obj.mat == multimaterial then (
					local total_mats = #()
					for m in obj.mat do (
						local out = mat_exporter.exportItem obj.mat	
						append total_mats out
					)
					comp_render.add "materials" total_mats
				) else (
					
					comp_render.add "materials" #("data/assets/materials/mtl_default.mtl")
					print ("Could not export material for object: " + obj.name + ", setting default material!")	
				) 			
			)	
			
			jwrite.add "render" comp_render
		)
	),
	
	-- Export the light component
	fn exportLight jwrite obj = (
		-- Check if it's a light
		-- Check the light's type
		-- Export light parameters depending on light type
		
		if superclassof obj == Light then (
		
			comp_light = MVDJson()
			comp_light.add "intensity" obj.multiplier
			comp_light.add "shadows" obj.castShadows
			comp_light.add "color" [obj.rgb.r/255, obj.rgb.g/255, obj.rgb.b/255]
			
			if classof obj == SkyLight then (
				comp_light.add "type" "skylight"
			) else (
				comp_light.add "radius" obj.DecayRadius 
				comp_light.add "near_start" obj.nearAttenStart
				comp_light.add "near_end" obj.nearAttenEnd
				comp_light.add "far_start" obj.farAttenStart
				comp_light.add "far_end" obj.farAttenEnd

				if classof obj == DirectionalLight  then (
					comp_light.add "type" "directional"
				)
				
				if classof obj == freeSpot then (
					comp_light.add "type" "spotlight"
					comp_light.add "inner_angle" obj.hotspot
					comp_light.add "outer_angle" obj.falloff
				)
				
				if classof obj == Omnilight then (
					comp_light.add "type" "pointlight"
				)
			)
			
			jwrite.add "light" comp_light
		)
	),
	
	-- Component to set the collider properties of the given object
	fn exportCollider jwrite obj emesh:false = (
		
		-- Check if children has collider component
		-- Method to work with convex and triangle mesh data
		
		-- In case we have a children belonging to colliders layer, export as 
		-- custom collider mesh
		-- Otherwise, check if component collider exists and export it's bounding box settings
		-- TO-DO
		if obj.children.count > 0 then (
			for child in obj.children do (
				if child.layer.name == layer_colliders then (
					return exportCollider jwrite child true	 
				)
			)
		)
		
		local c_value = retrieveComponent obj component_collider
		
		if c_value != undefined then (
			
			comp_collider = MVDJson()
			-- Create the mesh here
			if emesh == true then (
				-- Use the collider exporter
				-- Depending if its convex or triangle do something
			) else (
				-- Collider type box
				local bb = nodegetboundingbox obj obj.transform
				comp_collider.add "group" c_value.col_group
				comp_collider.add "mask" c_value.col_mask
				comp_collider.add "center" ((obj.pivot - obj.center) * MaxToMVD)  
				comp_collider.add "halfwidth" ( .5 * (bb[2] - bb[1]) * MaxToMVD)
				comp_collider.add "trigger" c_value.is_trigger
				comp_collider.add "dynamic" c_value.is_dynamic
				comp_collider.add "controller" c_value.is_controller
				comp_collider.add "gravity" c_value.is_gravity
			)
			
			jwrite.add "collider" comp_collider
		)
		
		
	),
	
	fn exportSpline jwrite obj = (
		
		-- Export all knots that belong to the spline
		-- Later to be used to build paths for cameras
		-- TO-DO
	),		
	
	-- Custom component, tag
	fn exportTag jwrite obj = (
		-- Get component parameters and export them
		-- TO-DO

	),
	
		-- Custom component, tag
	fn exportRotator jwrite obj = (
		-- Get component parameters and export them
		-- TO-DO

	),
	
	/*
		Add any other necessary custom components here...
	*/
	
	------------------------------------------------------------
	------------------------------------------------------------
	
	-- Used to declare a curve spline for cameras
	-- Do not implement this method yet
	fn exportEntityCurve obj = (
		
		entity = MVDJson()
		
		-- Export base components
		exportName entity obj
		exportSpline entity obj
		
		return entity
	),
	
	-- Used to export xref entities as prefabs
	-- Still on progress since no prefab system has been implemented in the engine.
	fn exportEntityPrefab obj = (
		
		entity = MVDJson()
		
		-- Export base components
		exportName entity obj
		exportTransform entity obj
		exportPrefabLink entity obj
		
		-- Export custom components
		-- Add other custom components you need here!
		exportRotator entity obj
		
		-- ExportTag component to be the last component to be exported.
		exportTag entity obj

		--fs.add "entity" entity
		return entity
	),
	
	-- Export the entity to the json
	fn exportEntity obj = (
		
		entity = MVDJson()
		
		-- Export base components
		exportName entity obj
		exportParent entity obj
		exportTransform entity obj
		exportRender entity obj
		exportLight entity obj 
		exportCollider entity obj

		-- Export custom components
		-- Add other custom components you need here!
		exportRotator entity obj
		
		-- ExportTag component to be the last component to be exported.
		exportTag entity obj
		
		--fs.add "entity" entity
		return entity
	),
	
	-- Set all the necessary directories here
	fn setDirectories epath = (
		
		-- Set the proper paths needed
		project_path = epath
		
		-- Set .obj export settings to geometry type 1 (triangles)
		local iniPath_exportSettings = objExp.getIniName()
		setINISetting iniPath_exportSettings "Geometry" "FaceType" "1"
		
		-- Create the necessary directories
		doesFolderExist (project_path + base_path) create:true
		doesFolderExist (project_path + scenes_path) create:true
		doesFolderExist (project_path + prefabs_path) create:true
		doesFolderExist (project_path + mesh_path) create:true
		doesFolderExist (project_path + mats_path) create:true
		doesFolderExist (project_path + cols_path) create:true
		doesFolderExist (project_path + tex_path) create:true
		doesFolderExist (project_path + curve_path) create:true
		doesFolderExist (project_path + parent_path) create:true
	),
	
	-- Main method used to export the whole scene into json file
	fn exportWorld enodes epath eprg = (
		
		-- Create and set the necessary directories
		setDirectories epath
		item_path = epath + scenes_path + item_name + ".scene"
		parent_path = scenes_path + getfilenamepath (trimRight item_name "\\/")
		
		-- Loop through the nodes and export them
		(
			local eamount = 0
			local entities = #()
			local enode = undefined
			for obj in enodes do (
				
				-- Export the mesh depending on the class type
				if classof obj == XrefObject then (
					enode = exportEntityPrefab obj	
				) else if classof obj == Line then (
					enode = exportEntityCurve obj	
				) else (
					enode = exportEntity obj	
				)
				
				append entities enode
				eamount = eamount + 1
				eprg.value = (eamount / enodes.count) * 100
			)	
		)
		
		-- Reset everything and save data
		(
			select enodes
			
			-- Write data to disk
			fs.add "scene" item_name
			fs.add "entities" entities
			fs.writeDisk item_path
			messageBox ("Scene SUCCESFULLY exported at location: \n\n" + item_path)	
		)
	),	
	
	-- Method to export an scene as prefab
	fn exportPrefab enodes epath eprg = (
		
		-- Export the current scene as prefab
		-- TO-DO
	),
	
	-- Method to export a single mesh object
	fn exportMesh enodes epath eprg = (
		
		-- Create and set the necessary directories
		setDirectories epath
		item_path = epath + mesh_path + item_name + ".mesh"
		parent_path = mesh_path + getfilenamepath (trimRight item_name "\\/")
		
		-- Export the mesh
		-- TO-DO
		messageBox ("Mesh SUCCESFULLY exported at location: \n\n" + item_path)	
	),
	
	-- Method to export a curve
	fn exportCurve enodes epath eprg = (

		-- Create and set the necessary directories
		setDirectories epath
		item_path = epath + curve_path + item_name + ".curve"
		parent_path = curve_path + getfilenamepath (trimRight item_name "\\/")
		
		-- Fill here with the data needed from the curve
		-- TO-DO
		
		messageBox ("Curve SUCCESFULLY exported at location: \n\n" + item_path)	
	),
	
	-- Check between different type of object generation
	fn exportItem enodes etype epath eprg = (
		
		case etype of
		(
			1: ( -- Scene
				exportWorld enodes epath eprg
			)
			2: ( -- Prefab
				exportPrefab enodes epath eprg
			)
			3: ( -- Mesh
				exportMesh enodes epath eprg
			)
			4: ( -- Curve
				exportCurve enodes epath eprg
			) -- More to be added
			default: exportWorld enodes epath eprg
		)
	)
)
