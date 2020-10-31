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

--local entityID = 0 -- GetEntity()
--local entityManager = 0 -- GetManagers():GetEntityManager()
--local entity = 0 -- entityManager:Get(entityID)
                 
--local transformManager = 0 -- GetManagers():GetTransformManager()
--local transformID = 0 -- entity:GetComponent(tManager:GetComponentID())
--local transform = 0 -- tManager:GetComponent(tID)
                 
--local spriteManager = 0 -- GetManagers():GetSpriteManager()
--local spriteID = 0 -- entity:GetComponent(spriteManager:GetComponentID())
--local sprite = 0 -- spriteManager.GetComponent(spriteID)

--local collisionManager = 0 -- GetManagers():GetCollisionManager()

--local input = 0

-- Main Menu
startButtonID = GetComponentHandle("CollisionComponent")
howToPlayButtonID = GetComponentHandle("CollisionComponent")
creditsButtonID = GetComponentHandle("CollisionComponent")
quitGameButtonID = GetComponentHandle("CollisionComponent")

-- Confirmation Page
titleTextID = GetComponentHandle("FontComponent")
confirmTextID = GetComponentHandle("FontComponent")
cancelTextID = GetComponentHandle("FontComponent")

quitPageRenderID = GetComponentHandle("RenderComponent")
confirmButtonRenderID = GetComponentHandle("RenderComponent")
cancelButtonRenderID = GetComponentHandle("RenderComponent")

confirmButtonID = GetComponentHandle("CollisionComponent")
cancelButtonID = GetComponentHandle("CollisionComponent")

function Init()

end

function Start()

	GetLuaEventSystem():AddListener("EVENT_MOUSECLICK", "CollisionCheck")
	
	--entityID 			= GetEntity()
	--entityManager 		= GetManagers():GetEntityManager()
	--entity 				= entityManager:Get(entityID)

	--input 				= GetInputInterface()
	
	--transformManager 	= GetManagers():GetTransformManager()
	--transformID 		= entity:GetComponent(transformManager:GetComponentID())
	--transform 			= transformManager.GetComponent(transformID)
					
	--spriteManager 		= GetManagers():GetSpriteManager()
	--spriteID 			= entity:GetComponent(spriteManager:GetComponentID())
	--sprite 				= spriteManager.GetComponent(spriteID)

	--collisionManager 	= GetManagers():GetCollisionManager()
	--triggerID 			= entity:GetComponent(collisionManager:GetComponentID())
	--trigger				= collisionManager.GetComponent(triggerID)
	
	-- Main Menu
	startButton = GetComponent(startButtonID)
	howToPlayButton = GetComponent(howToPlayButtonID)
	creditsButton = GetComponent(creditsButtonID)
	quitGameButton = GetComponent(quitGameButtonID)
	
	-- Confirmation Page
	titleText = GetComponent(titleTextID)
	confirmText = GetComponent(confirmTextID)
	cancelText = GetComponent(cancelTextID)
	
	quitPageRender = GetComponent(quitPageRenderID)
	confirmRender = GetComponent(confirmButtonRenderID)
	cancelRender = GetComponent(cancelButtonRenderID)
	
	confirmButton = GetComponent(confirmButtonID)
	cancelButton = GetComponent(cancelButtonID)
	
end

--function Interaction()
--	
--	GetEngine():Terminate()
--  
--end

function DisableMainMenu()
	
	startButton.isActive = false
	howToPlayButton.isActive = false
	creditsButton.isActive = false
	quitGameButton.isActive = false
	
end

function EnableQuitConfirmation()
	
	titleText.Switch = true
	confirmText.Switch = true
	cancelText.Switch = true
	
	quitPageRender.enabled = true
	confirmRender.enabled = true
	cancelRender.enabled = true
	
	confirmButton.isActive = true
	cancelButton.isActive = true
	
end

function CollisionCheck(mousePos)
	
	if(quitGameButton.isActive == true) then
		if(MousePositionInAABB(quitGameButton.aabb) == true) then
			DisableMainMenu()
			EnableQuitConfirmation()
		end
	end

end

function Update()
end

function Free()
end