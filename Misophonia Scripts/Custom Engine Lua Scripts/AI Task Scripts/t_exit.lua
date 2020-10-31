--/******************************************************************************/
--/*!
--\project	Misophonia
--\author		Clarence Phun Kok Hoe(100%)
--
--All content (C) 2018 DigiPen (SINGAPORE) Corporation, all rights reserved.
--Reproduction or disclosure of this file or its contents without the prior
--written consent of DigiPen Institute of Technology is prohibited.
--*/
--/******************************************************************************/
aiLogicID 						= GetComponentHandle("AILogicComponent")
aiTransformID					= GetComponentHandle("Transform")
wardrobeTransformID1 			= GetComponentHandle("Transform")
wardrobeTransformID2 			= GetComponentHandle("Transform")
wardrobeTransformID3 			= GetComponentHandle("Transform")
wardrobeTransformID4 			= GetComponentHandle("Transform")
wardrobeTransformID5 			= GetComponentHandle("Transform")
wardrobeTransformID6 			= GetComponentHandle("Transform")
wardrobeTransformID7 			= GetComponentHandle("Transform")

error_catch = 3

function Init()

end
	
function Start()

	aiSystem 					= GetAILogicSystem()
	aiManager 					= GetAILogicManager()


	aiLogic 					= aiManager.GetComponent(aiLogicID)

	transformManager 			= GetTransformManager()


	aiTransform					= GetComponent(aiTransformID)
	
	wardrobeTransform1			= GetComponent(wardrobeTransformID1)
	wardrobeTransform2			= GetComponent(wardrobeTransformID2) 
	wardrobeTransform3			= GetComponent(wardrobeTransformID3)
	wardrobeTransform4			= GetComponent(wardrobeTransformID4) 
	wardrobeTransform5			= GetComponent(wardrobeTransformID5) 
	wardrobeTransform6			= GetComponent(wardrobeTransformID6) 
	wardrobeTransform7			= GetComponent(wardrobeTransformID7)

	wardrobeOffset 				= Vec2.new(0, -1.44)
	
	wardrobePos1				= wardrobeTransform1:GlobalPosition()
	wardrobePos2				= wardrobeTransform2:GlobalPosition()
	wardrobePos3				= wardrobeTransform3:GlobalPosition()
	wardrobePos4				= wardrobeTransform4:GlobalPosition()
	wardrobePos5				= wardrobeTransform5:GlobalPosition()
	wardrobePos6				= wardrobeTransform6:GlobalPosition()
	wardrobePos7				= wardrobeTransform7:GlobalPosition()
	

									
	wardrobeOffset1				= wardrobeTransform1:GlobalPosition() + wardrobeOffset
	wardrobeOffset2				= wardrobeTransform2:GlobalPosition() + wardrobeOffset
	wardrobeOffset3				= wardrobeTransform3:GlobalPosition() + wardrobeOffset
	wardrobeOffset4				= wardrobeTransform4:GlobalPosition() + wardrobeOffset
	wardrobeOffset5				= wardrobeTransform5:GlobalPosition() + wardrobeOffset
	wardrobeOffset6				= wardrobeTransform6:GlobalPosition() + wardrobeOffset
	wardrobeOffset7				= wardrobeTransform7:GlobalPosition() + wardrobeOffset
	
	wardrobeOffsetList				= { wardrobeOffset1, wardrobeOffset2, wardrobeOffset3, wardrobeOffset4, 
									wardrobeOffset5, wardrobeOffset6, wardrobeOffset7 }
  
  error_catch = 3
end

function Distance(vec1, vec2)
	
	result = math.sqrt(((vec2.x - vec1.x)^2) + ((vec2.y - vec1.y)^2))
	return result
end

function GetNearestWardrobeToAI()

	wardrobeMin = nil
	temp = nil
	minDist = math.huge
	
	aiPos = aiTransform.position
	
	for i, v in pairs(wardrobeOffsetList) do
		
		dist = Distance(aiPos, v)
		
		if(dist < minDist) then
		
		
			wardrobeMin = v 
			minDist = dist
		end
		
	end
	
	return wardrobeMin
end

function Update()

end

function End()

end

function Free()

end

function StartTask()
	targetWardrobe = GetNearestWardrobeToAI()
	error_catch = aiLogic:AIMoveTo(targetWardrobe)
end

function Evaluate()
  if (error_catch == 3) then
    StartTask()
  else
    return aiLogic:AICompleteTask()
  end
end