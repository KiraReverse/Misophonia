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
aiLogicID     = GetComponentHandle("AILogicComponent")
aiTransformID = GetComponentHandle("Transform")

function Init()

end
  
function Start()
  aiSystem  = GetAILogicSystem()
  aiManager = GetAILogicManager()
  aiLogic   = aiManager.GetComponent(aiLogicID)
  
  transformManager = GetTransformManager()
  aiTransform      = transformManager.GetComponent(aiTransformID)
  
  error_catch = 3
end

function Update()
  
end

function End()
  
end

function Free()
  
end

function StartTask()
  vec = aiTransform.position
  error_catch = aiLogic:AISetSearch(vec, true)
end

function Evaluate()
  if (error_catch == 3) then
    StartTask() 
  else
    return aiLogic:AICompleteTask()
  end
end