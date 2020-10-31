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
playerTransformID = GetComponentHandle("Transform")
aiScriptID = GetComponentHandle("t_delay")

aiThresholdX = 0

doOnce = false

function Init()

end

function Start()

playerTransform = GetComponent(playerTransformID)

scriptManager = GetScriptedComponentManager()

aiScript = scriptManager.GetLuaScript(aiScriptID)

playerPos = playerTransform.position

end

function Function()
end

function Update()

if(playerPos.x > aiThresholdX and doOnce == false) then

aiScript.StartAI()
doOnce = true
print("activate ai")
end

end

function Free()
end