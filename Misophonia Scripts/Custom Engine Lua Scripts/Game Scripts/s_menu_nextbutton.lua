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

creditScreen1ID		= GetComponentHandle("RenderComponent")
creditScreen2ID 	= GetComponentHandle("RenderComponent")

audioID 			= GetComponentHandle("AudioPlayerComponent")


backRenderID 		= GetComponentHandle("RenderComponent") 
backFontID 			= GetComponentHandle("FontComponent")
backTriggerID 		= GetComponentHandle("CollisionComponent")

nextRenderID 		= GetComponentHandle("RenderComponent") 
nextFontID 			= GetComponentHandle("FontComponent")
nextTriggerID 		= GetComponentHandle("CollisionComponent")

-- audio info
clickAudio 			= GetAssetHandle("AudioAsset")




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
					


	collisionManager 	= GetManagers():GetCollisionManager()
	triggerID 			= entity:GetComponent(collisionManager:GetComponentID())
	trigger				= collisionManager.GetComponent(triggerID)
	
	audioManager 		= GetAudioPlayerComponentManager()
	audio 				= audioManager.GetComponent(audioID)
	

	
	creditScreen1		= GetComponent(creditScreen1ID)
	creditScreen2		= GetComponent(creditScreen2ID)
	

	
	
	--back buttons
	backRender 			= GetComponent(backRenderID)
	backFont 			= GetComponent(backFontID)
	backTrigger 		= GetComponent(backTriggerID)

	nextRender 			= GetComponent(nextRenderID)
	nextFont 			= GetComponent(nextFontID)
	

	
	
end

function Interaction()


	creditScreen1.enabled 		= false
	creditScreen2.enabled 		= true

	audio.AudioSound 			= clickAudio
	audio.Playing 				= true
	
	--turning off back buttons
	backRender.enabled			= true
	backFont.Switch				= true
	backTrigger.isActive 		= true

	nextRender.enabled			= false
	nextFont.Switch				= false
	trigger.isActive 		= false	
	
	
end

function CollisionCheck(mousePos)

	if(trigger.isActive == true) then
		if(MousePositionInAABB(trigger.aabb) == true) then

			Interaction()
		end
	end

end

function Update()
	print(trigger)
end

function Free()
end