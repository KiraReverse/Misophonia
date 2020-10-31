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

aiRenderID						= GetComponentHandle("RenderComponent")

playerTransformID 				= GetComponentHandle("Transform")

wardrobeTransformID1 			= GetComponentHandle("Transform")
wardrobeTransformID2 			= GetComponentHandle("Transform")
wardrobeTransformID3 			= GetComponentHandle("Transform")
wardrobeTransformID4 			= GetComponentHandle("Transform")
wardrobeTransformID5 			= GetComponentHandle("Transform")
wardrobeTransformID6 			= GetComponentHandle("Transform")
wardrobeTransformID7 			= GetComponentHandle("Transform")


wardrobeScript1ID				= GetComponentHandle("s_wardrobe")
wardrobeScript2ID				= GetComponentHandle("s_wardrobe")
wardrobeScript3ID				= GetComponentHandle("s_wardrobe")
wardrobeScript4ID				= GetComponentHandle("s_wardrobe")
wardrobeScript5ID				= GetComponentHandle("s_wardrobe")
wardrobeScript6ID				= GetComponentHandle("s_wardrobe")
wardrobeScript7ID				= GetComponentHandle("s_wardrobe")

audioPlayerID					= GetComponentHandle("AudioPlayerComponent")

laugh1							= GetAssetHandle ("AudioAsset")
laugh2							= GetAssetHandle ("AudioAsset")
laugh3							= GetAssetHandle ("AudioAsset")
	
	
error_catch = 3

local timer = 0

function Init()

end
	
function Start()

	aiSystem 					= GetAILogicSystem()
	aiManager 					= GetAILogicManager()

	aiLogic 					= aiManager.GetComponent(aiLogicID)
	
	aiRender 					= GetComponent(aiRenderID)

	transformManager 			= GetTransformManager()
	
	audioPlayer 				= GetComponent(audioPlayerID)

	--aiTransform					= transformManager.GetComponent(aiTransformID)
	playerTransform				= transformManager.GetComponent(playerTransformID)
	
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

									
	wardrobeOffset1				= wardrobeTransform1:GlobalPosition() + wardrobeOffset
	wardrobeOffset2				= wardrobeTransform2:GlobalPosition() + wardrobeOffset
	wardrobeOffset3				= wardrobeTransform3:GlobalPosition() + wardrobeOffset
	wardrobeOffset4				= wardrobeTransform4:GlobalPosition() + wardrobeOffset
	wardrobeOffset5				= wardrobeTransform5:GlobalPosition() + wardrobeOffset
	wardrobeOffset6				= wardrobeTransform6:GlobalPosition() + wardrobeOffset
	wardrobeOffset7				= wardrobeTransform7:GlobalPosition() + wardrobeOffset
	
	wardrobeOffsetList				= { wardrobeOffset1, wardrobeOffset2, wardrobeOffset3, wardrobeOffset4, 
									wardrobeOffset5, wardrobeOffset6, wardrobeOffset7 }
									
	
	scriptManager				= GetScriptedComponentManager()
	
	wardrobeScript1				= scriptManager.GetLuaScript(wardrobeScript1ID)
	wardrobeScript2				= scriptManager.GetLuaScript(wardrobeScript2ID)
	wardrobeScript3				= scriptManager.GetLuaScript(wardrobeScript3ID)
	wardrobeScript4				= scriptManager.GetLuaScript(wardrobeScript4ID)
	wardrobeScript5				= scriptManager.GetLuaScript(wardrobeScript5ID)
	wardrobeScript6				= scriptManager.GetLuaScript(wardrobeScript6ID)
	wardrobeScript7				= scriptManager.GetLuaScript(wardrobeScript7ID)


	wardrobeScriptList = { [wardrobeOffset1] = wardrobeScript1, [wardrobeOffset2] = wardrobeScript2, [wardrobeOffset3] = wardrobeScript3, [wardrobeOffset4] = wardrobeScript4, 
							[wardrobeOffset5] = wardrobeScript5, [wardrobeOffset6] = wardrobeScript6, [wardrobeOffset7] = wardrobeScript7, }


	
	error_catch = 3
end

function Distance(vec1, vec2)
	
	result = math.sqrt(((vec2.x - vec1.x)^2) + ((vec2.y - vec1.y)^2))
	return result
end

function GetNearestWardrobeToPlayer()

	wardrobeMin = nil
	temp = nil
	minDist = math.huge
	maxDist = 0
	
	playerPos = playerTransform.position
	
	for i, v in pairs(wardrobeOffsetList) do
		
		dist = Distance(playerPos, v)
		
		if(dist < minDist) then
			temp = wardrobeMin
			wardrobeMin = wardrobeOffsetList[i]
			minDist = dist

		end
		
		
		
	end 	 
	if(temp == nil)  then
		return wardrobeMin
	else
		return temp
	end
end

function GetScript(target)
	
	for i, v in pairs(wardrobeScriptList) do
		
		if( target == i) then
			return v
		end
		
	end
end

function Laugh()
	-- if(aiSystem:GetAIState(aiLogicID) == 3) then
		-- return
	-- end
	
	roll = math.random(1, 3)

	if(roll == 1) then
		audioPlayer.AudioSound = laugh1
	elseif(roll == 2) then
		audioPlayer.AudioSound = laugh2
	elseif(roll == 3) then
		audioPlayer.AudioSound = laugh3
	end
	
	audioPlayer.Playing = true

end
 

function Update()

	
end

function End()

end

function Free()
end

function StartTask()
  targetWardrobe = GetNearestWardrobeToPlayer()

  
  script = GetScript(targetWardrobe)
  
  script.AIEntry()
  Laugh();
  error_catch = aiLogic:AITeleportTo(targetWardrobe, 0.5)

  
end

function Evaluate()
  if (error_catch == 3) then
    StartTask()
  else
    return aiLogic:AICompleteTask()
  end
end