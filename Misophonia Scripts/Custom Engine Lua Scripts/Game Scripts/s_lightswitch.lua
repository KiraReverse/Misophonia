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
local  transform = 0 -- tManager:GetComponent(tID)
                 
local spriteManager = 0 -- GetManagers():GetSpriteManager()
local spriteID = 0 -- entity:GetComponent(spriteManager:GetComponentID())
local sprite = 0 -- spriteManager.GetComponent(spriteID)

local lightManager = 0
local lightID = 0
local light = 0

local audioManager = 0
local audioID = 0
local audio = 0

local eventSystem = 0
local input = 0

-- light switch global variables

switchOnAudio = GetAssetHandle("AudioAsset")
switchOffAudio = GetAssetHandle("AudioAsset")

switchOnIndex = 0
switchOffIndex = 0

-- function variables
local inRange = false
isOn = false

aiEnter = false
aiTimer = 0

function Init()

	
	
	

end

function Start()
	GetLuaEventSystem():AddListener("EVENT_COLLISION", "CollisionCheck")
	entityID = GetEntity()
	entityManager = GetManagers():GetEntityManager()
	entity = entityManager:Get(entityID)
	
	input = GetInputInterface()
					
	transformManager = GetManagers():GetTransformManager()
	transformID = entity:GetComponent(transformManager:GetComponentID())
	transform = transformManager.GetComponent(transformID)
					
	spriteManager = GetManagers():GetSpriteManager()
	spriteID = entity:GetComponent(spriteManager:GetComponentID())
	sprite = spriteManager.GetComponent(spriteID)
	
	lightManager = GetLightComponentManager()
	lightID = entity:GetComponent(lightManager:GetComponentID())
	light = lightManager.GetComponent(lightID)
	

	audioManager = GetAudioPlayerComponentManager()
	audioID = entity:GetComponent(audioManager:GetComponentID())
	audio = audioManager.GetComponent(audioID)
	
	isOn = light.Switch
	
	
end

function LightsOn()
	isOn = true
	light.Switch = true
	sprite.index = switchOnIndex
	audio.AudioSound = switchOnAudio
	audio.Playing = true
end

function LightsOff()
	isOn = false
	light.Switch = false
	sprite.index = switchOffIndex
	audio.AudioSound = switchOffAudio
	audio.Playing = true
end

function Interaction()
	
	if(isOn == false) then
		LightsOn()
	else
		LightsOff()
	end
end

function CollisionCheck(hitWrapper)

	name1 = entityManager:Get(hitWrapper.ent1):name()
	name2 = entityManager:Get(hitWrapper.ent2):name()
	
	if (name1 == "Player" and hitWrapper.ent2 == entityID) then
		inRange = true
	elseif (name2 == "Player" and hitWrapper.ent1 == entityID) then
		inRange = true
	end
	
	
	
	
	if(hitWrapper.GetState(hitWrapper) == CollisionState.CollisionState_ON_ENTER) then
		
		name1 = entityManager:Get(hitWrapper.ent1):name()
		name2 = entityManager:Get(hitWrapper.ent2):name()
		
		if (name1 == "EvilBoiAlive" and hitWrapper.ent2 == entityID) then
			if(isOn == true) then 
				aiEnter = true
			end
		elseif (name2 == "EvilBoiAlive" and hitWrapper.ent1 == entityID) then
			if(isOn == true) then 
				aiEnter = true
		end
	else
		
	end
		
	end

	
	if(hitWrapper.GetState(hitWrapper) == CollisionState.CollisionState_ON_EXIT) then
		
		name1 = entityManager:Get(hitWrapper.ent1):name()
		name2 = entityManager:Get(hitWrapper.ent2):name()
	
		if((name1 == "Player" and hitWrapper.ent2 == entityID) or (name2 =="Player" and hitWrapper.ent1 == entityID)) then
			inRange = false
		end
		
		if((name1 == "EvilBoiAlive" and hitWrapper.ent2 == entityID) or (name2 =="EvilBoiAlive" and hitWrapper.ent1 == entityID)) then
			aiTimer = 0
			aiEnter = false
		end
	
	end
	
	
end

function Update()
	if(audio.Playing == false) then
		if(CheckE() and inRange == true) then
			Interaction()
		end
	end
	
	if(aiEnter == true) then
		aiTimer = aiTimer + GetEngine():getDeltaTime()
	end
	
	if(aiTimer > 1.5) then
		LightsOff() 
	end

end

function Free()
end