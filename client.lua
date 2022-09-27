---------------------------------config--------------------------------------
useCommand = true -- Allow you to use /equipe to wear the explosive vest

deadman_switch = true -- set true to explode when you die

useBlip = true -- Set false if you want hide the jacket location

function location()
-- Set jacket location here, you can add multiple (set how many on locationCount if useBlip = true)
--emplacement(coords.x, coords.y, coords.z)
  emplacement(1417.87, 3647.52, 34.5) -- Example
end

locationCount = 1 -- Please Set how many emplacement you set (necessary if useBlip = true)
-----------------------------------------------------------------------------
n = 0 

Citizen.CreateThread(function()
  RequestWeaponAsset(GetHashKey("WEAPON_AIRSTRIKE_ROCKET")) 
  while not HasWeaponAssetLoaded(GetHashKey("WEAPON_AIRSTRIKE_ROCKET")) do
      Wait(0)
  end
  RequestWeaponAsset(GetHashKey("WEAPON_STICKYBOMB")) 
  while not HasWeaponAssetLoaded(GetHashKey("WEAPON_STICKYBOMB")) do
      Wait(0)
  end
  RequestWeaponAsset(GetHashKey("WEAPON_GRENADE")) 
  while not HasWeaponAssetLoaded(GetHashKey("WEAPON_GRENADE")) do
      Wait(0)
  end
  RequestWeaponAsset(GetHashKey("WEAPON_RPG")) 
  while not HasWeaponAssetLoaded(GetHashKey("WEAPON_RPG")) do
      Wait(0)
  end
  while true do
    location()
    Citizen.Wait(10)
  end
end)

if useCommand == true then
  RegisterCommand("equipe",function(source, args, rawCommand)
    equipe()
  end)
end



function emplacement(coordx,coordy,coordz)
  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)
  marker = DrawMarker(0, coordx, coordy, coordz, 0.0, 0.0, 0.0, 0.0, 0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 50, false, true, 2, nil, nil, false)
  distance = GetDistanceBetweenCoords(coords.x,coords.y,coords.z,coordx,coordy,coordz,true)
  if useBlip == true then
    point = AddBlipForCoord(coordx, coordy, coordz)
    SetBlipSprite(point, 486)
    SetBlipColour(point, 1)
    SetBlipAsShortRange(point, true)
    n = n + 1
    if n > locationCount - 1 then
      useBlip = false
    end
  end
  if distance < 1 then
    AddTextEntry("equiper", "Appuie sur ~INPUT_CONTEXT~ pour t'armer")
    DisplayHelpTextThisFrame("equiper",false)
    if IsControlPressed(0, 51) then
      equipe()
    end
  end
  return coordx, coordy, coordz
end

function equipe()
  local ped = PlayerPedId()
  SetPedComponentVariation(ped, 9, 15, 0, 0)
  AddTextEntry("HELP", "Appuie sur ~INPUT_DETONATE~ pour exploser.")
  DisplayHelpTextThisFrame("HELP",false)
  while true do
    Citizen.Wait(1)
    if deadman_switch == false then
      if IsControlPressed(0,58) then
        explosion()
        break
      end
      if IsPedDeadOrDying(ped, true) then
        break
      end
    else
      playerHealth = GetEntityHealth(ped)
      if IsControlPressed(0,58) or playerHealth < 1 then
        explosion()
        break
      end
      if IsPedDeadOrDying(ped, true) then
        break
      end
    end
  end
end

function explosion()
  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)
  if IsPedInAnyVehicle(ped,false) then
    local vehicle = GetVehiclePedIsIn(ped,false)
    ExplodeVehicleInCutscene(vehicle,true)
  else
    ShootSingleBulletBetweenCoords(coords.x, coords.y, coords.z+0.1, coords.x, coords.y, coords.z, 500, true,GetHashKey("WEAPON_PASSENGER_ROCKET"), ped, true, false, 0)
    ShootSingleBulletBetweenCoords(coords.x, coords.y, coords.z+0.1, coords.x, coords.y, coords.z, 500, true,GetHashKey("WEAPON_RPG"), ped, true, false, 0)
    ShootSingleBulletBetweenCoords(coords.x, coords.y, coords.z+0.1, coords.x, coords.y, coords.z, 500, true,GetHashKey("WEAPON_AIRSTRIKE_ROCKET"), ped, true, false, 0)
    ShootSingleBulletBetweenCoords(coords.x, coords.y, coords.z+0.1, coords.x, coords.y, coords.z, 500, true,GetHashKey("WEAPON_STICKYBOMB"), ped, true, false, 0)
  end
  SetPedComponentVariation(ped, 9, 0, 0, 0)
end