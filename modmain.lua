
local RESPAWN_TIME = GetModConfigData("respawn_time") or 2
local CHECK_RADIUS = GetModConfigData("check_radius") or 2
local DEBUG_MODE = GetModConfigData("debug_mode") or false

local function DebugPrint(...)
    if DEBUG_MODE then
        print("[Renewable Fireflies]", ...)
    end
end

DebugPrint("Mod loaded - Config:", RESPAWN_TIME, "days,", CHECK_RADIUS, "radius")

local firefly_positions = {}

local function CheckRespawnArea(x, z, radius)
    local entities = TheSim:FindEntities(x, 0, z, radius)
    local has_blocking_objects = false
    local has_fireflies = false
    
    for _, ent in pairs(entities) do
        if ent and ent:IsValid() then
            if ent.prefab == "fireflies" then
                has_fireflies = true
            elseif ent.components.inventoryitem or ent.components.workable or ent.components.structure then
                has_blocking_objects = true
            end
        end
    end
    
    if has_fireflies then
        return "firefly_present"
    elseif has_blocking_objects then
        return "blocked"
    else
        return "clear"
    end
end


AddPrefabPostInit("fireflies", function(ent)
    ent:ListenForEvent("onpickup", function()
        DebugPrint("Firefly picked up!")
        local x, y, z = ent.Transform:GetWorldPosition()
        local position = {x = x, y = 0, z = z}
        
        local pickup_day = GLOBAL.TheWorld.state.cycles
        table.insert(firefly_positions, {
            position = position,
            pickup_day = pickup_day
        })
        
        DebugPrint("Firefly picked at", x, z, "- will respawn in", RESPAWN_TIME, "days")
    end)
end)

AddPrefabPostInit("world", function(ent)
    -- Add save/load functionality
    local old_OnSave = ent.OnSave
    ent.OnSave = function(ent, data)
        if old_OnSave then
            old_OnSave(ent, data)
        end
        data.renewable_fireflies = {
            firefly_positions = firefly_positions,
            version = "1.0"
        }
        DebugPrint("Saved", #firefly_positions, "firefly positions")
    end
    
    local old_OnLoad = ent.OnLoad
    ent.OnLoad = function(ent, data)
        if old_OnLoad then
            old_OnLoad(ent, data)
        end
        if data and data.renewable_fireflies then
            if data.renewable_fireflies.firefly_positions then
                firefly_positions = data.renewable_fireflies.firefly_positions
                DebugPrint("Loaded", #firefly_positions, "firefly positions from world save")
            end
        else
            DebugPrint("No saved data found in world, starting fresh")
        end
    end
    
    ent:DoPeriodicTask(10, function() -- Check every 10 seconds
        local current_day = ent.state.cycles
        DebugPrint("Current day:", current_day)
        DebugPrint("Checking", #firefly_positions, "fireflies for respawn...")
        
        for i = #firefly_positions, 1, -1 do
            local data = firefly_positions[i]
            local days_since_pickup = current_day - data.pickup_day
            if days_since_pickup >= RESPAWN_TIME then
                local area_status = CheckRespawnArea(data.position.x, data.position.z, CHECK_RADIUS)
                
                if area_status == "clear" then
                    -- Area is clear, spawn firefly
                    local firefly = GLOBAL.SpawnPrefab("fireflies")
                    if firefly then
                        firefly.Transform:SetPosition(data.position.x, 0, data.position.z)
                        DebugPrint("Firefly respawned at", data.position.x, data.position.z)
                    end
                    table.remove(firefly_positions, i)
                elseif area_status == "firefly_present" then
                    -- Another firefly is already there, stop tracking this one
                    DebugPrint("Firefly already present at", data.position.x, data.position.z, "- removing from tracking list")
                    table.remove(firefly_positions, i)
                elseif area_status == "blocked" then
                    -- Area blocked by objects, keep trying later
                    DebugPrint("Area blocked at", data.position.x, data.position.z, "- will try again later")
                end
            else
                DebugPrint("Firefly at", data.position.x, data.position.z, "not ready to respawn yet. Days since pickup:", days_since_pickup)
            end
        end
    end)
end)