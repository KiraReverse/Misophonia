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


local input = 0

--spriteInfo
glowSpriteIndex 		= 1
defaultSpriteIndex	 	= 0

hoverAudio = GetAssetHandle("AudioAsset")
clickAudio = GetAssetHandle("AudioAsset")

audioCompID = GetComponentHandle("AudioPlayerComponent")

function Init()

	
	
	

end

function Start()

	GetLuaEventSystem():AddListener("EVENT_MOUSECLICK", "CollisionCheck")
	
	entityID 			= GetEntity()
	entityManager 		= GetManagers():GetEntityManager()
	entity 				= entityManager:Get(entityID)

	input 				= GetInputInterface()
	
	transformManager 	= GetManagers():GetTransformManager()
	transformID 		= entity:GetComponent(transformManager:GetComponentID())
	transform 			= transformManager.GetComponent(transformID)
					
	spriteManager 		= GetManagers():GetSpriteManager()
	spriteID 			= entity:GetComponent(spriteManager:GetComponentID())
	sprite 				= spriteManager.GetComponent(spriteID)

	collisionManager 	= GetManagers():GetCollisionManager()
	triggerID 			= entity:GetComponent(collisionManager:GetComponentID())
	trigger				= collisionManager.GetComponent(triggerID)
	
	audioComp			= GetComponent(audioCompID)
	
	playOnce = false
	
end

function Interaction()
	
	GetEngine():Terminate()
  
end

function CollisionCheck(mousePos)
	
	

end

function Update()

if(trigger.isActive == true) then
		if(MousePositionInAABB(trigger.aabb) == true) then
			sprite.index = glowSpriteIndex
			if (playOnce == false) then
				audioComp.Playing = true
				audioComp.AudioSound = hoverAudio
				playOnce = true
			end
		else
			sprite.index = defaultSpriteIndex
			if (playOnce == true) then
				playOnce = false
			end
		end
	end
end

function Free()
end