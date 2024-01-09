print("*** Loading character ceo validation... ***");

function validate_active_character_ceos(active_characters_list)
	local assumptions = 
	{
		Assumption:new("All characters should have one weapon",
			function(char_list)
				return char_list:filter(function(char) return not char:character_subtype("3k_colonel") and not char:character_type("castellan") end)
				:all_of( 
					function (character)
						local success = true;
						-- make sure that the charcater has a ceo manager
						if character:ceo_management() and not character:ceo_management():is_null_interface() then
							-- the character should have always one weapon equipped
							success = character:ceo_management():number_of_ceos_equipped_for_category("3k_main_ceo_category_ancillary_weapon") == 1;
							-- for now we need to print out when the evalidation fails
							if not success then 
								Validation:print_to_console("character_ceo_Validation: Character doesn't have a weapon equipped. [%s]", Validation:get_character_string(character))
							end
						end
						return success;
					end)
			end),

		Assumption:new("All characters should have one piece of armour",
			function(char_list)
				return char_list:filter(function(char) return not char:character_subtype("3k_colonel") and not char:character_type("castellan") end)
				:all_of( 
					function (character)
						local success = true;
						-- make sure that the charcater has a ceo manager
						if character:ceo_management() and not character:ceo_management():is_null_interface() then
							-- the character should have always one armour equipped
							local success = character:ceo_management():number_of_ceos_equipped_for_category("3k_main_ceo_category_ancillary_armour") == 1;
							-- for now we need to print out when the evalidation fails
							if not success then 
								Validation:print_to_console("character_ceo_Validation: Character doesn't have an armour equipped. [%s]", Validation:get_character_string(character))
							end
						end
						return success;
					end)
			end),

		Assumption:new("All characters should have one mount",
			function(char_list)
				return char_list:filter(function(char) return not char:character_subtype("3k_colonel") and not char:character_type("castellan") end)
				:all_of( 
					function (character)
						local success = true;
						-- make sure that the charcater has a ceo manager
						if character:ceo_management() and not character:ceo_management():is_null_interface() then
							-- the character should have always one mount equipped
							local success = character:ceo_management():number_of_ceos_equipped_for_category("3k_main_ceo_category_ancillary_mount") == 1;
							-- for now we need to print out when the evalidation fails
							if not success then 
								Validation:print_to_console("character_ceo_Validation: Character doesn't have a mount equipped. [%s]", Validation:get_character_string(character))
							end
						end
						return success;
					end)
			end),

		Assumption:new("Faction leaders should never have a title",
			function(char_list)
				return char_list:all_of( 
					function (character)
						local success = true;
						-- make sure that the charcater is a faction leader and has a ceo manager
						if character:is_faction_leader() and character:ceo_management() and not character:ceo_management():is_null_interface() then
							-- make sure that no tiltes are equipped
							success = character:ceo_management():number_of_ceos_equipped_for_category("3k_dlc05_ceo_category_ancillary_titles") == 0;
							-- for now we need to print out when the evalidation fails
							if not success then 
								Validation:print_to_console("character_ceo_Validation: faction leader has a title. [%s]", Validation:get_character_string(character))
							end
						end
						return success;
					end)
			end),
	};

	local validated_character_ceos = Validated_object:new("validate_active_character_ceos", active_characters_list, assumptions);
	return validated_character_ceos;
end;

print("*** Character ceo validation loaded... ***");