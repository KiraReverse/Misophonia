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
aiLogicID 						= GetComponentHandle("AILogicComponent")

audioPlayerID					= GetComponentHandle("AudioPlayerComponent")

enemyShadowID					= GetComponentHandle("Transform")
enemyStateID					= GetComponentHandle("PlayerState")

chase1							= GetAssetHandle ("AudioAsset")
chase2							= GetAssetHandle ("AudioAsset")
chase3							= GetAssetHandle ("AudioAsset")
	
doOnce = false

function Init()

end
	
function Start()

	aiSystem 					= GetAILogicSystem()
	aiManager 					= GetAILogicManager()

	aiLogic 					= aiManager.GetComponent(aiLogicID)
	
	enemyState 					= GetComponent(enemyStateID)

	
	audioPlayer 				= GetComponent(audioPlayerID)

	enemyShadow					= GetComponent(enemyShadowID)
	
	shadowPos					= enemyShadow.position
	
end


function ChaseRoll()

	roll = math.random(1, 3)

	if(roll == 1) then
		audioPlayer.AudioSound = chase1
	elseif(roll == 2) then
		audioPlayer.AudioSound = chase2
	elseif(roll == 3) then
		audioPlayer.AudioSound = chase3
	end
	
	audioPlayer.Playing = true

end
 

function Update()

	if(aiSystem:GetAIState(aiLogicID) == 3 and doOnce == false) then
		ChaseRoll()
		doOnce = true
	elseif (aiSystem:GetAIState(aiLogicID) ~= 3 and doOnce == true) then
		doOnce = false
	end
	
	if(enemyState.currState == CharacterState.CharacterState_Hijack
      or  enemyState.currState == CharacterState.CharacterState_Attack
      or  enemyState.currState == CharacterState.CharacterState_Stun) then
	  
		if(enemyState.currDir == Directions.Dir_Left) then
			shadowPos = enemyShadow.position
			shadowPos.x = 0.2
			enemyShadow.position = shadowPos
			enemyShadow.dirty = true
		elseif(enemyState.currDir == Directions.Dir_Right) then
			shadowPos = enemyShadow.position
			shadowPos.x = -0.2
			enemyShadow.position = shadowPos
			enemyShadow.dirty = true
		end
	else
		shadowPos.x = 0
		enemyShadow.position = shadowPos
		enemyShadow.dirty = true
		
	end

end

function End()

end

function Free()
end
