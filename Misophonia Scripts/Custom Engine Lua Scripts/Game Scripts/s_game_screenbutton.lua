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

-- audio info
clickAudio 			= GetAssetHandle("AudioAsset")


--other buttons

resumeRenderID 		= GetComponentHandle("RenderComponent")
resumeFontID 		= GetComponentHandle("FontComponent")
resumeTriggerID 		= GetComponentHandle("CollisionComponent")

howtoplayRenderID 	= GetComponentHandle("RenderComponent")
howtoplayFontID 	= GetComponentHandle("FontComponent")
howtoplayTriggerID 	= GetComponentHandle("CollisionComponent")

mainmenuRenderID 	= GetComponentHandle("RenderComponent")
mainmenuFontID 		= GetComponentHandle("FontComponent")
mainmenuTriggerID 	= GetComponentHandle("CollisionComponent")

quitRenderID 		= GetComponentHandle("RenderComponent")
quitFontID 			= GetComponentHandle("FontComponent")
quitTriggerID 		= GetComponentHandle("CollisionComponent")

pausedFontID 		= GetComponentHandle("FontComponent")


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
	
	
	--back buttons
	backRender 			= renderManager.GetComponent(backRenderID)
	backFont 			= fontManager.GetComponent(backFontID)
	backTrigger 		= collisionManager.GetComponent(backTriggerID)
	
	
	--other menu buttons
	resumeRender 		= renderManager.GetComponent(resumeRenderID)
	resumeFont 			= fontManager.GetComponent(resumeFontID)
	resumeTrigger		= collisionManager.GetComponent(resumeTriggerID)

	howtoplayRender		= renderManager.GetComponent(howtoplayRenderID)
	howtoplayFont 		= fontManager.GetComponent(howtoplayFontID)
	howtoplayTrigger 	= collisionManager.GetComponent(howtoplayTriggerID)

	mainmenuRender 		= renderManager.GetComponent(mainmenuRenderID)
	mainmenuFont 		= fontManager.GetComponent(mainmenuFontID)
	mainmenuTrigger 	= collisionManager.GetComponent(mainmenuTriggerID)

	quitRender 			= renderManager.GetComponent(quitRenderID)
	quitFont			= fontManager.GetComponent(quitFontID)
	quitTrigger 		= collisionManager.GetComponent(quitTriggerID)
	
	pausedFont 			= fontManager.GetComponent(pausedFontID)
	
	

	
	
end

function Interaction()
	
		audio.AudioSound 			= clickAudio
		audio.Playing 				= true
		
		--turning on screen render/turning off lights/eye
		screenRender.enabled 		= true
		
		--turning on back buttons
		backRender.enabled			= true
		backFont.Switch				= true
		backTrigger.isActive 		= true	
		
		-- turning off menu buttons
		resumeRender.enabled 		= false
		howtoplayRender.enabled 	= false
		mainmenuRender.enabled 		= false
		quitRender.enabled 			= false
		
		resumeFont.Switch			= false
		howtoplayFont.Switch 		= false
		mainmenuFont.Switch			= false
		quitFont.Switch				= false
		pausedFont.Switch			= false
		
		resumeTrigger.isActive 		= false
		howtoplayTrigger.isActive 	= false
		mainmenuTrigger.isActive 	= false
		quitTrigger.isActive 		= false
  
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

function Free()
end