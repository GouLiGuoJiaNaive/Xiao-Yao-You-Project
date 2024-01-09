---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_ytr_yellow_turban_assignments.lua, 
----- Description: 	Three Kingdoms system to spawn an ancillary on a character when they spawn.
-----				This script controls the character generation for the yellow turban character creation assignments
-----				There is one assignment for Huang Shao, and another for the other 2 factions (Guan Du/He Yi), also assignments for the DLC04 yellow turban factions.
-----				By default both assignments have a chance to generate recruitable characters of random elements each turn
-----				These go directly into the faction if human (or it's a legendary character), or spawned into the pool if an AI.
-----				The maximum amount of characters in the recruitment pool from this script is defined in yta_max_recruitable_characters
-----				The chance of this is defined in yta_normal_character_chance
-----				Huang Shao has a unique additional bonus of creating legendary characters with unique traits/ceos
-----				This requires the assignment to be active for at least yta_huang_shao_turns_min, and a max of yta_huang_shao_turns_max
-----				The script rolls a weighted percentage chance based on how close to the max yta_huang_shao_turns_current is
-----				When this check passes it fires a dilemma if the player is Huang Shao for the player which allows them to pick a Heaven, Earth, or Land general.
-----				The AI doesn't have dilemmas so they just get a random one from the 3 elements
---------------------------------------------------------------------------------------------------------
	
-- Early exit if we're in eight princes.
if cm.name == "ep_eight_princes" then
	output("yellow_turban_assignments: Not loaded in this campaign." );
	return;
else
	output("3k_ytr_yellow_turban_assignments.lua: Loaded");
end;

cm:add_first_tick_callback(function() yellow_turban_assignments:initialise() end); --Self register function

---------------------------------------------------------------------------------------------------------
----- SCRIPT INFORMATION
---------------------------------------------------------------------------------------------------------

yellow_turban_assignments = {}
yellow_turban_assignments.huang_shao_turns_max = 25 -- The maximum turn interval between generating legendary characters when Huang Shao's faction leader is on the assignment
yellow_turban_assignments.huang_shao_turns_min = 15 -- The minimum turn interval between generating legendary characters when Huang Shao's faction leader is on the assignment
yellow_turban_assignments.huang_shao_turns_current = 0 -- The current tracked turns for Huang Shao's legendary character generation
yellow_turban_assignments.yta_normal_character_chance = 33; -- % chance of a normal character being generated

function yellow_turban_assignments:initialise()
	output("yellow_turban_assignments:initialise()")

    core:add_listener(
        "FactionTurnStartYellowTurbanAssignmentsListener",
        "CharacterTurnStart",
		function(context) return context:query_character():faction():subculture() == "3k_main_subculture_yellow_turban" and context:current_assignment_key() == "3k_ytr_assignment_attract_talent" end,
		function(context) 
			local query_faction = context:query_character():faction();
			self:checks(query_faction, false) 
		end,
        true
	);
	
    core:add_listener(
        "FactionTurnStartYellowTurbanAssignmentsHuangShaoListener",
        "CharacterTurnStart",
		function(context) return context:query_character():faction():subculture() == "3k_main_subculture_yellow_turban" and context:current_assignment_key() == "3k_ytr_assignment_instill_heroism" end,
		function(context) 
			local query_faction = context:query_character():faction();
			self:checks(query_faction, true) 
		end,
        true
    );
end;

function yellow_turban_assignments:checks(query_faction, yta_huang_shao)
	output("Yellow turban assignments - RECRUIT CHARACTER assignment active, doing character checks");
	

	-- LEGENDARY CHARACTERS
	if yta_huang_shao == true then
		self.huang_shao_turns_current = self.huang_shao_turns_current + 1
		if self.huang_shao_turns_current >= self.huang_shao_turns_min then
			if cm:modify_model():random_percentage() <= math.min(((self.huang_shao_turns_current - self.huang_shao_turns_min + 1) / (self.huang_shao_turns_max - self.huang_shao_turns_min + 1) * 100), 100) then
				self.huang_shao_turns_current = 0
				if query_faction:is_human() == true then
					cm:modify_model():get_modify_faction(query_faction):trigger_dilemma("3k_ytr_huang_shao_assignment_dilemma_scripted", true);
				else
					local yta_random_element = cm:modify_model():random_number(0,2)
					if yta_random_element == 0 then
						self:recruit_character_ai(query_faction, "metal", true)
					elseif yta_random_element == 1 then
						self:recruit_character_ai(query_faction, "wood", true)
					else
						self:recruit_character_ai(query_faction, "water", true)
					end					
				end

				return; -- Exit here so we don't risk making two characters!
			end
		end
	end

	-- NORMAL CHARACTERS
	local yta_max_recruitable_characters = 10
	if query_faction:number_of_characters_in_recruitment_pool() < yta_max_recruitable_characters then
		
		if cm:modify_model():random_number(1,100) <= self.yta_normal_character_chance then
			if query_faction:is_human() == true then
				cm:modify_model():get_modify_faction(query_faction):trigger_dilemma("3k_ytr_attract_talent_assignment_dilemma_scripted", true);
			else
				local yta_random_element = cm:modify_model():random_number(0,2)
				if yta_random_element == 0 then
					self:recruit_character_ai(query_faction, "metal", false)
				elseif yta_random_element == 1 then
					self:recruit_character_ai(query_faction, "wood", false)
				else
					self:recruit_character_ai(query_faction, "water", false)
				end
			end;
		end
	end	

end


function yellow_turban_assignments:recruit_character_ai(query_faction, element, legendary)
--Recruit character based off of the element
	local yta_male_chance = 75 -- % chance of a generated character being male
	local yta_gender = ""
	if cm:modify_model():random_number(1,100) > yta_male_chance and element ~= "wood" then
		yta_gender = "female"
	else
		yta_gender = "male"
	end
	if legendary == true then
		output("Yellow turban assignments - creating a legendary character based on "..element.."!")
		local modify_character = cm:modify_model():get_modify_faction(query_faction):create_character_from_template("general", "3k_general_"..element, yellow_turban_assignments_character_lists[element]["legendary"][yta_gender][math.floor(cm:modify_model():random_number(1,#yellow_turban_assignments_character_lists[element]["legendary"][yta_gender]))], false);
		
		if modify_character and not modify_character:is_null_interface() then
			modify_character:ceo_management():add_ceo(yellow_turban_assignments_character_lists[element]["legendary"]["ceo"]);
		end;
	else
		output("Yellow turban assignments - creating a normal character based on "..element.."!")
		cm:modify_model():get_modify_faction(query_faction):create_recruitable_character_from_template("general", "3k_general_"..element, yellow_turban_assignments_character_lists[element]["normal"][yta_gender][math.floor(cm:modify_model():random_number(1,#yellow_turban_assignments_character_lists[element]["legendary"][yta_gender]))]);
	end
end

---------------------------------------------------------------------------------------------------------
----- SAVE/LOAD
---------------------------------------------------------------------------------------------------------
function yellow_turban_assignments:register_save_load_callbacks()
    cm:add_saving_game_callback(
        function(saving_game_event)
            cm:save_named_value("yellow_turban_assignments_huang_shao_turns_current", self.huang_shao_turns_current);
        end
    );

    cm:add_loading_game_callback(
        function(loading_game_event)
            local l_huang_shao_turns_current =  cm:load_named_value("yellow_turban_assignments_huang_shao_turns_current", self.huang_shao_turns_current);

            self.huang_shao_turns_current = l_huang_shao_turns_current;
        end
    );
end;

yellow_turban_assignments:register_save_load_callbacks();

yellow_turban_assignments_character_lists = {
	["metal"] = {
		["legendary"] = {
			["male"] = {
				"3k_ytr_template_generic_metal_agent_legendary_m_hero",
				"3k_ytr_template_generic_metal_general_legendary_m_hero",
				"3k_ytr_template_generic_metal_governor_legendary_m_hero",
				"3k_ytr_template_generic_metal_minister_legendary_m_hero",
				"3k_ytr_template_generic_metal_villager_legendary_m_hero"
			},
			["female"] = {
				"3k_ytr_template_generic_metal_agent_legendary_f_hero",
				"3k_ytr_template_generic_metal_general_legendary_f_hero",
				"3k_ytr_template_generic_metal_governor_legendary_f_hero",
				"3k_ytr_template_generic_metal_minister_legendary_f_hero",
				"3k_ytr_template_generic_metal_villager_legendary_f_hero"
			},
			["ceo"] = "3k_ytr_ceo_trait_physical_healer_of_people"
		},
		["normal"] = {
			["male"] = {
				"3k_ytr_template_generic_metal_agent_normal_m_hero",
				"3k_ytr_template_generic_metal_general_normal_m_hero",
				"3k_ytr_template_generic_metal_governor_normal_m_hero",
				"3k_ytr_template_generic_metal_minister_normal_m_hero",
				"3k_ytr_template_generic_metal_villager_normal_m_hero"
			},
			["female"] = {
				"3k_ytr_template_generic_metal_agent_normal_f_hero",
				"3k_ytr_template_generic_metal_general_normal_f_hero",
				"3k_ytr_template_generic_metal_governor_normal_f_hero",
				"3k_ytr_template_generic_metal_minister_normal_f_hero",
				"3k_ytr_template_generic_metal_villager_normal_f_hero"
			}
		}
	},
	["water"] = {
		["legendary"] = {
			["male"] = {
				"3k_ytr_template_generic_water_agent_legendary_m_hero",
				"3k_ytr_template_generic_water_general_legendary_m_hero",
				"3k_ytr_template_generic_water_governor_legendary_m_hero",
				"3k_ytr_template_generic_water_minister_legendary_m_hero",
				"3k_ytr_template_generic_water_villager_legendary_m_hero"
			},
			["female"] = {
				"3k_ytr_template_generic_water_agent_legendary_f_hero",
				"3k_ytr_template_generic_water_general_legendary_f_hero",
				"3k_ytr_template_generic_water_governor_legendary_f_hero",
				"3k_ytr_template_generic_water_minister_legendary_f_hero",
				"3k_ytr_template_generic_water_villager_legendary_f_hero"
			},
			["ceo"] = "3k_ytr_ceo_trait_physical_leader_of_people"
		},
		["normal"] = {
			["male"] = {
				"3k_ytr_template_generic_water_agent_normal_m_hero",
				"3k_ytr_template_generic_water_general_normal_m_hero",
				"3k_ytr_template_generic_water_governor_normal_m_hero",
				"3k_ytr_template_generic_water_minister_normal_m_hero",
				"3k_ytr_template_generic_water_villager_normal_m_hero"
			},
			["female"] = {
				"3k_ytr_template_generic_water_agent_normal_f_hero",
				"3k_ytr_template_generic_water_general_normal_f_hero",
				"3k_ytr_template_generic_water_governor_normal_f_hero",
				"3k_ytr_template_generic_water_minister_normal_f_hero",
				"3k_ytr_template_generic_water_villager_normal_f_hero"
			}
		}
	},
	["wood"] = {
		["legendary"] = {
			["male"] = {
			"3k_ytr_template_generic_wood_agent_legendary_m_hero",
			"3k_ytr_template_generic_wood_general_legendary_m_hero",
			"3k_ytr_template_generic_wood_governor_legendary_m_hero",
			"3k_ytr_template_generic_wood_minister_legendary_m_hero",
			"3k_ytr_template_generic_wood_villager_legendary_m_hero"
			},
			["ceo"] = "3k_ytr_ceo_trait_physical_protector_of_people"
		},
		["normal"] = {
			["male"] = {
				"3k_ytr_template_generic_wood_agent_normal_m_hero",
				"3k_ytr_template_generic_wood_general_normal_m_hero",
				"3k_ytr_template_generic_wood_governor_normal_m_hero",
				"3k_ytr_template_generic_wood_minister_normal_m_hero",
				"3k_ytr_template_generic_wood_villager_normal_m_hero"
			}
		}
	}
}