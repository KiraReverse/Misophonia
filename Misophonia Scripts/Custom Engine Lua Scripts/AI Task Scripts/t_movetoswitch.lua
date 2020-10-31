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

lightSwitchTransformID1 = GetComponentHandle("Transform")
lightSwitchTransformID2 = GetComponentHandle("Transform")
lightSwitchTransformID3 = GetComponentHandle("Transform")
lightSwitchTransformID4 = GetComponentHandle("Transform")

lightScript1ID = GetComponentHandle("s_lightswitch")
lightScript2ID = GetComponentHandle("s_lightswitch")
lightScript3ID = GetComponentHandle("s_lightswitch")
lightScript4ID = GetComponentHandle("s_lightswitch")

error_catch = 3

function Init()
end
  
function Start()
  aiSystem  = GetAILogicSystem()
  aiManager = GetAILogicManager()
  aiLogic = aiManager.GetComponent(aiLogicID)
  
  transformManager = GetTransformManager()
  aiTransform      = transformManager.GetComponent(aiTransformID)
  playerTransform  = GetComponent(playerTransformID)
  
  lightSwitchTransform1 = transformManager.GetComponent(lightSwitchTransformID1)
  lightSwitchTransform2 = transformManager.GetComponent(lightSwitchTransformID2) 
  lightSwitchTransform3 = transformManager.GetComponent(lightSwitchTransformID3)
  lightSwitchTransform4 = transformManager.GetComponent(lightSwitchTransformID4) 
  
  switchOffset = Vec2.new(0, -2)
  
  scriptManager = GetScriptedComponentManager()
  
  lightScript1 = scriptManager.GetLuaScript(lightScript1ID)
  lightScript2 = scriptManager.GetLuaScript(lightScript2ID)
  lightScript3 = scriptManager.GetLuaScript(lightScript3ID)
  lightScript4 = scriptManager.GetLuaScript(lightScript4ID)
  
  lightScriptList = { lightScript1, 
                      lightScript2, 
                      lightScript3, 
                      lightScript4  }
  
  lightSwitchPos1 = lightSwitchTransform1:GlobalPosition() + switchOffset
  lightSwitchPos2 = lightSwitchTransform2:GlobalPosition() + switchOffset
  lightSwitchPos3 = lightSwitchTransform3:GlobalPosition() + switchOffset
  lightSwitchPos4 = lightSwitchTransform4:GlobalPosition() + switchOffset
   
  switchList = { [lightSwitchPos1] = lightScript1,
                 [lightSwitchPos2] = lightScript2,
                 [lightSwitchPos3] = lightScript3,
                 [lightSwitchPos4] = lightScript4  }

  error_catch = 3
end

function Distance(vec1, vec2)
  
  result = math.sqrt(((vec2.x - vec1.x)^2) + ((vec2.y - vec1.y)^2))
  return result
end

function GetNearestSwitchToPlayer()

  switchMin = nil
  minDist = math.huge
  
  playerPos = playerTransform.position
  
  for i, v in pairs(switchList) do
    
    -- skip switches that are off
    if (v.isOn == true) then
    
      dist = Distance(playerPos, i)
      
      if(dist < minDist) then
      
        switchMin = i 
        minDist = dist
      end
    end
  end
  
  return switchMin
end


function Update()

end

function End()

end

function Free()

end

function StartTask()
  targetSwitch = GetNearestSwitchToPlayer()
  error_catch = aiLogic:AIMoveTo(targetSwitch)
end

function Evaluate()
  if (error_catch == 3) then
    StartTask()
  else
    return aiLogic:AICompleteTask()
  end
end