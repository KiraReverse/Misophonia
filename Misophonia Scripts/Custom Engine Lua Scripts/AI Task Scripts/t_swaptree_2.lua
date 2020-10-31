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
cond2 = false

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

-- chasing is more important
function TestChaseCondition()
  counter = aiLogic.chase_counter
  
  if (counter > 0) then
    cond1 = true
  else
    cond1 = false
  end
end

-- if too many light switches are on, go tree 1
function TestSwitchCondition()
  counter = GetNumberOfOnnedLightSwitches()
  
  if (counter > 2) then
    cond2 = true
  else
    cond2 = false
  end
end

function StartTask()
  -- test conditions here
  TestChaseCondition()
  TestSwitchCondition()
end

function Evaluate()
  -- cond 1 is true, cond 1 has higher priority than 2
  -- switch to tree 3, reset chase_counter
  if (cond1 == true) then
    print("Tree 2 | moving to Tree 3")
    aiSystem:LoadNewBehaviorTree(treeEntID1, aiLogicID)
    aiLogic.chase_counter = 0
    return 1
  end
  
  -- cond 2 is true, cond 2 has lower priority than 1
  -- switch to tree 1, chase_counter + 1
  if (cond2 == true) then
    print("Tree 2 | moving to Tree 1")
    aiSystem:LoadNewBehaviorTree(treeEntID2, aiLogicID)
    aiLogic.chase_counter = aiLogic.chase_counter + 1
    return 1
  end
  
  -- all conditions fail, return task failure
  -- staying in this tree
  return 0
end