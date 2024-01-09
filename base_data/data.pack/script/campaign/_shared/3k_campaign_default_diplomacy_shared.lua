--[[ HEADER

	NB. This is a template script. Please go through and change the 'my_' bits to suit your needs. Please delete anything you won't use, and then delete this comment :).

	Name: default_diplomacy
	Description: 
		Merges all the diasporate diplomacy default setups together as they ovelap a lot.
]]--

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("my_class_name: Not loaded in this campaign." );
	return;
else
	output("my_class_name: Loading");
end;



--[[ VARIABLES
	Setup variables here.
	Most variables should be 'local' (only in this script). 
	Only add global variables if they need to be accessed outside this script.
]]--
-- Define the table which holds all our data and functions.
default_diplomacy = {};



--[[ LOCAL FUNCTIONS
	Accesible only by this script. Should be defined before they are used in the file.
	Should define as 'local function function_name(params)'
]]--
-----------------------------------------------------
--------------------- 3K DCL05 ----------------------
--------- Enable Mercenary Treaties Between ---------
------------ Human Players And AI Factions ----------
-----------------------------------------------------
-- Function that limits the mercenary treaty to only be done between AI to player and Player to Player
-- Only Humans can be mercenaries.
local function limit_mercenary_treaties_to_players_only()
	
	local human_factions = cm:get_human_factions();

	local propose_mercenary_treaties_keys = "treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target";
	local recieve_mercenary_treaties_keys = "treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target";
	
	local lu_bu_is_human = false;
	for i, faction_key in ipairs(human_factions) do
		if faction_key == "3k_main_faction_lu_bu" then
			lu_bu_is_human = true;
			break;
		end;
	end;

	for i, faction_key in ipairs(human_factions) do
		local subculture = cm:query_faction(faction_key):subculture()

		if subculture ~= "3k_main_subculture_yellow_turban" then -- YTR cannot sign mercenary treaties.

			out("\tenabling mercenary treaties between " .. faction_key.. " and bandit and nanman subculute factions");

			-- Human Bandits, Lu Bu and Nanman can be asked to become a mercenary.
			if subculture == "3k_dlc05_subculture_bandits" or subculture == "3k_dlc06_subculture_nanman" or faction_key == "3k_main_faction_lu_bu" then
				cm:modify_model():enable_diplomacy("faction:" .. faction_key, "all", propose_mercenary_treaties_keys,"hidden");
				cm:modify_model():enable_diplomacy("all", "faction:" .. faction_key, recieve_mercenary_treaties_keys,"hidden");

				--NANMAN NEEDS TO UNLOCK TECHNOLOGY BECOME MERCENARY MASTER
				cm:modify_model():disable_diplomacy("faction:" .. faction_key, "subculture:3k_dlc06_subculture_nanman", propose_mercenary_treaties_keys,"technology_required_recipient")

				out("\t" .. faction_key.. " is of Bandit/Nananman subculture Or is Lu Bu, enabling mercenary treaties between them and all Han Chinese, Bandit and Nanman factions");
			end;

			-- Lu Bu can also be a mercenary if he's human
			if lu_bu_is_human and faction_key ~= "3k_main_faction_lu_bu" then
				cm:modify_model():enable_diplomacy("faction:3k_main_faction_lu_bu", "faction:" .. human_factions[i], propose_mercenary_treaties_keys,"hidden")
				cm:modify_model():enable_diplomacy("faction:" .. human_factions[i], "faction:3k_main_faction_lu_bu", recieve_mercenary_treaties_keys,"hidden")
				out("\t Player is not Lu Bu, enabling mercenary treaties between " .. human_factions[i].. " and Lu Bu");
			end;
		end
	end;

	-- Disable for YTR.
	cm:modify_model():disable_diplomacy("all", "subculture:3k_main_subculture_yellow_turban", propose_mercenary_treaties_keys, "hidden")
	cm:modify_model():disable_diplomacy("subculture:3k_main_subculture_yellow_turban", "all", recieve_mercenary_treaties_keys, "hidden")
end;



--[[ GLOBAL FUNCTIONS
	Accessible both inside and outside of this script.
	Should define as 'function my_class_name:function_name(params)'
]]--
function default_diplomacy:apply_default_diplomacy_new_game()

end;

function default_diplomacy:apply_default_diplomacy_any_game()
	limit_mercenary_treaties_to_players_only();

	if cm:saved_value_exists("specialisation_option_saved_value_key", "DLC06_shamoke_faction_events_values")
	 and cm:get_saved_value("specialisation_option_saved_value_key","DLC06_shamoke_faction_events_values") == "han_chosen" then
		default_diplomacy:shamoke_han_diplomacy_specialisation()
	end
end;

function default_diplomacy:shamoke_han_diplomacy_specialisation()
	-----------------------------------------------------
	------ Enable Diplomacy For Shamoke With Han --------
	----- Chinese Factions Based On Dilemma Choice ------
	-----------------------------------------------------
	--------- Lives in Shared Diplomacy because ---------
	---- it's used at various start dates by Shamoke ----
	-----------------------------------------------------
	
	local shamoke_faction_key = "3k_dlc06_faction_nanman_king_shamoke"
	if cm:saved_value_exists("specialisation_option_saved_value_key", "DLC06_shamoke_faction_events_values")
	 and cm:get_saved_value("specialisation_option_saved_value_key","DLC06_shamoke_faction_events_values") == "han_chosen" then
		
		-- Enable marriage with all Han Chinese factions
		cm:modify_model():enable_diplomacy("faction:"..shamoke_faction_key, "subculture:3k_main_chinese", "treaty_components_marriage_give_female,treaty_components_marriage_give_female_male,treaty_components_marriage_give_male,treaty_components_marriage_give_male_female,treaty_components_marriage_recieve_female,treaty_components_marriage_recieve_female_male,treaty_components_marriage_recieve_male,treaty_components_marriage_recieve_male_female", "hidden")
		cm:modify_model():enable_diplomacy("subculture:3k_main_chinese", "faction:"..shamoke_faction_key, "treaty_components_marriage_give_female,treaty_components_marriage_give_female_male,treaty_components_marriage_give_male,treaty_components_marriage_give_male_female,treaty_components_marriage_recieve_female,treaty_components_marriage_recieve_female_male,treaty_components_marriage_recieve_male,treaty_components_marriage_recieve_male_female", "hidden")
		
		--allows shamoke to create empire-type alliances.
		cm:modify_model():enable_diplomacy("faction:"..shamoke_faction_key, "all", "treaty_components_create_empire,treaty_components_coalition_to_empire,treaty_components_alliance_to_empire", "hidden")
		
		out.design("3k_campaign_default_diplomacy.lua: "..shamoke_faction_key.." has enabled "..cm:get_saved_value("specialisation_option_saved_value_key", "DLC06_shamoke_faction_events_values").." diplomatic options with subculture:3k_main_chinese.");
	end
end