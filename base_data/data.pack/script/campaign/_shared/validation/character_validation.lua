print("*** Loading character validation... ***");

-- used to check the subtypes of the characters
local class_keys_to_subtypes = 
{
    ["3k_dlc06_ceo_class_nanman"]   = "3k_general_nanman",
    ["3k_main_ceo_class_earth"]     = "3k_general_earth",
    ["3k_main_ceo_class_fire"]      = "3k_general_fire",
    ["3k_main_ceo_class_metal"]     = "3k_general_metal",
    ["3k_main_ceo_class_water"]     = "3k_general_water",
    ["3k_main_ceo_class_wood"]      = "3k_general_wood",
    ["3k_ytr_ceo_class_heaven"]     = "3k_general_wood",
    ["3k_ytr_ceo_class_land"]       = "3k_general_metal",
    ["3k_ytr_ceo_class_people"]     = "3k_general_water"
}

function validate_active_characters(active_characters_list)
	local assumptions = 
	{
		Assumption:new("All characters that have a military force are of legal age", 
			function(characters_list)
				return characters_list:all_of( 
					function (character)
						if character:has_military_force() and not character:has_come_of_age() then
							Validation:print_to_console("character_Validation: Character has not come of age but has a military force : [%s]", tostring(character:cqi()));
							return false;
						end
						return true;
					end)
			end),

		Assumption:new("Characters have a class which matches their subtype.",
			function(character_list)
				return character_list:all_of(
					function(character)
						-- Ignore characters without CEOs.
						if character:ceo_management():is_null_interface() then
							return true;
						end;
						-- Every other character's class should match their subtype.
						local subtype = character:character_subtype_key();
						local class_ceos = character:ceo_management():all_ceos_for_category("3k_main_ceo_category_class");
						if class_ceos:is_empty() or class_ceos:num_items() > 1 then
							return false;
						end;
						local class_ceo_key = class_ceos:item_at(0):ceo_data_key();
						
						-- Special cases.
						if subtype == "3k_colonel" -- Colonels can have classes of other elements.
							or class_ceo_key == "3k_main_ceo_class_transitive" then -- Transitive characters can be any element.
							return true;
						end;

						if not class_keys_to_subtypes[class_ceo_key] then
							Validation:print_to_console("character_Validation: Character has unsupported class [%s]: [%s]", Validation:get_character_string(character), tostring(class_ceo_key))
							return false;
						end;

						if class_keys_to_subtypes[class_ceo_key] ~= subtype then
							Validation:print_to_console("character_Validation: Character class [%s] with subtype [%s] doesn't match expected subtype of [%s]: [%s]", tostring(class_ceo_key), tostring(subtype), tostring(class_keys_to_subtypes[class_ceo_key]), Validation:get_character_string(character));
							return false;
						end;

						return true;
					end)
			end);

		Assumption:new("There is only one Ji Ben in the campaign.",
			function(character_list)
				local num_ji_bens = character_list:count_if(function(character) return character:generation_template_key() == "3k_main_template_historical_ji_ben_hero_wood" end);
				if num_ji_bens > 1 then
					Validation:print_to_console("character_Validation: Multiple Ji Bens in campaign. Count: %i", num_ji_bens);
					character_list:
						filter(function(character) return character:generation_template_key() == "3k_main_template_historical_ji_ben_hero_wood" end):
						foreach(function(character) 
							Validation:print_to_console("\t %s", Validation:get_character_string(character));
							end)

					return false;
				end;

				return true;
			end);

		Assumption:new("Characters have at least one name (forename/firstname)",
			function(character_list)
				return character_list:any_of(function(character)
					local name = character:get_forename() .. character:get_surname();
					if string.len(name) < 1 then
						Validation:print_to_console("character_Validation: Character has no name: [%s]", Validation:get_character_string(character))
						return false;
					end;

					return true; -- Valid
				end)
			end);
	};

	local validated_characters = Validated_object:new("Characters", active_characters_list, assumptions);
	return validated_characters;
end;

print("*** Character validation loaded... ***");