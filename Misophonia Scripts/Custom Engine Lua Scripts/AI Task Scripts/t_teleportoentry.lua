--/******************************************************************************/
--/*!
--\project	Misophonia
--\author		Clarence Phun Kok hoe(100%)
--
--All content (C) 2018 DigiPen (SINGAPORE) Corporation, all rights reserved.
--Reproduction or disclosure of this file or its contents without the prior
--written consent of DigiPen Institute of Technology is prohibited.
--*/
--/******************************************************************************/
aiLogicID 						= GetComponentHandle("AILogicComponent")
aiTransformID					= GetComponentHandle("Transform")

playerTransformID 				= GetComponentHandle("Transform")

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

	aiTransform					= transformManager.GetComponent(aiTransformID)
	playerTransform				= GetComponent(playerTransformID)
	
	wardrobeTransform1			= transformManager.GetComponent(wardrobeTransformID1)
	wardrobeTransform2			= transformManager.GetComponent(wardrobeTransformID2) 
	wardrobeTransform3			= transformManager.GetComponent(wardrobeTransformID3)
	wardrobeTransform4			= transformManager.GetComponent(wardrobeTransformID4) 
	wardrobeTransform5			= transformManager.GetComponent(wardrobeTransformID5) 
	wardrobeTransform6			= transformManager.GetComponent(wardrobeTransformID6) 
	wardrobeTransform7			= transformManager.GetComponent(wardrobeTransformID7)

	wardrobeOffset 				= Vec2.new(0, -1.44)
	
	wardrobePos1				= wardrobeTransform1:GlobalPosition()
	wardrobePos2				= wardrobeTransform2:GlobalPosition()
	wardrobePos3				= wardrobeTransform3:GlobalPosition()
	wardrobePos4				= wardrobeTransform4:GlobalPosition()
	wardrobePos5				= wardrobeTransform5:GlobalPosition()
	wardrobePos6				= wardrobeTransform6:GlobalPosition()
	wardrobePos7				= wardrobeTransform7:GlobalPosition()
	
	
	wardrobeList				= { wardrobePos1, wardrobePos2, wardrobePos3, wardrobePos4, 
									wardrobePos5, wardrobePos6, wardrobePos7 }
									
	wardrobeOffset1				= wardrobeTransform1:GlobalPosition() + wardrobeOffset
	wardrobeOffset2				= wardrobeTransform2:GlobalPosition() + wardrobeOffset
	wardrobeOffset3				= wardrobeTransform3:GlobalPosition() + wardrobeOffset
	wardrobeOffset4				= wardrobeTransform4:GlobalPosition() + wardrobeOffset
	wardrobeOffset5				= wardrobeTransform5:GlobalPosition() + wardrobeOffset
	wardrobeOffset6				= wardrobeTransform6:GlobalPosition() + wardrobeOffset
	wardrobeOffset7				= wardrobeTransform7:GlobalPosition() + wardrobeOffset
	
	-- variables
	local targetWardrobe 		= nil
	local wardrobeGiven 		= false
  
  error_catch = 3
end

function Distance(vec1, vec2)
	
	result = math.sqrt(((vec2.x - vec1.x)^2) + ((vec2.y - vec1.y)^2))
	return result
end

function GetNearestWardrobeToPlayer()

	wardrobeMin = nil
	minDist = math.huge
	
	playerPos = playerTransform.position
	
	for i, v in pairs(wardrobeList) do
		
		dist = Distance(playerPos, v)
		
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
	
end

function Evaluate()
  if (error_catch == 3) then
    StartTask()
  else
    return aiLogic:AICompleteTask()
  end
end