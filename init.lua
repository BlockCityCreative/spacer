local storage = minetest.get_mod_storage()
local maxTimes = 6-- maximum times -1 the command space can be used on one loading of the mod
local spaceBegin = 20002
local space_spawn = {}

if storage:get_string("space_spawn") then -- if space_spawn has been set, the value will not be nil
    space_spawn=minetest.deserialize(storage:get_string("space_spawn"))
else -- fallback space_spawn
    space_spawn.x = 20000
    space_spawn.y = 20000
    space_spawn.z = 20000
end

if not minetest.get_modpath("default") then
    minetest.register_node("spacer:seed", {
        description = "seed for creating a new base in space, initialized and used only if default is not installed",
        tiles = {"seed.png"},
        groups = {oddly_breakable_by_hand=3,not_in_creative_inventory=1},
        drop = ""
    })
    local isDefault = false

else
    isDefault = true

end

local numTimes= {}
minetest.register_chatcommand("space", {
    description = "adds a node under a player, if they are \n1) In space \n2) NOT in a protected area \n3)have not used it in the last 15 seconds",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()
        local canPlace = areas:canInteract(pos,name)
        pos["y"] = pos["y"] -2
        if (pos["y"]>= spaceBegin and canPlace and ((not numTimes[name]) or numTimes[name] < maxTimes) ) then
            
            if isDefault then
                minetest.set_node(pos, {name="default:dirt"})
            
            else
                minetest.set_node(pos, {name="spacer:seed"})
            end
            
            numTimes[name]=(numTimes[name]or 0) +1
            print(numTimes[name])
        else
            if pos["y"] < spaceBegin then
                minetest.chat_send_player(name, "goto space please. in this server, space begins at"..spaceBegin)
            end

            if not canPlace then
                minetest.chat_send_player(name, "You have been suspected of griefing. this incident will be reported")
                print(name.."attempts to place node at protected area at pos"..tostring(pos["x"])..", "..tostring(pos["y"])..", "..tostring(pos["z"]))
                
            end

            if (  numTimes[name] or 0) >= maxTimes then
                minetest.chat_send_player(name, "you are ssuspected of spamming the comman to place a block.please wait until a reboot before retrying. this incident will be reported")
                print(name.."used the space command multiple times. the command was again executed at "..tostring(pos["x"])..", "..tostring(pos["y"])..", "..tostring(pos["z"]))
            end
        end
    end
})

minetest.register_chatcommand("set_space_spawn", {
    description = "Set the space_spawn pos to your current position, for use with /space_spawn",
    privs= {server=true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        pos = player:get_pos()
        if pos.y >= spaceBegin then
            space_spawn = pos
            storage:set_string("space_spawn", minetest.serialize(space_spawn))
            minetest.chat_send_player(name, "set spawn to"..(pos.x).." , "..(pos.y).." , "..(pos.z))
        else
            minetest.chat_send_player(name, "idiot, it is space_spawn, not spawn")
        end
    end
})

minetest.register_chatcommand("space_spawn", {
    description="Takes you to the spawn location for space",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        print(space_spawn["x"])
        player:set_pos(space_spawn)
        minetest.chat_send_player(name, "teleprted to space_spawn")
    end
})