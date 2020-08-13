local storage = minetest.get_mod_storage()
print("[spacer] loaded")

minetest.register_chatcommand("space", {
    description = "adds a node under a player, if they are 1) In space \n2) NOT in a protected area \n3)have not used it in the last 15 seconds",
    func = function(name)
       local player = minetest.get_player_by_name(name)
       print(tostring(player:get_pos()))
       
    end
})