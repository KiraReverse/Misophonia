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
--reference to gamestate.lua
local scriptManager = GetScriptedComponentManager()
gameStateID			= GetComponentHandle("s_gamestate")


audioID 			= GetComponentHandle("AudioPlayerComponent")
clickAudio 			= GetAssetHandle("AudioAsset")
cursor = GetComponentHandle("s_cursor")

function Init()

end

function Start()

GetLuaEventSystem():AddListener("EVENT_MOUSECLICK", "EventCheck")
gameState 			= scriptManager.GetLuaScript(gameStateID)

entityID 			= GetEntity()
entityManager 		= GetManagers():GetEntityManager()
entity 				= entityManager:Get(entityID)

collisionManager 	= GetManagers():GetCollisionManager()
triggerID 			= entity:GetComponent(collisionManager:GetComponentID())
trigger				= collisionManager.GetComponent(triggerID)

end

function Interaction()

	if(gameState.isPaused == true) then
		audio = GetComponent(audioID)
		audio.AudioSound 			= clickAudio
		audio.Playing 				= true
		GetScriptedComponentManager().GetLuaScript(cursor).show_cursor = false
		gameState.Unpause()
		
		_G["enableInventory"] = true
	end
end

function EventCheck()

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