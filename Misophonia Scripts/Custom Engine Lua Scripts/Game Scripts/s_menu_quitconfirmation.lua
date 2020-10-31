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
	
	-- Start disabled
	DisableConfirmationPage()
	
end

function EnableMainMenu()

	startButton.isActive = true
	howToPlayButton.isActive = true
	creditsButton.isActive = true
	quitGameButton.isActive = true
	
end

function DisableConfirmationPage()

	titleText.Switch = false
	confirmText.Switch = false
	cancelText.Switch = false
	
	quitPageRender.enabled = false
	confirmRender.enabled = false
	cancelRender.enabled = false
	
	confirmButton.isActive = false
	cancelButton.isActive = false

end

function CollisionCheck(mousePos)
	
	if (confirmButton.isActive == true) then
	
		if(MousePositionInAABB(confirmButton.aabb) == true) then
			GetEngine():Terminate()
		end
		
	end
	
	if (cancelButton.isActive == true) then
	
		if(MousePositionInAABB(cancelButton.aabb) == true) then
			DisableConfirmationPage()
			EnableMainMenu()
		end
		
	end

end

function Update()
end

function Free()
end