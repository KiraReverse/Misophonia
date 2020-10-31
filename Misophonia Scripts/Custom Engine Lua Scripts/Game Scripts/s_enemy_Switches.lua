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
--exposed variables
switch1transformID			= GetComponentHandle("Transform")
switch2transformID			= GetComponentHandle("Transform")
switch3transformID			= GetComponentHandle("Transform")
switch4transformID			= GetComponentHandle("Transform")
switch5transformID			= GetComponentHandle("Transform")

switch1lightID				= GetComponentHandle("LightComponent")
switch2lightID				= GetComponentHandle("LightComponent")
switch3lightID				= GetComponentHandle("LightComponent")
switch4lightID				= GetComponentHandle("LightComponent")
switch5lightID				= GetComponentHandle("LightComponent")

switch1triggerID			= GetComponentHandle("CollisionComponent")
switch2triggerID			= GetComponentHandle("CollisionComponent")
switch3triggerID			= GetComponentHandle("CollisionComponent")
switch4triggerID			= GetComponentHandle("CollisionComponent")
switch5triggerID			= GetComponentHandle("CollisionComponent")

--managers
transformManager 			= GetTransformManager()
lightManager				= GetLightComponentManager()
collisionManager			= GetCollisionManager()

-- local variables
local switch1Pos			= 0
local switch2Pos			= 0
local switch3Pos			= 0
local switch4Pos			= 0
local switch5Pos			= 0



function Init()

end

function Start()

switch1transform 			= transformManager.GetComponent(switch1transformID)
switch2transform 			= transformManager.GetComponent(switch2transformID)
switch3transform 			= transformManager.GetComponent(switch3transformID)
switch4transform 			= transformManager.GetComponent(switch4transformID)
switch5transform 			= transformManager.GetComponent(switch5transformID)

switch1light				= lightManager.GetComponent(switch1lightID)



end

function Update()

end

function Free()
end