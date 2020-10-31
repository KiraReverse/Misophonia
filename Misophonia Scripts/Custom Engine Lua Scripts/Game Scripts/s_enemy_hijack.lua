--/******************************************************************************/
--/*!
--\project	Misophonia
--\author		Clarence Phun Kok Hoe(100%)
--
--All content (C) 2019 DigiPen (SINGAPORE) Corporation, all rights reserved.
--Reproduction or disclosure of this file or its contents without the prior
--written consent of DigiPen Institute of Technology is prohibited.
--*/
--/******************************************************************************/
aiLogicID 						= GetComponentHandle("AILogicComponent")
aiTransformID					= GetComponentHandle("Transform")

lightSwitchTransformID1 		= GetComponentHandle("Transform")
lightSwitchTransformID2 		= GetComponentHandle("Transform")
lightSwitchTransformID3 		= GetComponentHandle("Transform")
lightSwitchTransformID4 		= GetComponentHandle("Transform")
lightSwitchTransformID5 		= GetComponentHandle("Transform")

lightSwitchTriggerID1			= GetComponentHandle("CollisionComponent")
lightSwitchTriggerID2			= GetComponentHandle("CollisionComponent")
lightSwitchTriggerID3			= GetComponentHandle("CollisionComponent")
lightSwitchTriggerID4			= GetComponentHandle("CollisionComponent")
lightSwitchTriggerID5			= GetComponentHandle("CollisionComponent")



waitTime = 8
local timeCounter = 0

--figure out the int tied to this enum state in player state(?)
local distractedEnum

function Init()

end

function Start()

aiSystem 					= GetAILogicSystem()
aiManager 					= GetAILogicManager()

aiLogic 					= aiManager.GetComponent(aiLogicID)

transformManager 			= GetTransformManager()

aiTransform					= transformManager.GetComponent(aiTransformID)

lightSwitchTransform1		= transformManager.GetComponent(lightSwitchTransformID1)
lightSwitchTransform2		= transformManager.GetComponent(lightSwitchTransformID2) 
lightSwitchTransform3		= transformManager.GetComponent(lightSwitchTransformID3)
lightSwitchTransform4		= transformManager.GetComponent(lightSwitchTransformID4) 
lightSwitchTransform5		= transformManager.GetComponent(lightSwitchTransformID5) 

collisionManager			= GetCollisionManager()

lightSwitchTrigger1			= collisionManager.GetComponent(lightSwitchTriggerID1) 
lightSwitchTrigger2			= collisionManager.GetComponent(lightSwitchTriggerID2)  
lightSwitchTrigger3			= collisionManager.GetComponent(lightSwitchTriggerID3)  
lightSwitchTrigger4			= collisionManager.GetComponent(lightSwitchTriggerID4)  
lightSwitchTrigger5			= collisionManager.GetComponent(lightSwitchTriggerID5)

local offsetVec1 			= lightSwitchTrigger1.localtranslate
local offset1				= Vec2.new(offsetVec1.x/2, offsetVec1.y/2)

local offsetVec2 			= lightSwitchTrigger2.localtranslate
local offset2				= Vec2.new(offsetVec2.x/2, offsetVec2.y/2)

local offsetVec3 			= lightSwitchTrigger3.localtranslate
local offset3				= Vec2.new(offsetVec3.x/2, offsetVec3.y/2)

local offsetVec4 			= lightSwitchTrigger4.localtranslate
local offset4				= Vec2.new(offsetVec4.x/2, offsetVec4.y/2)

local offsetVec5 			= lightSwitchTrigger5.localtranslate
local offset5				= Vec2.new(offsetVec5.x/2, offsetVec5.y/2)


lightSwitchPos1				= lightSwitchTransform1.position + offset1
lightSwitchPos2				= lightSwitchTransform2.position + offset2
lightSwitchPos3				= lightSwitchTransform3.position + offset3
lightSwitchPos4				= lightSwitchTransform4.position + offset4
lightSwitchPos5				= lightSwitchTransform5.position + offset5
 
switchList					= { lightSwitchPos1, lightSwitchPos2, lightSwitchPos3, lightSwitchPos4, lightSwitchPos5 }

end


function GetDT()
	return GetEngine():getDeltaTime()
end

function Distance(vec1, vec2)
	
	result = math.sqrt(((vec2.x - vec1.x)^2) + ((vec2.y - vec1.y)^2))
	return result
end

function GetNearestSwitch()

	switchMin = nil
	minDist = math.huge
	
	aiPos = aiTransform.position
	for i, v in pairs(switchList) do
		
		dist = Distance(aiPos, v)
		
		if(dist < minDist) then
		
			switchMin = v 
			minDist = dist
		end
		
	end
	
	return switchMin
end

function RollDice()
	
	if(aiLogic.is_hijacked == true) then
		return
	end
	
    dice = math.random(1, 5)

	
	if(dice == 5) then
	
		switch = GetNearestSwitch()
		
		if(switch ~= nil) then
			aiLogic:HijackMovement(switch)
		end
	
	end
end

function Update()

	timeCounter = timeCounter + GetDT()

	if(timeCounter >= waitTime) then
		timeCounter = 0
		RollDice()
	end


end

function Free()

end