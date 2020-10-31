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
local entityID = 0 -- GetEntity()
local entityManager = 0 -- GetManagers():GetEntityManager()
local entity = 0 -- entityManager:Get(entityID)

local spriteManager = 0 -- GetManagers():GetSpriteManager()
local spriteID = 0 -- entity:GetComponent(spriteManager:GetComponentID())
local sprite = 0 -- spriteManager.GetComponent(spriteID)

local scriptManager = GetScriptedComponentManager()

inventoryID = GetComponentHandle("s_inventory")

lockedPromptIndex = 1
interactPromptIndex = 2

function Init()

end

function Start()

	GetLuaEventSystem():AddListener("EVENT_COLLISION", "CollisionCheck")
	
	entityID 							= GetEntity()
	entityManager 						= GetManagers():GetEntityManager()
	entity 								= entityManager:Get(entityID)

	input 								= GetInputInterface()
	
	transformManager 					= GetManagers():GetTransformManager()
	transformID 						= entity:GetComponent(transformManager:GetComponentID())
	transform 							= transformManager.GetComponent(transformID)
					
	spriteManager 						= GetManagers():GetSpriteManager()
	spriteID 							= entity:GetComponent(spriteManager:GetComponentID())
	sprite 								= spriteManager.GetComponent(spriteID)
	
	renderManager 						= GetRenderComponentManager()
	renderID				 			= entity:GetComponent(renderManager:GetComponentID())
	render 								= renderManager.GetComponent(renderID)
	
	collisionManager 					= GetManagers():GetCollisionManager()
	playerTriggerID 					= entity:GetComponent(collisionManager:GetComponentID())
	trigger 							= collisionManager.GetComponent(playerTriggerID)
	
	tagManager 							= GetTempTagManager()
	
	scriptManager						= GetScriptedComponentManager()
	inventory 							= scriptManager.GetLuaScript(inventoryID)
	
end

function CollisionCheck(hitWrapper)
	
	
	
	entity1 = entityManager:Get(hitWrapper.ent1)
	entity2 = entityManager:Get(hitWrapper.ent2)
	
	name1	= entityManager:Get(hitWrapper.ent1):name()
	name2 	= entityManager:Get(hitWrapper.ent2):name()
	
	if(name1 == "EvilBoiAlive" or name2 == "EvilBoiAlive") then
		return
	end
	
	
	if(hitWrapper.GetState(hitWrapper) == CollisionState.CollisionState_ON_EXIT) then
	
		render.enabled = false
		return
	end
	
	
	doorScript = GetComponentHandle("script_door")
	doorTypeID = doorScript.type_id
	
	
	if(entity1:HasComponent(tagManager:GetComponentID()) == false and entity2:HasComponent(tagManager:GetComponentID()) == false) then
		if(name1 == "Player" or name2 == "Player") then
			sprite.index = interactPromptIndex
			render.enabled = true
			
		end
		return
	end
	
	if(entity1:HasComponent(tagManager:GetComponentID()) == true) then
	
		tag1ID 	= entity1:GetComponent(tagManager:GetComponentID())
		tag1	= tagManager.GetComponent(tag1ID)
			
		if(name2 == "Player" and tag1.info_string == "door") then
			doorInstanceID = entity1:GetComponent(doorTypeID)
			doorInstance = scriptManager.GetLuaScript(doorInstanceID)
			
			if(doorInstance.needNamedKey == true) then
				if(inventory.CheckNamedKeys(doorInstance.keyName) == false) then
					sprite.index = lockedPromptIndex
				else
					sprite.index = interactPromptIndex
				
				end
			else
				sprite.index = interactPromptIndex
				
			end
			render.enabled = true
		elseif(name2 == "Player" and tag1.info_string == "plaque") then
			render.enabled = false
		end
		
		return
		
	end
	
	
	if(entity2:HasComponent(tagManager:GetComponentID()) == true) then
		tag2ID 	= entity2:GetComponent(tagManager:GetComponentID())
		tag2	= tagManager.GetComponent(tag2ID)
		
		if (name1 == "Player" and tag2.info_string == "door") then
			doorInstanceID = entity2:GetComponent(doorTypeID)
			doorInstance = scriptManager.GetLuaScript(doorInstanceID)
				
			if(doorInstance.needNamedKey == true) then
				if(inventory.CheckNamedKeys(doorInstance.keyName) == false) then
					sprite.index = lockedPromptIndex
				else
					sprite.index = interactPromptIndex
				end
			else
					sprite.index = interactPromptIndex
				
			end
			
			render.enabled = true
		elseif(name1 == "Player" and tag2.info_string == "plaque") then
			render.enabled = false
		end
		
		return
		
	end
	
	


	
	
end

function Update()

end

function Free()
end