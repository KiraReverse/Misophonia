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
leftFallSequence = 0
rightFallSequence = 1

local isStruggling = false
local isRight = true

local struggleTime = 0
local struggleWait = 2

local struggleCounter = 0
local struggleThreshold = 5


function Init()

	
	
	

end

function Start()

	GetLuaEventSystem():AddListener("EVENT_COLLISION", "CollisionCheck")
	
	entityID = GetEntity()
	entityManager = GetManagers():GetEntityManager()
	entity = entityManager:Get(entityID)

	input = GetInputInterface()
	
					
	transformManager = GetManagers():GetTransformManager()
	transformID = entity:GetComponent(transformManager:GetComponentID())
	transform = transformManager.GetComponent(transformID)
					
	spriteManager = GetManagers():GetSpriteManager()
	spriteID = entity:GetComponent(spriteManager:GetComponentID())
	sprite = spriteManager.GetComponent(spriteID)
	
	animationManager = GetSpriteAnimationControllerManager()
	animationID = entity:GetComponent(animationManager:GetComponentID())	
	animation = animationManager.GetComponent(animationID)

	renderManager = GetRenderComponentManager()
	renderID = entity:GetComponent(renderManager:GetComponentID())
	render = renderManager.GetComponent(renderID)
	
	pStateManager = GetPlayerStateManager()
	pStateID = entity:GetComponent(pStateManager:GetComponentID())
	pState = playerStateManager.GetComponent(pStateID)
	
	physicsManager = GetPhysicsManager()
	physicsID = entity:GetComponent(physicsManager:GetComponentID())
	physics = physicsManager.GetComponent(physicsID)
	
	cController = GetCConComponent()
	
end


function CheckDirection(x1, x2)

	result = x1 - x2
	
	return result
end



function CollisionCheck(hitWrapper)

	entity1 = entityManager:Get(hitWrapper.ent1)
	entity2 = entityManager:Get(hitWrapper.ent2)


	
	name1 = entityManager:Get(hitWrapper.ent1):name()
	name2 = entityManager:Get(hitWrapper.ent2):name()
	
	
	
	if ((name1 == "Player" and name2 == "EvilBoiAlive") or ((name2 == "Player" and name2 == "EvilBoiAlive"))) then
		
		cController.isActive = false
		
		animation.loop = false
		
		pState.currState = CharacterState_Struggle
		
		
		dist = CheckDirection(vec1.x, vec2.x)
		if(dist > 0) then
		
		
			animation.sequence_index = rightFallSequence
			
			isRight = true 
			isStruggling = true
		else
			animation.sequence_index = leftFallSequence
			
			isRight = false
			isStruggling = true
		end
	
end



function Update()

	if(isStruggling == true) then
	
		if(isRight == true) then
			if(input:CheckKeyTriggered(Virtual_Keys.AEVK_D) and animation.playing == false) then
				animation.Play()
				physics.forceManager.AddForce(10,0)
				struggleCounter = struggleCounter + 1
			end
			
		else
			if(input:CheckKeyTriggered(Virtual_Keys.AEVK_A) and animation.playing == false) then
				animation.Play()
				physics.forceManager.AddForce(10,0)
				struggleCounter = struggleCounter + 1
			end
		end
		
		struggleTime = struggleTime + GetEngine():getTimeStep()
		
		if(struggleTime >= struggleWait) then
			
		
			
		end
		
		if(struggleCounter >= struggleThreshold) then
			isStruggling = false
			struggleCounter = 0
			struggleTime = 0
			cController.isActive = false
		end
	
	end

end

end

function Free()
end