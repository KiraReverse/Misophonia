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
stunDuration					= 0

error_catch 					= 3
isActive						= false

function Init()
end
	
function Start()

	aiSystem 					= GetAILogicSystem()
	aiManager 					= GetAILogicManager()

	aiLogic 					= aiManager.GetComponent(aiLogicID)
	
	error_catch = 3

end

function StartAI()
isActive						= true
end

function Update()

if(isActive == true) then
  aiSystem:StartTree()
  isActive = false
end

end

function End()



end

function Free()


end

function StartTask()
	stunDuration = math.random(10, 30)	
	error_catch = aiLogic:AISetStun(stunDuration)
end

function Evaluate()
  if (error_catch == 3) then
    StartTask() 
  else
    return aiLogic:AICompleteTask()
  end
end