--/******************************************************************************/
--/*!
--\project	Misophonia
--\author		Clarence Phun Kok Hoe(100%)
--
--All content (C) 2018 DigiPen (SINGAPORE) Corporation, all rights reserved.
--Reproduction or disclosure of this file or its contents without the prior
--written consent of DigiPen Institute of Technology is prohibited.
--*/
--/******************************************************************************/
local isDone = false
local scriptManager = GetScriptedComponentManager()
local startWait 	= false

playerTransformID 	= GetComponentHandle("Transform")
aiTransformID		= GetComponentHandle("Transform")
endFlashID 			= GetComponentHandle("s_blackout")
endgameID 			= GetComponentHandle("s_enableEndGame")

aiTriggerID 		= GetComponentHandle("CollisionComponent")

audioPlayerID		= GetComponentHandle("AudioPlayerComponent")

swing				= GetAssetHandle ("AudioAsset")
hit					= GetAssetHandle ("AudioAsset")



local swingOnce = false
local hitOnce = false
local escapeStart = false
local ended = false
local escapeTimer = 0 
escapeDelay = 4
timeWaited = 0
hitTimer = 0

function Init()



end
	
function Start()
	audioPlayer 	= GetComponent(audioPlayerID)
	playerTransform = GetComponent(playerTransformID)
	aiTransform		= GetComponent(aiTransformID)
	endFlash		= scriptManager.GetLuaScript(endFlashID)
	endgame		    = scriptManager.GetLuaScript(endgameID)
	aiTrigger 		= GetComponent(aiTriggerID)

end

function EndGame()
	
	startWait = true
end

function Escape()
	escapeStart = true
end



function Update()

local aiVec = aiTransform.position
local playerVec = playerTransform.position





	if(startWait == true or ended == true) then
		timeWaited = timeWaited + GetEngine():getDeltaTime()
		
		if(swingOnce == false) then
			audioPlayer.AudioSound = swing
			audioPlayer.Playing = true
			swingOnce = true
		end

		if(timeWaited >= 2.2) then
			
			if(ended == false) then
				endFlash.Flash()
				escapeStart = false
				ended = true
			end
		end

		if(timeWaited >= 2.8) then
			endgame.turnOn = true
			--GetEngine():LoadLevel("levelfiles/endgame")
		end
	end
	
	if((startWait == true or escapeStart == true) and hitOnce == false) then
		hitTimer = hitTimer + GetEngine():getDeltaTime()
	
		if(hitTimer >= 1.8) then
			audioPlayer.AudioSound = hit
			audioPlayer.Playing = true
			hitOnce = true
			hitTimer = 0
		end
	end

	if(escapeStart == true and ended == false) then
		
		startWait = false
		timeWaited = 0
		escapeTimer = escapeTimer + GetEngine():getDeltaTime()
		
		if(escapeTimer >= escapeDelay) then
			escape = false
			escapeStart = false
			escapeTimer = 0
			isDone = true
			aiTrigger.isActive = true
		end
	end

end

function End()


end



function Free()



end

function Evaluate()


end

function StartAttack()
isDone 		= false
startWait 	= true
hitOnce = false
swingOnce = false
aiTrigger.isActive = false
hitTimer = 0
end

function CompleteAttack()
return isDone;
end