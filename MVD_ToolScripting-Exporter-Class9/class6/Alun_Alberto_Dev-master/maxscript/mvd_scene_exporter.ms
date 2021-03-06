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
global project_path = ""

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
		
		-- TO-DO
	),
	
	-- Link the entity to his parent if needed
	fn exportParent jwrite obj = (
		
		-- TO-DO
	),
	
	-- Export the entity prefab
	fn exportPrefab jwrite obj = (
		
		local f_name = getFilenameFile obj.filename 
		local f_path = (prefabs_path + f_name + ".prefab")
		jwrite.add "prefab" f_path
	),
	
	-- Export the transform component
	fn exportTransform jwrite obj = (
	
		comp_transform = MVDJson()

		-- Export all necessary data from transform
		-- Axis are different from one engine to another
		-- TO-DO

		jwrite.add "transform" comp_transform

	),
	
	-- Export the render component
	fn exportRender jwrite obj = (
		
		if superclassof obj == GeometryClass then (
			
			obj = convertToPoly obj
			comp_render = MVDJson()
			
			-- Export mesh
			-- Export materials
			-- TO-DO
			jwrite.add "render" comp_render
		)
	),
	
	-- Export the light component
	fn exportLight jwrite obj = (
		
		if (superclassof obj) == Light then (
			
			comp_light = MVDJson()
			-- Export lights by type
			-- Export properties
			-- TO-DO
		)
	),
	
	-- Component to set the collider properties of the given object
	fn exportCollider jwrite obj emesh:false = (
		
		-- Check if children has collider component
		-- Method to work with convex and triangle mesh data
		-- Export the collider as a mesh
		-- TO-DO

		-- Export the collider properties
		-- TO-DO
		
		
		comp_collider = MVDJson()
			
		-- Export the collider 
		jwrite.add "collider" comp_collider
			
	),
	
	-- Custom component, tag
	fn exportTag jwrite obj = (
		
		c_values = retrieveComponent obj component_tag

		-- Export a tag component
		-- Maximum four types supported per object
		-- TO-DO
		
		jwrite.add "tags" #("")
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
		
		--fs.add "entity" entity
		return entity
	),
	
	-- Used to export xref entities as prefabs
	-- Still on progress since no prefab system has been implemented in the engine.
	fn exportEntityPrefab obj = (
		
		entity = MVDJson()
		
		-- Export base components
		exportName entity obj
		exportTransform entity obj
		exportPrefab entity obj
		
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
		
		-- ExportTag component to be the last component to be exported.
		exportTag entity obj
		
		--fs.add "entity" entity
		return entity
	),
	
	-- Set all the necessary directories here
	fn setDirectories epath = (
		
		-- Set the proper paths needed
		project_path = epath
		
		-- Create the necessary directories
		doesFolderExist (project_path + base_path) create:true
		doesFolderExist (project_path + scenes_path) create:true
		doesFolderExist (project_path + prefabs_path) create:true
		doesFolderExist (project_path + mesh_path) create:true
		doesFolderExist (project_path + mats_path) create:true
		doesFolderExist (project_path + cols_path) create:true
		doesFolderExist (project_path + tex_path) create:true
		doesFolderExist (project_path + curve_path) create:true
	),
	
	-- Main method used to export the whole scene into json file
	fn exportWorld enodes epath eprg = (
		
		-- Create and set the necessary directories
		setDirectories epath
		item_path = epath + scenes_path + item_name + ".scene"
		
		-- Loop through the nodes and export them
		(
			local eamount = 0
			local entities = #()
			local enode = undefined
			for obj in enodes do (
				
				-- Export the mesh depending on the class type
				enode = exportEntity obj	
				-- Add support for other type of object export
				-- TO-DO
				
				append entities enode
				eamount = eamount + 1
				eprg.value = (eamount / enodes.count) * 100
			)	
		)
		
		-- Reset everything and save data
		(
			select enodes
			
			-- Write data to disk
			fs.add "entities" entities
			fs.writeDisk item_path
			messageBox ("Scene SUCCESFULLY exported at location: \n\n" + item_path)	
		)
	),	
	
	-- Method to export an scene as prefab
	fn exportPrefab enodes epath eprg = (
		
		-- Create and set the necessary directories
		setDirectories epath
		item_path = epath + prefabs_path + item_name + ".prefab"
		
		-- Export an object as a single prefab
		-- TO-DO
	),
	
	-- Method to export a single mesh object
	fn exportMesh enodes epath eprg = (
		
		-- Create and set the necessary directories
		-- Export an object as a single mesh
		-- TO-DO

		messageBox ("Mesh SUCCESFULLY exported at location: \n\n" + item_path)	
	),
	
	-- Method to export a curve
	fn exportCurve enodes epath eprg = (
		
		-- Create and set the necessary directories
		setDirectories epath
		item_path = epath + curve_path + item_name + ".curve"
		
		-- Fill here with the data needed from the curve
		
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
			3: ( -- Curve
				exportCurve enodes epath eprg
			) -- More to be added
			default: exportWorld enodes epath eprg
		)
	)
)
