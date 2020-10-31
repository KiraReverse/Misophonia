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
-- managers 

local entityID = 0 -- GetEntity()
local entityManager = 0 -- GetManagers():GetEntityManager()
local entity = 0 -- entityManager:Get(entityID)

local transformManager = 0
local transformID = 0
local transform = 0
                 
local spriteManager = 0
local spriteID = 0
local sprite = 0	

local input = 0

--exposed variables
madpieIndex = 3
--madpieScale = Vec2.new(20, 5)
levelpath = ""


--coroutine stuff
waitTime = 3
local timeWaited = 0



-- function variables
local switch = false
local loaded = false

function Init()

	
	
	

end

function Start()

	entityID = GetEntity()
	entityManager = GetManagers():GetEntityManager()
	entity = entityManager:Get(entityID)
	
	input = GetInputInterface()
	
	transformManager = GetTransformManager()
	transformID = entity:GetComponent(transformManager:GetComponentID())
	transform = transformManager.GetComponent(transformID)					
					
	spriteManager = GetManagers():GetSpriteManager()
	spriteID = entity:GetComponent(spriteManager:GetComponentID())
	sprite = spriteManager.GetComponent(spriteID)
  ShowCursor(false)
		
end



function Update()

	timeWaited = timeWaited + GetEngine():getDeltaTime()
	
	if(timeWaited >= waitTime) then
		if(switch == false) then
			transform.scale = Vec2.new(20, 5)
			sprite.index = madpieIndex
			switch = true
			timeWaited = 0
		else
			GetEngine():LoadLevel(levelpath)
			
		end
	end
	

end

function Free()
end