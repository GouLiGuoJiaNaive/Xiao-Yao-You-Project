print("*** Loading faction validation... ***");

function validate_factions(faction_list)
	local assumptions = 
	{
		Assumption:new("All factions have a leader post", 
			function(factions)
				return factions:all_of(function (faction)
					local found_leader = faction:character_posts():any_of(function (post)
						return post:ministerial_position_record_key() == "faction_leader";
					end)
					
					if not found_leader then
						Validation:print_to_console("Faction [%s] has no leader post. One is required.", faction:name());
					end;

					return found_leader;
				end)
			end),

		Assumption:new("All factions have an heir post", 
			function(factions)
				return factions:all_of(function (faction)
					local found_heir = faction:character_posts():any_of(function (post)
						return post:ministerial_position_record_key() == "faction_heir";
					end)

					if not found_heir then
						Validation:print_to_console("Faction [%s] has no heir post. One is required.", faction:name());
					end;

					return found_heir;
				end)
			end),

		Assumption:new("All factions have a government", 
			function(factions)
				return factions:none_of(function (faction)
					local has_government = not faction:character_posts():is_empty();
					
					if not has_government then
						Validation:print_to_console("Faction [%s] has no government setup. One is required.", faction:name());
					end;

					return has_government;
				end)
			end),

		Assumption:new("All factions have an opposite government", 
			function(factions)
				return factions:none_of(function (faction)
					local has_government = not faction:character_posts_for_opposite_government():is_empty();
					
					if not has_government then
						Validation:print_to_console("Faction [%s] has no opposition government setup. One is required.", faction:name());
					end;

					return has_government;
				end)
			end)
	};

	local validated_factions = Validated_object:new("Factions", faction_list, assumptions);
	return validated_factions;
end;

print("*** Faction validation loaded... ***");