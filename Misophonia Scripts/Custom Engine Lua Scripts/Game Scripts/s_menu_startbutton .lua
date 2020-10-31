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

local audioManager = 0

local input = 0

levelpath 			= ""

loading_sprite = GetComponentHandle("RenderComponent")

clickAudio 			= GetAssetHandle("AudioAsset")
audioID 			= GetComponentHandle("AudioPlayerComponent")

isLoading = false
counter = 0
function Init()

	
	
	

end

function Start()

	isLoading = false
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
	

	GetComponent(loading_sprite).enabled = false


	
	
end

function Interaction()
	

	TurnOffAllFonts()
	GetComponent(loading_sprite).enabled = true
	isLoading = true
	
	
		if(audioID ~= nil and audioID.instance_id ~= 0) then
		audio 				= GetComponent(audioID)
		audio.AudioSound 			= clickAudio
		audio.Playing 				= true
	end
  
end

function CollisionCheck(mousePos)
	
	if(trigger.isActive == true and isLoading  == false) then
		if(MousePositionInAABB(trigger.aabb) == true) then
			Interaction()
		end
	end

end

function Update()

	if(isLoading) then
	if(counter > 1) then
		GetEngine():LoadLevel(levelpath)
	else
		counter = counter + 1
		end
	end

end

function Free()
end