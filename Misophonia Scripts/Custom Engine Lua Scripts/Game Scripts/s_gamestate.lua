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
----asset references
--bg
bgRenderID 			= GetComponentHandle("RenderComponent")
pauseFontID 		= GetComponentHandle("FontComponent")

--resume
resumeRenderID 		= GetComponentHandle("RenderComponent")
resumeTriggerID 	= GetComponentHandle("CollisionComponent")
resumeFontID		= GetComponentHandle("FontComponent")

--howtoplay
howtoplayRenderID 	= GetComponentHandle("RenderComponent")
howtoplayTriggerID 	= GetComponentHandle("CollisionComponent")
howtoplayFontID		= GetComponentHandle("FontComponent")

--mainmenu
mainmenuRenderID 	= GetComponentHandle("RenderComponent")
mainmenuTriggerID 	= GetComponentHandle("CollisionComponent")
mainmenuFontID		= GetComponentHandle("FontComponent")

--quit
quitRenderID 		= GetComponentHandle("RenderComponent")
quitTriggerID 		= GetComponentHandle("CollisionComponent")
quitFontID			= GetComponentHandle("FontComponent")

-- quitConfirmation
titleTextID 			= GetComponentHandle("FontComponent")
confirmTextID 			= GetComponentHandle("FontComponent")
cancelTextID			= GetComponentHandle("FontComponent")

quitPageRenderID 		= GetComponentHandle("RenderComponent")
confirmButtonRenderID 	= GetComponentHandle("RenderComponent")
cancelButtonRenderID 	= GetComponentHandle("RenderComponent")

confirmButtonID 		= GetComponentHandle("CollisionComponent")
cancelButtonID 			= GetComponentHandle("CollisionComponent")

--howtoplayscreen
howtoplayScreenRenderID = GetComponentHandle("RenderComponent")


--script variables
isPaused = false

cursor = GetComponentHandle("s_cursor")

audioID 			= GetComponentHandle("AudioPlayerComponent")
clickAudio 			= GetAssetHandle("AudioAsset")

local pauseFont = 0

function Init()

end

function Start()

GetLuaEventSystem():AddListener("EVENT_KEY_PRESSED", "EventCheck")

engine = GetEngine()
engine:setTimeScale(1)
renderManager 		= GetRenderComponentManager()

bgRender 			= renderManager.GetComponent(bgRenderID)
resumeRender 		= renderManager.GetComponent(resumeRenderID)
howtoplayRender 	= renderManager.GetComponent(howtoplayRenderID)
mainmenuRender 		= renderManager.GetComponent(mainmenuRenderID)
quitRender 			= renderManager.GetComponent(quitRenderID)

collisionManager 	= GetCollisionManager()

resumeTrigger 		= collisionManager.GetComponent(resumeTriggerID)
howtoplayTrigger 	= collisionManager.GetComponent(howtoplayTriggerID)
mainmenuTrigger		= collisionManager.GetComponent(mainmenuTriggerID)
quitTrigger 		= collisionManager.GetComponent(quitTriggerID)

fontManager 		= GetFontComponentManager()

pauseFont 			= fontManager.GetComponent(pauseFontID)
resumeFont			= fontManager.GetComponent(resumeFontID)
howtoplayFont		= fontManager.GetComponent(howtoplayFontID)
mainmenuFont		= fontManager.GetComponent(mainmenuFontID)
quitFont			= fontManager.GetComponent(quitFontID)

howtoplayScreenRender = GetComponent(howtoplayScreenRenderID)

-- Confirmation Page
titleText = GetComponent(titleTextID)
confirmText = GetComponent(confirmTextID)
cancelText = GetComponent(cancelTextID)

quitPageRender = GetComponent(quitPageRenderID)
confirmRender = GetComponent(confirmButtonRenderID)
cancelRender = GetComponent(cancelButtonRenderID)

confirmButton = GetComponent(confirmButtonID)
cancelButton = GetComponent(cancelButtonID)

entityID      	= GetEntity()
entityManager 	= GetManagers():GetEntityManager()
entity        	= entityManager:Get(entityID)

tManager      	= GetTransformManager()
tID           	= entity:GetComponent(tManager:GetComponentID())
trans         	= tManager.GetComponent(tID)

end

function Pause()

	--pause reference bool set to true, timescale to 0
	isPaused 					= true
	engine:setTimeScale(0)
	trans.dirty 			= true
	--turn on pause menu visuals as well as their triggers
	bgRender.enabled 			= true
	resumeRender.enabled 		= true
	howtoplayRender.enabled 	= true
	mainmenuRender.enabled 		= true
	quitRender.enabled 			= true
	
	resumeTrigger.isActive 		= true
	howtoplayTrigger.isActive 	= true
	mainmenuTrigger.isActive 	= true
	quitTrigger.isActive 		= true
	
	print(GetEntity())
	
	pauseFont.Switch			= true
	resumeFont.Switch			= true
	howtoplayFont.Switch		= true
	mainmenuFont.Switch			= true
	quitFont.Switch				= true
end

function Unpause()

	isPaused 					= false
	engine:setTimeScale(1)
	
	bgRender.enabled 			= false
	resumeRender.enabled 		= false
	howtoplayRender.enabled 	= false
	mainmenuRender.enabled 		= false
	quitRender.enabled 			= false
	
	resumeTrigger.isActive 		= false
	howtoplayTrigger.isActive 	= false
	mainmenuTrigger.isActive 	= false
	quitTrigger.isActive 		= false
	
	
	pauseFont.Switch			= false
	resumeFont.Switch			= false
	howtoplayFont.Switch		= false
	mainmenuFont.Switch			= false
	quitFont.Switch				= false
end

function DisableConfirmationPage()
	
	resumeTrigger.isActive 		= true
	howtoplayTrigger.isActive 	= true
	mainmenuTrigger.isActive 	= true
	quitTrigger.isActive 		= true
	
	titleText.Switch 		= false
	confirmText.Switch 		= false
	cancelText.Switch 		= false
	
	quitPageRender.enabled 	= false
	confirmRender.enabled 	= false
	cancelRender.enabled 	= false
	
	confirmButton.isActive 	= false
	cancelButton.isActive 	= false
	
end

function EventCheck(key)

	if(key == Virtual_Keys.AEVK_ESCAPE) then
		
			audio = GetComponent(audioID)
		audio.AudioSound 			= clickAudio
		audio.Playing 				= true
		
		if(isPaused == false) then
			Pause()
			GetScriptedComponentManager().GetLuaScript(cursor).show_cursor = true
      _G["enableInventory"] = false
		elseif (isPaused == true) then
			if(quitPageRender.enabled == true) then
				DisableConfirmationPage()
			elseif(howtoplayScreenRender.enabled == false) then
				Unpause()
				GetScriptedComponentManager().GetLuaScript(cursor).show_cursor = false
		  _G["enableInventory"] = true
			end
		end
	
	end
end



function Update()

end

function Free()
end