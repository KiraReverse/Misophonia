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
playerTriggerID							= GetComponentHandle("CollisionComponent")
playerColliderID						= GetComponentHandle("CollisionComponent")

aiTriggerID								= GetComponentHandle("CollisionComponent")

portraitTransformID1					= GetComponentHandle("Transform")
portraitTransformID2					= GetComponentHandle("Transform")
portraitTransformID3					= GetComponentHandle("Transform")
portraitTransformID4					= GetComponentHandle("Transform")
portraitTransformID5					= GetComponentHandle("Transform")
portraitTransformID6					= GetComponentHandle("Transform")


--cheat flip bools--
local isGod								= false
local isNoClip							= false

function Init()

end

function Start()
	
	entityID 							= GetEntity()
	entityManager 						= GetManagers():GetEntityManager()
	entity 								= entityManager:Get(entityID)

	input 								= GetInputInterface()
	
	transformManager 					= GetManagers():GetTransformManager()
	transformID 						= entity:GetComponent(transformManager:GetComponentID())
	playerTransform 					= transformManager.GetComponent(transformID)

	collisionManager 					= GetManagers():GetCollisionManager()
	playerTrigger 						= collisionManager.GetComponent(playerTriggerID)
	playerCollider						= collisionManager.GetComponent(playerColliderID)
	
	aiTrigger							= collisionManager.GetComponent(aiTriggerID)
	
	scriptManager						= GetScriptedComponentManager()
	
	
	portraitTransform1					= GetComponent(portraitTransformID1)
	portraitTransform2					= GetComponent(portraitTransformID2)
	portraitTransform3					= GetComponent(portraitTransformID3)
	portraitTransform4					= GetComponent(portraitTransformID4)
	portraitTransform5					= GetComponent(portraitTransformID5)
	portraitTransform6					= GetComponent(portraitTransformID6)
	
	
	portraits 							= {portraitTransform1, portraitTransform2, portraitTransform3, portraitTransform4, portraitTransform5, portraitTransform6}
end

	
	
function GodMode()
	if(isGod == true) then
		isGod 							= false
		
		playerTrigger.isActive 			= true
		aiTrigger.isActive 				= true
	else
		isGod 							= true
		
		playerTrigger.isActive 			= false
		aiTrigger.isActive 				= false
	end
end

function NoClip()
	if(isNoClip == true) then
		isNoClip 						= false
		
		playerCollider.isActive 		= true
	else
		isNoClip 						= true
		
		playerCollider.isActive 		= false
	end
end

function OpenFinalDoor()

for i, v in pairs(portraits) do
	v.rotation = 0
end


end


function ReloadLevel()
	GetEngine():LoadLevel("levelfiles/02Feb2019_Level1")
end

function Update()
	
	if(input:CheckKeyTriggered(Virtual_Keys.AEVK_F1)) then
		GodMode()
	end
	
	if(input:CheckKeyTriggered(Virtual_Keys.AEVK_F2)) then
		NoClip()
	end
	

	
	if(input:CheckKeyTriggered(Virtual_Keys.AEVK_F3)) then
		OpenFinalDoor()
	end

end

function Free()
end