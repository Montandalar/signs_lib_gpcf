-- signs_lib text macros
-- by orwell96

local mstore=minetest.get_mod_storage()

local macros = minetest.deserialize(mstore:get_string("macros")) or {}

local function save_macros()
	mstore:set_string("macros", minetest.serialize(macros))
end

minetest.register_privilege("signs_macro", { description = "May edit sign macros", give_to_singleplayer = true, default = false })

minetest.register_chatcommand("signs_macro", {
        params = "list | set <macro> <string> | clear <macro>",
        description = "List or edit sign macros",
        privs = {signs_macros},
        func = function(name, param)
			if param=="list" then
				local c=0
				for k,v in pairs(macros) do
					minetest.chat_send_player(name, "@"..k.." -> "..v)
					c=c+1
				end
				return true, "Listed "..c.." sign macros."
			end
			local macro, strg = string.match(param, "^set%s@?([^@%s]+)%s?(.*)$")
			if macro and strg then
				macros[macro]=strg
				save_macros()
				return true, "Set macro '@"..macro.."'."
			end
			macro = string.match(param, "^clear%s@?(%S+)$")
			if macro then
				macros[macro]=nil
				save_macros()
				return true, "Cleared macro '@"..macro.."'."
			end
			return false, "Incorrect usage! Syntax: list | set <macro> <string> | clear <macro>"
        end
    })
-- replace_macros(text)
return function(text)
	for k, v in pairs(macros) do
		text=string.gsub(text, "@"..k, v)
	end
	return text
end
