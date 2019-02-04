function placeObjsOnSpline inputSpline inputObjs =
 (
   	local objsToPlace = #{1..inputObjs.count} as array;
   	for i = 1 to inputObjs.count do
   	(		
   		placeObjIndex = (random 1 objsToPlace.count);
 		inputObjs[objsToPlace[i]].position = (pathInterp inputSpline (i / inputObjs.count as float)); 
   		
   		--objsToPlace = (deleteItem objsToPlace placeObjIndex);
   	);
); 

totalObjs = #()
for i = 1 to 255 do (
	b = box name:(i as string) color:(color i 0 0) scale:[0.1,0.1,0.1]
	append totalObjs b
)

placeObjsOnSpline $Line001 totalObjs
