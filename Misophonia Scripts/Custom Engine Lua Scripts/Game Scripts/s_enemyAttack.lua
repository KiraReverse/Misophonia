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
-- managers 

local entityID = 0 -- GetEntity()
local entityManager = 0 -- GetManagers():GetEntityManager()
local entity = 0 -- entityManager:Get(entityID)
                 
local transformManager = 0 -- GetManagers():GetTransformManager()
local transformID = 0 -- entity:GetComponent(tManager:GetComponentID())
local transform = 0 -- tManager:GetComponent(tID)
                 
local spriteManager = 0 -- GetManagers():GetSpriteManager()
local spriteID = 0 -- entity:GetComponent(spriteManager:GetComponentID())
local sprite = 0 -- spriteManager.GetComponent(spriteID)

local collisionManager = 0 -- GetManagers():GetCollisionManager()
local colList = 0 -- entity:GetComponents(collisionManager:GetComponentID())

local audioManager = 0

local scriptManager = GetScriptedComponentManager()

local input = 0

-- mainRenderID = GetComponentHandle("RenderComponent")

endFlashID = GetComponentHandle("s_blackout")

local startWait = false
local waitTime = 2
local timeWaited = 0
local flashTime = 1

-- leftSequence = 0
-- rightSequence = 1

function Init()

	
	
	

end

function Start()

	GetLuaEventSystem():AddListener("EVENT_COLLISION", "CollisionCheck")
	entityID = GetEntity()
	entityManager = GetManagers():GetEntityManager()
	entity = entityManager:Get(entityID)

	input = GetInputInterface()
	
					
	-- transformManager = GetManagers():GetTransformManager()
	-- transformID = entity:GetComponent(transformManager:GetComponentID())
	-- transform = transformManager.GetComponent(transformID)
					
	-- spriteManager = GetManagers():GetSpriteManager()
	-- spriteID = entity:GetComponent(spriteManager:GetComponentID())
	-- sprite = spriteManager.GetComponent(spriteID)
	
	-- animationManager = GetSpriteAnimationControllerManager()
	-- animationID = entity:GetComponent(animationManager:GetComponentID())	
	-- animation = animationManager.GetComponent(animationID)

	-- renderManager = GetRenderComponentManager()
	-- mainRender = renderManager.GetComponent(mainRenderID)
	
	-- renderID = entity:GetComponent(renderManager:GetComponentID())
	-- render = renderManager.GetComponent(renderID)
	
	endFlash = scriptManager.GetLuaScript(endFlashID)
	
	
end

function EndGame()
	
	-- mainRender.enabled = false
	
	-- render.enabled = true
	-- animation.enabled = true
	-- animation.playing = true
	
	startWait = true
end

function CheckDirection(x1, x2)

	result = x1 - x2
	
	return result
end



function CollisionCheck(hitWrapper)

	entity1 = entityManager:Get(hitWrapper.ent1)
	entity2 = entityManager:Get(hitWrapper.ent2)
	
	-- transform1ID = entity1:GetComponent(transformManager:GetComponentID())
	-- transform1 = transformManager.GetComponent(transform1ID)
	
	-- transform2ID = entity2:GetComponent(transformManager:GetComponentID())
	-- transform2 = transformManager.GetComponent(transform2ID)
	
	-- vec1 = transform1.position
	-- vec2 = transform2.position
	

	
	name1 = entityManager:Get(hitWrapper.ent1):name()
	name2 = entityManager:Get(hitWrapper.ent2):name()
	
	
	
	if (name1 == "Player" and name2 == "EvilBoiAlive") then
		
		-- dist = CheckDirection(vec1.x, vec2.x)
		
		-- print(dist)
		-- if(dist > 0) then
		
		
			-- animation.sequence_index = rightSequence
		-- else
			-- animation.sequence_index = leftSequence
		-- end

		EndGame()
	
	elseif (name2 == "Player" and name2 == "EvilBoiAlive") then
		
		-- dist = CheckDirection(vec2.x, vec1.x)
		

		-- if(dist > 0) then
		
			-- animation.sequence_index = rightSequence
		-- else
			-- animation.sequence_index = leftSequence
		-- end

		EndGame()
	end
	
	
end

function Update()

if(startWait == true) then
	timeWaited = timeWaited + GetEngine():getDeltaTime()
	
	if(timeWaited >= flashTime) then
		endFlash.Flash()
	end
	
	if(timeWaited >= waitTime) then
		GetEngine():LoadLevel("levelfiles/endgame")
	end
end

end

function Free()
end