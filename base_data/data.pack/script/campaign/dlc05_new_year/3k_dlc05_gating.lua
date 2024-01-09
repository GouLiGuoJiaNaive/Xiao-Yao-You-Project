-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	GATING SCRIPTS
--	Declare scripts for campaign gating (when a game feature is enabled for the player) here
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

output("3k_dlc05_gating.lua: Loading");

---------------------------------------------------------------
--
--	Gating Trigger Condition variables
--
---------------------------------------------------------------

tax_advice_condition = 1;       -- Trigger tax advice when progression level
spy_progression_level = 1;          -- Trigger advice based on the progression level 2

---------------------------------------------------------------
--
--	Gating Conditions and UI Locking
--
---------------------------------------------------------------

function setup_gating()

    -- guard against being called in autoruns
	if not cm:get_local_faction(true) then
        output("*-* gating.lua: not starting gating as this is an autorun");
        return
    end;
    
    local faction = cm:query_local_faction():name();
    local subculture = cm:query_local_faction():subculture();

    output("*-* gating.lua: Initialise");
	output("*-* gating.lua: local faction is " .. faction);
    
    if core:is_tweaker_set("FORCE_DISABLE_GATING") then
        return
    end;
    
    local function has_unlocked_spies(query_faction)
		return query_faction:is_human() and query_faction:max_undercover_characters() > 0;
	end;
	
  --Add gating effects here if required
    -- script to disable spy UI for first turn --
    if has_unlocked_spies( cm:query_local_faction() ) then 
        output("*-* gating.lua: undercover_network unlocked");
        uim:override("undercover_network"):set_allowed(true);
    else
        output("*-* gating.lua: undercover_network locked");
        uim:override("undercover_network"):set_allowed(false);
    end;
  
    ---------------------------------------------------------------
    --
    --	Spy condition
    --
    ---------------------------------------------------------------

    if not uim:override("undercover_network"):get_allowed() then
        output("*-* gating.lua: ### establishing spy listener")
        core:add_listener(
            "spy restriction",
            "FactionFameLevelUp", 
			function(context)
				return has_unlocked_spies( context:faction() );
            end,
            function(context)
                core:trigger_event("ScriptEventSpyAdvice");
                cm:set_saved_value("gating_spy_unlocked", true);
                -- Re-enabling spy display --
                uim:override("undercover_network"):set_allowed(true);
                output("*-* gating.lua: ### re-enabling spies");
            end,
            false
        )

        output("*-* gating.lua: ### establishing spy listener 2")
        core:add_listener(
            "spy restriction 2",
            "ResearchStarted", 
            function(context)
                local technology = context:technology_record_key()
                output("######## Current technology completed is " .. technology)
                if technology == "3k_main_tech_water_tier1_masterful_disguise_techniques" then
                    return context:faction():is_human()
                end
            end,
            function(context)
                core:trigger_event("ScriptEventSpyAdvice");
                cm:set_saved_value("gating_spy_unlocked", true);
                -- Re-enabling spy display --
                uim:override("undercover_network"):set_allowed(true);
                output("*-* gating.lua: ### re-enabling spies");
            end,
            false
        )
    end;
  
end;


