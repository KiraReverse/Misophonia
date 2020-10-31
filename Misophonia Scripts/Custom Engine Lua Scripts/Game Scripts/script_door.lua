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

interactingTime = 1.0
local shouldInteract = false
local timer = 0
local player = 0
local playerTrans = 0


triggerID = GetComponentHandle("CollisionComponent") 
colliderID = GetComponentHandle("CollisionComponent")

audioID = GetComponentHandle("AudioPlayerComponent")

playerInventoryID = GetComponentHandle("s_inventory")


-- door sprite info

doorOpenIndex = 3
doorCloseIndex = 0

-- door audio info

doorLockedAudio = GetAssetHandle("AudioAsset")
doorUnlockedAudio = GetAssetHandle("AudioAsset")
doorOpenAudio = GetAssetHandle("AudioAsset")
doorClosedAudio = GetAssetHandle("AudioAsset")

-- function variables
local inRange = false
local isOpen = false
needNamedKey = false
keyName = ""

function Init()

	
	
	

end

function Start()
	GetLuaEventSystem():AddListener("EVENT_COLLISION", "CollisionCheck")
	entityID = GetEntity()
	entityManager = GetManagers():GetEntityManager()
	entity = entityManager:Get(entityID)

	input = GetInputInterface()
	playerStateM = GetPlayerStateManager()
					
	transformManager = GetManagers():GetTransformManager()
	transformID = entity:GetComponent(transformManager:GetComponentID())
	transform = transformManager.GetComponent(transformID)
					
	spriteManager = GetManagers():GetSpriteManager()
	spriteID = entity:GetComponent(spriteManager:GetComponentID())
	sprite = spriteManager.GetComponent(spriteID)

	collisionManager = GetManagers():GetCollisionManager()
	colList = entity:GetComponents(collisionManager:GetComponentID())
	
	audioManager = GetAudioPlayerComponentManager()
	
	
	playerInventory = scriptManager.GetLuaScript(playerInventoryID)
	

	
	trigger = collisionManager.GetComponent(triggerID)
	collider = collisionManager.GetComponent(colliderID)
	audio = audioManager.GetComponent(audioID)

	aiSystem = GetAILogicSystem()
	aiManager = GetAILogicManager()
	
end


function OpenDoor()
	sprite.index = doorOpenIndex
	
	if(collider.isActive == true) then
		collider.isActive = false
	end
	audio.AudioSound = doorOpenAudio
	audio.Playing = true
	isOpen = true
	
end

function CloseDoor()
	sprite.index = doorCloseIndex
		
	if(collider.isActive == false) then
			collider.isActive = true
	end
	
	audio.AudioSound = doorClosedAudio
	audio.Playing = true
	
	isOpen = false
	
end

function GetPlayerNewDir()

  nPos = transform:GlobalPosition() - playerTrans:GlobalPosition()
  
  --if left == true
  LR = Directions.Dir_Right
  if(nPos.x < 0) then
    LR = Directions.Dir_L
  end
  
  UD = Directions.Dir_Down
  if(nPos.y >= 0) then 
    UD = Directions.Dir_Up
  end
  
  if(math.abs(nPos.y) > math.abs(nPos.x)) then
  --  print("UP OR DOWN")
    return UD
  else
  --  print("LEFTRIGHT")
    return LR
  end
end



function Interaction()
	
	if(isOpen == false) then
		if(needNamedKey == true) then
				if(playerInventory.CheckNamedKeys(keyName) == true) then	
					needNamedKey = false
					audio.AudioSound = doorUnlockedAudio
					audio.Playing = true
					OpenDoor()
					isOpen = true
				else
					audio.AudioSound = doorLockedAudio
					audio.Playing = true
				end

			
		else
			
			
			
			OpenDoor()
		end

	else
		
		
		CloseDoor()
		
	end
  
  timer  = interactingTime
  shouldInteract = true
  
  
  
end

function IsAboveDoor(target)
	
	tPos = transform:GlobalPosition()
	
	if(tPos.y > target) then
		return false
	end
	
	return true

end






function CollisionCheck(hitWrapper)

	name1 = entityManager:Get(hitWrapper.ent1):name()
	name2 = entityManager:Get(hitWrapper.ent2):name()
	
		if (name1 == "Player" and hitWrapper.ent2 == entityID) then
   -- print("Player!!!")
		inRange = true
		player = entityManager:Get(hitWrapper.ent1)
		playerTransID = player:GetComponent(transformManager:GetComponentID())
		playerTrans = GetComponent(playerTransID)

  elseif (name2 == "Player" and hitWrapper.ent1 == entityID) then
  --  print("Player!!!")
		inRange = true
		player = entityManager:Get(hitWrapper.ent2)
		playerTransID = player:GetComponent(transformManager:GetComponentID())
		playerTrans = GetComponent(playerTransID)
  end
	
	if (name1 == "EvilBoiAlive" and hitWrapper.ent2 == entityID) then
	
		aiEnt = entityManager:Get(hitWrapper.ent1)
		aiTrans = GetComponent(aiEnt:GetComponent(transformManager:GetComponentID()))
		aiPos = aiTrans.position
		aiLogicID = aiEnt:GetComponent(aiManager:GetComponentID())
		
		if(aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Up and IsAboveDoor(aiPos.y) == false) then
			if(isOpen == false) then
				OpenDoor()
			end
		elseif (aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Down and IsAboveDoor(aiPos.y) == true) then
			if(isOpen == false) then
				OpenDoor()
			end
		end
		
	elseif (name2 == "EvilBoiAlive" and hitWrapper.ent1 == entityID) then
		
		aiEnt = entityManager:Get(hitWrapper.ent2)
		aiTrans = GetComponent(aiEnt:GetComponent(transformManager:GetComponentID()))
		aiPos = aiTrans.position
		aiLogicID = aiEnt:GetComponent(aiManager:GetComponentID())
		
		if(aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Up and IsAboveDoor(aiPos.y) == false) then
			if(isOpen == false) then
				OpenDoor()
			end
			
		elseif (aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Down and IsAboveDoor(aiPos.y) == true) then
			if(isOpen == false) then
				OpenDoor()
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
			aiPos = aiTrans.position
			aiLogicID = aiEnt:GetComponent(aiManager:GetComponentID())
			
      if(aiSystem:GetAIState(aiLogicID) == CharacterState.CharacterState_Stun or 
      aiSystem:GetAIState(aiLogicID) == CharacterState.CharacterState_Attack or aiSystem:GetAIState(aiLogicID) == CharacterState.CharacterState_Hijack) then
        return
      end
      
      
			if(aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Up and IsAboveDoor(aiPos.y) == true) then
				if(isOpen == true) then
					CloseDoor()
				end
				
			elseif (aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Down and IsAboveDoor(aiPos.y) == false) then
				if(isOpen == true) then
					CloseDoor()
				end 
			end
		
		elseif (name2 == "EvilBoiAlive" and hitWrapper.ent1 == entityID) then
		
			aiEnt = entityManager:Get(hitWrapper.ent2)
			aiTrans = GetComponent(aiEnt:GetComponent(transformManager:GetComponentID()))
			aiPos = aiTrans.position
			aiLogicID = aiEnt:GetComponent(aiManager:GetComponentID())
			
			if(aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Up and IsAboveDoor(aiPos.y) == true) then
				if(isOpen == true) then
					CloseDoor()
				end
				
			elseif (aiSystem:GetAIDirection(aiLogicID) == Directions.Dir_Down and IsAboveDoor(aiPos.y) == false) then
				if(isOpen == true) then
					CloseDoor()
				end
			end
		end
		
	end
	

	
end

function Update()

	if(audio.Playing == false) then
		if(CheckE()) then
			if(inRange == true) then
				Interaction()
			end
		end
	end
  
  
    if(shouldInteract and timer > 0.0) then
     -- print(player)
      playerStateID = player:GetComponent(playerStateM:GetComponentID())
      playerState = GetComponent(playerStateID)
      --print("playerState")
     -- print(playerState)
      --print("playerState end")
      playerState.newDir = GetPlayerNewDir()
      playerState.newState = CharacterState.CharacterState_Interact
      timer = timer - 0.1
  else
    shouldInteract = false
  end
  
  
end

function Free()
end