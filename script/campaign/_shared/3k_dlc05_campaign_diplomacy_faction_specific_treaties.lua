---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_dlc05_campaign_diplomacy_faction_specific_treaties.lua, 
----- Description: 	This script ensures in the rare case that Yuan Shao and White Tiger Yan are in a
-----				alliance or coalition together, that the White Tiger gets his faction pooled resource
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Early exit if we're in eight princes.
if cm.name == "ep_eight_princes"
or cm.name == "dlc04_mandate" then
		
	output("faction_specific_treaties: Not loaded in this campaign." );
	return;
end;

cm:add_first_tick_callback(function() faction_specific_treaties:initialise() end); --Self register function

--------------------------------------------------------------------------
----------------------VARIABLES AND SETUP---------------------------------
--------------------------------------------------------------------------

faction_specific_treaties = {}

function faction_specific_treaties:initialise()
	self:add_listeners()
end
--------------------------------------------------------------------------
----------------------LISTENERS-------------------------------------------
--------------------------------------------------------------------------

function faction_specific_treaties:add_listeners()  
  output("faction_specific_treaties:add_listeners()");
  --At the start of the White Tiger's turn ensure that his pooled resource matches the number of allies that he has.
  --Only used when he is in a coalition/alliance with Yuan Shao
  core:add_listener(
        "FactionTurnStartWhiteTigerYanPooledResource",
        "FactionTurnStart",
		function(context)
			if not context:faction():is_null_interface() then
				return context:faction():name() == "3k_dlc05_faction_white_tiger_yan"
			end
			return false
		end,
	function(context)
		local number_of_allies_yuan_shao_dummies = 0
		local allied_factions = context:faction():factions_we_have_specified_diplomatic_deal_with("treaty_components_coalition")
		if not allied_factions:is_empty() then 
			if not context:faction():factions_we_have_specified_diplomatic_deal_with("treaty_components_yuan_shao_alliance_dummy"):is_empty() then
				number_of_allies_yuan_shao_dummies = allied_factions:num_items()
			end
		end
		if number_of_allies_yuan_shao_dummies==0 then
			if not allied_factions:is_empty() then 
				if not context:faction():factions_we_have_specified_diplomatic_deal_with("treaty_components_yuan_shao_alliance_dummy"):is_empty() then
					number_of_allies_yuan_shao_dummies = allied_factions:num_items()
				end
			end
			if number_of_allies_yuan_shao_dummies==0 then
				allied_factions = context:faction():factions_we_have_specified_diplomatic_deal_with("treaty_components_empire")
				if not allied_factions:is_empty() then 
					if not context:faction():factions_we_have_specified_diplomatic_deal_with("treaty_components_yuan_shao_alliance_dummy"):is_empty() then
						number_of_allies_yuan_shao_dummies = allied_factions:num_items()
					end
				end
			end			
		end
		local number_of_allies_white_tiger_dummies = 0
		if not context:faction():factions_we_have_specified_diplomatic_deal_with("treaty_components_white_tiger_confederation_dummy"):is_empty() then 
			number_of_allies_white_tiger_dummies = context:faction():factions_we_have_specified_diplomatic_deal_with("treaty_components_white_tiger_confederation_dummy"):num_items()
		end
		--Remove any "white_tiger_confederation" effect-bundle
		if cm:saved_value_exists("white_tiger_effect_bundle","white_tiger_confederation_effect_bundles") then
			local white_tiger_effect_bundle = cm:get_saved_value("white_tiger_effect_bundle", "white_tiger_confederation_effect_bundles")
			context:modify_model():get_modify_faction(context:faction()):remove_effect_bundle(white_tiger_effect_bundle)
		end

		--Add the appropriate effect bundle
		if 0<number_of_allies_yuan_shao_dummies then
			if number_of_allies_yuan_shao_dummies==1 then
				context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_white_tiger_confederation_1",2)
				cm:set_saved_value("white_tiger_effect_bundle", "3k_dlc05_effect_bundle_white_tiger_confederation_1","white_tiger_confederation_effect_bundles")
			elseif number_of_allies_yuan_shao_dummies==2 then
				context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_white_tiger_confederation_2",2)
				cm:set_saved_value("white_tiger_effect_bundle", "3k_dlc05_effect_bundle_white_tiger_confederation_2","white_tiger_confederation_effect_bundles")
			elseif number_of_allies_yuan_shao_dummies==3 then
				context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_white_tiger_confederation_3",2)
				cm:set_saved_value("white_tiger_effect_bundle", "3k_dlc05_effect_bundle_white_tiger_confederation_3","white_tiger_confederation_effect_bundles")
			elseif number_of_allies_yuan_shao_dummies==4 then
				context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_white_tiger_confederation_4",2)
				cm:set_saved_value("white_tiger_effect_bundle", "3k_dlc05_effect_bundle_white_tiger_confederation_4","white_tiger_confederation_effect_bundles")
			elseif number_of_allies_yuan_shao_dummies==5 then
				context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_white_tiger_confederation_5",2)
				cm:set_saved_value("white_tiger_effect_bundle", "3k_dlc05_effect_bundle_white_tiger_confederation_5","white_tiger_confederation_effect_bundles")
			elseif number_of_allies_yuan_shao_dummies==6 then
				context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_white_tiger_confederation_6",2)
				cm:set_saved_value("white_tiger_effect_bundle", "3k_dlc05_effect_bundle_white_tiger_confederation_6","white_tiger_confederation_effect_bundles")
			elseif number_of_allies_yuan_shao_dummies==7 then
				context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_white_tiger_confederation_7",2)
				cm:set_saved_value("white_tiger_effect_bundle", "3k_dlc05_effect_bundle_white_tiger_confederation_7","white_tiger_confederation_effect_bundles")
			elseif number_of_allies_yuan_shao_dummies>=8 then
				context:modify_model():get_modify_faction(context:faction()):apply_effect_bundle("3k_dlc05_effect_bundle_white_tiger_confederation_8",2)
				cm:set_saved_value("white_tiger_effect_bundle", "3k_dlc05_effect_bundle_white_tiger_confederation_8","white_tiger_confederation_effect_bundles")
			end
		end
	end,
    true
	);
end