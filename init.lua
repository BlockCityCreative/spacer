local storage = minetest.get_mod_storage()
local maxTimes = 6-- maximum times -1 the command space can be used on one loading of the mod
print("[spacer] loaded")
local numTimes= {}
minetest.register_chatcommand("space", {
    description = "adds a node under a player, if they are 1) In space \n2) NOT in a protected area \n3)have not used it in the last 15 seconds",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        local pos = player:get_pos()
        local area= areas:getAreasAtPos(pos)
        local numAreas= 0
        
        for k in pairs(area) do 
            numAreas=numAreas+1 -- gets no of areas at pos
        end

        if (pos["y"]>=20000 and numAreas==0 and ((not numTimes[name]) or numTimes[name] >= maxTimes) ) then
            minetest.set_node(pos, {name="default:dirt"})
            numTimes[name]=(numTimes[name]or 0) +1
            print(numTimes[name])
        else
            print("hey you idiot get out of a protected place/goto space")
        end
    end
})