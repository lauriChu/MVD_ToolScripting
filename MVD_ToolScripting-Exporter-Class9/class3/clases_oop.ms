-- Change the path to make it work!!!
global mat_folders = "D:\Users\Alberto\Desktop\materials\\"

struct MyMaterialExporter
(
	mat_name = "default",
    mat_tech = "pbr.tech",
	mat_shadows = true,
	
    public
    fn Constructor =
    (
	print ("The object has been created")
	return true
    ),
	
    fn exportMaterial mat =  (  
		print mat_name
		print mat_tech
		print mat_shadows
		
		print mat.ambientMap
		print mat.specularMap
		print mat.diffuseMap
		txt = "test"
		
		f = (createFile mat_folders + mat_name)
		format txt to:f
    )
)

fn testMaterialExporter = (
	newmat = StandardMaterial()
	exp_test = MyMaterialExporter mat_name:"mtl_test.mat"
	exp_test.exportMaterial newmat		
)
testMaterialExporter()
