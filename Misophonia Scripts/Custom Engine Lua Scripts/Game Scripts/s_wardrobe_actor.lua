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

actorRenderID = GetComponentHandle("RenderComponent")
actorTransformID = GetComponentHandle("Transform")

local yTravel = -1.44
local isActive = false
local actorPos = Vec2.new(0, 0)

local timer = 0

function Init()
end

function Start()


	renderManager = GetRenderComponentManager()
	actorRender = renderManager.GetComponent(actorRenderID)
	
	transformManager = GetManagers():GetTransformManager()
	actorTransform = transformManager.GetComponent(actorTransformID)
end

--pos = wardrobe position
function ActivateActor(pos)
	if (isActive == false) then
		actorTransform.position = pos
		actorTransform.dirty = true
		isActive = true
		actorRender.enabled = true
	end
end

function Update()

	if(isActive == true) then

		actorPos = actorTransform.position
		actorPos.y = GlobalLerp(actorPos.y, actorPos.y + yTravel,1)
		actorPos.x = GlobalLerp(actorPos.x, actorPos.x ,1)
		actorTransform.dirty = true
		timer = timer + GetEngine():getDeltaTime()

	end

	if(timer >= 0) then
		
		isActive = false
		actorRender.enabled = false
		timer = 0
		
	end


end

function Free()
end