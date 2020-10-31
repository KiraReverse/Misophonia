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
aiLogicID 		= GetComponentHandle("AILogicComponent")
playerState		= GetComponentHandle("PlayerState")
bgmPlayerID  	= GetComponentHandle("AudioPlayerComponent")
effectPlayerID	= GetComponentHandle("AudioPlayerComponent")



--audio assets for states
defaultBGM 		= GetAssetHandle("AudioAsset")
chaseBGM 		= GetAssetHandle("AudioAsset")
--struggleBGM		= GetAssetHandle("AudioAsset")

chaseEffect 	= GetAssetHandle("AudioAsset")
struggleEffect	= GetAssetHandle("AudioAsset")



--bgmswitch checks
local chaseOn = false

function Lerp(from, to, dt)

	from = from + (dt*GetEngine():getDeltaTime())
	if(dt > 0) then
		if ( from > to) then
			from = to
		end
	elseif(dt < 0) then
		if ( from < to) then
			from = to
		end
	elseif(dt == 0) then
		return 0
	end
	
	return from
end

function Init()

end

function Start()


audioManager 	= GetAudioPlayerComponentManager()
effectPlayer	= audioManager.GetComponent(effectPlayerID)
bgmPlayer		= audioManager.GetComponent(bgmPlayerID)

aiSystem 		= GetAILogicSystem()
aiManager 		= GetAILogicManager()

aiLogic 		= aiManager.GetComponent(aiLogicID)







end
-----------------
---- AI ENUMS----
-----------------
-- 1	-	IDLE
-- 2	-	WALK
-- 3	-	CHASE
-- 5	-	STUN/ATTACK


function Update()
	if(aiSystem:GetAIState(aiLogicID) == 1 or aiSystem:GetAIState(aiLogicID) == 2) then
		if(chaseOn == true) then
			bgmPlayer.Volume = Lerp(bgmPlayer.Volume, 0, -100)
			effectPlayer.Volume = Lerp(effectPlayer.Volume, 0, -100)
			
			if(bgmPlayer.Volume <=1 and effectPlayer.Volume <= 1) then
				chaseOn = false
				effectPlayer.AudioSound.instance_id = 0
				effectPlayer.Playing = false
			end
		else
			if(bgmPlayer.Volume < 30) then
			
				if(bgmPlayer.AudioSound ~= defaultBGM) then
					bgmPlayer.AudioSound = defaultBGM
				end
				
				bgmPlayer.Volume = Lerp(bgmPlayer.Volume, 30, 30)
			end
		
		end
	end

	-- chase audio modifications
	if(aiSystem:GetAIState(aiLogicID) == 3 or aiSystem:GetAIState(aiLogicID) == 5) then
		
		if(chaseOn == false) then
			bgmPlayer.Volume = GlobalLerp(bgmPlayer.Volume, 0, 100)
			if(bgmPlayer.Volume <= 1) then		
				chaseOn = true
			end
		else
			if(bgmPlayer.AudioSound ~= chaseBGM) then
				bgmPlayer.AudioSound = chaseBGM
				bgmPlayer.Playing = false
				bgmPlayer.Playing = true
			end
		
			bgmPlayer.Volume = GlobalLerp(bgmPlayer.Volume, 50, 30)
			if(effectPlayer.AudioSound ~= chaseEffect) then
				effectPlayer.AudioSound = chaseEffect
				effectPlayer.Playing = true
			end
			
			effectPlayer.Volume = GlobalLerp(effectPlayer.Volume, 50, 30)
			effectPlayer.Volume = 30
		end
	end


end

function Free()
end