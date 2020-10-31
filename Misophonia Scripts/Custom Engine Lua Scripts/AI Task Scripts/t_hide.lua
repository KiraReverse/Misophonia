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
aiLogicID 						= GetComponentHandle("AILogicComponent")

playerTransformID 				= GetComponentHandle("Transform")

error_catch = 3

function Init()

end
	
function Start()

	aiSystem 					= GetAILogicSystem()
	aiManager 					= GetAILogicManager()

	aiLogic 					= aiManager.GetComponent(aiLogicID)

	transformManager 			= GetTransformManager()


	hideSpot 					= Vec2.new(47, -20)
  
  error_catch = 3
end


function Update()

end

function End()

end

function Free()

end

function StartTask()
	error_catch = aiLogic:AITeleportTo(hideSpot)
end

function Evaluate()
  if (error_catch == 3) then
    StartTask()
  else
    return aiLogic:AICompleteTask()
  end
end