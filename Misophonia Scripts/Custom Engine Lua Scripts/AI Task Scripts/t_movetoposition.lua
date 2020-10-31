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

playerTransformID = GetComponentHandle("Transform")
playerPhysicsID   = GetComponentHandle("PhysicsComponent")

error_catch = 3

function Init()

end
  
function Start()
  aiSystem  = GetAILogicSystem()
  aiManager = GetAILogicManager()
  aiLogic   = aiManager.GetComponent(aiLogicID)
  
  transformManager = GetTransformManager()
  aiTransform      = transformManager.GetComponent(aiTransformID)
  playerTransform  = transformManager.GetComponent(playerTransformID)
  
  physicsManager = GetPhysicsManager()
  playerPhysics  = physicsManager.GetComponent(playerPhysicsID)
  
  engine = GetEngine()
  
  error_catch = 3
end

function GetPredictedPosition()
  return playerTransform.position + playerPhysics.vel
end

function Distance(vec1, vec2)
  result = math.sqrt(((vec2.x - vec1.x)^2) + ((vec2.y - vec1.y)^2))
  return result
end

function Update()
  
end

function End()
  
end

function Free()
  
end

function StartTask()
  position = GetPredictedPosition()
  check    = aiSystem:CheckValidDestination(position)
  
  if (check ~= true) then
    position = aiSystem:GetRandomPointInMap()
  end
  
  error_catch = aiLogic:AIMoveTo(position)
end

function Evaluate()
  if (error_catch == 3) then
    StartTask()
  else
    return aiLogic:AICompleteTask()
  end
end