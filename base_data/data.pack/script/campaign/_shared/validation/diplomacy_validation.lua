print("*** Loading diplomacy validation... ***");

local function faction_is_in_any_alliance(faction, world)
	return world:alliance_list():any_of(
		function (alliance)
			return alliance:contains_member(faction);
		end);
end;

-- We have a list of active alliances in the world, but also of expired ones
-- This can be used to test if references to alliances in diplomacy are valid
local function alliance_is_active(alliance, world)
	return world:alliance_list():any_of(
		function (existing_alliance)
			return existing_alliance:cqi() == alliance:cqi();
		end);
end;

function validate_diplomacy(world)
	local assumptions = 
	{
		Assumption:new("No faction outside of an alliance has a group war component signed as proposer", 
			function(world)
				return world:faction_list():none_of(
					function (faction)
						return (not faction_is_in_any_alliance(faction, world)) and faction:diplomatic_deal_list():any_of(
							function(deal)
								return deal:components():any_of(
									function (component)
										local is_group_war_component = 
											component:treaty_component_key() == "treaty_components_group_war";
										return is_group_war_component and component:proposer() == faction;
									end)
							end);
					end)
			end),
		Assumption:new("Alliance CQIs referenced in active deals' components refer to existing alliances", 
			function (world)
				return world:faction_list():all_of(
					function (faction)
						local deals_with_components = faction:diplomatic_deal_list():filter(
							function (deal) return not deal:components():is_empty(); end);

						return deals_with_components:all_of(
							function (deal)
								local components_with_alliance_parameters = deal:components():filter(
									function (component) return not component:parameters():is_empty(); end)

								return components_with_alliance_parameters:all_of(
									function (component)
										local alliance_parameters = component:parameters():filter(
											function (parameter) return not parameter:get_alliances():is_empty(); end)

										return alliance_parameters:all_of(
											function(parameter)
												return parameter:get_alliances():all_of(
													function(alliance)
														return alliance_is_active(alliance, world);
													end
												);
											end);
									end)
							end);
					end)
			end),            
		Assumption:new("Each group war component should have one alliance parameter", 
			function (world)
				return world:faction_list():all_of(
					function (faction)
						local deals_with_group_war_components = faction:diplomatic_deal_list():filter(
							function (deal)
								return deal:components():any_of(
									function (component)
										return component:treaty_component_key() == "treaty_components_group_war";
									end)
							end)

						return deals_with_group_war_components:all_of(
							function (deal)
								return deal:components():filter(
									function (component)
										return component:treaty_component_key() == "treaty_components_group_war";
									end):all_of(
										function (component)
											return component:parameters():all_of(
												function (parameter)
													return parameter:get_alliances():num_items() == 1;
												end)
										end)
							end)
					end)
		 	end)
	};

	local validated_object = Validated_object:new("Diplomacy", world, assumptions);
	return validated_object;
end;

-- TODO
-- number of group war components divided by number of alliance members should be a whole number

print("*** Diplomacy validation loaded... ***");