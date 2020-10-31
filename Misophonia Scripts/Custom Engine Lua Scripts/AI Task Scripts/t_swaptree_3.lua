--/******************************************************************************/
--/*!
--\project	Misophonia
--\author		Hum Kai Ting(100%)
--
--All content (C) 2018 DigiPen (SINGAPORE) Corporation, all rights reserved.
--Reproduction or disclosure of this file or its contents without the prior
--written consent of DigiPen Institute of Technology is prohibited.
--*/
--/******************************************************************************/
aiLogicID = GetComponentHandle("AILogicComponent")

lightScript1ID = GetComponentHandle("s_lightswitch")
lightScript2ID = GetComponentHandle("s_lightswitch")
lightScript3ID = GetComponentHandle("s_lightswitch")
lightScript4ID = GetComponentHandle("s_lightswitch")

treeEntID1 = 0
treeEntID2 = 0

cond1 = false

function Init()

end
  
function Start()
  aiSystem  = GetAILogicSystem()
  aiManager = GetAILogicManager()
  aiLogic   = aiManager.GetComponent(aiLogicID)
  
  scriptManager = GetScriptedComponentManager()
  
  lightScript1 = scriptManager.GetLuaScript(lightScript1ID)
  lightScript2 = scriptManager.GetLuaScript(lightScript2ID)
  lightScript3 = scriptManager.GetLuaScript(lightScript3ID)
  lightScript4 = scriptManager.GetLuaScript(lightScript4ID)
  
  lightScriptList = { lightScript1, 
                      lightScript2, 
                      lightScript3, 
                      lightScript4  }
end

function Update()
  
end

function End()
  
end

function Free()
  
end

function GetNumberOfOnnedLightSwitches()
  counter = 0
  
  for i, v in pairs(lightScriptList) do
    if (v.isOn == true) then
      counter = counter + 1
    end
  end
  
  return counter
end

-- if too many light switches are on, go tree 1
function TestSwitchCondition()
  counter = GetNumberOfOnnedLightSwitches()
  
  if (counter > 2) then
    cond1 = true
  else
    cond1 = false
  end
end

function StartTask()
  -- test conditions here
  TestSwitchCondition()
end

function Evaluate()
  -- switch to tree 1, chase_counter + 1
  if (cond1 == true) then
    print("Tree 3 | moving to Tree 1")
    aiSystem:LoadNewBehaviorTree(treeEntID1, aiLogicID)
    aiLogic.chase_counter = aiLogic.chase_counter + 1
    return 1
  
  -- switch to tree 2, chase_counter + 2
  else
    print("Tree 3 | moving to Tree 2")
    aiSystem:LoadNewBehaviorTree(treeEntID2, aiLogicID)
    aiLogic.chase_counter = aiLogic.chase_counter + 2
    return 1
  end
  
  -- all conditions fail, return task failure
  -- staying in this tree
  return 0
end