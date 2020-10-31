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


--screen stuff
audioID 			= GetComponentHandle("AudioPlayerComponent")

screenRenderID 		= GetComponentHandle("RenderComponent")

backRenderID 		= GetComponentHandle("RenderComponent") 
backFontID 			= GetComponentHandle("FontComponent")
backTriggerID 		= GetComponentHandle("CollisionComponent")

nextRenderID 		= GetComponentHandle("RenderComponent") 
nextFontID 			= GetComponentHandle("FontComponent")
nextTriggerID 		= GetComponentHandle("CollisionComponent")

-- audio info
clickAudio 			= GetAssetHandle("AudioAsset")


--other buttons

startRenderID 		= GetComponentHandle("RenderComponent")
startFontID 		= GetComponentHandle("FontComponent")
startTriggerID 		= GetComponentHandle("CollisionComponent")

howtoplayRenderID 	= GetComponentHandle("RenderComponent")
howtoplayFontID 	= GetComponentHandle("FontComponent")
howtoplayTriggerID 	= GetComponentHandle("CollisionComponent")

creditsRenderID 	= GetComponentHandle("RenderComponent")
creditsFontID 		= GetComponentHandle("FontComponent")
creditsTriggerID 	= GetComponentHandle("CollisionComponent")

quitRenderID 		= GetComponentHandle("RenderComponent")
quitFontID 			= GetComponentHandle("FontComponent")
quitTriggerID 		= GetComponentHandle("CollisionComponent")

-- monster eyes

--eye1ID 				= GetComponentHandle("MonsterEyeComponent")
--eye2ID				= GetComponentHandle("MonsterEyeComponent")

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
	
	audioManager 		= GetAudioPlayerComponentManager()
	audio 				= audioManager.GetComponent(audioID)
	
	renderManager 		= GetRenderComponentManager()
	screenRender 		= renderManager.GetComponent(screenRenderID)
	
	fontManager 		= GetFontComponentManager()
	
	--eyeManager 			= GetMonsterEyeComponentManager()
	
	--back buttons
	backRender 			= renderManager.GetComponent(backRenderID)
	backFont 			= fontManager.GetComponent(backFontID)
	backTrigger 		= collisionManager.GetComponent(backTriggerID)
	
	nextRender 			= GetComponent(nextRenderID)
	nextFont 			= GetComponent(nextFontID)
	nextTrigger 		= GetComponent(nextTriggerID)
	
	--monster eye
	--eye1				= eyeManager.GetComponent(eye1ID)
	--eye2				= eyeManager.GetComponent(eye2ID)
	
	--other menu buttons
	startRender 		= renderManager.GetComponent(startRenderID)
	startFont 			= fontManager.GetComponent(startFontID)
	startTrigger		= collisionManager.GetComponent(startTriggerID)

	howtoplayRender		= renderManager.GetComponent(howtoplayRenderID)
	howtoplayFont 		= fontManager.GetComponent(howtoplayFontID)
	howtoplayTrigger 	= collisionManager.GetComponent(howtoplayTriggerID)

	creditsRender 		= renderManager.GetComponent(creditsRenderID)
	creditsFont 		= fontManager.GetComponent(creditsFontID)
	creditsTrigger 		= collisionManager.GetComponent(creditsTriggerID)

	quitRender 			= renderManager.GetComponent(quitRenderID)
	quitFont			= fontManager.GetComponent(quitFontID)
	quitTrigger 		= collisionManager.GetComponent(quitTriggerID)
	
	

	
	
end

function Interaction()
	
		audio.AudioSound 			= clickAudio
		audio.Playing 				= true
		
		--turning on screen render/turning off lights/eye
		screenRender.enabled 		= true
		
	--eye1.Switch					= false
	--eye2.Switch					= false	
		TurnOffAllLights()
		
		--turning on back buttons
		
		
		-- turning off menu buttons
		startRender.enabled 		= false
		howtoplayRender.enabled 	= false
		creditsRender.enabled 		= false
		quitRender.enabled 			= false
		
		startFont.Switch			= false
		howtoplayFont.Switch 		= false
		creditsFont.Switch			= false
		quitFont.Switch				= false
		
		startTrigger.isActive 		= false
		howtoplayTrigger.isActive 	= false
		creditsTrigger.isActive 	= false
		quitTrigger.isActive 		= false
		
		if(entity:name() == "Credits") then
			
			--_G["g_enableCredits"] = true
				
			nextRender.enabled			= true
			nextFont.Switch				= true
			nextTrigger.isActive 		= true	
			
		else
		
		backRender.enabled			= true
		backFont.Switch				= true
		backTrigger.isActive 		= true	
		end
		

		
		
  
end

function CollisionCheck(mousePos)
	
	if(trigger.isActive == true) then
		if(MousePositionInAABB(trigger.aabb) == true) then
			Interaction()
		end
	end

end

function Update()
end

function End()
GetLuaEventSystem():RemoveListener("EVENT_MOUSECLICK", "CollisionCheck")
end