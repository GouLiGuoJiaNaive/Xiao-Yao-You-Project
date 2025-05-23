local gst = xyy_gst:get_mod()

cm:add_first_tick_callback_new(function() xyy_kafka_story_mode(); end);

local player_faction_key;

function xyy_kafka_story_mode()
    set_xyyhlyjf_diplomacy();
    if cm:get_saved_value("kafka_mission_faction") then
        player_faction_key = cm:get_saved_value("kafka_mission_faction")
    end
end;

function set_xyyhlyjf_diplomacy()
    cm:modify_model():enable_diplomacy("all", "faction:xyyhlyjf", "treaty_components_proposer_declares_war_against_target,treaty_components_recipient_declares_war_against_target,treaty_components_abdicate_demand,treaty_components_abdicate_offer,treaty_components_acknowledge_legitimacy_demand,treaty_components_acknowledge_legitimacy_offer,treaty_components_alliance,treaty_components_alliance_democratic,treaty_components_alliance_to_alliance_group_peace,treaty_components_alliance_to_alliance_group_peace_no_vote,treaty_components_alliance_to_alliance_group_peace_no_vote_proposer,treaty_components_alliance_to_alliance_group_peace_no_vote_recipient,treaty_components_alliance_to_alliance_war,treaty_components_alliance_to_alliance_war_no_vote,treaty_components_alliance_to_empire,treaty_components_alliance_to_empire_white_tiger,treaty_components_alliance_to_empire_yuan_shao,treaty_components_alliance_to_faction_group_peace,treaty_components_alliance_to_faction_group_peace_no_vote,treaty_components_alliance_to_faction_war,treaty_components_alliance_to_faction_war_no_vote,treaty_components_ancillary_demand,treaty_components_ancillary_offer,treaty_components_annex_subject,treaty_components_annex_vassal,treaty_components_attitude_manipulation_negative,treaty_components_attitude_manipulation_negative_sima_yue,treaty_components_attitude_manipulation_positive,treaty_components_attitude_manipulation_positive_sima_yue,treaty_components_break_deal_negotiated,treaty_components_break_deal_unilateral,treaty_components_break_food_supply_demand,treaty_components_break_food_supply_offer,treaty_components_break_military_access,treaty_components_break_non_aggression,treaty_components_break_payment_regular_demand,treaty_components_break_payment_regular_demand_twenty_turns,treaty_components_break_payment_regular_offer,treaty_components_break_payment_regular_offer_twenty_turns,treaty_components_break_support_independence,treaty_components_break_support_legitimacy,treaty_components_break_trade,treaty_components_break_trade_monopoly,treaty_components_cai_balance_value,treaty_components_coalition,treaty_components_coalition_split_vote,treaty_components_coalition_to_alliance,treaty_components_coalition_to_alliance_white_tiger,treaty_components_coalition_to_alliance_yuan_shao,treaty_components_coalition_to_alliance_yuan_shu,treaty_components_coalition_to_empire,treaty_components_coalition_to_empire_white_tiger,treaty_components_coalition_to_empire_yuan_shao,treaty_components_coercion,treaty_components_confederate_proposer,treaty_components_confederate_recipient,treaty_components_confederate_recipient_no_conditions,treaty_components_create_alliance,treaty_components_create_alliance_yuan_shao,treaty_components_create_alliance_yuan_shu,treaty_components_create_coalition,treaty_components_create_coalition_white_tiger,treaty_components_create_coalition_yuan_shao,treaty_components_create_coalition_yuan_shu,treaty_components_create_empire,treaty_components_create_empire_counter_offer,treaty_components_create_empire_white_tiger,treaty_components_create_empire_yuan_shao,treaty_components_declare_independence,treaty_components_demand_autonomy,treaty_components_dissolve_empire,treaty_components_draw_vassal_into_war,treaty_components_empire,treaty_components_empire_mobilisation,treaty_components_empire_split_vote,treaty_components_enemy_of_the_han_negative,treaty_components_enemy_of_the_han_positive,treaty_components_faction_to_alliance_group_peace,treaty_components_faction_to_alliance_group_peace_no_vote,treaty_components_faction_to_alliance_war,treaty_components_food_supply_demand,treaty_components_food_supply_offer,treaty_components_forced_end_personal_feud_empress_he,treaty_components_forced_end_personal_feud_generic,treaty_components_governor_independence,treaty_components_group_war,treaty_components_guarentee_autonomy,treaty_components_instigate_proxy_war_proposer,treaty_components_instigate_proxy_war_recipient,treaty_components_instigate_trade_monopoly,treaty_components_issue_Imperial_decree,treaty_components_join_alliance_proposers,treaty_components_join_alliance_recipients,treaty_components_join_coalition_proposer,treaty_components_join_coalition_recipient,treaty_components_join_empire_proposer,treaty_components_join_empire_recipient,treaty_components_join_imperial_colaition_proposer,treaty_components_join_imperial_colaition_recipient,treaty_components_kick_alliance_member,treaty_components_kick_coalition_member,treaty_components_kick_empire_member,treaty_components_kick_empire_member_and_declare_war,treaty_components_liberate_proposer,treaty_components_liberate_recipient,treaty_components_liu_bei_confederate_proposer,treaty_components_liu_bei_confederate_recipient,treaty_components_lu_bu_coercion,treaty_components_lu_bu_receive_coercion,treaty_components_mandated_powers,treaty_components_mandated_powers_demand,treaty_components_mandated_powers_offer,treaty_components_marriage_confederate_proposer,treaty_components_marriage_confederate_recipient,treaty_components_marriage_give_female,treaty_components_marriage_give_female_male,treaty_components_marriage_give_male,treaty_components_marriage_give_male_female,treaty_components_marriage_recieve_female,treaty_components_marriage_recieve_female_male,treaty_components_marriage_recieve_male,treaty_components_marriage_recieve_male_female,treaty_components_master_accepts_war,treaty_components_mercenary_contract,treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target,treaty_components_mercenary_employer_signed_peace,treaty_components_military_access,treaty_components_military_alliance_split_vote,treaty_components_multiplayer_victory,treaty_components_non_aggression,treaty_components_offer_autonomy,treaty_components_payment_demand,treaty_components_payment_offer,treaty_components_payment_regular_demand,treaty_components_payment_regular_demand_twenty_turns,treaty_components_payment_regular_offer,treaty_components_payment_regular_offer_twenty_turns,treaty_components_pending_join_alliance_proposers,treaty_components_pending_join_coalition_proposers,treaty_components_pending_join_empire_proposers,treaty_components_personal_feud,treaty_components_quit_alliance,treaty_components_quit_alliance_and_declare_war,treaty_components_quit_alliance_no_treachery,treaty_components_quit_coalition,treaty_components_quit_coalition_and_declare_war,treaty_components_quit_coalition_no_treachery,treaty_components_quit_empire,treaty_components_quit_empire_and_declare_war,treaty_components_quit_empire_no_treachery,treaty_components_recieve_coercion,treaty_components_recieve_imperial_decree,treaty_components_recieve_threat,treaty_components_recieve_trade_monopoly,treaty_components_region_demand,treaty_components_region_offer,treaty_components_resolve_personal_feud,treaty_components_schemes_resource_demand,treaty_components_schemes_resource_offer,treaty_components_sima_lun_coercion,treaty_components_sima_lun_instigate_proxy_war_proposer,treaty_components_sima_lun_instigate_proxy_war_recipient,treaty_components_sima_lun_recieve_coercion,treaty_components_support_independence,treaty_components_support_independence_demand,treaty_components_support_independence_offer,treaty_components_supporting_legitimacy,treaty_components_take_tribute,treaty_components_threaten,treaty_components_threaten_sanctions,treaty_components_trade,treaty_components_trade_monopoly,treaty_components_tribute_demand,treaty_components_tribute_offer,treaty_components_vassal_demands_protection,treaty_components_vassal_demands_protection_group_war,treaty_components_vassal_han_empire_demands_protection,treaty_components_vassal_han_empire_demands_protection_group_war,treaty_components_vassal_joins_war,treaty_components_vassal_requests_war,treaty_components_vassalage,treaty_components_vassalise_proposer,treaty_components_vassalise_proposer_liu_biao,treaty_components_vassalise_proposer_sima_liang,treaty_components_vassalise_proposer_yellow_turban,treaty_components_vassalise_proposer_yuan_shu,treaty_components_vassalise_recipient,treaty_components_vassalise_recipient_liu_biao,treaty_components_vassalise_recipient_no_conditions,treaty_components_vassalise_recipient_sima_liang,treaty_components_vassalise_recipient_yellow_turban,treaty_components_vassalise_recipient_yuan_shu,treaty_components_war", "hidden")
    cm:modify_model():disable_diplomacy("all", "faction:xyyhlyjf", "treaty_components_abdicate_demand,treaty_components_abdicate_offer,treaty_components_acknowledge_legitimacy_demand,treaty_components_acknowledge_legitimacy_offer,treaty_components_alliance,treaty_components_alliance_democratic,treaty_components_alliance_to_alliance_group_peace,treaty_components_alliance_to_alliance_group_peace_no_vote,treaty_components_alliance_to_alliance_group_peace_no_vote_proposer,treaty_components_alliance_to_alliance_group_peace_no_vote_recipient,treaty_components_alliance_to_empire,treaty_components_alliance_to_empire_white_tiger,treaty_components_alliance_to_empire_yuan_shao,treaty_components_alliance_to_faction_group_peace,treaty_components_alliance_to_faction_group_peace_no_vote,treaty_components_ancillary_demand,treaty_components_ancillary_offer,treaty_components_annex_subject,treaty_components_annex_vassal,treaty_components_attitude_manipulation_negative,treaty_components_attitude_manipulation_negative_sima_yue,treaty_components_attitude_manipulation_positive,treaty_components_attitude_manipulation_positive_sima_yue,treaty_components_break_deal_negotiated,treaty_components_break_deal_unilateral,treaty_components_break_food_supply_demand,treaty_components_break_food_supply_offer,treaty_components_break_military_access,treaty_components_break_non_aggression,treaty_components_break_payment_regular_demand,treaty_components_break_payment_regular_demand_twenty_turns,treaty_components_break_payment_regular_offer,treaty_components_break_payment_regular_offer_twenty_turns,treaty_components_break_support_independence,treaty_components_break_support_legitimacy,treaty_components_break_trade,treaty_components_break_trade_monopoly,treaty_components_cai_balance_value,treaty_components_coalition,treaty_components_coalition_split_vote,treaty_components_coalition_to_alliance,treaty_components_coalition_to_alliance_white_tiger,treaty_components_coalition_to_alliance_yuan_shao,treaty_components_coalition_to_alliance_yuan_shu,treaty_components_coalition_to_empire,treaty_components_coalition_to_empire_white_tiger,treaty_components_coalition_to_empire_yuan_shao,treaty_components_coercion,treaty_components_confederate_proposer,treaty_components_confederate_recipient,treaty_components_confederate_recipient_no_conditions,treaty_components_create_alliance,treaty_components_create_alliance_yuan_shao,treaty_components_create_alliance_yuan_shu,treaty_components_create_coalition,treaty_components_create_coalition_white_tiger,treaty_components_create_coalition_yuan_shao,treaty_components_create_coalition_yuan_shu,treaty_components_create_empire,treaty_components_create_empire_counter_offer,treaty_components_create_empire_white_tiger,treaty_components_create_empire_yuan_shao,treaty_components_declare_independence,treaty_components_demand_autonomy,treaty_components_dissolve_empire,treaty_components_empire,treaty_components_empire_mobilisation,treaty_components_empire_split_vote,treaty_components_enemy_of_the_han_negative,treaty_components_enemy_of_the_han_positive,treaty_components_faction_to_alliance_group_peace,treaty_components_faction_to_alliance_group_peace_no_vote,treaty_components_food_supply_demand,treaty_components_food_supply_offer,treaty_components_forced_end_personal_feud_empress_he,treaty_components_forced_end_personal_feud_generic,treaty_components_governor_independence,treaty_components_guarentee_autonomy,treaty_components_instigate_trade_monopoly,treaty_components_issue_Imperial_decree,treaty_components_join_alliance_proposers,treaty_components_join_alliance_recipients,treaty_components_join_coalition_proposer,treaty_components_join_coalition_recipient,treaty_components_join_empire_proposer,treaty_components_join_empire_recipient,treaty_components_join_imperial_colaition_proposer,treaty_components_join_imperial_colaition_recipient,treaty_components_kick_alliance_member,treaty_components_kick_coalition_member,treaty_components_kick_empire_member,treaty_components_liberate_proposer,treaty_components_liberate_recipient,treaty_components_liu_bei_confederate_proposer,treaty_components_liu_bei_confederate_recipient,treaty_components_lu_bu_coercion,treaty_components_lu_bu_receive_coercion,treaty_components_mandated_powers,treaty_components_mandated_powers_demand,treaty_components_mandated_powers_offer,treaty_components_marriage_confederate_proposer,treaty_components_marriage_confederate_recipient,treaty_components_marriage_give_female,treaty_components_marriage_give_female_male,treaty_components_marriage_give_male,treaty_components_marriage_give_male_female,treaty_components_marriage_recieve_female,treaty_components_marriage_recieve_female_male,treaty_components_marriage_recieve_male,treaty_components_marriage_recieve_male_female,treaty_components_mercenary_contract,treaty_components_mercenary_employer_signed_peace,treaty_components_military_access,treaty_components_military_alliance_split_vote,treaty_components_multiplayer_victory,treaty_components_non_aggression,treaty_components_offer_autonomy,treaty_components_payment_demand,treaty_components_payment_offer,treaty_components_payment_regular_demand,treaty_components_payment_regular_demand_twenty_turns,treaty_components_payment_regular_offer,treaty_components_payment_regular_offer_twenty_turns,treaty_components_peace,treaty_components_peace_no_event,treaty_components_pending_join_alliance_proposers,treaty_components_pending_join_coalition_proposers,treaty_components_pending_join_empire_proposers,treaty_components_personal_feud,treaty_components_quit_alliance,treaty_components_quit_alliance_no_treachery,treaty_components_quit_coalition,treaty_components_quit_coalition_no_treachery,treaty_components_quit_empire,treaty_components_quit_empire_no_treachery,treaty_components_recieve_coercion,treaty_components_recieve_imperial_decree,treaty_components_recieve_threat,treaty_components_recieve_trade_monopoly,treaty_components_region_demand,treaty_components_region_offer,treaty_components_resolve_personal_feud,treaty_components_schemes_resource_demand,treaty_components_schemes_resource_offer,treaty_components_sima_lun_coercion,treaty_components_sima_lun_recieve_coercion,treaty_components_support_independence,treaty_components_support_independence_demand,treaty_components_support_independence_offer,treaty_components_supporting_legitimacy,treaty_components_take_tribute,treaty_components_threaten,treaty_components_threaten_sanctions,treaty_components_trade,treaty_components_trade_monopoly,treaty_components_tribute_demand,treaty_components_tribute_offer,treaty_components_vassal_demands_protection,treaty_components_vassal_han_empire_demands_protection,treaty_components_vassalage,treaty_components_vassalise_proposer,treaty_components_vassalise_proposer_liu_biao,treaty_components_vassalise_proposer_sima_liang,treaty_components_vassalise_proposer_yellow_turban,treaty_components_vassalise_proposer_yuan_shu,treaty_components_vassalise_recipient,treaty_components_vassalise_recipient_liu_biao,treaty_components_vassalise_recipient_no_conditions,treaty_components_vassalise_recipient_sima_liang,treaty_components_vassalise_recipient_yellow_turban,treaty_components_vassalise_recipient_yuan_shu", "hidden")
    cm:modify_model():disable_diplomacy("faction:xyyhlyjf", "all", "treaty_components_abdicate_demand,treaty_components_abdicate_offer,treaty_components_acknowledge_legitimacy_demand,treaty_components_acknowledge_legitimacy_offer,treaty_components_alliance,treaty_components_alliance_democratic,treaty_components_alliance_to_alliance_group_peace,treaty_components_alliance_to_alliance_group_peace_no_vote,treaty_components_alliance_to_alliance_group_peace_no_vote_proposer,treaty_components_alliance_to_alliance_group_peace_no_vote_recipient,treaty_components_alliance_to_empire,treaty_components_alliance_to_empire_white_tiger,treaty_components_alliance_to_empire_yuan_shao,treaty_components_alliance_to_faction_group_peace,treaty_components_alliance_to_faction_group_peace_no_vote,treaty_components_ancillary_demand,treaty_components_ancillary_offer,treaty_components_annex_subject,treaty_components_annex_vassal,treaty_components_attitude_manipulation_negative,treaty_components_attitude_manipulation_negative_sima_yue,treaty_components_attitude_manipulation_positive,treaty_components_attitude_manipulation_positive_sima_yue,treaty_components_break_deal_negotiated,treaty_components_break_deal_unilateral,treaty_components_break_food_supply_demand,treaty_components_break_food_supply_offer,treaty_components_break_military_access,treaty_components_break_non_aggression,treaty_components_break_payment_regular_demand,treaty_components_break_payment_regular_demand_twenty_turns,treaty_components_break_payment_regular_offer,treaty_components_break_payment_regular_offer_twenty_turns,treaty_components_break_support_independence,treaty_components_break_support_legitimacy,treaty_components_break_trade,treaty_components_break_trade_monopoly,treaty_components_cai_balance_value,treaty_components_coalition,treaty_components_coalition_split_vote,treaty_components_coalition_to_alliance,treaty_components_coalition_to_alliance_white_tiger,treaty_components_coalition_to_alliance_yuan_shao,treaty_components_coalition_to_alliance_yuan_shu,treaty_components_coalition_to_empire,treaty_components_coalition_to_empire_white_tiger,treaty_components_coalition_to_empire_yuan_shao,treaty_components_coercion,treaty_components_confederate_proposer,treaty_components_confederate_recipient,treaty_components_confederate_recipient_no_conditions,treaty_components_create_alliance,treaty_components_create_alliance_yuan_shao,treaty_components_create_alliance_yuan_shu,treaty_components_create_coalition,treaty_components_create_coalition_white_tiger,treaty_components_create_coalition_yuan_shao,treaty_components_create_coalition_yuan_shu,treaty_components_create_empire,treaty_components_create_empire_counter_offer,treaty_components_create_empire_white_tiger,treaty_components_create_empire_yuan_shao,treaty_components_declare_independence,treaty_components_demand_autonomy,treaty_components_dissolve_empire,treaty_components_empire,treaty_components_empire_mobilisation,treaty_components_empire_split_vote,treaty_components_enemy_of_the_han_negative,treaty_components_enemy_of_the_han_positive,treaty_components_faction_to_alliance_group_peace,treaty_components_faction_to_alliance_group_peace_no_vote,treaty_components_food_supply_demand,treaty_components_food_supply_offer,treaty_components_forced_end_personal_feud_empress_he,treaty_components_forced_end_personal_feud_generic,treaty_components_governor_independence,treaty_components_guarentee_autonomy,treaty_components_instigate_trade_monopoly,treaty_components_issue_Imperial_decree,treaty_components_join_alliance_proposers,treaty_components_join_alliance_recipients,treaty_components_join_coalition_proposer,treaty_components_join_coalition_recipient,treaty_components_join_empire_proposer,treaty_components_join_empire_recipient,treaty_components_join_imperial_colaition_proposer,treaty_components_join_imperial_colaition_recipient,treaty_components_kick_alliance_member,treaty_components_kick_coalition_member,treaty_components_kick_empire_member,treaty_components_liberate_proposer,treaty_components_liberate_recipient,treaty_components_liu_bei_confederate_proposer,treaty_components_liu_bei_confederate_recipient,treaty_components_lu_bu_coercion,treaty_components_lu_bu_receive_coercion,treaty_components_mandated_powers,treaty_components_mandated_powers_demand,treaty_components_mandated_powers_offer,treaty_components_marriage_confederate_proposer,treaty_components_marriage_confederate_recipient,treaty_components_marriage_give_female,treaty_components_marriage_give_female_male,treaty_components_marriage_give_male,treaty_components_marriage_give_male_female,treaty_components_marriage_recieve_female,treaty_components_marriage_recieve_female_male,treaty_components_marriage_recieve_male,treaty_components_marriage_recieve_male_female,treaty_components_mercenary_contract,treaty_components_mercenary_employer_signed_peace,treaty_components_military_access,treaty_components_military_alliance_split_vote,treaty_components_multiplayer_victory,treaty_components_non_aggression,treaty_components_offer_autonomy,treaty_components_payment_demand,treaty_components_payment_offer,treaty_components_payment_regular_demand,treaty_components_payment_regular_demand_twenty_turns,treaty_components_payment_regular_offer,treaty_components_payment_regular_offer_twenty_turns,treaty_components_peace,treaty_components_peace_no_event,treaty_components_pending_join_alliance_proposers,treaty_components_pending_join_coalition_proposers,treaty_components_pending_join_empire_proposers,treaty_components_personal_feud,treaty_components_quit_alliance,treaty_components_quit_alliance_no_treachery,treaty_components_quit_coalition,treaty_components_quit_coalition_no_treachery,treaty_components_quit_empire,treaty_components_quit_empire_no_treachery,treaty_components_recieve_coercion,treaty_components_recieve_imperial_decree,treaty_components_recieve_threat,treaty_components_recieve_trade_monopoly,treaty_components_region_demand,treaty_components_region_offer,treaty_components_resolve_personal_feud,treaty_components_schemes_resource_demand,treaty_components_schemes_resource_offer,treaty_components_sima_lun_coercion,treaty_components_sima_lun_recieve_coercion,treaty_components_support_independence,treaty_components_support_independence_demand,treaty_components_support_independence_offer,treaty_components_supporting_legitimacy,treaty_components_take_tribute,treaty_components_threaten,treaty_components_threaten_sanctions,treaty_components_trade,treaty_components_trade_monopoly,treaty_components_tribute_demand,treaty_components_tribute_offer,treaty_components_vassal_demands_protection,treaty_components_vassal_han_empire_demands_protection,treaty_components_vassalage,treaty_components_vassalise_proposer,treaty_components_vassalise_proposer_liu_biao,treaty_components_vassalise_proposer_sima_liang,treaty_components_vassalise_proposer_yellow_turban,treaty_components_vassalise_proposer_yuan_shu,treaty_components_vassalise_recipient,treaty_components_vassalise_recipient_liu_biao,treaty_components_vassalise_recipient_no_conditions,treaty_components_vassalise_recipient_sima_liang,treaty_components_vassalise_recipient_yellow_turban,treaty_components_vassalise_recipient_yuan_shu", "hidden")
end

local function xyy_summon_huanlong_faction()
--      campaign_invasions:create_invasion("xyyhlyjf", "3k_main_wuling_resource_1", 2, false)

        local world_faction_list = cm:query_model():world():faction_list();
--         for i = 0, world_faction_list:num_items() - 1 do
--             local world_faction = world_faction_list:item_at(i)
--             -- -- ModLog(world_faction:name());
--         end;
        faction_xyyhlyjf = cm:query_faction("xyyhlyjf");
        
        cm:modify_region("3k_main_shoufang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_shoufang"));
        cm:modify_region("3k_main_shoufang_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_faction("xyyhlyjf"):apply_effect_bundle("huanlong_event_buff", -1);
        cm:modify_faction("xyyhlyjf"):increase_treasury(1000000);
        
--         gst.region_random_set_manager("3k_main_shoufang_resource_1","xyyhlyjf");
        local hlyjdingzhia = gst.character_add_to_faction("hlyjdingzhia", "xyyhlyjf", "3k_general_destroy")
        gst.character_CEO_equip("hlyjdingzhia","hlyjdingzhiazuoqi","3k_main_ceo_category_ancillary_mount");
        gst.character_CEO_equip("hlyjdingzhia","hlyjdingzhiawuqi","3k_main_ceo_category_ancillary_weapon");
        gst.character_CEO_equip("hlyjdingzhia","hlyjdingzhiafujian","3k_main_ceo_category_ancillary_accessory");
        gst.faction_set_minister_position("hlyjdingzhia","faction_leader");
        gst.character_remove_all_traits(hlyjdingzhia);
        cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_01");
        cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("3k_main_ceo_trait_personality_vengeful");
        cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("3k_main_ceo_trait_personality_cruel");
        cm:modify_character(hlyjdingzhia):add_experience(295000,0);
        
        for i = 0, world_faction_list:num_items() - 1 do
            local q_faction = world_faction_list:item_at(i)
             if not q_faction:is_dead() and q_faction:name() ~= "xyyhlyjf" then
                diplomacy_manager:apply_automatic_deal_between_factions(faction_xyyhlyjf:name(), q_faction:name(), "data_defined_situation_war_proposer_to_recipient")
             end
        end;
        
        local xyyhlyjf = faction_xyyhlyjf;
        
        local hlyjdingzhia_force = gst.faction_find_character_military_force(hlyjdingzhia);
        if hlyjdingzhia_force then
            local modify_force = cm:modify_military_force(hlyjdingzhia_force);
            
            local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
            local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
            
            modify_character_1:add_experience(295000,0);
            modify_character_2:add_experience(295000,0);
            
            if modify_force:query_military_force():character_list():num_items() < 3 then
                modify_force:add_existing_character_as_retinue(modify_character_1, true);
            end
            if modify_force:query_military_force():character_list():num_items() < 3 then
                modify_force:add_existing_character_as_retinue(modify_character_2, true);
            end

            cm:modify_character(hlyjdingzhia):apply_effect_bundle("huanlong_unbreakable", -1);
            add_freeze(hlyjdingzhia:cqi())
            
            cm:modify_model():disable_diplomacy("faction:xyyhlyjf", "all", "treaty_components_peace,treaty_components_peace_no_event","hidden");
            
            cm:set_saved_value("xyyhlyjf_generated", true)
        end
end;


local is_kafka_with_leader = false;

local mission_keys = {
    "kafka_mission_01",
    "kafka_mission_02",
    "kafka_mission_02_dlc04",
    "kafka_mission_02_dlc05",
    "kafka_mission_02_dlc07",
    "kafka_mission_02_a",
    "kafka_mission_02_a_dlc04",
    "kafka_mission_02_a_dlc05",
    "kafka_mission_02_a_dlc07",
    "kafka_mission_03",
    "kafka_mission_04",
    "kafka_mission_04_dlc04",
    "kafka_mission_04_dlc05",
    "kafka_mission_04_dlc07",
    "kafka_mission_huanlong",
    "kafka_mission_05",
    "kafka_mission_05_dlc04",
    "kafka_mission_05_dlc05",
    "kafka_mission_05_dlc07",
    "kafka_mission_05_a",
    "kafka_mission_07",
    "kafka_mission_07_3",
    "kafka_mission_08",
    "kafka_mission_09",
    "kafka_mission_huanlong_01",
    "kafka_mission_12_a",
    "kafka_mission_14",
    "kafka_mission_14_a",
    "kafka_mission_huanlong_02",
    "kafka_mission_huanlong_03",
    "kafka_mission_15",
    "kafka_mission_15_a"
}

function create_force_with_existing_general(modify_character, faction_key, unit_list, region_key, x, y, id, success_callback, starting_health_percentage, starting_orientation)
	starting_health_percentage = starting_health_percentage or 100;
	starting_orientation = starting_orientation or 0;

	if not modify_character or modify_character:is_null_interface() then
		return;
	end;
	
	if not is_string(faction_key) then
		return;
	end;
	
	if not cm:faction_exists(faction_key) then
		return;
	end;
	
	-- We can support an empty unit list in 3K, so allow this to happen and fix it up.
	if not is_string(unit_list) then
		unit_list = "";
	end;
	
	if not is_string(region_key) then
		return;
	end;
	
	if not is_number(x) or x < 0 then
		return;
	end;
	
	if not is_number(y) or y < 0 then
		return;
	end;
	
	if not is_string(id) then
		return;
	end;
	
	if not is_function(success_callback) and not is_nil(success_callback) then
		return;
	end;
	
	if not cm:can_modify() then
		return;
	end;
	
	if not is_number(starting_health_percentage) or starting_health_percentage < 1 then
		return;
	end;
	
	if not is_number(starting_orientation) then
		return;
	end;
	
	local listener_name = "campaign_manager_create_force_" .. id;
	
	core:add_listener(
		listener_name,
		"ScriptedForceCreated",
		true,
		function() cm:force_created(id, listener_name, faction_key, x, y, success_callback) end,
		true
	);
	
	-- make the call to create the force
	modify_character:create_force(region_key, unit_list, x, y, id, starting_health_percentage, starting_orientation);
	
end;

function add_force_to_xyyhlyjf()
    local c1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
    c1:add_experience(295000,0);
    local c2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
    c2:add_experience(295000,0);
    local c3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
    c3:add_experience(295000,0);
    local c4 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
    c4:add_experience(295000,0);
    local c5 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
    c5:add_experience(295000,0);
    local c6 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
    c6:add_experience(295000,0);
end



--卡芙卡剧情线
core:add_listener(
    "kafka_mission_01",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "summon_hlyjcj";
    end,
    function(context)
        if not cm:get_saved_value("roguelike_mode") then
            cm:trigger_mission(context:faction(), "kafka_mission_01", true);
        else
            gst.character_add_CEO_and_equip("hlyjcj", "hlyjcjwuqi_faction", "3k_main_ceo_category_ancillary_weapon")
            gst.character_add_CEO_and_equip("hlyjcj", "hlyjdingzhibzuoqi", "3k_main_ceo_category_ancillary_mount")
        end
        cm:set_saved_value("kafka_mission", true);
--         local kafka = gst.character_query_for_template("hlyjcj");
--         cm:modify_character(kafka):remove_effect_bundle("essentials_effect_bundle")
    end,
    false
)

core:add_listener(
    "kafka_mission_01_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_01";
    end,
    function(context)
        local leader = context:faction():faction_leader();
        cm:set_saved_value("kafka_mission_leader", leader:generation_template_key());
        local kafka = gst.character_query_for_template("hlyjcj");
        local kafka_force = kafka:military_force();
        if kafka_force and kafka:has_military_force() then
            if context:faction():faction_leader():generation_template_key() == "hlyjcj" then
                cm:set_saved_value("kafka_mission_01_success",true);
                local kafka = context:faction():faction_leader()
                local mission = string_mission:new("kafka_mission_02_kafka_leader")
                if kafka:startpos_key() then
                    mission:add_primary_objective("MOVE_TO_REGION", {"start_pos_character ".. kafka:startpos_key() .. ";region 3k_main_shoufang_resource_1"});
                else
                    mission:add_primary_objective("MOVE_TO_REGION", {"region 3k_main_shoufang_resource_1"})
                end
                mission:add_primary_payload("text_display{lookup kafka_mission_02_kafka_leader;}")
                mission:trigger_mission_for_faction(context:faction():name())
            else
                if kafka_force:character_list():num_items() < 3 then
                    cm:modify_military_force(kafka_force):add_existing_character_as_retinue(cm:modify_character(leader),true);
                end
                local have_leader = false;
                for i = 0, kafka_force:character_list():num_items() - 1 do
                    if kafka_force:character_list():item_at(i) == leader then
                        -- -- ModLog(i .. " " .. kafka_force:character_list():item_at(i):generation_template_key())
                        have_leader = true;
                    end
                end
                if not have_leader then
                    if cm:query_local_faction(true):name() == kafka:faction():name() then
                        effect.advice(effect.get_localised_string("mod_kafka_mission_01_message"))
                    end
                else
                    cm:set_saved_value("kafka_mission_01_success",true);
                    if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                        cm:trigger_mission(context:faction(), "kafka_mission_02", true)
                    elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                        cm:trigger_mission(context:faction(), "kafka_mission_02_dlc04", true)
                    elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                        cm:trigger_mission(context:faction(), "kafka_mission_02_dlc05", true)
                    elseif cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                        cm:trigger_mission(context:faction(), "kafka_mission_02_dlc07", true)
                    end
                end
            end
        else
            if cm:query_local_faction(true):name() == kafka:faction():name() then
                effect.advice(effect.get_localised_string("mod_kafka_mission_01_message"))
            end
            cm:set_saved_value("kafka_mission_01",true);
        end
    end,
    false
)

core:add_listener(
    "kafka_mission_force_created",
    "MilitaryForceCreated",
    function(context)
        local military_force_created = context:military_force_created();
        -- -- ModLog(military_force_created:general_character():generation_template_key());
        return military_force_created 
        and cm:get_saved_value("kafka_mission_leader")
        and not military_force_created:general_character():is_null_interface();
    end,
    function(context)
        local military_force_created = context:military_force_created();
        local kafka_force = context:military_force_created();
        local kafka = gst.character_query_for_template("hlyjcj");
        local leader = gst.character_query_for_template(cm:get_saved_value("kafka_mission_leader"));
        if military_force_created:general_character():generation_template_key() == "hlyjcj" 
        and kafka:has_military_force()
        and kafka_force 
        then
            if kafka_force:character_list():num_items() < 3 and not leader:has_military_force() then
                cm:modify_military_force(kafka_force):add_existing_character_as_retinue(cm:modify_character(leader),true);
            end
        end
        if kafka:has_military_force() then
            -- -- ModLog("kafka_leader_military_force = true")
            cm:set_saved_value("kafka_leader_military_force", true)
        else
            -- -- ModLog("kafka_leader_military_force = false")
            cm:set_saved_value("kafka_leader_military_force", false)
        end
    end,
    true
)

core:add_listener(
    "kafka_mission_force_event",
    "MilitaryForceEvent",
    function(context)
        local military_force = context:military_force();
        -- -- ModLog(military_force:general_character():generation_template_key());
        return military_force 
        and cm:get_saved_value("kafka_mission_leader")
        and not military_force:general_character():is_null_interface();
    end,
    function(context)
        local kafka = gst.character_query_for_template("hlyjcj");
        if kafka:has_military_force() then
            -- -- ModLog("kafka_leader_military_force = true")
            cm:set_saved_value("kafka_leader_military_force", true)
        else
            -- -- ModLog("kafka_leader_military_force = false")
            cm:set_saved_value("kafka_leader_military_force", false)
        end
    end,
    true
)

--回合触发器
core:add_listener(
    "kafka_mission_01_round",
    "FactionTurnStart",
    function(context)
        local kafka = gst.character_query_for_template("hlyjcj");
        if not kafka or kafka:is_null_interface() then
            return false;
        end
        return context:faction():name() == kafka:faction():name() and context:faction():is_human() and not cm:get_saved_value("roguelike_mode"); 
    end,
    function(context)
        local leader = context:faction():faction_leader();
        local kafka = gst.character_query_for_template("hlyjcj");
        local leader = kafka:faction():faction_leader();
        if cm:get_saved_value("is_kafka_leaved") then
            if not kafka:is_dead()
            and not kafka:is_character_is_faction_recruitment_pool()
            and kafka:faction():is_human()
            then 
                player_faction_key = kafka:faction():name()
                cm:set_saved_value("is_kafka_leaved", nil)
                cm:trigger_mission(cm:query_faction(player_faction_key), "kafka_mission_01", true);
            end
        end
        
        cm:set_saved_value("kafka_mission_faction", context:faction():name());
        
        if leader:has_military_force() then
            cm:set_saved_value("kafka_leader_military_force", true)
        else
            cm:set_saved_value("kafka_leader_military_force", false)
        end
        
        --卡芙卡出仕之前固定在3k_main_faction_shoufang，方便调用start_pos_id;
        local shoufang = cm:query_faction("3k_main_faction_shoufang");
        if shoufang and not shoufang:is_dead() and not cm:get_saved_value("kafka_mission") then
            cm:modify_faction(shoufang):apply_effect_bundle("kafka_mission");
        end
        
        --未开启卡芙卡剧情线则跳过
        if not cm:get_saved_value("kafka_mission") then
            cm:modify_character(kafka):apply_effect_bundle("essentials_effect_bundle", -1)
            if not kafka:is_dead() 
            and kafka:faction():name() ~= "3k_main_faction_shoufang" 
            or kafka:is_character_is_faction_recruitment_pool() 
            then
                cm:modify_character(kafka):move_to_faction_and_make_recruited("3k_main_faction_shoufang")
            end
            return;
        end
        
        if not kafka:is_dead() 
        and kafka:faction():name() == context:faction():name()
        and not kafka:is_character_is_faction_recruitment_pool() 
        then
            player_faction_key = context:faction():name()
        end
        
        --设置抽出卡芙卡的派系的领袖（变成剧情人物）
        if not cm:get_saved_value("kafka_mission_leader") then
            cm:set_saved_value("kafka_mission_leader", kafka:faction():faction_leader():generation_template_key());
        elseif not cm:get_saved_value("tingyun_joined") 
        and cm:get_saved_value("kafka_mission_leader") ~= kafka:faction():faction_leader():generation_template_key()
        and not kafka:is_faction_leader()
        then
            cm:set_saved_value("kafka_mission_leader", kafka:faction():faction_leader():generation_template_key());
        end
        
        --主公换人会导致卡芙卡叛逃（只在停云来投之后~幻胧死亡之前触发）
        if cm:get_saved_value("xyyhlyjf_generated") 
        and cm:get_saved_value("tingyun_joined") 
        and not cm:get_saved_value("huanlong_dead") 
        and not cm:get_saved_value("is_kafka_leaved") 
        and cm:get_saved_value("kafka_mission_leader") ~= leader:generation_template_key() 
        and kafka:faction():name() == context:faction():name() 
        and not kafka:is_faction_leader() 
        then
            if not cm:get_saved_value("kafka_mission_ready_to_summon_huanlong") then
                cm:set_saved_value("kafka_mission_ready_to_summon_huanlong", 0);
            end
            
            cm:trigger_incident(context:faction():name(),"kafka_mission_13_a_incident", true);
            
            local hlyjdingzhie = gst.character_add_to_faction("hlyjdingzhie", "xyyhlyjf", "3k_general_water");
            if hlyjdingzhie and hlyjdingzhie:faction():name() == context:faction():name() then
                cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi");
                gst.character_CEO_equip("hlyjdingzhie","hlyjdingzhiewuqi","3k_main_ceo_category_ancillary_weapon");
                cm:modify_character(context:faction():faction_leader()):apply_relationship_trigger_set(hlyjdingzhie,    "3k_main_relationship_trigger_set_event_negative_betrayed");
            end
            gst.character_runaway("hlyjcj");
            
            if context:faction():ceo_management():has_ceo_equipped("hlyjcjwuqi") then
                cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjcjwuqi");
                gst.character_CEO_equip("hlyjcj","hlyjcjwuqi","3k_main_ceo_category_ancillary_weapon");
            end
            
            gst.faction_random_kill_character(context:faction():name(),3);
            
            cm:modify_character(context:faction():faction_leader()):apply_relationship_trigger_set(kafka, "3k_main_relationship_trigger_set_event_negative_betrayed");
            
            cm:set_saved_value("is_kafka_leaved", true);
        end
        
        --生成幻胧的倒计时
        if cm:get_saved_value("kafka_mission_ready_to_summon_huanlong") and cm:get_saved_value("kafka_mission_ready_to_summon_huanlong") >= 0 then 
            if cm:get_saved_value("kafka_mission_ready_to_summon_huanlong") <= 5 then
                cm:set_saved_value("kafka_mission_ready_to_summon_huanlong", cm:get_saved_value("kafka_mission_ready_to_summon_huanlong") + 1);
            else
                if context:faction():faction_leader():generation_template_key() == "3k_main_template_historical_cao_cao_hero_earth" then
                    cm:trigger_incident(context:faction():name(), "kafka_mission_summon_huanlong_cao_cao", true)
                elseif context:faction():faction_leader():generation_template_key() == "3k_main_template_historical_liu_bei_hero_earth" then
                    cm:trigger_incident(context:faction():name(), "kafka_mission_summon_huanlong_liu_bei", true)
                elseif context:faction():faction_leader():generation_template_key() == "hlyjcj" then
                    cm:trigger_incident(context:faction():name(), "kafka_mission_summon_huanlong_kafka_leader", true)
                else
                    cm:trigger_incident(context:faction():name(), "kafka_mission_summon_huanlong", true)
                end
                
                xyy_summon_huanlong_faction();
                
                if context:faction():faction_leader():generation_template_key() == "hlyjcj" then
                    if context:faction():is_mission_active("kafka_mission_02_a_kafka_leader") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_02_a_kafka_leader");
                    end
                    if context:faction():is_mission_active("kafka_mission_03_kafka_leader") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_03_kafka_leader");
                    end
                    if context:faction():is_mission_active("kafka_mission_04_kafka_leader") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_04_kafka_leader");
                    end
                else
                    if context:faction():is_mission_active("kafka_mission_02_a") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_02_a");
                    end
                    if context:faction():is_mission_active("kafka_mission_02_a_dlc04") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_02_a_dlc04");
                    end
                    if context:faction():is_mission_active("kafka_mission_02_a_dlc05") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_02_a_dlc05");
                    end
                    if context:faction():is_mission_active("kafka_mission_02_a_dlc07") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_02_a_dlc07");
                    end
                    if context:faction():is_mission_active("kafka_mission_02_a_fallback") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_02_a_fallback");
                    end
                    if context:faction():is_mission_active("kafka_mission_03") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_03");
                    end
                    if context:faction():is_mission_active("kafka_mission_04") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_04");
                    end
                    if context:faction():is_mission_active("kafka_mission_04_dlc04") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_04_dlc04");
                    end
                    if context:faction():is_mission_active("kafka_mission_04_dlc05") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_04_dlc05");
                    end
                    if context:faction():is_mission_active("kafka_mission_04_dlc07") then
                        cm:cancel_custom_mission(context:faction():name(), "kafka_mission_04_dlc07");
                    end
                end
                
                cm:set_saved_value("kafka_mission_ready_to_summon_huanlong", -1);
            end
        end
        
        --停云来投的倒计时
        if cm:get_saved_value("trigger_kafka_mission_06") then
            incident = cm:modify_model():create_incident("kafka_mission_06");
            incident:add_character_target("target_character_1", context:faction():faction_leader());
            incident:trigger(cm:modify_faction(context:faction()), true);
        end
        
        if cm:get_saved_value("summon_hlyjdingzhie") and cm:get_saved_value("summon_hlyjdingzhie") >= 0 then
            if  cm:get_saved_value("summon_hlyjdingzhie") >= 1 then
                -- -- ModLog("触发停云来投")
                cm:set_saved_value("summon_hlyjdingzhie", -1);
                local tingyun = gst.character_query_for_template("hlyjdingzhie")
                if not tingyun or tingyun:is_null_interface() then
                    cm:trigger_dilemma(context:faction():name(),"kafka_mission_06_choice", true);
                end
                cm:set_saved_value("tingyun_joined", true)
            else
                cm:set_saved_value("summon_hlyjdingzhie", cm:get_saved_value("summon_hlyjdingzhie") + 1);
            end
        end
        
        local kafka = gst.character_query_for_template("hlyjcj");
        
        --检测领袖是否在卡芙卡军队
        if kafka and not kafka:is_dead() and not kafka:is_character_is_faction_recruitment_pool() and kafka:faction() == context:faction() then 
            if not cm:get_saved_value("kafka_mission_01_success") then
                local leader = context:faction():faction_leader();
                local kafka_force = kafka:military_force();
                if kafka_force and not kafka_force:is_null_interface() and kafka_force:has_general() and kafka_force:general_character() == kafka then
                    if context:faction():faction_leader():generation_template_key() == "hlyjcj" then
                        cm:set_saved_value("kafka_mission_01_success",true);
                        local kafka = context:faction():faction_leader()
                        local mission = string_mission:new("kafka_mission_02_kafka_leader")
                        if kafka:startpos_key() then
                            mission:add_primary_objective("MOVE_TO_REGION", {"start_pos_character ".. kafka:startpos_key() .. ";region 3k_main_shoufang_resource_1"});
                        else
                            mission:add_primary_objective("MOVE_TO_REGION", {"region 3k_main_shoufang_resource_1"})
                        end
                    mission:add_primary_payload("text_display{lookup kafka_mission_02_kafka_leader;}")
                        mission:trigger_mission_for_faction(context:faction():name())
                    else
                        if kafka_force:character_list():num_items() < 3 then
                            cm:modify_military_force(kafka_force):add_existing_character_as_retinue(cm:modify_character(leader),true);
                        end
                        local have_leader = false;
                        for i = 0, kafka_force:character_list():num_items() - 1 do
                            if kafka_force:character_list():item_at(i) == leader then
                                -- -- ModLog(i .. " " .. kafka_force:character_list():item_at(i):generation_template_key())
                                have_leader = true;
                            end
                        end
                        if not have_leader then
                            is_kafka_with_leader = false;
                            if cm:query_local_faction(true):name() == kafka:faction():name() then
                                effect.advice(effect.get_localised_string("mod_kafka_mission_01_message"))
                            end
                        else
                            is_kafka_with_leader = true;
                            cm:set_saved_value("kafka_mission_01_success",true);
                            if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                                cm:trigger_mission(context:faction(), "kafka_mission_02", true)
                            elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                                cm:trigger_mission(context:faction(), "kafka_mission_02_dlc04", true)
                            elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                                cm:trigger_mission(context:faction(), "kafka_mission_02_dlc05", true)
                            elseif cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                                cm:trigger_mission(context:faction(), "kafka_mission_02_dlc07", true)
                            end
                        end
                    end
                else
                    is_kafka_with_leader = false
                    
                    if cm:query_local_faction(true):name() == kafka:faction():name() then
                        effect.advice(effect.get_localised_string("mod_kafka_mission_01_message"))
                    end
                end
            end
        end
        
        --监测卡芙卡是否已经离开派系
        if 
        not cm:get_saved_value("kafka_mission_12_a") 
        and cm:get_saved_value("is_player_have_kafka") 
        and not cm:get_saved_value("is_kafka_leaved") 
        and not cm:get_saved_value("kafka_mission_12_a_trigger") 
        then
            local kafka = gst.character_query_for_template("hlyjcj"); 
            local tingyun = gst.character_query_for_template("hlyjdingzhie"); 
            if 
            kafka
            and not kafka:is_dead() 
            and not kafka:is_spy() 
            and (kafka:faction() ~= context:faction() or kafka:is_character_is_faction_recruitment_pool())
            and tingyun 
            and not tingyun:is_dead() 
            and tingyun:faction() == context:faction() 
            and not tingyun:is_character_is_faction_recruitment_pool()
            then
                local hlydingzhie = gst.character_add_to_faction("hlyjdingzhie", "xyyhlyjf", "3k_general_water");
                cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi");
                gst.character_CEO_equip("hlyjdingzhie","hlyjdingzhiewuqi","3k_main_ceo_category_ancillary_weapon");
                
                local xyyhlyjf = cm:query_faction("xyyhlyjf");
                
                found_pos, x, y = xyyhlyjf:get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
                cm:create_force_with_existing_general(hlyjdingzhie:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhie_force", nil, 100);
                
                -- -- ModLog("debug: trigger is_kafka_mission_15" .. xyyhlyjf:capital_region():name() )
                local modify_force = cm:modify_military_force(hlyjdingzhie:military_force());
                
                local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                
                modify_character_1:add_experience(295000,0);
                modify_character_2:add_experience(295000,0);
                
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_1, true);
                end
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_2, true);
                end
                if context:faction():ceo_management():has_ceo_equipped("hlyjcjwuqi") then
                    cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjcjwuqi");
                    gst.character_CEO_equip("hlyjcj","hlyjcjwuqi","3k_main_ceo_category_ancillary_weapon");
                end
                
                cm:trigger_incident(context:faction():name(),"kafka_mission_13_c_incident", true);
                cm:set_saved_value("is_kafka_leaved", true);
                
                for i = 1, #mission_keys do
				-- Cancel the mission if it's active.
                    if context:faction():is_mission_active(mission_keys[i]) then
                        cm:cancel_custom_mission(context:faction():name(), mission_keys[i])
                        -- -- ModLog("Canceling intro mission " .. mission_keys[i] .. " as faction rank up has happened!")
                    end;
                end;

            end;
        end;
        
        --击败停云之后事件
        if 
        cm:get_saved_value("hlyjdingzhie_has_been_killed") 
        and not cm:get_saved_value("is_kafka_mission_huanlong_02_triggered")
        then
            if not cm:get_saved_value("is_kafka_leaved") 
            then
                -- -- ModLog("debug: trigger kafka_mission_huanlong_02")
                local mission = string_mission:new("kafka_mission_huanlong_02");
                mission:add_primary_objective("DEFEAT_N_ARMIES_OF_FACTION", {"total 5","faction xyyhlyjf"});
                mission:add_primary_payload("money 15000");
                mission:trigger_mission_for_faction(context:faction():name());
                cm:set_saved_value("is_kafka_mission_huanlong_02_triggered",true);
            end
        end
        
        if 
        cm:get_saved_value("hlyjdingzhie_has_been_killed") 
        and not cm:get_saved_value("kafka_mission_14_triggered")
        then
            -- -- ModLog("debug: trigger is_kafka_mission_14")
            --cm:set_saved_value("is_kafka_mission_14_triggered", true);
            local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
            local xyyhlyjf = cm:query_faction("xyyhlyjf");
            local hlyjdingzhia_force = gst.faction_find_character_military_force("hlyjdingzhia")
            if hlyjdingzhia_force then
                local modify_force = cm:modify_military_force(hlyjdingzhia_force);
                
                local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                
                modify_character_1:add_experience(295000,0);
                modify_character_2:add_experience(295000,0);
                
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_1, true);
                end
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_2, true);
                end
                modify_force:set_retreated()
                gst.faction_military_teleport_to_region("hlyjdingzhia", xyyhlyjf:capital_region():name())
                if not cm:get_saved_value("is_kafka_leaved") then
                    if context:faction():faction_leader():generation_template_key() == "hlyjcj" then
                        cm:trigger_mission(context:faction(), "kafka_mission_16_kafka_leader", true);
                    else
                        cm:trigger_mission(context:faction(), "kafka_mission_14", true);
                    end
                else
                    cm:trigger_mission(context:faction(), "kafka_mission_14_a", true);
                end
            end
        end
        
        if context:faction():is_mission_active("kafka_mission_14")
        or context:faction():is_mission_active("kafka_mission_14_a")  
        then
            local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
            local hlyjdingzhia_force = gst.faction_find_character_military_force(hlyjdingzhia)
            if hlyjdingzhia_force then
                local modify_force = cm:modify_military_force(hlyjdingzhia_force);
                modify_force:set_retreated();
            end
        end
        
        if 
        cm:get_saved_value("trigger_kafka_mission_15") 
        and not context:faction():has_mission_been_issued("kafka_mission_15")
        and not context:faction():has_mission_been_issued("kafka_mission_15_a")  
        then
            local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
            local xyyhlyjf = cm:query_faction("xyyhlyjf");
            local region = xyyhlyjf:capital_region():name()
            local hlyjdingzhia_force = gst.faction_find_character_military_force("hlyjdingzhia")
            if 1 then
                if hlyjdingzhia_force then
                    local modify_force = cm:modify_military_force(hlyjdingzhia_force);
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                    local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                    
                    modify_character_1:add_experience(295000,0);
                    modify_character_2:add_experience(295000,0);
                
                    cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                    ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                    
                    cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                    ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                    
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_1, true);
                    end
                    
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_2, true);
                    end
                else
                    gst.faction_military_teleport_to_region("hlyjdingzhia", region)
                end
                --cm:modify_character(hlyjdingzhia):apply_effect_bundle("freeze", -1);
                add_freeze(hlyjdingzhia:cqi())
                region = hlyjdingzhia:region():name()
                local log_x = hlyjdingzhia:logical_position_x();
                local log_y = hlyjdingzhia:logical_position_x();
                if 1 then
                    found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 4, false);
                    
                    if x == 0 or y == 0 then
                        found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                        x = x1;
                        y = y1;
                    end
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_general", false);
                    
                    modify_character_1:add_experience(295000,0);
                    
                    -- -- ModLog(x.." "..y.." "..region)
                    
                    create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force1", nil, 100);
                        
                    if modify_character_1:query_character():has_military_force() then
                        -- -- ModLog("debug: trigger is_kafka_mission_15_modify_character_1")
                        local modify_force = cm:modify_military_force(modify_character_1:query_character():military_force());
                        
                        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                        
                        local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                        
                        modify_character_2:add_experience(295000,0);
                        modify_character_3:add_experience(295000,0);
                    
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_3, true);
                        end
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        --modify_character_1:apply_effect_bundle("freeze",-1);
                        add_freeze(modify_character_1:query_character():cqi())
                    end
                end
                
                if 1 then
                    found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 4, false);
                    
                    if x == 0 or y == 0 then
                        found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                        x = x1;
                        y = y1;
                    end
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_general", false);
                    modify_character_1:add_experience(295000,0);
                    
                    -- -- ModLog(x.." "..y.." "..region)
                    
                    create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force2", nil, 100);
                        
                    if modify_character_1:query_character():has_military_force() then
                        -- -- ModLog("debug: trigger is_kafka_mission_15_modify_character_2")
                        
                        local modify_force = cm:modify_military_force(modify_character_1:query_character():military_force());
                        
                        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                        
                        local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                        
                        modify_character_2:add_experience(295000,0);
                        modify_character_3:add_experience(295000,0);
                                    
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_3, true);
                        end
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        --modify_character_1:apply_effect_bundle("freeze",-1);
                        add_freeze(modify_character_1:query_character():cqi())
                    end
                end
                
                if 1 then
                    found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 5, false);
                    
                    if x == 0 or y == 0 then
                        found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                        x = x1;
                        y = y1;
                    end
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_general", false);
                    modify_character_1:add_experience(295000,0);
                    
                    -- -- ModLog(x.." "..y.." "..region)
                    
                    create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force3", nil, 100);
                        
                    if modify_character_1:query_character():has_military_force() then
                        -- -- ModLog("debug: trigger is_kafka_mission_15_modify_character_3")
                        local modify_force = cm:modify_military_force(modify_character_1:query_character():military_force());
                        
                        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                        
                        local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                        
                        modify_character_2:add_experience(295000,0);
                        modify_character_3:add_experience(295000,0);
                                    
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_3, true);
                        end
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        --modify_character_1:apply_effect_bundle("freeze",-1);
                        add_freeze(modify_character_1:query_character():cqi())
                    end
                end
                
                if 1 then
                    found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 6, false);
                    
                    if x == 0 or y == 0 then
                        found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                        x = x1;
                        y = y1;
                    end
                    
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_general", false);
                    modify_character_1:add_experience(295000,0);
                    
                    -- -- ModLog(x.." "..y.." "..region)
                    
                    create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force4", nil, 100);
                        
                    if modify_character_1:query_character():has_military_force() then
                        -- -- ModLog("debug: trigger is_kafka_mission_15_modify_character_4")
                        local modify_force = cm:modify_military_force(modify_character_1:query_character():military_force());
                        
                        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                        
                        local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                        
                        modify_character_2:add_experience(295000,0);
                        modify_character_3:add_experience(295000,0);
                                    
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_3, true);
                        end
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        --modify_character_1:apply_effect_bundle("freeze",-1);
                        add_freeze(modify_character_1:query_character():cqi())
                    end
                end
            end
            
            if not cm:get_saved_value("is_kafka_leaved") then
                cm:trigger_mission(context:faction(), "kafka_mission_15",true);
            else
                cm:trigger_mission(context:faction(), "kafka_mission_15_a",true);
            end
        end
        if cm:get_saved_value("kafka_mission_07_2_incident") then
            -- -- ModLog("debug: trigger kafka_mission_07_2_incident")
            cm:set_saved_value("kafka_mission_07_2_incident",false);
            cm:trigger_incident(context:faction():name(),"kafka_mission_07_2_incident", true);
        end
        if cm:get_saved_value("kafka_mission_05_cancel") then
            cm:set_saved_value("kafka_mission_05_cancel", false);
            local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
            local xyyhlyjf = cm:query_faction("xyyhlyjf");
            local hlyjdingzhia_force = gst.faction_find_character_military_force("hlyjdingzhia")
            if hlyjdingzhia_force then
                local modify_force = cm:modify_military_force(hlyjdingzhia_force);
                
                local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                
                modify_character_1:add_experience(295000,0);
                modify_character_2:add_experience(295000,0);
                
                modify_force:add_existing_character_as_retinue(modify_character_1, true);
                modify_force:add_existing_character_as_retinue(modify_character_2, true);
                
                if context:faction():faction_leader():generation_template_key() == "hlyjcj" then
                    cm:trigger_incident(context:faction(), "kafka_mission_05_kafka_mission", true);
                else
                    if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                        cm:trigger_mission(context:faction(), "kafka_mission_05", true)
                    elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                        cm:trigger_mission(context:faction(), "kafka_mission_05_dlc04", true)
                    elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                        cm:trigger_mission(context:faction(), "kafka_mission_05_dlc05", true)
                    elseif cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                        cm:trigger_mission(context:faction(), "kafka_mission_05_dlc07", true)
                    end
                end
            end
        end 
        
        --幻胧死后的事件（玩家回合）
        if xyyhlyjf and not xyyhlyjf:is_dead() then
            local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
            if
            cm:get_saved_value("huanlong_dead") 
            or hlyjdingzhia:is_dead() 
            then
                if not hlyjdingzhia:is_dead() then
                    cm:modify_character(hlyjdingzhia):kill_character(false);
                elseif not cm:get_saved_value("huanlong_dead") then
                    cm:set_saved_value("huanlong_dead",true)
                end
                -- -- ModLog("huanlong_dead")
                local region_list = xyyhlyjf:region_list();
                cm:modify_character(hlyjdingzhia):kill_character(false);
                for i = 0 , region_list:num_items() - 1 do
                    local region = region_list:item_at(i);
                    cm:modify_region(region):raze_and_abandon_settlement_without_attacking();
                end
                gst.region_set_manager("3k_main_shoufang_capital","3k_dlc04_faction_rebels");
                gst.faction_kill_all_character("xyyhlyjf")
                diplomacy_manager:force_confederation("3k_dlc04_faction_rebels", "xyyhlyjf");
                
                local character = gst.character_add_to_faction("hlyjdw", player_faction_key, gst.all_character_detils["hlyjdw"]['subtype']);
                cm:modify_character(character):add_experience(88000,0);
                cm:modify_character(character):reset_skills();
                
                if not is_tingyun_unlock() and not cm:get_saved_value("xyy_cheat_mode") then
                    tingyun_unlock()
                    local incident = cm:modify_model():create_incident("unlock_hlyjdw");
                    incident:add_character_target("target_character_1", character);
                    incident:add_faction_target("target_faction_1", cm:query_faction(player_faction_key));
                    incident:trigger(cm:modify_faction(player_faction_key), true);
                else
                    local incident = cm:modify_model():create_incident("summon_hlyjdw");
                    incident:add_character_target("target_character_1", character);
                    incident:add_faction_target("target_faction_1", cm:query_faction(player_faction_key));
                    incident:trigger(cm:modify_faction(player_faction_key), true);
                end
                
                local hlyjck_dark = gst.character_query_for_template("hlyjck_dark");
                local hlyjdy_dark = gst.character_query_for_template("hlyjdy_dark");
                local hlyjcm_dark = gst.character_query_for_template("hlyjcm_dark");
                local hlyjda_dark = gst.character_query_for_template("hlyjda_dark");
                local hlyjeb_dark = gst.character_query_for_template("hlyjeb_dark");
                if not hlyjck_dark:is_dead() then
                    cm:modify_character(hlyjck_dark):kill_character(false);
                end
                if not hlyjdy_dark:is_dead() then
                    cm:modify_character(hlyjdy_dark):kill_character(false);
                end
                if not hlyjcm_dark:is_dead() then
                    cm:modify_character(hlyjcm_dark):kill_character(false);
                end
                if not hlyjda_dark:is_dead() then
                    cm:modify_character(hlyjda_dark):kill_character(false);
                end
                if not hlyjeb_dark:is_dead() then
                    cm:modify_character(hlyjeb_dark):kill_character(false);
                end
                return
            end
        end
        
        --任务中止后重新触发追杀停云任务
        local hlyjdingzhie = gst.character_query_for_template("hlyjdingzhie");
        if hlyjdingzhie
        and not hlyjdingzhie:is_null_interface()
        and not hlyjdingzhie:is_dead()
        and hlyjdingzhie:faction():name() == "xyyhlyjf"
        and not cm:get_saved_value("hlyjdingzhie_has_been_killed")
        and not context:faction():is_mission_active("kafka_mission_12_a")
        then
            if hlyjdingzhie:has_military_force() then
                gst.faction_set_minister_position("hlyjdingzhie","faction_leader");
                if not context:faction():is_mission_active("kafka_mission_12_a") then
                    cm:trigger_mission(context:faction(),"kafka_mission_12_a", true);
                end
                gst.faction_set_minister_position("hlyjdingzhia","faction_leader");
            else
                cm:set_saved_value("kafka_mission_12_a", true)
            end
        end
        
        if cm:get_saved_value("kafka_mission_02_a_kafka_leader") 
        and not context:faction():has_mission_been_issued("kafka_mission_02_a_kafka_leader")
        then
            local kafka = gst.character_query_for_template("hlyjcj")
            local mission = string_mission:new("kafka_mission_02_a_kafka_leader")
            if kafka:startpos_key() then
                mission:add_primary_objective("MOVE_TO_REGION", {"start_pos_character ".. kafka:startpos_key() .. ";region 3k_main_shoufang_resource_2"});
            else
                mission:add_primary_objective("MOVE_TO_REGION", {"region 3k_main_shoufang_resource_2"})
            end
            mission:add_primary_payload("text_display{lookup unknown;}")
            mission:trigger_mission_for_faction(context:faction():name())
        end
        
        --招募令已发布
        if cm:get_saved_value("kafka_recruiting") then
            if not cm:get_saved_value("kafka_recruiting_disable") then
                local max = cm:get_saved_value("kafka_recruiting")
                local random = gst.lib_getRandomValue(0, max);
                if random > 300
                and not cm:get_saved_value("kafka_mission_09_choice_kafka_leader") then
                    cm:trigger_dilemma(context:faction(),"kafka_mission_06_choice_kafka_leader",true)
                    cm:set_saved_value("kafka_recruiting", max - 100);
                else
                    cm:trigger_dilemma(context:faction(),"kafka_mission_07_choice_kafka_leader",true)
                    cm:set_saved_value("kafka_recruiting", 1000);
                end
            else
                --无人可招募了
                cm:trigger_dilemma(context:faction(),"kafka_mission_06_choice_kafka_leader",true)
                local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia")
                remove_freeze(hlyjdingzhia:cqi())
                local modify_hlyjdingzhia = cm:modify_character(hlyjdingzhia);
                modify_hlyjdingzhia:remove_effect_bundle("huanlong_unbreakable");
            end
        end
           
        if cm:get_saved_value("kafka_mission_12_a") and not gst.faction_is_character_deployed("hlyjdingzhie") then
            local xyyhlyjf = cm:query_faction("xyyhlyjf")
            local hlyjdingzhie = gst.character_query_for_template("hlyjdingzhie");
            local hlyjdingzhie_force = gst.faction_find_character_military_force(hlyjdingzhie)
            if hlyjdingzhie_force then
                local modify_force = cm:modify_military_force(hlyjdingzhie_force);
                local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                modify_character_1:add_experience(295000,0);
                modify_character_2:add_experience(295000,0);
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_1, true);
                end
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_2, true);
                end
            end
            if not context:faction():is_mission_active("kafka_mission_12_a") and gst.faction_is_character_deployed("hlyjdingzhie") then
                cm:modify_character(hlyjdingzhie):apply_effect_bundle("freeze", 1);
                gst.character_add_CEO_and_equip("hlyjdingzhie", "hlyjdingzhiezuoqi", "3k_main_ceo_category_ancillary_mount")
                add_freeze(hlyjdingzhie:cqi())
                gst.faction_set_minister_position("hlyjdingzhie","faction_leader");
                cm:trigger_mission(cm:query_faction(player_faction_key),"kafka_mission_12_a", true);
                gst.faction_set_minister_position("hlyjdingzhia","faction_leader");
                cm:set_saved_value("kafka_mission_12_a_trigger", true);
                cm:set_saved_value("kafka_mission_12_a", false);
            end
        end
    end,
    true
)


core:add_listener(
    "kafka_mission_02_success",
    "MissionSucceeded",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_02" 
        or context:mission():mission_record_key() == "kafka_mission_02_dlc04" 
        or context:mission():mission_record_key() == "kafka_mission_02_dlc05" 
        or context:mission():mission_record_key() == "kafka_mission_02_dlc07";
    end,
    function(context)
        cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("3k_main_game_lost_yuan_shao");
        
        if context:faction():faction_leader():generation_template_key() == "hlyjcj" then
            cm:trigger_dilemma(context:faction():name(),"kafka_mission_02_choice_kafka_leader", true);
        else
            cm:trigger_dilemma(context:faction():name(),"kafka_mission_02_choice", true);
        end
        
        -- -- ModLog(cm:query_model():campaign_name())
        cm:set_saved_value("kafka_mission_ready_to_summon_huanlong",0);
    end,
    false
)

core:add_listener(
    "kafka_mission_02_kafka_leader_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_02_kafka_leader";
    end,
    function(context)
        local kafka = gst.character_query_for_template("hlyjcj")
        cm:modify_model():get_modify_episodic_scripting():register_instant_movie_by_record("3k_main_game_lost_yuan_shao");
        if context:faction():faction_leader():generation_template_key() == "hlyjcj" then
            cm:trigger_dilemma(context:faction():name(),"kafka_mission_02_choice_kafka_leader", true);
        else
            cm:trigger_dilemma(context:faction():name(),"kafka_mission_02_choice", true);
        end
        cm:modify_character(kafka):add_experience(6500);
        -- -- ModLog(cm:query_model():campaign_name())
        cm:set_saved_value("kafka_mission_ready_to_summon_huanlong",0);
    end,
    false
)

core:add_listener(
    "kafka_mission_02_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_02_choice" 
        or context:dilemma() == "kafka_mission_02_choice_kafka_leader" 
    end, -- criteria
    function (context) --what to do if listener fires
        if context:choice() == 0 then
            if context:faction():faction_leader():generation_template_key() == "hlyjcj" then
                cm:set_saved_value("kafka_mission_02_a_kafka_leader", true)
                local kafka = context:faction():faction_leader()
                local mission = string_mission:new("kafka_mission_02_a_kafka_leader")
                if kafka:startpos_key() then
                    mission:add_primary_objective("MOVE_TO_REGION", {"start_pos_character ".. kafka:startpos_key() .. ";region 3k_main_shoufang_resource_2"});
                else
                    mission:add_primary_objective("MOVE_TO_REGION", {"region 3k_main_shoufang_resource_2"})
                end
                mission:add_primary_payload("text_display{lookup unknown;}")
                mission:trigger_mission_for_faction(context:faction():name())
            else
                if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                    cm:trigger_mission(context:faction(), "kafka_mission_02_a", true)
                elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                    cm:trigger_mission(context:faction(), "kafka_mission_02_a_dlc04", true)
                elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                    cm:trigger_mission(context:faction(), "kafka_mission_02_a_dlc05", true)
                elseif cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                    cm:trigger_mission(context:faction(), "kafka_mission_02_a_dlc07", true)
                end
            end
        end
        if context:choice() == 1 then
            if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                cm:trigger_mission(context:faction(), "kafka_mission_04", true)
            elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_04_dlc04", true)
            elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_04_dlc05", true)
            elseif cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_04_dlc07", true)
            end
        end
    end,   
    false
)

core:add_listener(
    "kafka_mission_03_complete_kafka_leader",
    "IncidentOccuredEvent",
    function(context) 
        return context:incident() == "kafka_mission_03_complete_kafka_leader"
    end,
    function (context) 
        cm:set_saved_value("is_kafka_have_weapon", true)
    end,   
    false
)

core:add_listener(
    "kafka_mission_04_trigger",
    "FactionTurnStart",
    function(context) 
        return context:faction():is_human()
        and context:faction():name() == player_faction_key
        and cm:get_saved_value("is_kafka_have_weapon")
    end, -- criteria
    function (context) --what to do if listener fires
        if context:faction():faction_leader():generation_template_key() == "hlyjcj"  then
            if not context:faction():has_mission_been_issued("kafka_mission_04_kafka_leader")
            and not context:faction():has_mission_been_issued("kafka_mission_04")
            and not context:faction():has_mission_been_issued("kafka_mission_04_dlc04")
            and not context:faction():has_mission_been_issued("kafka_mission_04_dlc05")
            and not context:faction():has_mission_been_issued("kafka_mission_04_dlc07")
            then
                local kafka = context:faction():faction_leader()
                local mission = string_mission:new("kafka_mission_04_kafka_leader")
                if kafka:startpos_key() then
                    mission:add_primary_objective("MOVE_TO_REGION", {"start_pos_character ".. kafka:startpos_key() .. ";region " .. context:faction():capital_region():name()});
                else
                    mission:add_primary_objective("MOVE_TO_REGION", {"region " .. context:faction():capital_region():name()})
                end
                mission:add_primary_payload("text_display{lookup unknown;}")
                mission:trigger_mission_for_faction(context:faction():name())
            end
        else
            if cm:query_model():campaign_name() == "3k_main_campaign_map" then
                cm:trigger_mission(context:faction(), "kafka_mission_04", true)
            elseif cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_04_dlc04", true)
            elseif cm:query_model():campaign_name() == "3k_dlc05_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_04_dlc05", true)
            elseif cm:query_model():campaign_name() == "3k_dlc07_start_pos" then
                cm:trigger_mission(context:faction(), "kafka_mission_04_dlc07", true)
            end
        end
    end,   
    false
)

core:add_listener(
    "kafka_mission_02_a_success",
    "MissionSucceeded",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_02_a" 
        or context:mission():mission_record_key() == "kafka_mission_02_a_dlc04" 
        or context:mission():mission_record_key() == "kafka_mission_02_a_dlc05" 
        or context:mission():mission_record_key() == "kafka_mission_02_a_dlc07" 
        or context:mission():mission_record_key() == "kafka_mission_02_a_fallback"
        or context:mission():mission_record_key() == "kafka_mission_02_a_kafka_leader";
    end,
    function(context)
        --{spawn_region = "3k_main_shoufang_resource_2", x_pos = 186, y_pos = 466}
        local faction_key = context:faction():name();
        if not faction_key then
            faction_key = player_faction_key;
        end
        local invasion_faction_key = "3k_dlc04_faction_rebels";
        diplomacy_manager:apply_automatic_deal_between_factions(invasion_faction_key, faction_key, "data_defined_situation_war_proposer_to_recipient")
        campaign_invasions:create_invasion_attack_region("3k_dlc04_faction_rebels", "3k_main_shoufang_resource_2", 4, "3k_main_shoufang_resource_2", false, 248, 595);
        cm:modify_faction(player_faction_key):make_region_seen_in_shroud("3k_main_shoufang_resource_2");
        cm:scroll_camera_from_current(8, true, {166, 459, 14, -2, 11});
        if context:faction():faction_leader():generation_template_key() == "hlyjcj" then
            cm:trigger_mission(context:faction(),"kafka_mission_03_kafka_leader", true);
        else
            cm:trigger_mission(context:faction(),"kafka_mission_03", true);
        end
    end,
    false
)

core:add_listener(
    "kafka_mission_03_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_03";
    end,
    function(context)
        local kafka = gst.character_query_for_template("hlyjcj");
        incident = cm:modify_model():create_incident("kafka_mission_03_complete");
        incident:add_character_target("target_character_1", kafka);
        incident:add_faction_target("target_faction_1", context:faction());
        incident:trigger(cm:modify_faction(context:faction()), true);
        gst.faction_add_tickets(context:faction():name(), 10);
    end,
    false
)

core:add_listener(
    "kafka_mission_03_kafka_leader_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_03_kafka_leader";
    end,
    function(context)
        local kafka = gst.character_query_for_template("hlyjcj");
        incident = cm:modify_model():create_incident("kafka_mission_03_complete_kafka_leader");
        incident:add_character_target("target_character_1", kafka);
        incident:add_faction_target("target_faction_1", context:faction());
        incident:trigger(cm:modify_faction(context:faction()), true);
        gst.faction_add_tickets(context:faction():name(), 10);
    end,
    false
)

core:add_listener(
    "kafka_mission_03_failed",
    "MissionFailed",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_03";
    end,
    function(context)
        cm:trigger_mission(context:faction(),"kafka_mission_03", true);
    end,
    false
)

core:add_listener(
    "kafka_mission_04_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_04" or context:mission():mission_record_key() == "kafka_mission_04_dlc04" or context:mission():mission_record_key() == "kafka_mission_04_dlc05" or context:mission():mission_record_key() == "kafka_mission_04_dlc07";
    end,
    function(context)
        --cm:set_saved_value("kafka_mission_ready_to_summon_huanlong",0);
    end,
    false
)

core:add_listener(
    "kafka_mission_summon_huanlong",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "kafka_mission_summon_huanlong"
        or context:incident() == "kafka_mission_summon_huanlong_liu_bei"
        or context:incident() == "kafka_mission_summon_huanlong_cao_cao"
        or context:incident() == "kafka_mission_summon_huanlong_kafka_leader";
    end,
    function(context)
        local mission = string_mission:new("kafka_mission_huanlong");
        mission:add_primary_objective("DESTROY_FACTION", {"faction xyyhlyjf"});
        mission:add_primary_payload("text_display{lookup dummy_game_victory;}");
        local randomint = cm:random_int(42, 38);
        mission:set_turn_limit(randomint);
        cm:set_saved_value("huanlong_mission_limit", randomint)
        mission:trigger_mission_for_faction(context:faction():name());
        cm:set_saved_value("kafka_mission_summon_huanlong",0);
        cm:modify_character(context:faction():faction_leader()):apply_effect_bundle("character_captives_escape_force",-1);
        cm:modify_character(gst.character_query_for_template("hlyjcj")):apply_effect_bundle("character_captives_escape_force",-1);
    end,
    false
)

core:add_listener(
    "kafka_mission_summon_huanlong_re-enable",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human() and not cm:get_saved_value("huanlong_dead") and not cm:get_saved_value("roguelike_mode");
    end,
    function(context)
        if cm:get_saved_value("huanlong_mission_limit") then
            local huanlong_mission_limit = cm:get_saved_value("huanlong_mission_limit");
            cm:set_saved_value("huanlong_mission_limit", huanlong_mission_limit - 1);
            local xyyhlyjf = cm:query_faction("xyyhlyjf")
            local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia")
            if xyyhlyjf 
            and not xyyhlyjf:is_null_interface() 
            and xyyhlyjf:is_dead() 
            and not hlyjdingzhia:is_null_interface()
            and not hlyjdingzhia:is_dead()
            and not context:faction():is_mission_active("kafka_mission_huanlong")
            then
                xyy_summon_huanlong_faction()
                local mission = string_mission:new("kafka_mission_huanlong");
                mission:add_primary_objective("DESTROY_FACTION", {"faction xyyhlyjf"});
                mission:add_primary_payload("text_display{lookup dummy_game_victory;}");
                mission:set_turn_limit(huanlong_mission_limit);
                mission:trigger_mission_for_faction(context:faction():name());
                cm:set_saved_value("kafka_mission_summon_huanlong",0);
                cm:modify_character(context:faction():faction_leader()):apply_effect_bundle("character_captives_escape_force",-1);
                cm:modify_character(gst.character_query_for_template("hlyjcj")):apply_effect_bundle("character_captives_escape_force",-1);
            end
        end
    end,
    true
)
core:add_listener(
    "kafka_mission_05_start",
    "MissionIssued",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc04"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc07";
    end,
    function(context)
        -- -- ModLog("debug: kafka_mission_05_start")
        cm:modify_character(context:faction():faction_leader()):apply_effect_bundle("character_captives_escape_force",-1);
        cm:modify_character(gst.character_query_for_template("hlyjcj")):apply_effect_bundle("character_captives_escape_force",-1);
    end,
    false
)

core:add_listener(
    "kafka_mission_05_cancel",
    "MissionCancelled",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc04"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc07";
    end,
    function(context)
        -- -- ModLog("debug: kafka_mission_05_cancel")
        cm:set_saved_value("kafka_mission_05_cancel",true);
    end,
    false
)

core:add_listener(
    "kafka_mission_05_success",
    "MissionSucceeded",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc04"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc05"
        or context:mission():mission_record_key() == "kafka_mission_05_dlc07";
    end,
    function(context)
        cm:trigger_mission(context:faction(),"kafka_mission_05_a", true);
        local leader = gst.character_query_for_template(cm:get_saved_value("kafka_mission_leader"));
        local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
        local modify_hlyjdingzhia = cm:modify_character(hlyjdingzhia);
        
        remove_freeze(hlyjdingzhia:cqi())
        
        modify_hlyjdingzhia:replenish_action_points();
        modify_hlyjdingzhia:attack(kafka);
        
--         local kafka = gst.character_query_for_template("hlyjcj")
--         local kafka_force = cm:query_model():get_modify_military_force(kafka:military_force())
--         kafka_force:set_retreated();
        
    end,
    false
)

-- core:add_listener(
--     "kafka_mission_05_BattleCompleted",
--     "BattleCompleted",
--     function(context)
--         if not cm:get_saved_value("kafka_mission_leader") then
--             return false
--         end
--         local leader = gst.character_query_for_template(cm:get_saved_value("kafka_mission_leader"));
--         local faction = leader:faction();
--         return faction:has_mission_been_issued("kafka_mission_05_a") and not cm:get_saved_value("summon_hlyjdingzhie");
--         --return false;
--     end,
--     function(context)
--         local pb = cm:query_model():pending_battle();
--         local leader = gst.character_query_for_template(cm:get_saved_value("kafka_mission_leader"));
--         local kafka = gst.character_query_for_template("hlyjcj");
--         local faction = leader:faction();
--         
--         if pb:has_attacker() then
--             -- -- ModLog(pb:attacker():generation_template_key() .. " " .. pb:attacker():faction():name())
--         end
--         
--         if pb:has_defender() then
--             -- -- ModLog(pb:defender():generation_template_key() .. " " .. pb:defender():faction():name())
--         end
--         
--         if pb:has_attacker() 
--         and pb:attacker():faction():name() == "xyyhlyjf" then 
--             if pb:has_defender() and pb:defender():generation_template_key() == "hlyjcj"
--             then
--                 if not kafka:won_battle() then
--                     if faction:is_mission_active("kafka_mission_05_a") then
--                         cm:modify_faction(faction):cancel_custom_mission("kafka_mission_05_a")
--                     end
--                     -- -- ModLog("loose battle")
--                     incident = cm:modify_model():create_incident("kafka_mission_06");
--                     incident:add_character_target("target_character_1", leader);
--                     incident:trigger(cm:modify_faction(faction), true);
--                     return;
--                 end
--                 -- -- ModLog("win battle")
--             end
--             if pb:has_defender() and pb:defender():generation_template_key() == cm:get_saved_value("kafka_mission_leader")
--             then
--                 if not leader:won_battle() then
--                     if faction:is_mission_active("kafka_mission_05_a") then
--                         cm:modify_faction(faction):cancel_custom_mission("kafka_mission_05_a")
--                     end
--                     -- -- ModLog("loose battle")
--                     incident = cm:modify_model():create_incident("kafka_mission_06");
--                     incident:add_character_target("target_character_1", leader);
--                     incident:trigger(cm:modify_faction(faction), true);
--                     return;
--                 end
--                 -- -- ModLog("win battle")
--             end
--             -- -- ModLog("no defender")
--         end
--         
--         if pb:has_defender() 
--         and pb:defender():faction():name() == "xyyhlyjf" then 
--             if pb:has_attacker() and pb:attacker():generation_template_key() == "hlyjcj"
--             then
--                 if not kafka:won_battle() then
--                     if faction:is_mission_active("kafka_mission_05_a") then
--                         cm:modify_faction(faction):cancel_custom_mission("kafka_mission_05_a")
--                     end
--                     -- -- ModLog("loose battle")
--                     incident = cm:modify_model():create_incident("kafka_mission_06");
--                     incident:add_character_target("target_character_1", leader);
--                     incident:trigger(cm:modify_faction(faction), true);
--                     return;
--                 end
--                 -- -- ModLog("win battle")
--             end
--             if pb:has_attacker() and pb:attacker():generation_template_key() == cm:get_saved_value("kafka_mission_leader")
--             then
--                 if not leader:won_battle() then
--                     if faction:is_mission_active("kafka_mission_05_a") then
--                         cm:modify_faction(faction):cancel_custom_mission("kafka_mission_05_a")
--                     end
--                     -- -- ModLog("loose battle")
--                     incident = cm:modify_model():create_incident("kafka_mission_06");
--                     incident:add_character_target("target_character_1", leader);
--                     incident:trigger(cm:modify_faction(faction), true);
--                     return;
--                 end
--                 -- -- ModLog("win battle")
--             end
--             -- -- ModLog("no attacker")
--         end
--         
--         if cm:get_saved_value("kafka_leader_military_force") then
--             local kafka_force = kafka:military_force();
--             if not kafka:has_military_force()
--             or not kafka_force
--             or kafka_force:is_null_interface()
--             then
--                 if (pb:has_attacker() and pb:attacker():faction():name() == "xyyhlyjf")
--                 or (pb:has_defender() and pb:defender():faction():name() == "xyyhlyjf")
--                 then
--                     -- -- ModLog("kafka loose battle")
--                     incident = cm:modify_model():create_incident("kafka_mission_06");
--                     incident:add_character_target("target_character_1", leader);
--                     incident:trigger(cm:modify_faction(faction), true);
--                 end
--             end
--             cm:set_saved_value("kafka_leader_military_force", false)
--         end
--     end,
--     true
-- )

core:add_listener(
    "kafka_mission_05_a_check", -- Unique handle
    "CampaignBattleLoggedEvent", -- Campaign Event to listen for
    function(context)
        if not cm:get_saved_value("kafka_mission_leader") then
            return false
        end
        local log_entry = context:log_entry();
        local pending_battle = pending_battle_cache:get_pending_battle_cache()
        local leader = gst.character_query_for_template(cm:get_saved_value("kafka_mission_leader"));
        local kafka = gst.character_query_for_template("hlyjcj");
        local faction = leader:faction();
        if faction:is_mission_active("kafka_mission_05_a") then
            local was_leader_in_battle = pending_battle:was_character_in_battle(leader);
            local was_kafka_in_battle = pending_battle:was_character_in_battle(kafka);
            local was_my_faction_lose = false
            local enemy_is_xyyhlyjf = false

            for i = 0, log_entry:losing_characters():num_items() - 1 do
                local character = log_entry:losing_characters():item_at(i):character();
                if character:faction():name() == faction:name() then
                    was_my_faction_lose = true;
                    break;
                end
            end;
            
            if log_entry:winning_factions():contains(cm:query_faction("xyyhlyjf")) then
                enemy_is_xyyhlyjf = true;
            else
                for i = 0, log_entry:winning_characters():num_items() - 1 do
                    local character = log_entry:winning_characters():item_at(i):character();
                    if character:faction():name() == "xyyhlyjf" then
                        enemy_is_xyyhlyjf = true;
                        break;
                    end
                end;
            end
            if was_leader_in_battle 
            and was_kafka_in_battle 
            and was_my_faction_lose 
            and enemy_is_xyyhlyjf 
            then
                return true
            end
        end
        return false;
    end,
    function(context) -- What to do if listener fires.
        local leader = gst.character_query_for_template(cm:get_saved_value("kafka_mission_leader"));
        local faction = leader:faction();
        if faction:is_mission_active("kafka_mission_05_a") then
            cm:modify_faction(faction):cancel_custom_mission("kafka_mission_05_a")
            -- -- ModLog("loose battle")
            cm:set_saved_value("trigger_kafka_mission_06", true)
            incident = cm:modify_model():create_incident("kafka_mission_06");
            incident:add_character_target("target_character_1", leader);
            incident:trigger(cm:modify_faction(faction), true);
        end
        return;
    end,
    true --Is persistent
);


core:add_listener(
    "leader_dead",
    "CharacterDied",
    function(context)
        return cm:get_saved_value("kafka_mission_leader") and context:query_character():generation_template_key() == cm:get_saved_value("kafka_mission_leader");
    end,
    function(context)
        cm:set_saved_value("leader_dead",true);
    end,
    true
)

core:add_listener(
    "kafka_defected",
    "CharacterDefectedEvent",
    function(context)
        return context:query_character():generation_template_key() == "hlyjcj";
    end,
    function(context)
        -- -- ModLog("卡芙卡叛逃")
    end,
    true
)

core:add_listener(
    "kafka_mission_06",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "kafka_mission_06";
    end,
    function(context)
        --gst.character_add_to_faction(cm:get_saved_value("kafka_mission_leader"), context:faction():name(), leader:character_subtype_key());
        --gst.faction_set_minister_position(cm:get_saved_value("kafka_mission_leader"),"faction_leader");
        
        local modify_hlyjdingzhia = cm:modify_character(gst.character_query_for_template("hlyjdingzhia"));
        modify_hlyjdingzhia:remove_effect_bundle("huanlong_unbreakable");
        
        cm:modify_faction(context:faction()):cancel_custom_mission("kafka_mission_05_a")
        cm:modify_character(context:faction():faction_leader()):remove_effect_bundle("character_captives_escape_force");
        cm:modify_character(gst.character_query_for_template("hlyjcj")):remove_effect_bundle("character_captives_escape_force");
        cm:set_saved_value("summon_hlyjdingzhie",0);
        cm:set_saved_value("trigger_kafka_mission_06", nil)
    end,
    false
)


core:add_listener(
    "kafka_mission_06_choice",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_06_choice" and (context:choice() == 0 or context:choice() == 1);
    end, -- criteria
    function (context) --what to do if listener fires
        local query_faction = player_faction_key;
        if context:choice() == 0 then
        end
        if context:choice() == 1 then
            local tingyun = gst.character_add_to_faction("hlyjdingzhie", context:faction():name(), "3k_general_water")
            local kafka = gst.character_query_for_template("hlyjcj");
            cm:modify_character(tingyun):apply_relationship_trigger_set(kafka, "3k_main_relationship_trigger_set_event_negative_generic_extreme");
            cm:modify_character(tingyun):apply_relationship_trigger_set(kafka, "3k_main_relationship_trigger_set_event_negative_dilemma_extreme");
            cm:modify_character(tingyun):apply_relationship_trigger_set(kafka, "3k_main_relationship_trigger_set_event_negative_bad_omen");
        end
    end,   
    false
)

core:add_listener(
    "hlyjdingzhie_join_event",
    "ActiveCharacterCreated",
    function(context) 
        return context:query_character():generation_template_key() == "hlyjdingzhie";
    end,
    function (context)
        local tingyun = context:query_character()
        incident = cm:modify_model():create_incident("summon_hlyjdingzhie");
        incident:add_character_target("target_character_1", tingyun);
        incident:add_faction_target("target_faction_1", context:query_character():faction());
        incident:trigger(cm:modify_faction(context:query_character():faction()), true);
        gst.character_close_agent("hlyjdingzhie");
    end,   
    false
)
 

core:add_listener(
    "kafka_mission_07_choice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "kafka_mission_07_choice" ;
    end,
    function(context)
        if context:choice() == 0 then
            cm:trigger_mission(context:faction(),"kafka_mission_07", true);
        end
    end,
    false
)

core:add_listener(
    "kafka_mission_07_1_choice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "kafka_mission_07_1_choice" ;
    end,
    function(context)
        if context:choice() == 1 then
            cm:set_saved_value("kafka_mission_07_2_incident", true)
        end
    end,
    false
)

core:add_listener(
    "kafka_mission_07_3_choice",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "kafka_mission_07_3_choice" ;
    end,
    function(context)
        if context:choice() == 0 then
            -- -- ModLog("debug: kafka_mission_07_3_choice = 0")
            cm:modify_faction(context:faction()):ceo_management():add_ceo("hlyjdingzhibzuoqi")
            cm:trigger_mission(context:faction(),"kafka_mission_07_3", true);
        else
            -- -- ModLog("debug: kafka_mission_07_3_choice = 1")
            -- -- ModLog("debug: set kafka_mission_07_choice, true")
            cm:set_saved_value("kafka_mission_07_choice",true);
        end
    end,
    false
)

core:add_listener(
    "kafka_mission_07_3_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_07_3";
    end,
    function(context)
        -- -- ModLog("debug: set kafka_mission_07_choice, true")
        cm:set_saved_value("kafka_mission_07_choice",true);
        -- -- ModLog("debug: set is_kafka_have_horse, true")
        cm:set_saved_value("is_kafka_have_horse",true);
    end,
    false
)

core:add_listener(
    "hlyjdingzhie_joins", -- Unique handle
    "ActiveCharacterCreated", -- Campaign Event to listen for
    function(context) -- Criteria
        if context:query_character():generation_template_key() == "hlyjdingzhie" then
            return true
        end
    end,
    function(context)
        gst.character_close_agent("hlyjdingzhie");
        cm:modify_character(context:query_character()):ceo_management():add_ceo("3k_ytr_ceo_trait_personality_heaven_tranquil");
    end,
    true --Is persistent
)

core:add_listener(
    "kafka_mission_08_incident",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "kafka_mission_08_incident";
    end,
    function(context)
        local mission = string_mission:new("kafka_mission_08");
		mission:add_primary_objective("CONTROL_N_REGIONS_INCLUDING", {"total 2","region 3k_main_changan_capital", "region 3k_main_changan_resource_1"});
		mission:add_primary_payload("money 5000");
		--mission:set_turn_limit(40);
		mission:trigger_mission_for_faction(context:faction():name());
-- 		trigger_kafka_mission_05(context:faction():name());
        
        gst.faction_set_minister_position("hlyjdingzhid","faction_leader");
        cm:trigger_mission(context:faction(),"kafka_mission_09", true);
        gst.faction_set_minister_position("hlyjdingzhia","faction_leader");
        local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
        remove_freeze(hlyjdingzhia:cqi())
    end,
    false
)

core:add_listener(
    "kafka_mission_09_mission",
    "CharacterWoundReceivedEvent",
    function(context)
        if cm:get_saved_value("kafka_mission_faction") then
            local player_faction_key = cm:get_saved_value("kafka_mission_faction")
            return cm:query_faction(player_faction_key) and cm:query_faction(player_faction_key):is_mission_active("kafka_mission_09");
        else
            return false
        end
    end,
    function(context)
        if context:query_character():generation_template_key() == "hlyjdingzhid"
        and not context:query_character():won_battle()
        then
            local faction = cm:query_faction(player_faction_key)
            cm:modify_faction(faction):complete_custom_mission("kafka_mission_09")
        end
    end,
    true
)

core:add_listener(
    "kafka_mission_09_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_09";
    end,
    function(context)
        local general = gst.character_query_for_template("hlyjdingzhid");
        if not general:has_garrison_residence() and not cm:is_multiplayer() then
            cm:modify_character(general):kill_character(false);
        end
        cm:set_saved_value("kill_character_hlyjdingzhid",true);
        gst.faction_add_tickets(context:faction():name(), 10);
--         incident = cm:modify_model():create_incident("kafka_mission_09_incident");
--         incident:add_character_target("target_character_1", hlyjdingzhia);
--         incident:add_faction_target("target_faction_1", context:faction());
--         incident:trigger(cm:modify_faction(context:faction()), true);
    end,
    false
)

core:add_listener(
    "summon_hlyjby_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "summon_hlyjby";
    end,
    function(context)
        gst.faction_add_tickets(context:faction():name(), 5);
    end,
    false
)

core:add_listener(
    "kafka_mission_08_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_08";
    end,
    function(context)
        cm:trigger_dilemma(context:faction():name(),"kafka_mission_09_dilemma", true);
    end,
    false
)

core:add_listener(
    "kafka_mission_09_failed",
    "MissionFailed ",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_09";
    end,
    function(context)
        cm:set_saved_value("kafka_mission_09",true);
    end,
    true
)

core:add_listener(
    "kafka_mission_09_cancel",
    "MissionCancelled ",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_09";
    end,
    function(context)
        cm:set_saved_value("kafka_mission_09",true);
    end,
    false
)

core:add_listener(
    "kafka_mission_10_a_incident",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "kafka_mission_10_a_incident";
    end,
    function(context)
        local hlyjdingzhie = gst.character_query_for_template("hlyjdingzhie");
        cm:modify_character(hlyjdingzhie):move_to_faction_and_make_recruited("xyyhlyjf")
        
        cm:set_saved_value("kafka_mission_10_a_incident", true);
        
        cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi")
        gst.character_CEO_equip("hlyjdingzhie","hlyjdingzhiewuqi","3k_main_ceo_category_ancillary_weapon");
        cm:modify_character(context:faction():faction_leader()):apply_relationship_trigger_set(hlyjdingzhie, "3k_main_relationship_trigger_set_event_negative_betrayed");
        cm:modify_character(hlyjdingzhie):apply_effect_bundle("hlyjdingzhie_effect", -1);
        
        
    end,
    false
)

core:add_listener(
    "kafka_mission_11_a_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "kafka_mission_11_a_dilemma" and context:choice() == 0;
    end,
    function(context)
        local hlyjdingzhie = gst.character_query_for_template("hlyjdingzhie");
        if not hlyjdingzhie:has_military_force() or not hlyjdingzhie:military_force() then
            local xyyhlyjf = cm:query_faction("xyyhlyjf");
            found_pos, x, y = xyyhlyjf:get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
            cm:create_force_with_existing_general(hlyjdingzhie:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhie_force", nil, 100);
            
            local modify_force = cm:modify_military_force(hlyjdingzhie:military_force());
            
            local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
            local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
            
            modify_character_1:add_experience(295000,0);
            modify_character_2:add_experience(295000,0);
            
            if modify_force:query_military_force():character_list():num_items() < 3 then
                modify_force:add_existing_character_as_retinue(modify_character_1, true);
            end
            if modify_force:query_military_force():character_list():num_items() < 3 then
                modify_force:add_existing_character_as_retinue(modify_character_2, true);
            end
        end
        --cm:modify_character(hlyjdingzhie):apply_effect_bundle("freeze", 1);
        add_freeze(hlyjdingzhie:cqi())
        gst.faction_set_minister_position("hlyjdingzhie","faction_leader");
        if not context:faction():is_mission_active("kafka_mission_12_a") then
            cm:trigger_mission(context:faction(),"kafka_mission_12_a", true);
        end
        gst.faction_set_minister_position("hlyjdingzhia","faction_leader");
    end,
    false
)

core:add_listener(
    "kafka_mission_11_b_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() ==  "kafka_mission_11_b_dilemma" and context:choice() == 1;
    end,
    function(context)
        cm:trigger_incident(context:faction():name(),"kafka_mission_11_b_incident", true);
    end,
    false
)

core:add_listener(
    "kafka_mission_12_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return (context:dilemma() ==  "kafka_mission_12_dilemma" or context:dilemma() ==  "kafka_mission_12_a_dilemma") and (context:choice() == 0 or context:choice() == 1);
    end,
    function(context)
        if context:choice() == 0 then
            cm:set_saved_value("kafka_mission_12_a",true);
            cm:set_saved_value("is_kafka_leaved", true);
            cm:trigger_incident(context:faction():name(),"kafka_mission_13_a_incident", true);
            local hlyjdingzhie = gst.character_add_to_faction("hlyjdingzhie", "xyyhlyjf", "3k_general_water");
            cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi");
            gst.character_CEO_equip("hlyjdingzhie","hlyjdingzhiewuqi","3k_main_ceo_category_ancillary_weapon");
            local kafka = gst.character_query_for_template("hlyjcj");
            
            gst.character_runaway("hlyjcj")
            
            if context:faction():ceo_management():has_ceo_equipped("hlyjcjwuqi") then
                cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjcjwuqi");
                gst.character_CEO_equip("hlyjcj","hlyjcjwuqi","3k_main_ceo_category_ancillary_weapon");
            end
            
            gst.faction_random_kill_character(context:faction():name(),5);
            cm:modify_character(context:faction():faction_leader()):apply_relationship_trigger_set(hlyjdingzhie, "3k_main_relationship_trigger_set_event_negative_betrayed");
            cm:modify_character(context:faction():faction_leader()):apply_relationship_trigger_set(kafka, "3k_main_relationship_trigger_set_event_negative_betrayed");
        elseif context:choice() == 1 then
            cm:trigger_incident(context:faction():name(), "kafka_mission_13_b_incident", true);
            local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
            gst.character_been_killed("hlyjdingzhie");
            cm:modify_character(hlyjdingzhia):ceo_management():remove_ceos("kafka_mission_complete_01");
            cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_04");
            cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi");
            
            cm:modify_faction(cm:query_faction("xyyhlyjf")):ceo_management():remove_ceos("hlyjdingzhiayifu");
            gst.character_CEO_equip("hlyjdingzhia","hlyjdingzhibyifu","3k_main_ceo_category_ancillary_armour");
            
            cm:set_saved_value("hlyjdingzhie_has_been_killed",true);
            cm:modify_faction("xyyhlyjf"):remove_effect_bundle("huanlong_event_buff");
        end
    end,
    false
)

core:add_listener(
    "kafka_mission_12_a_mission",
    "CharacterWoundReceivedEvent",
    function(context)
        if cm:get_saved_value("kafka_mission_faction") then
            local player_faction_key = cm:get_saved_value("kafka_mission_faction")
            return cm:query_faction(player_faction_key) and cm:query_faction(player_faction_key):is_mission_active("kafka_mission_12_a");
        else
            return false
        end
    end,
    function(context)
        if context:query_character():generation_template_key() == "hlyjdingzhie"
        and not context:query_character():won_battle()
        then
            local faction = cm:query_faction(player_faction_key);
            cm:modify_faction(faction):complete_custom_mission("kafka_mission_12_a")
        end
    end,
    true
)

core:add_listener(
    "kafka_mission_12_a_failed",
    "MissionFailed",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_12_a";
    end,
    function(context)
        cm:set_saved_value("kafka_mission_12_a",true);
    end,
    true
)

core:add_listener(
    "kafka_mission_12_a_cancel",
    "MissionCancelled",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_12_a";
    end,
    function(context)
        cm:set_saved_value("kafka_mission_12_a",true);
    end,
    true
)

core:add_listener(
    "kafka_mission_12_a_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_12_a";
    end,
    function(context)
        local tingyun = gst.character_query_for_template("hlyjdingzhie")
        
        if not tingyun:has_garrison_residence() and not cm:is_multiplayer() then
            cm:modify_character(tingyun):kill_character(false);
        end 
        cm:set_saved_value("kill_character_hlyjdingzhie",true);
        cm:set_saved_value("hlyjdingzhie_has_been_killed",true);
            cm:modify_faction("xyyhlyjf"):remove_effect_bundle("huanlong_event_buff");
    end,
    false
)

--[[
core:add_listener(
    "kafka_mission_14_mission",
    "BattleCompletedCameraMove",
    function(context)
        local faction = get_player_faction()
        return faction:is_mission_active("kafka_mission_14") or faction:is_mission_active("kafka_mission_14_a")
    end,
    function(context)
        local faction = get_player_faction()
        local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
        if cm:get_saved_value("huanlong_wounded")
        and cm:get_saved_value("huanlong_wounded") >= 1
        then
            if context:faction():is_mission_active("kafka_mission_14") then
                cm:modify_faction(faction):complete_custom_mission("kafka_mission_14")
            end
            if context:faction():is_mission_active("kafka_mission_14_a") then
                cm:modify_faction(faction):complete_custom_mission("kafka_mission_14_a")
            end
        end
    end,
    true
)]]

core:add_listener(
    "kafka_mission_14_start",
    "MissionIssued",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_14"
        or context:mission():mission_record_key() == "kafka_mission_14_a"
        or context:mission():mission_record_key() == "kafka_mission_16_kafka_leader";
    end,
    function(context)
        cm:set_saved_value("kafka_mission_14_triggered",true)
    end,
    false
)

core:add_listener(
    "kafka_mission_14_success",
    "MissionSucceeded",
    function(context)
        return 
        context:mission():mission_record_key() == "kafka_mission_14"
        or context:mission():mission_record_key() == "kafka_mission_14_a"
        or context:mission():mission_record_key() == "kafka_mission_16_kafka_leader";
    end,
    function(context)
        local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
        local xyyhlyjf = cm:query_faction("xyyhlyjf");
        cm:modify_faction(cm:query_faction("xyyhlyjf")):ceo_management():remove_ceos("hlyjdingzhibyifu");
        gst.character_CEO_equip("hlyjdingzhia","hlyjdingzhicyifu","3k_main_ceo_category_ancillary_armour");
        cm:set_saved_value("trigger_kafka_mission_15",true)
    end,
    false
)


--[[

core:add_listener(
    "kafka_mission_15_mission",
    "BattleCompletedCameraMove",
    function(context)
        local faction = get_player_faction()
        return faction:is_mission_active("kafka_mission_15") or faction:is_mission_active("kafka_mission_15_a")
    end,
    function(context)
        local faction = get_player_faction()
        local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
        if cm:get_saved_value("huanlong_wounded")
        and cm:get_saved_value("huanlong_wounded") >= 1
        then
            if context:faction():is_mission_active("kafka_mission_15") then
                cm:modify_faction(faction):complete_custom_mission("kafka_mission_15")
            end
            if context:faction():is_mission_active("kafka_mission_15_a") then
                cm:modify_faction(faction):complete_custom_mission("kafka_mission_15_a")
            end
        end
    end,
    true
)]]


core:add_listener(
    "kafka_mission_15_success",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_15" or context:mission():mission_record_key() == "kafka_mission_15_a";
    end,
    function(context)
        cm:set_saved_value("huanlong_dead",true);
        local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
        local hlyjck_dark = gst.character_query_for_template("hlyjck_dark");
        local hlyjdy_dark = gst.character_query_for_template("hlyjdy_dark");
        local hlyjcm_dark = gst.character_query_for_template("hlyjcm_dark");
        local hlyjda_dark = gst.character_query_for_template("hlyjda_dark");
        local hlyjeb_dark = gst.character_query_for_template("hlyjeb_dark");
        if not hlyjdingzhia:has_garrison_residence() and not cm:is_multiplayer() then
            cm:modify_character(hlyjdingzhia):kill_character(false);
            if not hlyjck_dark:is_dead() then
                cm:modify_character(hlyjck_dark):kill_character(false);
            end
            if not hlyjdy_dark:is_dead() then
                cm:modify_character(hlyjdy_dark):kill_character(false);
            end
            if not hlyjcm_dark:is_dead() then
                cm:modify_character(hlyjcm_dark):kill_character(false);
            end
            if not hlyjda_dark:is_dead() then
                cm:modify_character(hlyjda_dark):kill_character(false);
            end
            if not hlyjeb_dark:is_dead() then
                cm:modify_character(hlyjeb_dark):kill_character(false);
            end
        end
    end,
    false
)




--幻胧剧情线
core:add_listener(
    "xyyhlyjf_listener",
    "FactionTurnStart",
        
    function(context)
        return context:faction():name() == "xyyhlyjf" and not cm:get_saved_value("roguelike_mode");
    end,

    function(context)
        --cm:set_saved_value("huanlong_wounded",0);
        
        if cm:get_saved_value("kafka_mission_summon_huanlong") then
            -- -- ModLog("debug: 幻胧点数 = "..cm:get_saved_value("kafka_mission_summon_huanlong"));
        end
        local world_faction_list = cm:query_model():world():faction_list();
        local xyyhlyjf = cm:query_faction("xyyhlyjf")
        if xyyhlyjf and not xyyhlyjf:is_dead() then
            local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
            if cm:get_saved_value("huanlong_dead") 
            or hlyjdingzhia:is_dead() then
                if not hlyjdingzhia:is_dead() then
                    cm:modify_character(hlyjdingzhia):kill_character(false);
                elseif not cm:get_saved_value("huanlong_dead") then
                    cm:set_saved_value("huanlong_dead",true)
                end
                ModLog("huanlong_dead")
                local region_list = xyyhlyjf:region_list();
                local character_list = xyyhlyjf:character_list();
                local capital_region = xyyhlyjf:capital_region()
                local rebels = "3k_dlc04_faction_rebels"
                if not cm:query_faction(rebels) 
                or cm:query_faction(rebels):is_null_interface() 
                then
                    rebels = "3k_main_faction_rebels"
                end
                cm:modify_region(capital_region):settlement_gifted_as_if_by_payload(cm:modify_faction(rebels));
                
                for i = 0 , region_list:num_items() - 1 do
                    local region = region_list:item_at(i);
                    ModLog(region:name());
                    cm:modify_region(region):raze_and_abandon_settlement_without_attacking();
                end
                for i = 0, character_list:num_items() - 1 do
                    local query_character = character_list:item_at(i);
                    if not query_character:is_null_interface()
                    and not query_character:is_dead()
                    then
                        local key = query_character:generation_template_key()
                        ModLog(key)
                        if key ~= "hlyjdingzhia"
                        and key ~= "hlyjdingzhid"
                        and key ~= "hlyjdingzhie"
                        and not string.find(key, "xyyhlyjf")
                        then
                            cm:modify_character(query_character):move_to_faction_and_make_recruited(rebels)
                        else
                            cm:modify_character(query_character):kill_character(false);
                        end
                    end
                end
                diplomacy_manager:force_confederation(rebels, "xyyhlyjf");
                
                local character = gst.character_add_to_faction("hlyjdw", player_faction_key, gst.all_character_detils["hlyjdw"]['subtype']);
                cm:modify_character(character):add_experience(88000,0);
                cm:modify_character(character):reset_skills();
                
                if not is_tingyun_unlock() and not cm:get_saved_value("xyy_cheat_mode") then
                    tingyun_unlock()
                    local incident = cm:modify_model():create_incident("unlock_hlyjdw");
                    incident:add_character_target("target_character_1", character);
                    incident:add_faction_target("target_faction_1", cm:query_faction(player_faction_key));
                    incident:trigger(cm:modify_faction(player_faction_key), true);
                else
                    local incident = cm:modify_model():create_incident("summon_hlyjdw");
                    incident:add_character_target("target_character_1", character);
                    incident:add_faction_target("target_faction_1", cm:query_faction(player_faction_key));
                    incident:trigger(cm:modify_faction(player_faction_key), true);
                end
                
                local hlyjck_dark = gst.character_query_for_template("hlyjck_dark");
                local hlyjdy_dark = gst.character_query_for_template("hlyjdy_dark");
                local hlyjcm_dark = gst.character_query_for_template("hlyjcm_dark");
                local hlyjda_dark = gst.character_query_for_template("hlyjda_dark");
                local hlyjeb_dark = gst.character_query_for_template("hlyjeb_dark");
                if not hlyjck_dark:is_dead() then
                    cm:modify_character(hlyjck_dark):kill_character(false);
                end
                if not hlyjdy_dark:is_dead() then
                    cm:modify_character(hlyjdy_dark):kill_character(false);
                end
                if not hlyjcm_dark:is_dead() then
                    cm:modify_character(hlyjcm_dark):kill_character(false);
                end
                if not hlyjda_dark:is_dead() then
                    cm:modify_character(hlyjda_dark):kill_character(false);
                end
                if not hlyjeb_dark:is_dead() then
                    cm:modify_character(hlyjeb_dark):kill_character(false);
                end
                
                return
            end
            for i = 0, world_faction_list:num_items() - 1 do
                local q_faction = world_faction_list:item_at(i)
                if not q_faction:is_dead() and q_faction:name() ~= "xyyhlyjf" and not xyyhlyjf:has_specified_diplomatic_deal_with("data_defined_situation_war_proposer_to_recipient", q_faction) then
                    diplomacy_manager:apply_automatic_deal_between_factions("xyyhlyjf", q_faction:name(), "data_defined_situation_war_proposer_to_recipient")
                    -- -- ModLog("xyyhlyjf向"..q_faction:name().."宣战了");
                end;
            end;
            if cm:get_saved_value("kill_character_hlyjdingzhid") then
                local general = gst.character_query_for_template("hlyjdingzhid");
                cm:modify_character(general):kill_character(false);
                
                cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_03");
                cm:set_saved_value("kill_character_hlyjdingzhid",false)
            end;
            if cm:get_saved_value("kill_character_hlyjdingzhie") then
                local hlyjdingzhie = gst.character_query_for_template("hlyjdingzhie");
                if not hlyjdingzhie:is_null_interface()
                and not hlyjdingzhie:is_dead()
                then
                    cm:modify_character(hlyjdingzhie):kill_character(false);
                end
                ModLog("kill_hlyjdingzhie")
                cm:modify_character(hlyjdingzhia):ceo_management():remove_ceos("kafka_mission_complete_01");
                cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_04");
                cm:modify_faction(context:faction()):ceo_management():remove_ceos("hlyjdingzhiewuqi");
                cm:modify_faction(cm:query_faction("xyyhlyjf")):ceo_management():remove_ceos("hlyjdingzhiayifu");
                gst.character_CEO_equip("hlyjdingzhia","hlyjdingzhibyifu","3k_main_ceo_category_ancillary_armour");
                cm:set_saved_value("kill_character_hlyjdingzhie",false)
            end;
            if cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                cm:modify_faction(context:faction()):complete_custom_mission("kafka_mission_12_a")
            end;
            if cm:get_saved_value("kafka_mission_summon_huanlong") then
                local calendar = cm:get_saved_value("kafka_mission_summon_huanlong");
                if calendar >= 2 and not cm:get_saved_value("calendar_2") then
                    cm:set_saved_value("calendar_2",true);
                    local region_list = {"3k_main_shoufang_capital", "3k_main_shoufang_resource_1", "3k_main_shoufang_resource_2", 
                    "3k_main_shoufang_resource_3", "3k_main_wuwei_capital", "3k_main_wuwei_resource_1", "3k_main_wuwei_resource_2", 
                    "3k_main_anding_capital", "3k_main_anding_resource_1", "3k_main_anding_resource_2", "3k_main_anding_resource_3", }

                    for _,i in ipairs(region_list) do
                        gst.region_set_manager(i,"xyyhlyjf")
                    end
                end
                if calendar >= 3 and not cm:get_saved_value("calendar_3") then
                    cm:set_saved_value("calendar_3",true);
                    local region_list = {"3k_main_wudu_capital", "3k_main_wudu_resource_1", "3k_main_hanzhong_capital", 
                    "3k_main_hanzhong_resource_1", "3k_main_jincheng_capital", "3k_main_jincheng_resource_1", 
                    "3k_main_jincheng_resource_2", "3k_dlc06_san_pass", }

                    for _,i in ipairs(region_list) do
                        gst.region_set_manager(i,"xyyhlyjf")
                    end
                    
                    add_force_to_xyyhlyjf()
                end
                if calendar >= 6 and not cm:get_saved_value("calendar_6") then
                    add_force_to_xyyhlyjf()
                    local mission = string_mission:new("kafka_mission_huanlong_01");
                    mission:add_primary_objective("DEFEAT_N_ARMIES_OF_FACTION", {"total 5","faction xyyhlyjf"});
                    mission:add_primary_payload("money 150000");
                    mission:set_turn_limit(50);
                    mission:trigger_mission_for_faction(player_faction_key);
                    cm:set_saved_value("calendar_6", true);
                end
                if calendar >= 7 and not cm:get_saved_value("calendar_7") then
                    gst.faction_military_teleport_to_region(hlyjdingzhia, "3k_main_changan_capital")
                    cm:modify_character(hlyjdingzhia):replenish_action_points()
                    cm:modify_character(hlyjdingzhia):attack_settlement(cm:query_region("3k_main_changan_capital"):settlement())
                    cm:set_saved_value("calendar_7", true);
                end
                if calendar >= 8 and not cm:get_saved_value("summoned_hlyjdingzhid") then
                    if cm:get_saved_value("kafka_mission_07_choice") then
                        cm:set_saved_value("kafka_mission_07_choice",false);
                        
                        cm:modify_region("3k_main_changan_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
                        cm:modify_region("3k_main_changan_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
                        
                        local region_list = {"3k_main_shoufang_capital", "3k_main_shoufang_resource_1", "3k_main_shoufang_resource_2", 
                        "3k_main_shoufang_resource_3", "3k_main_wuwei_capital", "3k_main_wuwei_resource_1", "3k_main_wuwei_resource_2", 
                        "3k_main_anding_capital", "3k_main_anding_resource_1", "3k_main_anding_resource_2", "3k_main_anding_resource_3", 
                        "3k_main_jincheng_capital", "3k_main_jincheng_resource_1", "3k_main_jincheng_resource_2", "3k_main_wudu_capital", 
                        "3k_main_wudu_resource_1", "3k_main_hanzhong_capital", "3k_main_hanzhong_resource_1", "3k_dlc06_san_pass", 
                        "3k_dlc06_tong_pass"}

                        for _,i in ipairs(region_list) do
                            gst.region_set_manager(i,"xyyhlyjf")
                        end

                        local modify_xyyhlyjf = cm:modify_faction("xyyhlyjf")
                    
                        modify_xyyhlyjf:make_region_capital(cm:query_region("3k_main_changan_capital"));
                        
                        local hlyjdingzhid = gst.character_add_to_faction("hlyjdingzhid", "xyyhlyjf", "3k_general_destroy");
                        
                        cm:modify_character(hlyjdingzhid):apply_effect_bundle("hlyjdingzhid_effect", -1);
                        add_freeze(hlyjdingzhid:cqi())
                        
                        cm:modify_character(hlyjdingzhid):add_experience(295000,0);
                        gst.character_add_CEO_and_equip("hlyjdingzhid", "hlyjdingzhiezuoqi", "3k_main_ceo_category_ancillary_mount")

                        local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
                        cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_02");
                        
                        local hlyjdingzhid_force = gst.faction_find_character_military_force(hlyjdingzhid)
                        
                        gst.faction_military_teleport_to_region(hlyjdingzhid, "3k_main_changan_capital")
                        
                        local modify_force = cm:modify_military_force(hlyjdingzhid_force);
                        
                        local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "hlyjdy_dark", false);
                        
                        gst.character_add_CEO_and_equip("hlyjdy_dark", "hlyjdywuqi_dark", "3k_main_ceo_category_ancillary_weapon")
                        gst.character_add_CEO_and_equip("hlyjdy_dark", "hlyjdingzhiezuoqi", "3k_main_ceo_category_ancillary_mount")
                        modify_xyyhlyjf:ceo_management():remove_ceos("hlyjdywuqi")
                        modify_character_1:ceo_management():remove_ceos("hlyjdyfujian")
                        gst.character_remove_all_traits(modify_character_1:query_character());
                        modify_character_1:ceo_management():add_ceo("dark_character");
                        modify_character_1:apply_effect_bundle("dark_character", -1)
                        modify_character_1:add_experience(295000, 0);
                        
                        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "hlyjck_dark", false);    
                        gst.character_CEO_unequip("hlyjck_dark", "hlyjckyanzhao");
                        gst.character_add_CEO_and_equip("hlyjck_dark", "3k_main_ancillary_accessory_art_of_war",
                            "3k_main_ceo_category_ancillary_accessory");
                        gst.character_add_CEO_and_equip("hlyjck_dark", "hlyjckwuqi_dark", "3k_main_ceo_category_ancillary_weapon");
                        gst.character_add_CEO_and_equip("hlyjck_dark", "hlyjdingzhiezuoqi", "3k_main_ceo_category_ancillary_mount")
                        modify_xyyhlyjf:ceo_management():remove_ceos("hlyjckwuqi_faction")
                        modify_character_2:ceo_management():remove_ceos("hlyjckyanzhao")
                        gst.character_remove_all_traits(modify_character_2:query_character());
                        modify_character_2:ceo_management():add_ceo("dark_character");
                        modify_character_2:apply_effect_bundle("dark_character", -1)
                        modify_character_2:add_experience(295000, 0);
                        
                        local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "hlyjcm_dark", false);    
                        gst.character_add_CEO_and_equip("hlyjcm_dark", "hlyjcmwuqi_dark", "3k_main_ceo_category_ancillary_weapon");
                        gst.character_add_CEO_and_equip("hlyjcm_dark", "hlyjdingzhiezuoqi", "3k_main_ceo_category_ancillary_mount")
                        modify_xyyhlyjf:ceo_management():remove_ceos("hlyjcmwuqi_faction")
                        gst.character_remove_all_traits(modify_character_3:query_character());
                        modify_character_3:ceo_management():add_ceo("dark_character");
                        modify_character_3:apply_effect_bundle("dark_character", -1)
                        modify_character_3:add_experience(295000, 0);
                        
                        local modify_character_4 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "hlyjda_dark", false);    
                        gst.character_add_CEO_and_equip("hlyjda_dark", "hlyjdawuqi_dark", "3k_main_ceo_category_ancillary_weapon");
                        gst.character_add_CEO_and_equip("hlyjda_dark", "hlyjdingzhiezuoqi", "3k_main_ceo_category_ancillary_mount")
                        modify_xyyhlyjf:ceo_management():remove_ceos("hlyjdawuqi_faction")
                        gst.character_remove_all_traits(modify_character_4:query_character());
                        modify_character_4:ceo_management():add_ceo("dark_character");
                        modify_character_4:apply_effect_bundle("dark_character", -1)
                        modify_character_4:add_experience(295000, 0);
                        
                        local modify_character_5 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_water", "hlyjeb_dark", false);    
                        gst.character_add_CEO_and_equip("hlyjda_dark", "hlyjdingzhiezuoqi", "3k_main_ceo_category_ancillary_mount")
                        gst.character_remove_all_traits(modify_character_5:query_character());
                        modify_character_5:ceo_management():add_ceo("dark_character");
                        modify_character_5:apply_effect_bundle("dark_character", -1)
                        modify_character_5:add_experience(295000, 0);
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_1, true);
                        end
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                        
                        cm:modify_faction(player_faction_key):make_region_seen_in_shroud("3k_main_changan_capital");
                        
                        cm:modify_faction(player_faction_key):make_region_seen_in_shroud("3k_main_changan_resource_1");
                        cm:trigger_incident(player_faction_key,"kafka_mission_08_incident", true);
                        cm:set_saved_value("summoned_hlyjdingzhid",true);
                    end
                end
                
                if calendar == 9 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                    add_force_to_xyyhlyjf()
                    add_force_to_xyyhlyjf()
                
                    local region_list = {"3k_dlc06_tong_pass", "3k_dlc06_wu_pass", "3k_dlc06_jiameng_pass",
                    "3k_main_baxi_capital", "3k_main_baxi_resource_1", "3k_main_baxi_resource_2"}

                    for _,i in ipairs(region_list) do
                        gst.region_set_manager(i,"xyyhlyjf")
                    end

                end
                if calendar == 10 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                
                    local region_list = {"3k_main_xihe_capital", "3k_main_xihe_resource_1", "3k_main_chengdu_capital", 
                    "3k_main_chengdu_resource_1", "3k_main_chengdu_resource_2", "3k_main_chengdu_resource_3", 
                    "3k_main_bajun_capital", "3k_main_bajun_resource_1", "3k_main_hedong_capital", 
                    "3k_main_hedong_resource_1", "3k_dlc06_hedong_resource_2", "3k_dlc06_tong_pass", "3k_dlc06_wu_pass", "3k_dlc06_jiameng_pass",
                    "3k_main_baxi_capital", "3k_main_baxi_resource_1", "3k_main_baxi_resource_2"}

                    for _,i in ipairs(region_list) do
                        gst.region_set_manager(i,"xyyhlyjf")
                    end
                end
                if calendar == 12 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                    add_force_to_xyyhlyjf()
                    cm:set_saved_value("calendar_10",true);
                    add_force_to_xyyhlyjf()
                    
                    local region_list = {"3k_main_badong_capital", "3k_main_badong_resource_1", "3k_main_badong_resource_2", 
                    "3k_main_wuling_capital", "3k_main_wuling_resource_1", "3k_main_wuling_resource_2", "3k_main_wuling_resource_3", 
                    "3k_dlc06_hangu_pass", "3k_main_luoyang_resource_1", "3k_main_taiyuan_capital", "3k_main_taiyuan_resource_1", 
                    "3k_main_taiyuan_resource_2", "3k_main_yanmen_capital", "3k_main_yanmen_resource_1", "3k_main_xihe_capital", "3k_main_xihe_resource_1", "3k_main_chengdu_capital", 
                    "3k_main_chengdu_resource_1", "3k_main_chengdu_resource_2", "3k_main_chengdu_resource_3", 
                    "3k_main_bajun_capital", "3k_main_bajun_resource_1", "3k_main_hedong_capital", 
                    "3k_main_hedong_resource_1", "3k_dlc06_hedong_resource_2", "3k_dlc06_tong_pass", "3k_dlc06_wu_pass", "3k_dlc06_jiameng_pass",
                    "3k_main_baxi_capital", "3k_main_baxi_resource_1", "3k_main_baxi_resource_2"}

                    for _,i in ipairs(region_list) do
                        gst.region_set_manager(i,"xyyhlyjf")
                    end
                end
                if calendar == 13 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                    local region_list = {"3k_dlc06_gu_pass", "3k_dlc06_qi_pass", "3k_dlc06_hulao_pass", "3k_main_luoyang_capital", 
                    "3k_main_taiyuan_capital", "3k_main_taiyuan_resource_1", "3k_main_taiyuan_resource_2", "3k_main_shangdang_capital", 
                    "3k_main_shangdang_resource_1", "3k_dlc06_shangdang_resource_2", "3k_main_zhongshan_capital", "3k_main_zhongshan_resource_1", "3k_main_badong_capital", "3k_main_badong_resource_1", "3k_main_badong_resource_2", 
                    "3k_main_wuling_capital", "3k_main_wuling_resource_1", "3k_main_wuling_resource_2", "3k_main_wuling_resource_3", 
                    "3k_dlc06_hangu_pass", "3k_main_luoyang_resource_1", "3k_main_taiyuan_capital", "3k_main_taiyuan_resource_1", 
                    "3k_main_taiyuan_resource_2", "3k_main_yanmen_capital", "3k_main_yanmen_resource_1", "3k_main_xihe_capital", "3k_main_xihe_resource_1", "3k_main_chengdu_capital", 
                    "3k_main_chengdu_resource_1", "3k_main_chengdu_resource_2", "3k_main_chengdu_resource_3", 
                    "3k_main_bajun_capital", "3k_main_bajun_resource_1", "3k_main_hedong_capital", 
                    "3k_main_hedong_resource_1", "3k_dlc06_hedong_resource_2", "3k_dlc06_tong_pass", "3k_dlc06_wu_pass", "3k_dlc06_jiameng_pass",
                    "3k_main_baxi_capital", "3k_main_baxi_resource_1", "3k_main_baxi_resource_2"}

                    for _,i in ipairs(region_list) do
                        gst.region_set_manager(i,"xyyhlyjf")
                    end
                end
                if calendar == 15 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                    local region_list = {"3k_main_anping_capital", "3k_main_anping_resource_1", "3k_main_weijun_capital", "3k_main_weijun_resource_1", 
                    "3k_main_henei_capital", "3k_main_henei_resource_1", "3k_main_nanyang_capital", "3k_main_nanyang_resource_1", 
                    "3k_main_yingchuan_capital", "3k_main_yingchuan_resource_1", "3k_dlc06_gu_pass", "3k_dlc06_qi_pass", "3k_dlc06_hulao_pass", "3k_main_luoyang_capital", 
                    "3k_main_taiyuan_capital", "3k_main_taiyuan_resource_1", "3k_main_taiyuan_resource_2", "3k_main_shangdang_capital", 
                    "3k_main_shangdang_resource_1", "3k_dlc06_shangdang_resource_2", "3k_main_zhongshan_capital", "3k_main_zhongshan_resource_1", "3k_main_badong_capital", "3k_main_badong_resource_1", "3k_main_badong_resource_2", 
                    "3k_main_wuling_capital", "3k_main_wuling_resource_1", "3k_main_wuling_resource_2", "3k_main_wuling_resource_3", 
                    "3k_dlc06_hangu_pass", "3k_main_luoyang_resource_1", "3k_main_taiyuan_capital", "3k_main_taiyuan_resource_1", 
                    "3k_main_taiyuan_resource_2", "3k_main_yanmen_capital", "3k_main_yanmen_resource_1", "3k_main_xihe_capital", "3k_main_xihe_resource_1", "3k_main_chengdu_capital", 
                    "3k_main_chengdu_resource_1", "3k_main_chengdu_resource_2", "3k_main_chengdu_resource_3", 
                    "3k_main_bajun_capital", "3k_main_bajun_resource_1", "3k_main_hedong_capital", 
                    "3k_main_hedong_resource_1", "3k_dlc06_hedong_resource_2", "3k_dlc06_tong_pass", "3k_dlc06_wu_pass", "3k_dlc06_jiameng_pass",
                    "3k_main_baxi_capital", "3k_main_baxi_resource_1", "3k_main_baxi_resource_2"}

                    for _,i in ipairs(region_list) do
                        gst.region_set_manager(i,"xyyhlyjf")
                    end
                end
                if calendar == 17 and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                    local region_list = {"3k_dlc06_kui_pass", "3k_main_xiangyang_capital", "3k_main_xiangyang_resource_1", "3k_main_jingzhou_capital", 
                    "3k_main_jingzhou_resource_1", "3k_main_daijun_capital", "3k_main_daijun_resource_1", "3k_main_bohai_capital", 
                    "3k_main_bohai_resource_1", "3k_main_pingyuan_capital", "3k_main_pingyuan_resource_1", "3k_main_anping_capital", "3k_main_anping_resource_1", "3k_main_weijun_capital", "3k_main_weijun_resource_1", 
                    "3k_main_henei_capital", "3k_main_henei_resource_1", "3k_main_nanyang_capital", "3k_main_nanyang_resource_1", 
                    "3k_main_yingchuan_capital", "3k_main_yingchuan_resource_1", "3k_dlc06_gu_pass", "3k_dlc06_qi_pass", "3k_dlc06_hulao_pass", "3k_main_luoyang_capital", 
                    "3k_main_taiyuan_capital", "3k_main_taiyuan_resource_1", "3k_main_taiyuan_resource_2", "3k_main_shangdang_capital", 
                    "3k_main_shangdang_resource_1", "3k_dlc06_shangdang_resource_2", "3k_main_zhongshan_capital", "3k_main_zhongshan_resource_1", "3k_main_badong_capital", "3k_main_badong_resource_1", "3k_main_badong_resource_2", 
                    "3k_main_wuling_capital", "3k_main_wuling_resource_1", "3k_main_wuling_resource_2", "3k_main_wuling_resource_3", 
                    "3k_dlc06_hangu_pass", "3k_main_luoyang_resource_1", "3k_main_taiyuan_capital", "3k_main_taiyuan_resource_1", 
                    "3k_main_taiyuan_resource_2", "3k_main_yanmen_capital", "3k_main_yanmen_resource_1", "3k_main_xihe_capital", "3k_main_xihe_resource_1", "3k_main_chengdu_capital", 
                    "3k_main_chengdu_resource_1", "3k_main_chengdu_resource_2", "3k_main_chengdu_resource_3", 
                    "3k_main_bajun_capital", "3k_main_bajun_resource_1", "3k_main_hedong_capital", 
                    "3k_main_hedong_resource_1", "3k_dlc06_hedong_resource_2", "3k_dlc06_tong_pass", "3k_dlc06_wu_pass", "3k_dlc06_jiameng_pass",
                    "3k_main_baxi_capital", "3k_main_baxi_resource_1", "3k_main_baxi_resource_2"}

                    for _,i in ipairs(region_list) do
                        gst.region_set_manager(i,"xyyhlyjf")
                    end
                end
                cm:set_saved_value("kafka_mission_summon_huanlong", calendar + 1);
            else
                local mission = string_mission:new("kafka_mission_huanlong_01");
                mission:add_primary_objective("DEFEAT_N_ARMIES_OF_FACTION", {"total 5","faction xyyhlyjf"});
                mission:add_primary_payload("money 150000");
                mission:set_turn_limit(50);
                mission:trigger_mission_for_faction(player_faction_key);
                cm:set_saved_value("kafka_mission_summon_huanlong", 11);
            end
            if cm:get_saved_value("kafka_mission_09") then
                
                local hlyjdingzhid = gst.character_query_for_template("hlyjdingzhid");
                
                found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
                
                if not hlyjdingzhid:has_military_force() or not hlyjdingzhid:military_force() then
                    cm:create_force_with_existing_general(hlyjdingzhid:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhie_force", nil, 100);
                    
                    add_freeze(hlyjdingzhid:cqi())
                    
                    cm:modify_character(hlyjdingzhid):add_experience(295000,0);
                    gst.character_add_CEO_and_equip("hlyjdingzhid", "hlyjdingzhiezuoqi", "3k_main_ceo_category_ancillary_mount")

                    local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
                    cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_02");
                    
                    found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region("3k_main_changan_capital", false);
                    
                    cm:create_force_with_existing_general(hlyjdingzhid:command_queue_index(), "xyyhlyjf", "", "3k_main_changan_capital", x, y, "hlyjdingzhid_force", nil, 100);
                    
                    local modify_force = cm:modify_military_force(hlyjdingzhid:military_force());
                    
                    local modify_character_1 = cm:modify_character(gst.character_query_for_template("hlyjdy_dark"))
                    if modify_character_1
                    and not modify_character_1:is_null_interface()
                    and not modify_character_1:is_dead()
                    then
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_1, true);
                        end
                    end
                    
                    local modify_character_2 = cm:modify_character(gst.character_query_for_template("hlyjck_dark"))
                    if modify_character_2
                    and not modify_character_2:is_null_interface()
                    and not modify_character_2:is_dead()
                    then
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                    end
                    
                    local modify_character_3 = cm:modify_character(gst.character_query_for_template("hlyjcm_dark"))
                    if modify_character_3
                    and not modify_character_3:is_null_interface()
                    and not modify_character_3:is_dead()
                    then
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_3, true);
                        else
                            modify_force = cm:modify_military_force(gst.faction_create_military_force("xyyhlyjf", "3k_main_changan_capital", "hlyjcm_dark"));
                        end
                    end
                    
                    local modify_character_4 = cm:modify_character(gst.character_query_for_template("hlyjda_dark"))
                    if modify_character_4
                    and not modify_character_4:is_null_interface()
                    and not modify_character_4:is_dead()
                    then
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_4, true);
                        end
                    end
                    
                    local modify_character_5 = cm:modify_character(gst.character_query_for_template("hlyjeb_dark"))
                    if modify_character_5
                    and not modify_character_5:is_null_interface()
                    and not modify_character_5:is_dead()
                    then
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_5, true);
                        end
                    end
                end
                
                add_freeze(hlyjdingzhid:cqi())
                
                gst.faction_set_minister_position("hlyjdingzhid","faction_leader");
                cm:trigger_mission(cm:query_faction(player_faction_key),"kafka_mission_09", true);
                gst.faction_set_minister_position("hlyjdingzhia","faction_leader");
                cm:set_saved_value("kafka_mission_09", false);
            end
            
            if cm:get_saved_value("kafka_mission_12_a") then
                local hlyjdingzhie = gst.character_query_for_template("hlyjdingzhie");
                found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
                if not hlyjdingzhie:has_military_force() or not hlyjdingzhie:military_force() then
                    cm:create_force_with_existing_general(hlyjdingzhie:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhie_force", nil, 100);
                    local modify_force = cm:modify_military_force(hlyjdingzhie:military_force());
                    local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                    local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                    modify_character_1:add_experience(295000,0);
                    modify_character_2:add_experience(295000,0);
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_1, true);
                    end
                    if modify_force:query_military_force():character_list():num_items() < 3 then
                        modify_force:add_existing_character_as_retinue(modify_character_2, true);
                    end
                end
                cm:modify_character(hlyjdingzhie):apply_effect_bundle("freeze", 1);
                gst.character_add_CEO_and_equip("hlyjdingzhie", "hlyjdingzhiezuoqi", "3k_main_ceo_category_ancillary_mount")
                add_freeze(hlyjdingzhie:cqi())
                gst.faction_set_minister_position("hlyjdingzhie","faction_leader");
                cm:trigger_mission(cm:query_faction(player_faction_key),"kafka_mission_12_a", true);
                gst.faction_set_minister_position("hlyjdingzhia","faction_leader");
                cm:set_saved_value("kafka_mission_12_a_trigger", true);
                cm:set_saved_value("kafka_mission_12_a", false);
            end
            
            if 
            cm:get_saved_value("trigger_kafka_mission_15") 
            and not cm:query_faction(player_faction_key):has_mission_been_issued("kafka_mission_15")
            and not cm:query_faction(player_faction_key):has_mission_been_issued("kafka_mission_15_a")  
            then 
                local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
                local xyyhlyjf = cm:query_faction("xyyhlyjf");
                local region = xyyhlyjf:capital_region():name()
                local hlyjdingzhia_force = gst.faction_find_character_military_force("hlyjdingzhia")
                if 1 then
                    if hlyjdingzhia_force then
                        local modify_force = cm:modify_military_force(hlyjdingzhia_force);
                        
                        -- -- ModLog("debug: trigger is_kafka_mission_15_"..hlyjdingzhia:command_queue_index());
                        
                        local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                        local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                        
                        modify_character_1:add_experience(295000,0);
                        modify_character_2:add_experience(295000,0);
                    
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                        ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_1, true);
                        end
                        
                        if modify_force:query_military_force():character_list():num_items() < 3 then
                            modify_force:add_existing_character_as_retinue(modify_character_2, true);
                        end
                        
                        gst.faction_military_teleport_to_region("hlyjdingzhia", region)
                    end
                    --cm:modify_character(hlyjdingzhia):apply_effect_bundle("freeze", -1);
                    add_freeze(hlyjdingzhia:cqi());
                    region = hlyjdingzhia:region():name()
                    local log_x = hlyjdingzhia:logical_position_x();
                    local log_y = hlyjdingzhia:logical_position_x();
                    if 1 then
                        found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 4, false);
                        
                        if x == 0 or y == 0 then
                            found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                            x = x1;
                            y = y1;
                        end
                        
                        local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_general", false);
                        
                        modify_character_1:add_experience(295000,0);
                        
                        -- -- ModLog(x.." "..y.." "..region)
                        
                        create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force1", nil, 100);
                            
                        if modify_character_1:query_character():has_military_force() then
                            -- -- ModLog("debug: trigger is_kafka_mission_15_modify_character_1")
                            local modify_force = cm:modify_military_force(modify_character_1:query_character():military_force());
                            
                            local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                            
                            local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                            
                            modify_character_2:add_experience(295000,0);
                            modify_character_3:add_experience(295000,0);
                        
                            if modify_force:query_military_force():character_list():num_items() < 3 then
                                modify_force:add_existing_character_as_retinue(modify_character_2, true);
                            end
                            
                            if modify_force:query_military_force():character_list():num_items() < 3 then
                                modify_force:add_existing_character_as_retinue(modify_character_3, true);
                            end
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            --modify_character_1:apply_effect_bundle("freeze",-1);
                            add_freeze(modify_character_1:query_character():cqi())
                        end
                    end
                    
                    if 1 then
                        found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 4, false);
                        
                        if x == 0 or y == 0 then
                            found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                            x = x1;
                            y = y1;
                        end
                        
                        local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_general", false);
                        modify_character_1:add_experience(295000,0);
                        
                        -- -- ModLog(x.." "..y.." "..region)
                        
                        create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force2", nil, 100);
                            
                        if modify_character_1:query_character():has_military_force() then
                            -- -- ModLog("debug: trigger is_kafka_mission_15_modify_character_2")
                            
                            local modify_force = cm:modify_military_force(modify_character_1:query_character():military_force());
                            
                            local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                            
                            local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                            
                            modify_character_2:add_experience(295000,0);
                            modify_character_3:add_experience(295000,0);
                                        
                            if modify_force:query_military_force():character_list():num_items() < 3 then
                                modify_force:add_existing_character_as_retinue(modify_character_2, true);
                            end
                            
                            if modify_force:query_military_force():character_list():num_items() < 3 then
                                modify_force:add_existing_character_as_retinue(modify_character_3, true);
                            end
                            
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            --modify_character_1:apply_effect_bundle("freeze",-1);
                            add_freeze(modify_character_1:query_character():cqi())
                        end
                    end
                    
                    if 1 then
                        found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 5, false);
                        
                        if x == 0 or y == 0 then
                            found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                            x = x1;
                            y = y1;
                        end
                        
                        local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_general", false);
                        modify_character_1:add_experience(295000,0);
                        
                        -- -- ModLog(x.." "..y.." "..region)
                        
                        create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force3", nil, 100);
                            
                        if modify_character_1:query_character():has_military_force() then
                            -- -- ModLog("debug: trigger is_kafka_mission_15_modify_character_3")
                            local modify_force = cm:modify_military_force(modify_character_1:query_character():military_force());
                            
                            local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                            
                            local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                            
                            modify_character_2:add_experience(295000,0);
                            modify_character_3:add_experience(295000,0);
                                        
                            if modify_force:query_military_force():character_list():num_items() < 3 then
                                modify_force:add_existing_character_as_retinue(modify_character_2, true);
                            end
                            
                            if modify_force:query_military_force():character_list():num_items() < 3 then
                                modify_force:add_existing_character_as_retinue(modify_character_3, true);
                            end
                            
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhicwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhicwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            --modify_character_1:apply_effect_bundle("freeze",-1);
                            add_freeze(modify_character_1:query_character():cqi())
                        end
                    end
                    
                    if 1 then
                        found_pos, x, y = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_near(log_x, log_y, 6, false);
                        
                        if x == 0 or y == 0 then
                            found_pos, x1, y1 = cm:query_faction("xyyhlyjf"):get_valid_spawn_location_in_region(region, false);
                            x = x1;
                            y = y1;
                        end
                        
                        local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_general", false);
                        modify_character_1:add_experience(295000,0);
                        
                        -- -- ModLog(x.." "..y.." "..region)
                        
                        create_force_with_existing_general(modify_character_1, "xyyhlyjf", "", region, x, y, "hlyjdingzhia_force4", nil, 100);
                            
                        if modify_character_1:query_character():has_military_force() then
                            -- -- ModLog("debug: trigger is_kafka_mission_15_modify_character_4")
                            local modify_force = cm:modify_military_force(modify_character_1:query_character():military_force());
                            
                            local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                            
                            local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                            
                            modify_character_2:add_experience(295000,0);
                            modify_character_3:add_experience(295000,0);
                                        
                            if modify_force:query_military_force():character_list():num_items() < 3 then
                                modify_force:add_existing_character_as_retinue(modify_character_2, true);
                            end
                            
                            if modify_force:query_military_force():character_list():num_items() < 3 then
                                modify_force:add_existing_character_as_retinue(modify_character_3, true);
                            end
                            
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_1:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            cdir_events_manager:add_or_remove_ceo_from_faction("xyyhlyjf", "hlyjdingzhibwuqi", true);
                            ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhibwuqi", "3k_main_ceo_category_ancillary_weapon");
                            
                            --modify_character_1:apply_effect_bundle("freeze",-1);
                            add_freeze(modify_character_1:query_character():cqi())
                        end
                    end
                end
                if gst.faction_is_character_deployed("hlyjdingzhia") then
                    if not cm:get_saved_value("is_kafka_leaved") then
                        cm:trigger_mission(cm:query_faction(player_faction_key), "kafka_mission_15",true);
                    else
                        cm:trigger_mission(cm:query_faction(player_faction_key), "kafka_mission_15_a",true);
                    end
                end
            end
            
            if cm:get_saved_value("kafka_mission_10_a_incident") and not cm:get_saved_value("hlyjdingzhie_has_been_killed") then
                local hlyjdingzhie = gst.character_query_for_template("hlyjdingzhie");
                
                --:modify_character(hlyjdingzhie):apply_effect_bundle("freeze", 1);
                add_freeze(hlyjdingzhie:cqi())
                
                cm:modify_character(hlyjdingzhie):add_experience(295000,0);
                
                if not hlyjdingzhie:military_force() or not hlyjdingzhie:has_military_force() then
                    local xyyhlyjf = cm:query_faction("xyyhlyjf");
            
                    found_pos, x, y = xyyhlyjf:get_valid_spawn_location_in_region(xyyhlyjf:capital_region():name(), false);
                    cm:create_force_with_existing_general(hlyjdingzhie:command_queue_index(), "xyyhlyjf", "", xyyhlyjf:capital_region():name(), x, y, "hlyjdingzhie_force", nil, 100);
                    
                    -- -- ModLog("debug: trigger is_kafka_mission_15" .. xyyhlyjf:capital_region():name() )
                end
                local modify_force = cm:modify_military_force(hlyjdingzhie:military_force());
                
                local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_wood", "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late", false);
                local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template("general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);    
                
                modify_character_1:add_experience(295000,0);
                modify_character_2:add_experience(295000,0);
                
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_1, true);
                end
                if modify_force:query_military_force():character_list():num_items() < 3 then
                    modify_force:add_existing_character_as_retinue(modify_character_2, true);
                end
                    
            end
        end;
    end,
    true
)

core:add_listener(
    "kafka_mission_huanlong_failed",
    "MissionFailed",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_huanlong";
    end,
    function(context)
        cm:trigger_dilemma(context:faction():name(),"kafka_mission_failed_dilemma", true);
    end,
    false
)
core:add_listener(
    "kafka_mission_huanlong_02_succcess",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_huanlong_02";
    end,
    function(context)
        if not cm:get_saved_value("is_kafka_leaved") then
            -- -- ModLog("debug: trigger kafka_mission_huanlong_03")
            local xyyhlyjf = cm:query_faction("xyyhlyjf");
            local town_number = xyyhlyjf:region_list():num_items() - 5;
            -- -- ModLog("debug: town_number = " .. town_number)
            if town_number > 10 then town_number = 10 end;
            if town_number < 5 then town_number = 5 end;
            local mission = string_mission:new("kafka_mission_huanlong_03");
            mission:add_primary_objective("DEFEAT_N_ARMIES_OF_FACTION", {"total ".. town_number ,"faction xyyhlyjf"});
            mission:add_primary_payload("money " .. town_number * 10000);
            mission:trigger_mission_for_faction(context:faction():name());
        end
    end,
    false
)
core:add_listener(
    "kafka_mission_failed_dilemma",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "kafka_mission_failed_dilemma" and (context:choice() == 0 or context:choice() == 1);
    end,
    function(context)
        local world_faction_list = cm:query_model():world():faction_list();
        local xyyhlyjf = cm:query_faction("xyyhlyjf")
        progression:force_campaign_defeat(player_faction_key)
        
        if not cm:query_faction(player_faction_key):is_dead() then
            local not_human = 0;
            -- -- ModLog("not_human = "..not_human);
            if not_human == 0 then
                local faction = context:faction();
                local region_list = faction:region_list()
                local character_list = faction:character_list()
                for i = 0, character_list:num_items() - 1 do
                    local character = character_list:item_at(i);
                    cm:modify_character(character):move_to_faction_and_make_recruited("xyyhlyjf");
                end;
                for i = 0, region_list:num_items() - 1 do
                    local region = region_list:item_at(i);
                    cm:modify_region(region:name()):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
                end;
            else
                if xyyhlyjf and not xyyhlyjf:is_dead() then
                    local random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items() - 1,0));
                    while (
                    not random_faction 
                    or random_faction:is_null_interface() 
                    or random_faction:is_dead() 
                    or not random_faction:region_list() 
                    or random_faction:region_list():num_items() == 0 
                    or random_faction:name() == player_faction_key
                    or random_faction:name() == "xyyhlyjf")
                    do
                        random_faction = world_faction_list:item_at(cm:random_int(world_faction_list:num_items() - 1,0));
                    end
                    diplomacy_manager:force_confederation("xyyhlyjf", random_faction:name());
                    -- -- ModLog("xyyhlyjf 吞并了 " .. random_faction:name());
                    cm:trigger_dilemma(context:faction():name(),"kafka_mission_failed_dilemma", true);
                end;
            end;
        end;
    end,
    true
)

core:add_listener(
    "kafka_mission_failed_incident",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "kafka_mission_failed_incident";
    end,
    function(context)
        cm:trigger_dilemma(context:faction():name(),"kafka_mission_failed_dilemma", true);
        
    end,
    false
)

core:add_listener(
    "xyyhlyjf_About_To_Die",
    "FactionAboutToDie",
	function(context)
        return not cm:get_saved_value("huanlong_dead") and context:faction():name() == "xyyhlyjf";
	end,
	function(context)
        cm:modify_region("3k_main_shoufang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_shoufang"));
        cm:modify_region("3k_main_shoufang_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
        cm:modify_region("3k_main_shoufang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
	end,
	true
)
 
core:add_listener(
    "kafka_mission_07",
    "CharacterAssignedToPost",
	function(context)
        if context:query_character():faction():is_human()
            then
            local character = context:query_character()
            -- -- ModLog(character:generation_template_key() .. "被任命为" .. character:character_post():ministerial_position_record_key());
            return character:generation_template_key() == "hlyjdingzhie" 
            and (character:character_post():ministerial_position_record_key() == "3k_main_court_offices_prime_minister" 
            or character:character_post():ministerial_position_record_key() == "3k_main_court_offices_prime_minister_liu_biao" 
            or character:character_post():ministerial_position_record_key() == "3k_dlc06_court_offices_minister_prime_minister_shi_xie" 
            or character:character_post():ministerial_position_record_key() == "3k_dlc05_court_offices_sun_ce_prime_minister" 
            or character:character_post():ministerial_position_record_key() == "3k_dlc05_court_offices_minister_prime_minister" 
            or character:character_post():ministerial_position_record_key() == "3k_dlc06_court_offices_nanman_minister_prime_minister" 
            or character:character_post():ministerial_position_record_key() == "ep_prime_minister_sima_liang" 
            or character:character_post():ministerial_position_record_key() == "ep_prime_minister_sima_ying" 
            or character:character_post():ministerial_position_record_key() == "ep_prime_minister_sima_yue" 
            or character:character_post():ministerial_position_record_key() == "ep_court_offices_prime_minister" 
            or character:character_post():ministerial_position_record_key() == "faction_heir")
            and character:faction():name() == gst.character_query_for_template("hlyjcj"):faction():name();
		else
            return false
        end
	end,
	function(context)
        kafka = gst.character_query_for_template("hlyjcj");
        faction_leader = kafka:faction():faction_leader();
        incident = cm:modify_model():create_incident("kafka_mission_07_incident");
        incident:add_character_target("target_character_1", kafka);
        incident:add_character_target("target_character_2", faction_leader);
        incident:trigger(cm:modify_faction(kafka:faction()), true);
	end,
	false
)

core:add_listener(
    "character_assigned_to_post",
    "CharacterAssignedToPost",
	function(context)
        if context:query_character():faction():is_human()
        then
            local character = context:query_character()
            ModLog(character:generation_template_key() .. "被任命为" .. character:character_post():ministerial_position_record_key());
            return character:generation_template_key() == "hlyjcm" 
            and (character:character_post():ministerial_position_record_key() == "3k_main_court_offices_prime_minister" 
            or character:character_post():ministerial_position_record_key() == "ep_court_offices_prime_minister" 
            or character:character_post():ministerial_position_record_key() == "faction_heir" 
            or character:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_general_in_chief" 
            or character:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_tutor" 
            or character:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_excellency_of_works" 
            or character:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_grand_commandant" 
            or character:character_post():ministerial_position_record_key() == "3k_dlc04_court_offices_prime_minister");
		else
            return false
        end
	end,
	function(context)
        local query_faction = context:query_character():faction()
        cm:modify_faction(query_faction):remove_event_restricted_unit_record("hlyjdingzhiedanwei")
        cm:modify_faction(query_faction):remove_event_restricted_unit_record("hlyjdingzhifdanwei")
	end,
	true
)

core:add_listener(
    "xyyhlyjf_resurrect_event",
    "RegionOwnershipChanged",
    function(context)
        return context:previous_owner()
        and not context:previous_owner():is_null_interface()
        and not context:previous_owner():is_dead()
        and context:previous_owner():name() == "xyyhlyjf"
        and context:previous_owner():region_list():num_items() <= 0
        and context:previous_owner():faction_leader():generation_template_key() == "hlyjdingzhia"
        and not gst.character_query_for_template("hlyjdingzhia"):is_null_interface()
        and not gst.character_query_for_template("hlyjdingzhia"):is_dead()
        and not cm:get_saved_value("huanlong_dead")
    end,
    function(context)
        gst.character_been_killed("hlyjdingzhia");
        gst.character_been_killed("hlyjdingzhid");
        gst.character_been_killed("hlyjdingzhie");
        cm:set_saved_value("huanlong_dead",true)
        -- 取消所有任务
        local human = cm:get_human_factions();
        for i = 1, #mission_keys do
            if cm:query_faction(player_faction_key):is_mission_active(mission_keys[i]) then
                cm:cancel_custom_mission(context:faction():name(), mission_keys[i])
            end;
        end;
    end,
    true
)

core:add_listener(
    "xyyhlyjf_resurrect_event_turn",
    "FactionTurnStart",
    function(context)
        return 
        context:faction():name() == "xyyhlyjf"
        and context:faction():region_list():num_items() <= 0
        and context:faction():faction_leader():generation_template_key() == "hlyjdingzhia"
        and not gst.character_query_for_template("hlyjdingzhia"):is_null_interface()
        and not gst.character_query_for_template("hlyjdingzhia"):is_dead();
    end,
    function(context)
--         cm:modify_region("3k_main_shoufang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("3k_main_faction_shoufang"));
--         cm:modify_region("3k_main_shoufang_resource_3"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
--         cm:modify_region("3k_main_shoufang_resource_2"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
--         cm:modify_region("3k_main_shoufang_resource_1"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
--         cm:modify_region("3k_main_shoufang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
--         cm:modify_faction("xyyhlyjf"):increase_treasury(100000);
        
    end,
    true
)

function add_freeze(command_queue_index)
    local character = cm:query_model():character_for_command_queue_index(command_queue_index)
    if character 
    and not character:is_null_interface() 
    and not character:is_dead()
    then
        cm:modify_character(character):zero_action_points();
        cm:modify_character(character):disable_movement();
        local freeze_cqi_table;
        if cm:get_saved_value("freeze_cqi_table") then
            freeze_cqi_table = cm:get_saved_value("freeze_cqi_table");
        else
            freeze_cqi_table = {};
        end
        for i, v in ipairs(freeze_cqi_table) do
            if v == command_queue_index then
                return;
            end
        end
        table.insert(freeze_cqi_table,command_queue_index);
        cm:set_saved_value("freeze_cqi_table", freeze_cqi_table);
    end
end

function remove_freeze(command_queue_index)
    local character = cm:query_model():character_for_command_queue_index(command_queue_index)
    if character 
    and not character:is_null_interface() 
    and not character:is_dead()
    then
        cm:modify_character(character):replenish_action_points();
        cm:modify_character(character):enable_movement();
        if cm:get_saved_value("freeze_cqi_table") then
            local freeze_cqi_table = cm:get_saved_value("freeze_cqi_table");
            for i, v in ipairs(freeze_cqi_table) do
                if v == command_queue_index then
                    table.remove(freeze_cqi_table, i);
                    break;
                end
            end
            cm:set_saved_value("freeze_cqi_table", freeze_cqi_table);
        else
            local freeze_cqi_table = {}
            cm:set_saved_value("freeze_cqi_table", freeze_cqi_table);
        end
    end
end

core:add_listener(
    "freeze_check_listener",
    "FactionTurnStart",
	function(context)
        --local hlyjdingzhia = cm:query_model:character_for_template("hlyjdingzhia")
        --add_freeze(hlyjdingzhia:cqi())
        return cm:get_saved_value("freeze_cqi_table");
	end,
	function(context)
        local freeze_cqi_table = cm:get_saved_value("freeze_cqi_table");
        for i, v in ipairs(freeze_cqi_table) do
            ModLog("freeze_cqi_table[_]" .. tostring(i).. "] " .. tostring(v))
            local character = cm:query_model():character_for_command_queue_index(v)
            if character 
            and not character:is_null_interface() 
            and not character:is_dead()
            then
                if character:faction() == context:faction() then
                    cm:modify_character(character):zero_action_points();
                    cm:modify_character(character):disable_movement();
                    ModLog("禁用"..character:generation_template_key().."移动")
                end
            else
                remove_freeze(v)
            end
        end
	end,
	true
)

core:add_listener(
    "hlyjdingzhia_wounded_received",
    "CharacterWoundReceivedEvent",
    function(context)
        if cm:get_saved_value("kafka_mission_faction") then
            local player_faction_key = cm:get_saved_value("kafka_mission_faction")
            return cm:query_faction(player_faction_key) and not cm:query_faction(player_faction_key):is_null_interface();
        else
            return false
        end
    end,
    function(context)
        if context:query_character():generation_template_key() == "hlyjdingzhia"
        and not context:query_character():won_battle()
        then
            local faction = cm:query_faction(player_faction_key)
            ModLog("huanlong_wounded")
            if faction:is_mission_active("kafka_mission_14") then
                cm:modify_faction(faction):complete_custom_mission("kafka_mission_14")
            end
            if faction:is_mission_active("kafka_mission_14_a") then
                cm:modify_faction(faction):complete_custom_mission("kafka_mission_14_a")
            end
            if faction:is_mission_active("kafka_mission_15") then
                cm:modify_faction(faction):complete_custom_mission("kafka_mission_15")
            end
            if faction:is_mission_active("kafka_mission_15_a") then
                cm:modify_faction(faction):complete_custom_mission("kafka_mission_15_a")
            end
            if faction:is_mission_active("kafka_mission_15_kafka_leader") then
                cm:modify_faction(faction):complete_custom_mission("kafka_mission_15_kafka_leader")
            end
            if faction:is_mission_active("kafka_mission_16_kafka_leader") then
                cm:modify_faction(faction):complete_custom_mission("kafka_mission_16_kafka_leader")
            end
        end
    end,
    true
)

core:add_listener(
    "summon_hlyjby_failed",
    "MissionFailed",
    function(context)
        return context:mission():mission_record_key() == "summon_hlyjby";
    end,
    function(context)
        gst.character_join_random_faction("hlyjby", "3k_general_fire")
    end,
    false
)

core:add_listener(
    "kafka_mission_05_kafka_leader",
    "IncidentOccuredEvent",
    function(context)
        return context:incident() == "kafka_mission_05_kafka_leader";
    end,
    function(context)
        cm:set_saved_value("kafka_recruiting", 1000)
        local restricting_events_list = {"kafka_mission_08_choice_kafka_leader"}
        
        --雷电将军不在派系则可能来投
        local hlyjcm = gst.character_query_for_template("hlyjcm")
        if (not hlyjcm 
        or hlyjcm:is_null_interface()
        or hlyjcm:is_character_is_faction_recruitment_pool())
        or (hlyjcm:faction():name() ~= context:faction():name() and hlyjcm:faction():faction_leader():generation_template_key() ~= "hlyjcm") then
            table.insert(restricting_events_list, "kafka_mission_09_choice_kafka_leader")
        end
        
        --钟离不在派系则可能来投
        local hlyjch = gst.character_query_for_template("hlyjch")
        if not hlyjch 
        or hlyjch:is_null_interface()
        or hlyjch:faction():name() ~= context:faction():name() 
        or hlyjch:is_character_is_faction_recruitment_pool() then
            table.insert(restricting_events_list, "kafka_mission_10_choice_kafka_leader")
        end
        
        --符玄不在派系则可能来投
        local hlyjcp = gst.character_query_for_template("hlyjcp")
        if not hlyjcp 
        or hlyjcp:is_null_interface()
        or hlyjcp:faction():name() ~= context:faction():name() 
        or hlyjcp:is_character_is_faction_recruitment_pool() then
            table.insert(restricting_events_list, "kafka_mission_12_choice_kafka_leader")
        end
        
        --符玄不在派系则可能来投
        local hlyjdj = gst.character_query_for_template("hlyjdj")
        if not hlyjdj 
        or hlyjdj:is_null_interface()
        or hlyjdj:faction():name() ~= context:faction():name() 
        or hlyjdj:is_character_is_faction_recruitment_pool() then
            table.insert(restricting_events_list, "kafka_mission_17_choice_kafka_leader")
        end
        
        --空和荧不在派系则可能来投
        local hlyjdc = gst.character_query_for_template("hlyjdc")
        local hlyjdd = gst.character_query_for_template("hlyjdd")
        if (not hlyjdc 
        or hlyjdc:is_null_interface()
        or hlyjdc:faction():name() ~= context:faction():name() 
        or hlyjdc:is_character_is_faction_recruitment_pool())
        and (not hlyjdd 
        or hlyjdd:is_null_interface()
        or hlyjdd:faction():name() ~= context:faction():name() 
        or hlyjdd:is_character_is_faction_recruitment_pool()) then
            table.insert(restricting_events_list, "kafka_mission_14_choice_kafka_leader")
        end
        
        cm:set_saved_value("restricting_events_list", restricting_events_list)
    end,
    false
)
core:add_listener(
    "kafka_mission_06_choice_kafka_leader",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_06_choice_kafka_leader"
    end,
    function (context)
        if context:choice() == 1 then
            cm:set_saved_value("kafka_recruiting", false)
            local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia")
            remove_freeze(hlyjdingzhia:cqi())
            local modify_hlyjdingzhia = cm:modify_character(hlyjdingzhia);
            modify_hlyjdingzhia:remove_effect_bundle("huanlong_unbreakable");
            cm:trigger_mission(context:faction(), "kafka_mission_15_kafka_leader", false);
            gst.character_add_CEO_and_equip("hlyjcj", "hlyjdingzhibzuoqi", "3k_main_ceo_category_ancillary_mount")
        end
    end,   
    true
)

core:add_listener(
    "kafka_mission_07_choice_kafka_leader",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_07_choice_kafka_leader"
    end,
    function (context)
        if context:choice() == 0 then
            if not cm:get_saved_value("kafka_mission_09_choice_kafka_leader") then
                local restricting_events_list = cm:get_saved_value("restricting_events_list")
                if #restricting_events_list == 0 then
                    cm:trigger_dilemma(context:faction(), "kafka_mission_13_choice_kafka_leader", true)
                    cm:set_saved_value("kafka_recruiting_disable", true)
                else
                    local random = gst.lib_getRandomValue(1, #restricting_events_list)
                    local event = restricting_events_list[random];
                    if event == "kafka_mission_09_choice_kafka_leader" then
                        cm:set_saved_value("kafka_mission_09_choice_kafka_leader", true);
                    end
                    table.remove(restricting_events_list, random)
                    cm:set_saved_value("restricting_events_list", restricting_events_list);
                    cm:trigger_dilemma(context:faction(),event,true)
                end
            else
                cm:trigger_dilemma(context:faction(), "kafka_mission_11_choice_kafka_leader", true)
                cm:set_saved_value("kafka_mission_09_choice_kafka_leader", false);
            end
        end
    end,   
    true
)

core:add_listener(
    "kafka_mission_09_choice_kafka_leader",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_09_choice_kafka_leader"
    end,
    function (context)
        if context:choice() == 0 then
            add_character_to_player("hlyjcm")
        end
    end,   
    false
)

core:add_listener(
    "kafka_mission_10_choice_kafka_leader",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_10_choice_kafka_leader"
    end,
    function (context)
        if context:choice() == 0 then
            add_character_to_player("hlyjch", cm:query_faction(player_faction_key))
        end
    end,   
    false
)

core:add_listener(
    "kafka_mission_12_choice_kafka_leader",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_12_choice_kafka_leader"
    end,
    function (context)
        if context:choice() == 0 then
            add_character_to_player("hlyjcp", cm:query_faction(player_faction_key))
        end
    end,   
    false
)

core:add_listener(
    "kafka_mission_13_choice_kafka_leader",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_13_choice_kafka_leader"
    end,
    function (context)
        if context:choice() == 0 then
            add_character_to_player("hlyjdingzhie", cm:query_faction(player_faction_key))
        end
    end,   
    false
)

core:add_listener(
    "kafka_mission_14_choice_kafka_leader",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_14_choice_kafka_leader"
    end,
    function (context)
        if context:choice() == 0 then
            add_character_to_player("hlyjdc", cm:query_faction(player_faction_key))
            add_character_to_player("hlyjdd", cm:query_faction(player_faction_key))
        end
    end,   
    false
)

core:add_listener(
    "kafka_mission_17_choice_kafka_leader",
    "DilemmaChoiceMadeEvent",
    function(context) 
        return context:dilemma() == "kafka_mission_17_choice_kafka_leader"
    end,
    function (context)
        if context:choice() == 0 then
            firefly_unlock()
            add_character_to_player("hlyjdj", cm:query_faction(player_faction_key))
        end
    end,   
    false
)

core:add_listener(
    "kafka_mission_15_kafka_leader",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == "kafka_mission_15_kafka_leader";
    end,
    function(context)
        gst.character_force_been_killed("hlyjdingzhie")
        cm:set_saved_value("hlyjdingzhie_has_been_killed", true)
            cm:modify_faction("xyyhlyjf"):remove_effect_bundle("huanlong_event_buff");
    end,
    false
)

core:add_listener(
    "kafka_mission_huanlong_enter_player_faction",
    "FactionTurnStart",
    function(context)
        return context:faction():is_human()
        and not cm:get_saved_value("huanlong_dead")
    end,
    function(context)
        local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia")
        if hlyjdingzhia
        and not hlyjdingzhia:is_null_interface()
        and not hlyjdingzhia:is_dead()
        and hlyjdingzhia:faction():name() ~= "xyyhlyjf"
        then
            if hlyjdingzhia:faction():is_human() then
                progression:force_campaign_defeat(hlyjdingzhia:faction():name())
            else
                local xyyhlyjf = cm:query_faction("xyyhlyjf")
                diplomacy_manager:force_confederation("xyyhlyjf", hlyjdingzhia:faction():name());
                gst.faction_set_minister_position("hlyjdingzhia","faction_leader");
            end
        end
    end,
    true
)

core:add_listener(
    "kafka_mission_huanlong_enter_player_faction_2",
    "FirstTickAfterWorldCreated",
    function(context)
        return true
    end,
    function(context)
        local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia")
        if hlyjdingzhia
        and not hlyjdingzhia:is_null_interface()
        and not hlyjdingzhia:is_dead()
        and hlyjdingzhia:faction():name() ~= "xyyhlyjf"
        then
            if hlyjdingzhia:faction():is_human() then
                ModLog("force campaign defeat for " .. hlyjdingzhia:faction():name())
                progression:force_campaign_defeat(hlyjdingzhia:faction():name());
            end
        end
    end,
    false
)

core:add_listener(
    "kafka_becomes_faction_leader",
    "CharacterBecomesFactionLeader",
    function(context)
        return context:query_character():generation_template_key() == "hlyjcj"
    end,
    function(context) -- What to do if listener fires.
        if cm:get_saved_value("kafka_mission") 
        and not cm:get_saved_value("huanlong_dead")
        and not cm:get_saved_value("xyyhlyjf_generated") 
        then
            cm:trigger_incident(context:query_character():faction(),"kafka_leader", true);
        elseif not cm:get_saved_value("huanlong_dead") then
            cm:trigger_incident(context:query_character():faction(),"kafka_leader_negative", true);
            local old_leader = gst.character_query_for_template(cm:get_saved_value("kafka_mission_leader"))
            cm:modify_character(old_leader):assign_faction_leader();
        end
    end,
    true
);

core:add_listener(
    "dark_character_kill_listener",
    "CharacterWoundReceivedEvent",
    function(context)
        ModLog("CharacterWoundReceivedEvent")
        return cm:get_saved_value("has_pending_battle") and cm:get_saved_value("xyy_roguelike_character_wound_listener") and not cm:get_saved_value("roguelike_mode") and cm:get_saved_value("kafka_mission_faction");
    end,
    function(context)
        local faction = cm:query_faction(cm:get_saved_value("kafka_mission_faction"))
        if faction:is_mission_active("xyy_mission_kill_hlyjci_dark") then
            if context:query_character():generation_template_key() == "hlyjci_dark" 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key()) then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjci_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
        if faction:is_mission_active("xyy_mission_kill_hlyjcj_dark") 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
            if context:query_character():generation_template_key() == "hlyjcj_dark" then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjcj_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
        if faction:is_mission_active("xyy_mission_kill_hlyjck_dark") 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
            if context:query_character():generation_template_key() == "hlyjck_dark" then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjck_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
        if faction:is_mission_active("xyy_mission_kill_hlyjcm_dark") 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
            if context:query_character():generation_template_key() == "hlyjcm_dark" then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjcm_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
        if faction:is_mission_active("xyy_mission_kill_hlyjcn_dark") 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
            if context:query_character():generation_template_key() == "hlyjcn_dark" then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjcn_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
        if faction:is_mission_active("xyy_mission_kill_hlyjcy_dark") 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
            if context:query_character():generation_template_key() == "hlyjcy_dark" then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjcy_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
        if faction:is_mission_active("xyy_mission_kill_hlyjda_dark") 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
            if context:query_character():generation_template_key() == "hlyjda_dark" then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjda_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
        if faction:is_mission_active("xyy_mission_kill_hlyjdi_dark") 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
            if context:query_character():generation_template_key() == "hlyjdi_dark" then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjdi_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
        if faction:is_mission_active("xyy_mission_kill_hlyjdf_dark") 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
            if context:query_character():generation_template_key() == "hlyjdf_dark" then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjdf_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
        if faction:is_mission_active("xyy_mission_kill_hlyjdt_dark") 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
            if context:query_character():generation_template_key() == "hlyjdt_dark" then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjdt_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
        if faction:is_mission_active("xyy_mission_kill_hlyjdy_dark") 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
            if context:query_character():generation_template_key() == "hlyjdy_dark" then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjdy_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
        if faction:is_mission_active("xyy_mission_kill_hlyjeb_dark") 
            and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
            if context:query_character():generation_template_key() == "hlyjeb_dark" then
                cm:modify_faction(faction):complete_custom_mission("xyy_mission_kill_hlyjeb_dark")
                cm:modify_character(context:query_character()):remove_effect_bundle("dark_character")
                cm:modify_character(context:query_character()):kill_character(true)
            end
        end
    end,
    true
)

core:add_listener(
    "dark_character_mission",
    "ActiveCharacterCreated",
    function(context)
        return not cm:get_saved_value("roguelike_mode") and string.find(context:query_character():generation_template_key(), "_dark");
    end,
    function(context)
        local character_key = context:query_character():generation_template_key()
        local mission_key = "xyy_mission_kill_" .. character_key
        ModLog(mission_key .. " to " .. player_faction_key)
        local mission = string_mission:new(mission_key)
        mission:set_issuer("CLAN_ELDERS");
        mission:add_primary_objective("SCRIPTED",
            { "script_key treaty_components_war",
                "override_text mission_text_" .. mission_key }
        );
        mission:add_primary_payload("money 100000;");
        mission:add_primary_payload("text_display{lookup kill_" .. character_key .. ";}");
        mission:add_primary_payload( "effect_bundle{bundle_key killed_dark_character_buff;turns 5;}" );
        mission:trigger_mission_for_faction(player_faction_key)
    end,
    true
);

core:add_listener(
    "mission_completed_listener",
    "MissionSucceeded",
    function(context)
        return true;
    end,
    function(context)
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjcy_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
        end
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjcn_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
            cm:modify_local_faction():ceo_management():add_ceo("hlyjcnwuqi_dark");
        end
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjdi_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
        end
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjdy_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdywuqi_dark");
        end
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjeb_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
        end
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjda_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdawuqi_dark");
        end
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjci_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
        end
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjck_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
            cm:modify_local_faction():ceo_management():add_ceo("hlyjckwuqi_dark");
        end
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjdt_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdtwuqi_dark");
        end
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjcm_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
            cm:modify_local_faction():ceo_management():add_ceo("hlyjcmwuqi_dark");
        end
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjcj_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
            cm:modify_local_faction():ceo_management():add_ceo("hlyjcjwuqi_dark");
        end
        if context:mission():mission_record_key() == "xyy_mission_kill_hlyjdf_dark" then
            cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
        end
    end,
    true
)