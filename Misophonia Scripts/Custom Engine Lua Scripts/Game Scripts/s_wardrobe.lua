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
local input = 0

triggerID = GetComponentHandle("CollisionComponent") 
colliderID = GetComponentHandle("CollisionComponent")
playerColliderID = GetComponentHandle("CollisionComponent")
playerRenderID = GetComponentHandle("RenderComponent")
audioID = GetComponentHandle("AudioPlayerComponent")
actorScriptID = GetComponentHandle("s_wardrobe_actor")

-- door sprite info

wardrobeOpenIndex = 10
wardrobeCloseIndex = 9

-- door audio info

wardrobeOpenAudio = GetAssetHandle("AudioAsset")
wardrobeClosedAudio = GetAssetHandle("AudioAsset")

-- function variables
local inRange = false
local isOpen = false
local isInRange = false
local isInside = false

function Init()
end

function Start()
	GetLuaEventSystem():AddListener("EVENT_COLLISION", "CollisionCheck")
	entityID = GetEntity()
	entityManager = GetManagers():GetEntityManager()
	entity = entityManager:Get(entityID)
					
	transformManager = GetManagers():GetTransformManager()
	transformID = entity:GetComponent(transformManager:GetComponentID())
	transform = transformManager.GetComponent(transformID)
	
	input = GetInputInterface()
	cController =  GetCConComponent()
	
	spriteManager = GetManagers():GetSpriteManager()
	spriteID = entity:GetComponent(spriteManager:GetComponentID())
	sprite = spriteManager.GetComponent(spriteID)
	collisionManager = GetManagers():GetCollisionManager()
	colList = entity:GetComponents(collisionManager:GetComponentID())
	audioManager = GetAudioPlayerComponentManager()
	trigger = collisionManager.GetComponent(triggerID)
	collider = collisionManager.GetComponent(colliderID)
	audio = audioManager.GetComponent(audioID)
	playerCollider = GetComponent(playerColliderID)
	playerRender = GetComponent(playerRenderID)
	scriptManager = GetScriptedComponentManager()
	actorScript = scriptManager.GetLuaScript(actorScriptID)
	
	aiSystem = GetAILogicSystem()
	aiManager = GetAILogicManager()
  
  
    playerEntID = playerRender:GetEntity()
  playerEnt = GetEntityManager():Get(playerEntID)
  playerState = playerEnt:GetComponent(GetPlayerStateManager():GetComponentID())
end

function Interaction()
	if(isOpen == false) then		
		OpenDoor()
	else
		CloseDoor()
	end
end

function OpenDoor()
	isOpen = true
	sprite.index = wardrobeOpenIndex
		
	if(collider.isActive == true) then
		collider.isActive = false
	end
	
	audio.AudioSound = wardrobeOpenAudio
	audio.Playing = true
end

function CloseDoor()
	isOpen = false	
	sprite.index = wardrobeCloseIndex
		
	if(collider.isActive == false) then
		collider.isActive = true
	end
		
	audio.AudioSound = wardrobeClosedAudio
	audio.Playing = true
end

function AIEntry()
	actorScript.ActivateActor(transform:GlobalPosition())
	
	if(isOpen == false) then
		OpenDoor()
	end
end

function OpenDoorInside()
				sprite.index = wardrobeOpenIndex
				audio.AudioSound = wardrobeOpenAudio
				audio.Playing = true
				playerRender.enabled = true
				cController.isActive = true
				playerCollider.isActive = true
				isOpen = true
				isInside = false
end

function CloseDoorInside()
				sprite.index = wardrobeCloseIndex
				audio.AudioSound = wardrobeClosedAudio
				audio.Playing = true
				playerRender.enabled = false
				cController.isActive = false
				playerCollider.isActive = false
				isOpen = false
				isInside = true
end

function CollisionCheck(hitWrapper)
	name1 = entityManager:Get(hitWrapper.ent1):name()
	name2 = entityManager:Get(hitWrapper.ent2):name()
	
	if (name1 == "Player" and hitWrapper.ent2 == entityID) then
		inRange = true
	elseif (name2 == "Player" and hitWrapper.ent1 == entityID) then
		inRange = true
	end
	
	if (name1 == "EvilBoiAlive" and hitWrapper.ent2 == entityID) then
	
		aiEnt = entityManager:Get(hitWrapper.ent1)
		aiTrans = GetComponent(aiEnt:GetComponent(transformManager:GetComponentID()))
		aiLogicID = aiEnt:GetComponent(aiManager:GetComponentID())
		
		if(aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Up) then
			if(isOpen == false and isInside == false) then
				OpenDoor()
			elseif ( isOpen == false and isInside == true) then
				OpenDoorInside()
			end
		end
		
	elseif (name2 == "EvilBoiAlive" and hitWrapper.ent1 == entityID) then
		
		aiEnt = entityManager:Get(hitWrapper.ent2)
		aiTrans = GetComponent(aiEnt:GetComponent(transformManager:GetComponentID()))
		aiLogicID = aiEnt:GetComponent(aiManager:GetComponentID())
		
		if(aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Up) then
			if(isOpen == false and isInside == false) then
				OpenDoor()
			elseif ( isOpen == false and isInside == true	) then
				OpenDoorInside()
			end
		end
	end
	
	
	if(hitWrapper.GetState(hitWrapper) == CollisionState.CollisionState_ON_EXIT) then
		name1 = entityManager:Get(hitWrapper.ent1):name()
		name2 = entityManager:Get(hitWrapper.ent2):name()
	
		if((name1 == "Player" and hitWrapper.ent2 == entityID) or (name2 =="Player" and hitWrapper.ent1 == entityID)) then
			inRange = false
		end
		
		if (name1 == "EvilBoiAlive" and hitWrapper.ent2 == entityID) then
	
			aiEnt = entityManager:Get(hitWrapper.ent1)
			aiTrans = GetComponent(aiEnt:GetComponent(transformManager:GetComponentID()))
			aiLogicID = aiEnt:GetComponent(aiManager:GetComponentID())
				
			if (aiSystem:GetAIState(aiLogicID) ~= CharacterState.CharacterState_Run and aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Down) then
				if(isOpen == true) then
					CloseDoor()
				end 
			end
		
		elseif (name2 == "EvilBoiAlive" and hitWrapper.ent1 == entityID) then
		
			aiEnt = entityManager:Get(hitWrapper.ent2)
			aiTrans = GetComponent(aiEnt:GetComponent(transformManager:GetComponentID()))
			aiLogicID = aiEnt:GetComponent(aiManager:GetComponentID())
			
			if (aiSystem:GetAIState(aiLogicID) ~=  CharacterState.CharacterState_Run and aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Down) then
				if(isOpen == true) then
					CloseDoor()
				end
			end
		end
	end	
end

function Update()
	if(playerCollider.aabb.min_.y > trigger.aabb.max_.y and playerCollider.aabb.min_.y < trigger.aabb.max_.y + 0.5) then
		if(playerCollider.aabb.min_.x > trigger.aabb.min_.x and 
		   playerCollider.aabb.max_.x < trigger.aabb.max_.x) then
			isInRange = true
		else
			isInRange = false
		end
	else
		isInRange = false
	end
	
	if(audio.Playing == false) then
		if(isOpen == false) then
			if((isInRange == true and CheckE()) or playerState.currState == CharacterState.CharacterState_Hijack
      or  playerState.currState == CharacterState.CharacterState_Struggle
      or  playerState.currState == CharacterState.CharacterState_Stun) then
				OpenDoorInside()
			end
		else
			if(isInRange == true and CheckE()) then
				CloseDoorInside()
			end
		end
	end
	
	if(CheckE()) then
		if(audio.Playing == false) then
			if(inRange == true) then
				Interaction()
			end
		end
	end
end

function Free()
end