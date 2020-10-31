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
local wardrobePos 		= Vec2.new(0,0)
local wardrobeScriptID 	= GetComponentHandle("s_wardrobe")

--variable to store AI in hiding spot
local hidingSpot 		= Vec2.new(0,0)



-- just to save the render layer he's meant to be on while active
local inactiveRenderLayer = 0

--flip bools to check steps
local taskComplete = false

local isMoving = false
local isInactive = true

function Init()

	
	
	

end

function Start()

	
	--these information might have to be recieved in GetInfo as well (?)
	-- then the start for task scripts need to come later
	--access to AI's entity
	entityID 			= GetEntity()
	entityManager 		= GetManagers():GetEntityManager()
	entity	 			= entityManager:Get(entityID)	
					
	--access to AI's render component (should be in child though, EvilBoiSprite).
	renderManager 		= GetRenderComponentManager()
	renderID      		= entity:GetComponent(renderManager:GetComponentID())
	render 				= renderManager.GetComponent(renderID)
	
	
	--access to AI's transform component
	transformManager 	= GetManagers():GetTransformManager()
	transformID 		= entity:GetComponent(transformManager:GetComponentID())
	transform 			= transformManager.GetComponent(transformID)
	
	--access to AI's collision components (both collision components should be turned off while inactive)
	collisionManager 	= GetManagers():GetCollisionManager()
	colList 			= entity:GetComponents(collisionManager:GetComponentID())

	for i, v in pairs(colList) do
			if (collisionManager.GetComponent(v).isTrigger == true) then
				trigger 	= collisionManager.GetComponent(v)
			else
				collider 	= collisionManager.GetComponent(v)
			end
		end
	
	--access to script 
	scriptManager		= GetScriptedComponentManager()
	
end

----------------------------------------------------------------------
---------------Functions that I require for this script---------------
----------------------------------------------------------------------

--this function possible recieves the information that director passes down via events (?)
--assuming we're using events to send it down
function GetInfo(wdPos, wdSID)

	wardrobePos 		= wdPos
	wardrobeScriptID	= wdSID

end

function AIMoveToPosition(wardrobePos)
--takes in transform.position of wardrobe appointed by director
--AI pathfinds to wardrobe





end

function TaskInterrupt()
--function that is called when chase state is entered?
isMoving = false
end

function CheckDoor(wardrobeScriptID)

	--access to wardrobe's s_wardrobe component
	wardrobe = scriptManager.GetLuaScript(wardrobeScriptID)

	
	--opens wardrobe door if it isnt already open
	if(wardrobe.isOpen == true) then
		wardrobe.Interaction()
	end
	
	--maybe play some particles/make effect when he disappears
	
	--set render layer to active layer so sprite appears
	render.layer = inactiveRenderLayer
	

	
	--turns on trigger
	trigger.isActive = false
	collider.isActive = false
	


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
		AIMoveToPosition()
		isMoving = true
	end
	
	if(position == wardrobe.position && isInactive == false)
		CheckDoor()
		isInactive = true
	end
	
	if(isMoving == true and isInactive == true)
		taskComplete = true
	end
	

	
	
	
	
end

function Free()
end

