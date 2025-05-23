function apply_DLC04_diplomatic_availability()
	------------------------------------------------------
	----------------------- 3K DCL04----------------------
	------ Enable 3k_Main Faction Specific Treaties ------
	-------------------- For Factions --------------------
	------------------------------------------------------	
	out("* applying 3K DLC04 faction specific treaty availability");
	cm:modify_model():enable_diplomacy("faction:3k_main_faction_liu_biao", "all", "treaty_components_vassalise_recipient_liu_biao", "hidden")
	cm:modify_model():enable_diplomacy("all", "faction:3k_main_faction_liu_biao", "treaty_components_vassalise_proposer_liu_biao", "hidden")

    
    cm:modify_model():enable_diplomacy("all", "all","treaty_components_demand_autonomy,treaty_components_offer_autonomy,treaty_components_liberate_proposer,treaty_components_liberate_recipient,treaty_components_declare_independence,treaty_components_draw_vassal_into_war,treaty_components_call_vassals_to_arms,treaty_components_vassal_joins_war,treaty_components_vassal_requests_war,treaty_components_support_independence_offer", "hidden")
    
end;
