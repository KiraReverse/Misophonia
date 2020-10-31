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
--Variable information to be pass to script from Director
local targetPos 		= Vec2.new(0,0)

--flip bools to check steps
local taskComplete 		= false

local isMoving 			= false
local reached 			= false

function Init()

end

function Start()
	
end

----------------------------------------------------------------------
---------------Functions that I require for this script---------------
----------------------------------------------------------------------

--this function possible recieves the information that director passes down via events (?)
--assuming we're using events to send it down
function GetInfo(tPos)

	targetPos 		= tPos

end

function AIMoveToPosition(targetPos)
--takes in target position appointed by director
--AI pathfinds to targetPos





end

function TaskInterrupt()
--function that is called when chase state is entered?
isMoving = false
end


function EndTask()
	--just a function i call to end this script and tell tree to move to next task

end


function Update()

	if(taskComplete == true)
		EndTask()
	end
	
	--AI's render level should be 0/below 5 after exiting/before entry
	if(isMoving == false) then
		AIMoveToPosition(targetPos)
		isMoving = true
	end
	
	if(transform.position == targetPos)

		reached = true
	end
	
	if(reached == true=)
		taskComplete = true
	end
	

	
	
	
	
end

function Free()
end

