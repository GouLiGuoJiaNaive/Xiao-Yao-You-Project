local gst = xyy_gst:get_mod()

local roguelike_panel = nil;

local roguelike_store_panel = nil;
local store_confirm_button = nil;

local static_index = 0;
local UI_MOD_NAME = "";
local max = 3
local max_character = 1
local max_character_browser = 2
local level = 0
local selected_effect_bundle = "";
local selected_enemy_effect_key = "";

local refresh_num = 0
local main_faction_table = {}
local current_regions = {}
local counter = 0
local store_page = 0
local diplomacy_keys =
"treaty_components_proposer_declares_war_against_target,treaty_components_recipient_declares_war_against_target,treaty_components_abdicate_demand,treaty_components_abdicate_offer,treaty_components_acknowledge_legitimacy_demand,treaty_components_acknowledge_legitimacy_offer,treaty_components_alliance,treaty_components_alliance_democratic,treaty_components_alliance_to_alliance_group_peace,treaty_components_alliance_to_alliance_group_peace_no_vote,treaty_components_alliance_to_alliance_group_peace_no_vote_proposer,treaty_components_alliance_to_alliance_group_peace_no_vote_recipient,treaty_components_alliance_to_alliance_war,treaty_components_alliance_to_alliance_war_no_vote,treaty_components_alliance_to_empire,treaty_components_alliance_to_empire_white_tiger,treaty_components_alliance_to_empire_yuan_shao,treaty_components_alliance_to_faction_group_peace,treaty_components_alliance_to_faction_group_peace_no_vote,treaty_components_alliance_to_faction_war,treaty_components_alliance_to_faction_war_no_vote,treaty_components_annex_subject,treaty_components_annex_vassal,treaty_components_attitude_manipulation_negative,treaty_components_attitude_manipulation_negative_sima_yue,treaty_components_attitude_manipulation_positive,treaty_components_attitude_manipulation_positive_sima_yue,treaty_components_cai_balance_value,treaty_components_coalition,treaty_components_coalition_split_vote,treaty_components_coalition_to_alliance,treaty_components_coalition_to_alliance_white_tiger,treaty_components_coalition_to_alliance_yuan_shao,treaty_components_coalition_to_alliance_yuan_shu,treaty_components_coalition_to_empire,treaty_components_coalition_to_empire_white_tiger,treaty_components_coalition_to_empire_yuan_shao,treaty_components_coercion,treaty_components_confederate_proposer,treaty_components_confederate_recipient,treaty_components_confederate_recipient_no_conditions,treaty_components_create_alliance,treaty_components_create_alliance_yuan_shao,treaty_components_create_alliance_yuan_shu,treaty_components_create_coalition,treaty_components_create_coalition_white_tiger,treaty_components_create_coalition_yuan_shao,treaty_components_create_coalition_yuan_shu,treaty_components_create_empire,treaty_components_create_empire_counter_offer,treaty_components_create_empire_white_tiger,treaty_components_create_empire_yuan_shao,treaty_components_declare_independence,treaty_components_demand_autonomy,treaty_components_dissolve_empire,treaty_components_draw_vassal_into_war,treaty_components_empire,treaty_components_empire_mobilisation,treaty_components_empire_split_vote,treaty_components_enemy_of_the_han_negative,treaty_components_enemy_of_the_han_positive,treaty_components_faction_to_alliance_group_peace,treaty_components_faction_to_alliance_group_peace_no_vote,treaty_components_faction_to_alliance_war,treaty_components_forced_end_personal_feud_empress_he,treaty_components_forced_end_personal_feud_generic,treaty_components_governor_independence,treaty_components_group_war,treaty_components_guarentee_autonomy,treaty_components_instigate_proxy_war_proposer,treaty_components_instigate_proxy_war_recipient,treaty_components_issue_Imperial_decree,treaty_components_join_alliance_proposers,treaty_components_join_alliance_recipients,treaty_components_join_coalition_proposer,treaty_components_join_coalition_recipient,treaty_components_join_empire_proposer,treaty_components_join_empire_recipient,treaty_components_join_imperial_colaition_proposer,treaty_components_join_imperial_colaition_recipient,treaty_components_kick_alliance_member,treaty_components_kick_coalition_member,treaty_components_kick_empire_member,treaty_components_kick_empire_member_and_declare_war,treaty_components_liberate_proposer,treaty_components_liberate_recipient,treaty_components_liu_bei_confederate_proposer,treaty_components_liu_bei_confederate_recipient,treaty_components_lu_bu_coercion,treaty_components_lu_bu_receive_coercion,treaty_components_mandated_powers,treaty_components_mandated_powers_demand,treaty_components_mandated_powers_offer,treaty_components_marriage_confederate_proposer,treaty_components_marriage_confederate_recipient,treaty_components_marriage_give_female,treaty_components_marriage_give_female_male,treaty_components_marriage_give_male,treaty_components_marriage_give_male_female,treaty_components_marriage_recieve_female,treaty_components_marriage_recieve_female_male,treaty_components_marriage_recieve_male,treaty_components_marriage_recieve_male_female,treaty_components_master_accepts_war,treaty_components_mercenary_contract,treaty_components_mercenary_contract_proposer_declares_war_against_target,treaty_components_mercenary_contract_recipient_declares_war_against_target,treaty_components_mercenary_counter_contract_proposer_declares_war_against_target,treaty_components_mercenary_counter_contract_recipient_declares_war_against_target,treaty_components_mercenary_employer_signed_peace,treaty_components_military_alliance_split_vote,treaty_components_multiplayer_victory,treaty_components_offer_autonomy,treaty_components_pending_join_alliance_proposers,treaty_components_pending_join_coalition_proposers,treaty_components_pending_join_empire_proposers,treaty_components_personal_feud,treaty_components_quit_alliance,treaty_components_quit_alliance_and_declare_war,treaty_components_quit_alliance_no_treachery,treaty_components_quit_coalition,treaty_components_quit_coalition_and_declare_war,treaty_components_quit_coalition_no_treachery,treaty_components_quit_empire,treaty_components_quit_empire_and_declare_war,treaty_components_quit_empire_no_treachery,treaty_components_recieve_coercion,treaty_components_recieve_imperial_decree,treaty_components_recieve_threat,treaty_components_region_demand,treaty_components_region_offer,treaty_components_resolve_personal_feud,treaty_components_schemes_resource_demand,treaty_components_schemes_resource_offer,treaty_components_sima_lun_coercion,treaty_components_sima_lun_instigate_proxy_war_proposer,treaty_components_sima_lun_instigate_proxy_war_recipient,treaty_components_sima_lun_recieve_coercion,treaty_components_support_independence,treaty_components_support_independence_demand,treaty_components_support_independence_offer,treaty_components_supporting_legitimacy,treaty_components_take_tribute,treaty_components_threaten,treaty_components_threaten_sanctions,treaty_components_tribute_demand,treaty_components_tribute_offer,treaty_components_vassal_demands_protection,treaty_components_vassal_demands_protection_group_war,treaty_components_vassal_han_empire_demands_protection,treaty_components_vassal_han_empire_demands_protection_group_war,treaty_components_vassal_joins_war,treaty_components_vassal_requests_war,treaty_components_vassalage,treaty_components_vassalise_proposer,treaty_components_vassalise_proposer_liu_biao,treaty_components_vassalise_proposer_sima_liang,treaty_components_vassalise_proposer_yellow_turban,treaty_components_vassalise_proposer_yuan_shu,treaty_components_vassalise_recipient,treaty_components_vassalise_recipient_liu_biao,treaty_components_vassalise_recipient_no_conditions,treaty_components_vassalise_recipient_sima_liang,treaty_components_vassalise_recipient_yellow_turban,treaty_components_vassalise_recipient_yuan_shu,treaty_components_war"

local effect_bundles_table = {
    "xyy_roguelike_1",
    "xyy_roguelike_2",
    "xyy_roguelike_3",
    "xyy_roguelike_4",
    "xyy_roguelike_5",
    "xyy_roguelike_6",
    "xyy_roguelike_7",
    "xyy_roguelike_8",
    "xyy_roguelike_9",
    "xyy_roguelike_10",
    "xyy_roguelike_11",
    "xyy_roguelike_12",
    "xyy_roguelike_13",
    "xyy_roguelike_14",
    "xyy_roguelike_15",
    "xyy_roguelike_16",
    "xyy_roguelike_17",
    "xyy_roguelike_18",
    "xyy_roguelike_19",
    "xyy_roguelike_20",
    "xyy_roguelike_21",
    "xyy_roguelike_22",
    "xyy_roguelike_23",
    "xyy_roguelike_24",
    "xyy_roguelike_25",
    "xyy_roguelike_26",
    "xyy_roguelike_27",
    "xyy_roguelike_28",
    "xyy_roguelike_29",
    "xyy_roguelike_30",
    "xyy_roguelike_31",
    "xyy_roguelike_32",
    "xyy_roguelike_33",
    "xyy_roguelike_34",
    "xyy_roguelike_35",
    "xyy_roguelike_36",
    "xyy_roguelike_38",
    "xyy_roguelike_39",
    "xyy_roguelike_40",
    "xyy_roguelike_41",
    "xyy_roguelike_42",
    "xyy_roguelike_43",
    "xyy_roguelike_44",
    "xyy_roguelike_45",
    "xyy_roguelike_46",
    "xyy_roguelike_47",
    "xyy_roguelike_48",
    "xyy_roguelike_49",
    "xyy_roguelike_50",
    "xyy_roguelike_51",
    "xyy_roguelike_52",
    "xyy_roguelike_53",
    "xyy_roguelike_54",
    "xyy_roguelike_55",
    "xyy_roguelike_56",
    "xyy_roguelike_57",
    "xyy_roguelike_58",
    "xyy_roguelike_59",
    "xyy_roguelike_60",
    "xyy_roguelike_61",
    "xyy_roguelike_62",
    "xyy_roguelike_63",
    "xyy_roguelike_64",
    "xyy_roguelike_65",
    "xyy_roguelike_66",
    "xyy_roguelike_67",
};

local unlocked_table = {}

local kill_character_table = {}

local effect_bundles_info = {
    ["xyy_roguelike_1"] = { ["element"] = "earth", ["point"] = 2 },
    ["xyy_roguelike_2"] = { ["element"] = "metal", ["point"] = 3 },
    ["xyy_roguelike_3"] = { ["element"] = "fire", ["point"] = 3 },
    ["xyy_roguelike_4"] = { ["element"] = "earth", ["point"] = 2 },
    ["xyy_roguelike_5"] = { ["element"] = "wood", ["point"] = 2 },
    ["xyy_roguelike_6"] = { ["element"] = "water", ["point"] = 2 },
    ["xyy_roguelike_7"] = { ["element"] = "fire", ["point"] = 2 },
    ["xyy_roguelike_8"] = { ["element"] = "earth", ["point"] = 3 },
    ["xyy_roguelike_9"] = { ["element"] = "water", ["point"] = 3 },
    ["xyy_roguelike_10"] = { ["element"] = "wood", ["point"] = 2 },
    ["xyy_roguelike_11"] = { ["element"] = "metal", ["point"] = 3 },
    ["xyy_roguelike_12"] = { ["element"] = "fire", ["point"] = 1 },
    ["xyy_roguelike_13"] = { ["element"] = "wood", ["point"] = 3 },
    ["xyy_roguelike_14"] = { ["element"] = "fire", ["point"] = 3 },
    ["xyy_roguelike_15"] = { ["element"] = "wood", ["point"] = 3 },
    ["xyy_roguelike_16"] = { ["element"] = "water", ["point"] = 3 },
    ["xyy_roguelike_17"] = { ["element"] = "earth", ["point"] = 3 },
    ["xyy_roguelike_18"] = { ["element"] = "fire", ["point"] = 1 },
    ["xyy_roguelike_19"] = { ["element"] = "metal", ["point"] = 2 },
    ["xyy_roguelike_20"] = { ["element"] = "earth", ["point"] = 2 },
    ["xyy_roguelike_21"] = { ["element"] = "water", ["point"] = 3 },
    ["xyy_roguelike_22"] = { ["element"] = "earth", ["point"] = 2 },
    ["xyy_roguelike_23"] = { ["element"] = "fire", ["point"] = 3, ["time"] = 5 },
    ["xyy_roguelike_24"] = { ["element"] = "metal", ["point"] = 3 },
    ["xyy_roguelike_25"] = { ["element"] = "water", ["point"] = 2, ["time"] = 15 },
    ["xyy_roguelike_26"] = { ["element"] = "earth", ["point"] = 2 },
    ["xyy_roguelike_27"] = { ["element"] = "water", ["point"] = 2 },
    ["xyy_roguelike_28"] = { ["element"] = "metal", ["point"] = 3 },
    ["xyy_roguelike_29"] = { ["element"] = "metal", ["point"] = 3 },
    ["xyy_roguelike_30"] = { ["element"] = "fire", ["point"] = 2 },
    ["xyy_roguelike_31"] = { ["element"] = "earth", ["point"] = 3 },
    ["xyy_roguelike_32"] = { ["element"] = "water", ["point"] = 3 },
    ["xyy_roguelike_33"] = { ["element"] = "metal", ["point"] = 3 },
    ["xyy_roguelike_34"] = { ["element"] = "wood", ["point"] = 2 },
    ["xyy_roguelike_35"] = { ["element"] = "wood", ["point"] = 1 },
    ["xyy_roguelike_36"] = { ["element"] = "water", ["point"] = 1 },
    ["xyy_roguelike_38"] = { ["element"] = "metal", ["point"] = 2 },
    ["xyy_roguelike_39"] = { ["element"] = "fire", ["point"] = 2 },
    ["xyy_roguelike_40"] = { ["element"] = "earth", ["point"] = 3 },
    ["xyy_roguelike_41"] = { ["element"] = "water", ["point"] = 2 },
    ["xyy_roguelike_42"] = { ["element"] = "metal", ["point"] = 3 },
    ["xyy_roguelike_43"] = { ["element"] = "earth", ["point"] = 2 },
    ["xyy_roguelike_44"] = { ["element"] = "wood", ["point"] = 3 },
    ["xyy_roguelike_45"] = { ["element"] = "wood", ["point"] = 1 },
    ["xyy_roguelike_46"] = { ["element"] = "wood", ["point"] = 1 },
    ["xyy_roguelike_47"] = { ["element"] = "fire", ["point"] = 1 },
    ["xyy_roguelike_48"] = { ["element"] = "metal", ["point"] = 3 },
    ["xyy_roguelike_49"] = { ["element"] = "wood", ["point"] = 3 },
    ["xyy_roguelike_50"] = { ["element"] = "earth", ["point"] = 1, ["time"] = 1 },
    ["xyy_roguelike_51"] = { ["element"] = "water", ["point"] = 1, ["time"] = 1 },
    ["xyy_roguelike_52"] = { ["element"] = "metal", ["point"] = 3 },
    ["xyy_roguelike_53"] = { ["element"] = "wood", ["point"] = 3 },
    ["xyy_roguelike_54"] = { ["element"] = "water", ["point"] = 2 },
    ["xyy_roguelike_55"] = { ["element"] = "water", ["point"] = 3 },
    ["xyy_roguelike_56"] = { ["element"] = "fire", ["point"] = 1 },
    ["xyy_roguelike_57"] = { ["element"] = "fire", ["point"] = 2 },
    ["xyy_roguelike_58"] = { ["element"] = "fire", ["point"] = 3 },
    ["xyy_roguelike_59"] = { ["element"] = "metal", ["point"] = 1 },
    ["xyy_roguelike_60"] = { ["element"] = "metal", ["point"] = 2 },
    ["xyy_roguelike_61"] = { ["element"] = "metal", ["point"] = 3 },
    ["xyy_roguelike_62"] = { ["element"] = "fire", ["point"] = 3 },
    ["xyy_roguelike_63"] = { ["element"] = "wood", ["point"] = 1 },
    ["xyy_roguelike_64"] = { ["element"] = "wood", ["point"] = 2 },
    ["xyy_roguelike_65"] = { ["element"] = "wood", ["point"] = 3 },
    ["xyy_roguelike_66"] = { ["element"] = "wood", ["point"] = 2 },
    ["xyy_roguelike_67"] = { ["element"] = "water", ["point"] = 2 },
};

--恶堕者人物
local dark_character = {
    "hlyjci_dark",
    "hlyjcj_dark",
    "hlyjck_dark",
    "hlyjcm_dark",
    "hlyjcn_dark",
    "hlyjcy_dark",
    "hlyjda_dark",
    "hlyjdi_dark",
    "hlyjdf_dark",
    "hlyjdt_dark",
    "hlyjdy_dark",
    "hlyjeb_dark",
};

local dark_character_pin = {
    ["hlyjci_dark"] = 0,
    ["hlyjcj_dark"] = 0,
    ["hlyjck_dark"] = 0,
    ["hlyjcm_dark"] = 0,
    ["hlyjcn_dark"] = 0,
    ["hlyjcy_dark"] = 0,
    ["hlyjda_dark"] = 0,
    ["hlyjdi_dark"] = 0,
    ["hlyjdf_dark"] = 0,
    ["hlyjdt_dark"] = 0,
    ["hlyjdy_dark"] = 0,
    ["hlyjeb_dark"] = 0,
};

local dark_character_info = {
    ["hlyjci_dark"] = { ["element"] = "water", ["difficulty"] = 2 },
    ["hlyjcj_dark"] = { ["element"] = "fire", ["difficulty"] = 3 },
    ["hlyjck_dark"] = { ["element"] = "metal", ["difficulty"] = 2 },
    ["hlyjcm_dark"] = { ["element"] = "fire", ["difficulty"] = 3 },
    ["hlyjcn_dark"] = { ["element"] = "metal", ["difficulty"] = 1 },
    ["hlyjcy_dark"] = { ["element"] = "water", ["difficulty"] = 1 },
    ["hlyjda_dark"] = { ["element"] = "wood", ["difficulty"] = 2 },
    ["hlyjdi_dark"] = { ["element"] = "fire", ["difficulty"] = 1 },
    ["hlyjdf_dark"] = { ["element"] = "fire", ["difficulty"] = 3 },
    ["hlyjdt_dark"] = { ["element"] = "metal", ["difficulty"] = 2 },
    ["hlyjdy_dark"] = { ["element"] = "wood", ["difficulty"] = 1 },
    ["hlyjeb_dark"] = { ["element"] = "water", ["difficulty"] = 2 },
};

local enemy_effect_keys = {
    "xyy_roguelike_enemy_earth",
    "xyy_roguelike_enemy_metal",
    "xyy_roguelike_enemy_wood",
    "xyy_roguelike_enemy_water",
    "xyy_roguelike_enemy_fire"
};

local enemy_effect_key = nil
local enemy_effect_level = 1;

local item_info = {
    ["xyy_roguelike_the_seven_kings"] = { ["price"] = 2000, ["quality"] = "gold" },
    ["xyy_roguelike_max_1"] = { ["price"] = 200, ["quality"] = "silver" },
    ["xyy_roguelike_max_2"] = { ["price"] = 300, ["quality"] = "silver" },
    ["xyy_roguelike_max_3"] = { ["price"] = 500, ["quality"] = "silver" },
    ["xyy_roguelike_max_4"] = { ["price"] = 800, ["quality"] = "silver" },
    ["xyy_roguelike_sima_yi"] = { ["price"] = 500, ["quality"] = "silver" },
    ["xyy_roguelike_37"] = { ["price"] = 500, ["quality"] = "gold" },
    ["xyy_roguelike_max_character_browser_1"] = { ["price"] = 500, ["quality"] = "silver" },
    ["xyy_roguelike_max_character_browser_2"] = { ["price"] = 750, ["quality"] = "silver" },
    ["xyy_roguelike_max_character_browser_3"] = { ["price"] = 1000, ["quality"] = "silver" },
    ["xyy_roguelike_max_character_browser_4"] = { ["price"] = 1500, ["quality"] = "silver" },
    ["xyy_roguelike_max_character_1"] = { ["price"] = 1800, ["quality"] = "gold" },
    ["xyy_roguelike_redraw_1"] = { ["price"] = 300, ["quality"] = "silver" },
    ["xyy_roguelike_craft_weapons"] = { ["price"] = 100, ["quality"] = "gold", ["time"] = 3 },
    ["xyy_roguelike_craft_mounts"] = { ["price"] = 100, ["quality"] = "gold", ["time"] = 4 },
    ["xyy_roguelike_craft_armors"] = { ["price"] = 50, ["quality"] = "gold", ["time"] = 2 },
    ["xyy_roguelike_craft_accessories"] = { ["price"] = 75, ["quality"] = "gold", ["time"] = 2 },
    ["xyy_roguelike_craft_weapons_1"] = { ["price"] = 40, ["quality"] = "silver", ["time"] = 3 },
    ["xyy_roguelike_craft_mounts_1"] = { ["price"] = 40, ["quality"] = "silver", ["time"] = 4 },
    ["xyy_roguelike_craft_armors_1"] = { ["price"] = 25, ["quality"] = "silver", ["time"] = 2 },
    ["xyy_roguelike_craft_accessories_1"] = { ["price"] = 25, ["quality"] = "silver", ["time"] = 2 },
};

local store_table = {
    "xyy_roguelike_the_seven_kings",
    "xyy_roguelike_max_1",
    "xyy_roguelike_max_2",
    "xyy_roguelike_max_3",
    "xyy_roguelike_max_4",
    "xyy_roguelike_max_character_browser_1",
    "xyy_roguelike_max_character_browser_2",
    "xyy_roguelike_max_character_browser_3",
    "xyy_roguelike_max_character_browser_4",
    "xyy_roguelike_max_character_1",
    "xyy_roguelike_redraw_1",
    "xyy_roguelike_craft_weapons",
    "xyy_roguelike_craft_mounts",
    "xyy_roguelike_craft_armors",
    "xyy_roguelike_craft_accessories",
    "xyy_roguelike_craft_weapons_1",
    "xyy_roguelike_craft_mounts_1",
    "xyy_roguelike_craft_armors_1",
    "xyy_roguelike_craft_accessories_1",
    "xyy_roguelike_sima_yi",
    "xyy_roguelike_37",
}

local selected_store_items = {}

local confirm_button = nil;

local roguelike_btn_table = {}

local panel_size_x = 1920  --面板大小
local panel_size_y = 900   --面板大小

local bt_close_size_x = 36 --面板关闭按钮大小
local bt_close_size_y = 36 --面板关闭按钮大小

local toggle_ui = true

local slot_1_button = nil;
local slot_2_button = nil;
local slot_3_button = nil;
local slot_4_button = nil;
local slot_5_button = nil;
local slot_6_button = nil;
local slot_7_button = nil;

local faction_difficulty = {}


--author:大相great-xiang,date:2024.06.17
xyy_roguelike_mode = {
    target_factions = {},
    capital_regions = {},
    minor_regions = {},

    prohibited_regions = {
        ["3k_main_campaign_map"] = {},

        ["3k_dlc04_start_pos"] = {},

        ["3k_dlc05_start_pos"] = {},

        ["3k_dlc07_start_pos"] = {},

        ["8p_start_pos"] = {}
    },

    empire_factions = {
        ["3k_main_campaign_map"] = "xyyhlyjf",
        ["3k_dlc05_start_pos"] = "xyyhlyjf",
        ["3k_dlc04_start_pos"] = "xyyhlyjf",
        ["3k_dlc07_start_pos"] = "xyyhlyjf",
        ["8p_start_pos"] = "ep_faction_empire_of_jin"
    },

    strong_factions = {
        ["3k_main_campaign_map"] = {
            "3k_main_faction_dong_zhuo",
            "3k_main_faction_cao_cao",
            "3k_main_faction_liu_bei",
            "3k_main_faction_sun_jian",
            "3k_main_faction_liu_yan",
            "3k_main_faction_liu_biao",
            "3k_main_faction_ma_teng",
            "3k_main_faction_yuan_shao",
            "3k_main_faction_yuan_shu",
            "3k_main_faction_gongsun_zan",
            "xyy",
            "xyyhlyja",
            "3k_dlc06_faction_nanman_king_meng_huo",
            "3k_main_faction_yellow_turban_anding"
        },
        ["3k_dlc04_start_pos"] = {
            "3k_main_faction_dong_zhuo",
            "3k_main_faction_cao_cao",
            "3k_main_faction_liu_bei",
            "3k_main_faction_sun_jian",
            "3k_main_faction_liu_yan",
            "3k_main_faction_ma_teng",
            "3k_main_faction_zhang_lu",
            "3k_main_faction_gongsun_zan",
            "3k_main_faction_liu_biao",
            "xyy",
            "3k_dlc06_faction_nanman_king_meng_huo",
            "3k_main_faction_yellow_turban_anding"
        },
        ["3k_dlc05_start_pos"] = {
            "3k_main_faction_lu_bu",
            "3k_main_faction_dong_zhuo",
            "3k_main_faction_cao_cao",
            "3k_main_faction_liu_bei",
            "3k_dlc05_faction_sun_ce",
            "3k_main_faction_liu_yan",
            "3k_main_faction_ma_teng",
            "3k_main_faction_liu_biao",
            "3k_main_faction_yuan_shao",
            "3k_main_faction_yuan_shu",
            "xyy",
            "xyyhlyja",
            "3k_dlc06_faction_nanman_king_meng_huo",
            "3k_main_faction_yellow_turban_anding"
        },
        ["3k_dlc07_start_pos"] = {
            "3k_main_faction_yuan_shao",
            "3k_main_faction_cao_cao",
            "3k_main_faction_liu_bei",
            "3k_main_faction_liu_biao",
            "3k_dlc05_faction_sun_ce",
            "3k_main_faction_liu_yan",
            "3k_main_faction_ma_teng",
            "3k_main_faction_zhang_lu",
            "xyy",
            "xyyhlyja",
            "3k_dlc06_faction_nanman_king_meng_huo",
            "3k_main_faction_yellow_turban_anding"
        },
        ["8p_start_pos"] = {}
    },

    skip_factions = {
        ["3k_main_campaign_map"] = "3k_main_faction_shoufang",
        ["3k_dlc04_start_pos"] = "3k_main_faction_shoufang",
        ["3k_dlc05_start_pos"] = "3k_main_faction_shoufang",
        ["3k_dlc07_start_pos"] = "3k_main_faction_shoufang",
        ["8p_start_pos"] = "ep_faction_shoufang"
    },

    rebel_factions = {
        ["3k_main_campaign_map"] = "3k_dlc04_faction_rebels",
        ["3k_dlc04_start_pos"] = "3k_dlc04_faction_rebels",
        ["3k_dlc05_start_pos"] = "3k_dlc04_faction_rebels",
        ["3k_dlc07_start_pos"] = "3k_dlc04_faction_rebels",
        ["8p_start_pos"] = "ep_faction_shoufang"
    },

    invalid_factions = {
        "3k_main_faction_shoufang"
    }
}

function xyy_roguelike_mode:initialization_roguelike_mode()
    ModLog("汉献帝加入玩家阵营")
    gst.character_add_to_faction("3k_dlc04_template_historical_emperor_xian_earth", cm:query_local_faction():name(),
        "3k_general_earth");
    gst.character_add_CEO_and_equip("3k_dlc04_template_historical_emperor_xian_earth", "3k_dlc07_ancillary_weapon_emperor_xian_weapon_unique", "3k_main_ceo_category_ancillary_weapon")
    --------------------------------------------------------
    -- set give away faction, rebel faction and skip faction
    local empire_faction = self.empire_factions[cm:query_model():campaign_name()];
    local rebel_faction = self.rebel_factions[cm:query_model():campaign_name()];
    local strong_faction = self.strong_factions[cm:query_model():campaign_name()];
    local skip_faction = self.skip_factions[cm:query_model():campaign_name()];
    -- --ModLog("empire_faction: " .. empire_faction);
    -- --ModLog("rebel_faction: " .. rebel_faction);
    -- --ModLog("skip_faction: " .. skip_faction);
    --  go through factions and prepare armies
    -- 如果玩家没有军队则放置一个（防止游戏失败）
    local military_force_counter = 0
    local military_force_list = cm:query_local_faction():military_force_list()
    for j = 0, military_force_list:num_items() - 1 do
        local query_military_force = military_force_list:item_at(j);
        local character_list = query_military_force:character_list()
        for k = 0, character_list:num_items() - 1 do
            local character = character_list:item_at(k);
            if not character:is_null_interface()
                and not character:is_dead()
                and character:generation_template_key() ~= "3k_main_template_generic_castellan_m_01"
                and character:generation_template_key() ~= "3k_main_template_generic_castellan_f_01"
                and character:generation_template_key() ~= "3k_dlc06_template_generic_castellan_nanman_m_01"
                and character:generation_template_key() ~= "3k_dlc06_template_generic_castellan_nanman_f_01"
                and character:character_type("general")
            then
                military_force_counter = military_force_counter + 1
            end
        end
    end

    if military_force_counter == 0 then
        gst.faction_create_military_force(cm:query_local_faction():name(),
            cm:query_local_faction():capital_region():name(), cm:query_local_faction():faction_leader())
    end
    ModLog("清理派系")
    local faction_list = {}
    cm:query_model():world():faction_list():filter(
        function(filter_faction)
            return filter_faction and not filter_faction:is_dead()
        end
    ):foreach(
        function(filter_faction)
            if filter_faction:subculture() == "3k_dlc06_subculture_nanman"
                and filter_faction:name() ~= "3k_dlc06_faction_nanman_king_meng_huo"
            then
                diplomacy_manager:force_confederation("3k_dlc06_faction_nanman_king_meng_huo", filter_faction:name());
            elseif filter_faction:subculture() == "3k_main_subculture_yellow_turban"
                and filter_faction:name() ~= "3k_main_faction_yellow_turban_anding"
            then
                diplomacy_manager:force_confederation("3k_main_faction_yellow_turban_anding", filter_faction:name());
            end
            gst.lib_table_insert(faction_list, filter_faction:name());
        end
    )

    faction_list = gst.lib_shuffle_table(faction_list);

    if not gst.lib_value_in_list(strong_faction, cm:query_local_faction():name()) then
        gst.lib_table_insert(strong_faction, cm:query_local_faction():name())
    end

    for k, v in ipairs(faction_list) do
        if #strong_faction < 15 and not gst.lib_value_in_list(strong_faction, v) and v ~= "3k_main_faction_han_empire" then
            gst.lib_table_insert(strong_faction, v);
        end
    end

    local clist = {}
    --ModLog("所有可用派系")
    for k, v in ipairs(strong_faction) do
        --ModLog(v)
    end


    cm:modify_region("3k_main_shoufang_capital"):settlement_gifted_as_if_by_payload(cm:modify_faction("xyyhlyjf"));
    
    
    gst.lib_table_insert(self.target_factions, cm:query_local_faction():name())

    ModLog("设置敌对派系")
    for i = 1, cm:query_model():world():faction_list():num_items() - 1 do
        local filter_faction = cm:query_model():world():faction_list():item_at(i)
        if filter_faction
            and not filter_faction:is_null_interface() then
            ModLog("派系：" .. filter_faction:name())
            if not filter_faction:is_dead()
                and filter_faction:name() ~= "xyyhlyjf"
                and filter_faction:name() ~= "3k_main_faction_han_empire"
                and filter_faction:name() ~= "3k_main_faction_shoufang"
                and filter_faction:name() ~= "rebels"
                and not filter_faction:is_human()
                and not string.find(filter_faction:name(), "_separatists")
                and not (string.find(filter_faction:name(), "xyy") and string.find(filter_faction:name(), "_s"))
            then
                ModLog("派系：" .. filter_faction:name())
                --ModLog("派系："..filter_faction:name())
                if gst.lib_value_in_list(strong_faction, filter_faction:name()) then
                    local civil_war_faction;
                    if string.find(filter_faction:name(), "xyy") then
                        civil_war_faction = filter_faction:name() .. "_s";
                    elseif gst.separatist_factions[filter_faction:name()] then
                        civil_war_faction = gst.separatist_factions[filter_faction:name()]
                    else
                        civil_war_faction = filter_faction:name() .. "_separatists";
                    end
                    ModLog("敌对派系" .. civil_war_faction)
                    local character = filter_faction:faction_leader()
                    local query_civil_war_faction = cm:query_faction(civil_war_faction);
                    if query_civil_war_faction and not query_civil_war_faction:is_null_interface() then
                        local give_region;
                        if filter_faction:has_capital_region() then
                            give_region = filter_faction:capital_region()
                        else
                            give_region = cm:query_region("3k_dlc06_wu_pass")
                        end
                        ModLog("设置领地" .. give_region:name())
                        cm:modify_region(give_region):settlement_gifted_as_if_by_payload(cm:modify_faction(
                        query_civil_war_faction));
                        ModLog("合邦")
                        diplomacy_manager:force_confederation(civil_war_faction, filter_faction:name());
                        filter_faction = query_civil_war_faction;
                        if character and not character:is_null_interface() then
                            cm:modify_character(character):assign_faction_leader();
                        end
                    end
                    ModLog("加入派系列表")
                    if not gst.lib_value_in_list(self.invalid_factions, filter_faction:name())
                        and skip_faction ~= filter_faction:name()
                        and not filter_faction:is_dead()
                        and not gst.lib_value_in_list(self.target_factions, filter_faction:name())
                    then
                        gst.lib_table_insert(self.target_factions, filter_faction:name())
                        gst.lib_table_insert(main_faction_table, filter_faction:name())
                    end
                    ModLog("创建军队")
                    if filter_faction
                        and not filter_faction:is_null_interface()
                        and not filter_faction:is_dead()
                        and filter_faction:military_force_list():is_empty()
                    then
                        gst.faction_create_military_force(filter_faction:name(), filter_faction:capital_region():name(),
                            filter_faction:faction_leader())
                        --campaign_invasions:create_invasion(filter_faction:name(), filter_faction:capital_region():name(), 2, false);
                    end
                    ModLog("完成创建")
                end
            end
        end
    end

    ModLog("回收所有领地")
    -- 回收所有领地
    cm:query_model():world():region_manager():region_list():foreach(
        function(filter_region)
            if filter_region
                and not filter_region:is_null_interface()
                and filter_region:name()
            then
                if filter_region:name() == "3k_dlc06_gu_pass"
                    or filter_region:name() == "3k_dlc06_hangu_pass"
                    or filter_region:name() == "3k_dlc06_hulao_pass"
                    or filter_region:name() == "3k_dlc06_jiameng_pass"
                    or filter_region:name() == "3k_dlc06_kui_pass"
                    or filter_region:name() == "3k_dlc06_qi_pass"
                    or filter_region:name() == "3k_dlc06_san_pass"
                    or filter_region:name() == "3k_dlc06_tong_pass"
                    or filter_region:name() == "3k_dlc06_wu_pass"
                then
                    cm:modify_model():get_modify_region(filter_region):raze_and_abandon_settlement_without_attacking();
                    gst.lib_table_insert(self.minor_regions, filter_region:name());
                else
                    cm:modify_model():get_modify_region(filter_region):settlement_gifted_as_if_by_payload(cm
                    :modify_faction(empire_faction));
                    gst.lib_table_insert(self.capital_regions, filter_region:name());
                end
            end;
        end
    );
    

    self.target_factions = gst.lib_shuffle_table(self.target_factions)
    local new_start_region = {}
    --分配领地

    ModLog("分配领地")
    for i = 0, cm:query_model():world():region_manager():region_list():num_items() - 1 do
        local filter_region = cm:query_model():world():region_manager():region_list():item_at(i)
        if filter_region:adjacent_region_list():num_items() < 3
        and filter_region:name() ~= "3k_main_yizhou_island_capital"
        and filter_region:name() ~= "3k_main_yizhou_island_resource_1"
        then
            gst.lib_table_insert(new_start_region, filter_region:name())
        end
    end
    gst.lib_table_insert(new_start_region, "3k_main_luoyang_capital")
    new_start_region = gst.lib_shuffle_table(new_start_region)
    local i = 1;
    while i <= #new_start_region and not self:SetRandomRegion(cm:query_local_faction():name(), new_start_region[i]) do
        i = i + 1;
    end;

    cm:set_saved_value("roguelike_current_regions", current_regions)

    self:faction_difficulty_rating();

    cm:query_model():world():faction_list():foreach(
        function(filter_faction)
            if not filter_faction:is_dead()
                and filter_faction:region_list():is_empty()
                and not gst.lib_value_in_list(self.invalid_factions, filter_faction:name())
                or filter_faction:name() == "3k_main_faction_han_empire"
            then
                --ModLog("尝试清理派系：".. filter_faction:name())
                if gst.lib_getRandomValue(1, 1000) > 800
                    or filter_faction:name() == "3k_main_faction_han_empire"
                    or #self.capital_regions <= 10
                then
                    diplomacy_manager:force_confederation("xyyhlyjf", filter_faction:name());
                else
                    local filter_region = self.capital_regions
                    [math.floor(gst.lib_getRandomValue(1, #self.capital_regions))]
                    cm:modify_model():get_modify_region(filter_region):settlement_gifted_as_if_by_payload(cm
                    :modify_faction(filter_faction));
                    gst.lib_remove_value_from_list(self.capital_regions, filter_region)
                    gst.lib_table_insert(self.minor_regions, filter_region)
                    self:MoveArmy(filter_faction:name());
                end
            end
        end
    )

    ModLog("清理不可用派系")
    cm:query_model():world():faction_list():foreach(
        function(filter_faction)
            if not filter_faction:is_dead()
                and filter_faction:region_list():is_empty()
                and not gst.lib_value_in_list(self.invalid_factions, filter_faction:name())
                or filter_faction:name() == "3k_main_faction_han_empire"
            then
                --ModLog("尝试清理派系：".. filter_faction:name())
                local dlist = {}
                filter_faction:character_list():foreach(
                    function(character)
                        if character
                            and not character:is_dead()
                            and not character:is_character_is_faction_recruitment_pool()
                        then
                            gst.lib_table_insert(dlist, character)
                        end
                    end
                );
                for k, v in ipairs(dlist) do
                    cm:modify_character(v):move_to_faction_and_make_recruited("xyyhlyjf")
                end
            end
        end
    )


    cm:modify_faction("xyyhlyjf"):apply_effect_bundle("huanlong_event_buff", -1);
    cm:modify_faction("xyyhlyjf"):apply_effect_bundle("huanlong_event_debuff", -1);
    --cm:modify_faction("xyyhlyjf"):increase_treasury(50000);

    local hlyjdingzhia = gst.character_add_to_faction("hlyjdingzhia", "xyyhlyjf", "3k_general_destroy")
    gst.character_CEO_equip("hlyjdingzhia", "hlyjdingzhiazuoqi", "3k_main_ceo_category_ancillary_mount");
    gst.character_CEO_equip("hlyjdingzhia", "hlyjdingzhiawuqi", "3k_main_ceo_category_ancillary_weapon");
    gst.character_CEO_equip("hlyjdingzhia", "hlyjdingzhiafujian", "3k_main_ceo_category_ancillary_accessory");
    gst.character_CEO_equip("hlyjdingzhia", "hlyjdingzhiayifu", "3k_main_ceo_category_ancillary_armour");
    gst.faction_set_minister_position("hlyjdingzhia", "faction_leader");
    gst.character_remove_all_traits(hlyjdingzhia);

    cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("kafka_mission_complete_01");
    cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("3k_main_ceo_trait_personality_vengeful");
    cm:modify_character(hlyjdingzhia):ceo_management():add_ceo("3k_main_ceo_trait_personality_cruel");
    cm:modify_character(hlyjdingzhia):add_experience(295000, 0);

    self:force_disable_diplomacy()

    
    ModLog("传送军队")
    -- disperse give faction/ rebel faction 's army
    local public_factions = {};
    gst.lib_table_insert(public_factions, empire_faction);
    --gst.lib_table_insert(public_factions, rebel_faction);
    for k, public_faction in ipairs(public_factions) do
        local query_faction = cm:query_faction(public_faction);
        for i = 0, query_faction:military_force_list():num_items() - 1 do
            local filter_force = query_faction:military_force_list():item_at(i)
            local picked_region_id = math.floor(gst.lib_getRandomValue(1, query_faction:region_list():num_items()));
            local picked_region = query_faction:region_list():item_at(picked_region_id - 1);
            local region_x = picked_region:settlement():logical_position_x() + gst.lib_getRandomValue(1, 1200) / 100 - 6;
            local region_y = picked_region:settlement():logical_position_y() + gst.lib_getRandomValue(1, 1200) / 100 - 6;
            if not misc:is_transient_character(filter_force:general_character())
                and not filter_force:unit_list():is_empty() then
                local force_general = filter_force:general_character();
                local found_pos, x, y = query_faction:get_valid_spawn_location_near(region_x, region_y, 10,
                    false);
                if not found_pos then
                    found_pos, x, y = query_faction:get_valid_spawn_location_in_region(picked_region:name(),
                        false);
                end;
                if found_pos then
                    cm:modify_character(force_general):teleport_to(x, y);
                end;
            end;
        end;
    end;

    -- 移除任务
    ModLog("移除任务")
    xyy_roguelike_mode:RemoveMission();
    -- 移动镜头
    ModLog("移动镜头")
    local query_settlement = cm:query_faction(cm:get_human_factions()[1]):capital_region():settlement();
    local x, y, d, b, h = cm:get_camera_position();
    local new_capital_x = query_settlement:display_position_x();
    local new_capital_y = query_settlement:display_position_y();
    local duration = 0.2 * distance_squared(x, y, new_capital_x, new_capital_y);
    duration = math.min(duration, 5);
    if duration > 0 then
        cm:scroll_camera_from_current(duration, true, { new_capital_x, new_capital_y, 8, b, 10 });
    end;
    local region_key =  cm:query_faction("xyyhlyjf"):capital_region():name()
    cm:modify_model():get_modify_world():add_world_leader_region_status(region_key)
    
    if cm:query_model():campaign_name() == "3k_dlc04_start_pos" then
        cm:modify_model():get_modify_world():remove_world_leader_region_status("3k_main_luoyang_capital");
    end
    
    cm:set_saved_value("xyy_roguelike_world_leader_target_region", region_key);
    cm:modify_local_faction():increase_treasury(100000)
    ---------------------------------------------------------
end

function xyy_roguelike_mode:SetRandomRegion(faction_key, target_region)
    --ModLog("分配领地" .. faction_key );
    if gst.lib_value_in_list(self.capital_regions, target_region) then
        cm:modify_region(target_region):settlement_gifted_as_if_by_payload(cm:modify_faction(faction_key));
        gst.lib_remove_value_from_list(self.capital_regions, target_region);
        gst.lib_table_insert(self.minor_regions, target_region);
        gst.lib_table_insert(current_regions, target_region);
        --ModLog("将领地" .. target_region .. "移交给" .. faction_key);
    end
    -- 将整个省份分配给派系
    local query_region = cm:query_region(target_region);
    cm:query_model():world():region_manager():region_list():foreach(
        function(region)
            if region:province_name() == query_region:province_name()
            then
                if gst.lib_value_in_list(self.capital_regions, region:name()) then
                    cm:modify_region(region):settlement_gifted_as_if_by_payload(cm:modify_faction(faction_key));
                    gst.lib_remove_value_from_list(self.capital_regions, region:name());
                    gst.lib_table_insert(self.minor_regions, region:name());
                    gst.lib_table_insert(current_regions, region:name());
                end;
            end;
        end
    );
    if cm:query_faction(faction_key):region_list():is_empty() then
        return false;
    end
    self:MoveArmy(faction_key);

    gst.lib_remove_value_from_list(self.target_factions, faction_key)
    local last_faction = faction_key

    local rate = 1
    while #self.target_factions > 0 do
        local faction = self.target_factions[1]
        --ModLog("分配领地" .. faction );
        -- 获得一个领地
        self:add_regions(faction, last_faction, target_region)

        -- 如果领地数量仍然等于0，则随机获得一个新领地
        while cm:query_faction(faction):region_list():is_empty() do
            self:add_regions(faction, nil, target_region)
        end
        for i = 1, 1 do
            self:add_regions(faction, faction, target_region)
            if math.floor(gst.lib_getRandomValue(1, 1000)) < 800 * rate then
                self:add_regions(faction, faction, target_region)
            end

            if rate < 2 then
                break;
            end

            if math.floor(gst.lib_getRandomValue(1, 1000)) < 500 * rate then
                self:add_regions(faction, faction, target_region)
            end

            if rate < 3 then
                break;
            end

            if math.floor(gst.lib_getRandomValue(1, 1000)) < 200 * rate then
                self:add_regions(faction, faction, target_region)
            end

            if math.floor(gst.lib_getRandomValue(1, 1000)) < 100 * rate then
                self:add_regions(faction, faction, target_region)
            end

            if math.floor(gst.lib_getRandomValue(1, 1000)) < 80 * rate then
                self:add_regions(faction, faction, target_region)
            end

            if math.floor(gst.lib_getRandomValue(1, 1000)) < 80 * rate then
                self:add_regions(faction, faction, target_region)
            end

            if rate < 8 then
                break;
            end

            if math.floor(gst.lib_getRandomValue(1, 1000)) < 40 * rate then
                self:add_regions(faction, faction, target_region)
            end

            if rate < 10 then
                break;
            end

            if math.floor(gst.lib_getRandomValue(1, 1000)) < 20 * rate then
                self:add_regions(faction, faction, target_region)
            end
            if rate < 13 then
                break;
            end

            if math.floor(gst.lib_getRandomValue(1, 1000)) < 20 * rate then
                self:add_regions(faction, faction, target_region)
            end

            if math.floor(gst.lib_getRandomValue(1, 1000)) < 20 * rate then
                self:add_regions(faction, faction, target_region)
            end
        end

        self:MoveArmy(faction);
        target_region = cm:query_faction(faction):capital_region():name()
        last_faction = faction
        gst.lib_remove_value_from_list(self.target_factions, faction)
        rate = rate + 1;
    end
    return true;
end

function xyy_roguelike_mode:add_regions(new_faction, last_faction, capital_region)
    local additional_region = nil;
    if last_faction then
        local reg_table = {}
        for i = 0, cm:query_faction(last_faction):region_list():num_items() - 1 do
            local region = cm:query_faction(last_faction):region_list():item_at(i)
            gst.lib_table_insert(reg_table, region)
        end
        reg_table = gst.lib_shuffle_table(reg_table);
        for k, region in ipairs(reg_table) do
            for j = 0, region:adjacent_region_list():num_items() - 1 do
                local adjacent_region = region:adjacent_region_list():item_at(j)
                if gst.lib_value_in_list(self.capital_regions, adjacent_region:name())
                    and cm:query_region(capital_region):distance_to_region(region) <= 24
                then
                    additional_region = adjacent_region;
                    break;
                end
            end
        end
    end

    if not additional_region then
        if cm:query_faction(new_faction):region_list():is_empty() then
            for i = 1, #self.minor_regions do
                local region = cm:query_region(self.minor_regions[i])
                if not gst.lib_value_in_list(self.capital_regions, region:name()) then
                    for j = 0, region:adjacent_region_list():num_items() - 1 do
                        local adjacent_region = region:adjacent_region_list():item_at(j)
                        if gst.lib_value_in_list(self.capital_regions, adjacent_region:name())
                        then
                            additional_region = adjacent_region;
                            break;
                        end
                    end
                end
            end
        end
    end

    local distance = 3
    while not additional_region and distance < 10 do
        if cm:query_faction(new_faction):region_list():is_empty() then
            for i = 1, #self.minor_regions do
                local region = cm:query_region(self.minor_regions[i])
                if not gst.lib_value_in_list(self.capital_regions, region:name()) then
                    for j = 0, cm:query_model():world():region_manager():region_list():num_items() - 1 do
                        local adjacent_region = cm:query_model():world():region_manager():region_list():item_at(j)
                        if gst.lib_value_in_list(self.capital_regions, adjacent_region:name())
                            and cm:query_region(capital_region):distance_to_region(region) <= distance
                        then
                            additional_region = adjacent_region;
                            break;
                        end
                    end
                    if additional_region then
                        break;
                    end
                end
            end
        end
        distance = distance + 1
    end

    if additional_region then
        if gst.lib_value_in_list(self.capital_regions, additional_region:name()) then
            cm:modify_region(additional_region):settlement_gifted_as_if_by_payload(cm:modify_faction(new_faction));
            --ModLog("将领地" .. additional_region:name() .. "移交给" .. new_faction);
            gst.lib_remove_value_from_list(self.capital_regions, additional_region:name());
        end
        -- 将整个省份分配给派系
        cm:query_model():world():region_manager():region_list():foreach(
            function(region)
                if region:province_name() == additional_region:province_name()
                then
                    if gst.lib_value_in_list(self.capital_regions, region:name()) then
                        cm:modify_region(region):settlement_gifted_as_if_by_payload(cm:modify_faction(new_faction));
                        gst.lib_remove_value_from_list(self.capital_regions, region:name());
                        gst.lib_table_insert(self.minor_regions, region:name());
                    end;
                end;
            end
        );
    end
end

function xyy_roguelike_mode:MoveArmy(faction_key)
    local filter_faction = cm:query_faction(faction_key);
    local query_capital = filter_faction:capital_region();
    if query_capital and not query_capital:is_null_interface() then
        for i = 0, filter_faction:military_force_list():num_items() - 1 do
            local filter_force = filter_faction:military_force_list():item_at(i);
            local region_x = query_capital:settlement():logical_position_x() + gst.lib_getRandomValue(1, 1200) / 100 - 6;
            local region_y = query_capital:settlement():logical_position_y() + gst.lib_getRandomValue(1, 1200) / 100 - 6;
            if not misc:is_transient_character(filter_force:general_character())
                and not filter_force:unit_list():is_empty() then
                local force_general = filter_force:general_character();
                local found_pos, x, y = filter_faction:get_valid_spawn_location_near(region_x, region_y, 10, false);
                if not found_pos then
                    found_pos, x, y = filter_faction:get_valid_spawn_location_in_region(query_capital:name(), false);
                end;
                if found_pos then
                    cm:modify_character(force_general):teleport_to(x, y);
                end;
            end;
        end;
    end
end

function xyy_roguelike_mode:faction_difficulty_rating()
    cm:query_model():world():faction_list():foreach(function(filter_faction)
        if filter_faction
            and not filter_faction:is_dead()
            and not filter_faction:is_human()
            and (gst.lib_value_in_list(main_faction_table, filter_faction:name()) or filter_faction:name() == "xyyhlyjf")
            and filter_faction:name() ~= "3k_dlc04_faction_rebels"
            and not filter_faction:region_list():is_empty() then
            if filter_faction:name() == "xyyhlyjf" then
                faction_difficulty[filter_faction:name()] = 5000;
            else
                cm:modify_faction(filter_faction):increase_treasury(100000);
                faction_difficulty[filter_faction:name()] = filter_faction:region_list():num_items() * 30;
            end
            --ModLog(filter_faction:name() .. "评分: " .. faction_difficulty[filter_faction:name()]);
        end
    end)
    cm:set_saved_value("roguelike_faction_difficulty", faction_difficulty);
end

function xyy_roguelike_mode:force_disable_diplomacy()
    cm:modify_model():disable_diplomacy("all", "all", diplomacy_keys, "roguelike_mode");
    cm:modify_model():disable_diplomacy("faction:" .. cm:query_local_faction():name(), "all",
        "treaty_components_peace,treaty_components_peace_no_event", "roguelike_mode")
end

function xyy_roguelike_mode:RemoveMission()
    -- Assuming player's keys,Selecting the first faction key,Passing faction key to modify_faction
    modify_filter_faction = cm:modify_faction(cm:get_human_factions()[1]);
    modify_filter_faction:cancel_custom_mission("3k_dlc05_tutorial_mission_kong_rong_destroy_yuan_shao");
    modify_filter_faction:cancel_custom_mission("3k_dlc05_tutorial_mission_kong_rong_destroy_yuan_tan");
    modify_filter_faction:cancel_custom_mission("3k_dlc05_tutorial_mission_liu_bei_destroy_lu_bu");
    modify_filter_faction:cancel_custom_mission("3k_dlc05_tutorial_mission_liu_bei_destroy_yuan_shu");
    modify_filter_faction:cancel_custom_mission("3k_dlc05_tutorial_mission_yuan_shao_destroy_faction");
    modify_filter_faction:cancel_custom_mission("3k_dlc04_main_tutorial_liu_chong_defeat_army_mission");
    modify_filter_faction:cancel_custom_mission("3k_dlc04_tutorial_liu_bei_defeat_army_mission");
    modify_filter_faction:cancel_custom_mission("3k_dlc04_tutorial_liu_bei_defeat_army_1_mission");
    modify_filter_faction:cancel_custom_mission("3k_dlc04_tutorial_liu_bei_defeat_army_2_mission");
    modify_filter_faction:cancel_custom_mission("3k_dlc04_tutorial_liu_bei_defeat_army_3_mission");
    modify_filter_faction:cancel_custom_mission("3k_dlc05_tutorial_mission_gongsun_zan_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_dlc05_tutorial_mission_kong_rong_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_dlc05_tutorial_mission_liu_bei_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_dlc05_tutorial_mission_liu_biao_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_dlc05_tutorial_mission_zhang_yan_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_dlc05_tutorial_mission_zheng_jiang_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_cao_cao_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_dong_zhuo_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_gongsun_zan_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_kong_rong_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_liu_bei_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_liu_biao_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_ma_teng_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_sun_jian_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_tao_qian_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_yuan_shao_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_yuan_shu_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_zhang_yan_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_main_tutorial_mission_zheng_jiang_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_ytr_tutorial_mission_gong_du_1_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_ytr_tutorial_mission_he_yi_1_defeat_army");
    modify_filter_faction:cancel_custom_mission("3k_ytr_tutorial_mission_huang_shao_1_defeat_army");
    modify_filter_faction:cancel_custom_mission("ep_mission_introduction_destroy_army_sima_yue");
    modify_filter_faction:cancel_custom_mission("ep_mission_introduction_destroy_army_sima_ying");
    modify_filter_faction:cancel_custom_mission("ep_mission_introduction_destroy_army_sima_yong");
    modify_filter_faction:cancel_custom_mission("ep_mission_introduction_destroy_army_sima_lun");
    modify_filter_faction:cancel_custom_mission("ep_mission_introduction_destroy_army_sima_wei");
    modify_filter_faction:cancel_custom_mission("ep_mission_introduction_destroy_army_sima_jiong");
    modify_filter_faction:cancel_custom_mission("ep_mission_introduction_destroy_army_sima_ai");
    modify_filter_faction:cancel_custom_mission("ep_mission_introduction_destroy_army_sima_liang");

    modify_filter_faction:complete_custom_mission("3k_dlc04_main_tutorial_liu_chong_capture_settlement_mission");
    modify_filter_faction:complete_custom_mission("3k_dlc05_tutorial_mission_kong_rong_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_dlc05_tutorial_mission_liu_bei_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_dlc05_tutorial_mission_yan_baihu_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_dlc05_tutorial_mission_zheng_jiang_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_cao_cao_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_dong_zhuo_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_gongsun_zan_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_kong_rong_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_liu_bei_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_liu_biao_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_ma_teng_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_sun_jian_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_tao_qian_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_yuan_shao_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_yuan_shu_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_zhang_yan_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_zheng_jiang_capture_settlement");
    modify_filter_faction:complete_custom_mission("3k_ytr_tutorial_mission_gong_du_1_capture_region");
    modify_filter_faction:complete_custom_mission("3k_ytr_tutorial_mission_huang_shao_1_capture_region");
    modify_filter_faction:complete_custom_mission("3k_ytr_tutorial_mission_he_yi_1_capture_region");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_liu_bei_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_yuan_shao_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_ma_teng_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_cao_cao_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_zhang_yan_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_liu_biao_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_dong_zhuo_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_sun_jian_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_yuan_shu_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_gongsun_zan_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_zheng_jiang_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_kong_rong_construct_building");
    modify_filter_faction:complete_custom_mission("3k_main_tutorial_mission_tao_qian_construct_building");
    modify_filter_faction:complete_custom_mission("3k_dlc05_tutorial_mission_ma_teng_construct_building");
    modify_filter_faction:complete_custom_mission("3k_dlc05_tutorial_mission_yan_baihu_construct_building");
    modify_filter_faction:complete_custom_mission("3k_dlc05_tutorial_mission_zheng_jiang_construct_building");
    modify_filter_faction:complete_custom_mission("3k_dlc06_progression_nanman_destroy_faction_mission");
    -- --ModLog("RemoveMission Done!");
end

cm:add_first_tick_callback(function() xyy_roguelike_mode:Initialise() end);
function xyy_roguelike_mode:Initialise()
    core:add_listener(
        "roguelike_dilemma_choice", -- UID
        "DilemmaChoiceMadeEvent",   -- CampaignEvent
        function(context)
            return context:dilemma() == "roguelike_dilemma"
        end,               -- criteria
        function(context)  --what to do if listener fires
            if context:choice() == 0 then
                core:remove_listener("progression_new_faction_leader")
                xyy_roguelike_mode:initialization_roguelike_mode();
                xyy_roguelike_mode:register_roguelike_listeners();
                cm:set_saved_value("roguelike_mode", true);
                cm:set_saved_value("invalid", true)
                cm:modify_local_faction():apply_effect_bundle("3k_xyy_roguelike_dummy", -1)
                cm:trigger_dilemma(cm:query_local_faction():name(), "roguelike_dilemma_first_select", true);
            else
                cm:trigger_dilemma(cm:query_local_faction():name(), "hexie2_script", true);
            end
        end,
        false
    )

    if cm:get_saved_value("roguelike_mode") then
        --读取随机赐福表
        if not cm:get_saved_value("roguelike_effect_bundles_table") then
            cm:set_saved_value("roguelike_effect_bundles_table", effect_bundles_table);
        else
            effect_bundles_table = cm:get_saved_value("roguelike_effect_bundles_table")
        end

        if not cm:get_saved_value("roguelike_unlocked_table") then
            cm:set_saved_value("roguelike_unlocked_table", unlocked_table);
        else
            unlocked_table = cm:get_saved_value("roguelike_unlocked_table")
        end

        for key, v in pairs(effect_bundles_info) do
            if not gst.lib_value_in_list(effect_bundles_table, key)
                and not gst.lib_value_in_list(unlocked_table, key)
            then
                gst.lib_table_insert(effect_bundles_table, key)
            end
        end

        --读取商店列表
        if not cm:get_saved_value("roguelike_store_table") then
            cm:set_saved_value("roguelike_store_table", store_table);
        else
            store_table = cm:get_saved_value("roguelike_store_table")
            if not cm:query_local_faction():has_effect_bundle("xyy_roguelike_craft_weapons") then
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_weapons")
            end
            if not cm:query_local_faction():has_effect_bundle("xyy_roguelike_craft_weapons_1") then
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_weapons_1")
            end
            if not cm:query_local_faction():has_effect_bundle("xyy_roguelike_craft_accessories") then
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_accessories")
            end
            if not cm:query_local_faction():has_effect_bundle("xyy_roguelike_craft_accessories_1") then
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_accessories_1")
            end
            if not cm:query_local_faction():has_effect_bundle("xyy_roguelike_craft_armors") then
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_armors")
            end
            if not cm:query_local_faction():has_effect_bundle("xyy_roguelike_craft_armors_1") then
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_armors_1")
            end
            if not cm:query_local_faction():has_effect_bundle("xyy_roguelike_craft_mounts") then
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_mounts")
            end
            if not cm:query_local_faction():has_effect_bundle("xyy_roguelike_craft_mounts_1") then
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_mounts_1")
            end
            if not cm:query_local_faction():has_effect_bundle("xyy_roguelike_sima_yi") then
                gst.lib_table_insert(store_table, "xyy_roguelike_sima_yi")
            end
            cm:set_saved_value("roguelike_store_table", store_table);
        end

        --读取随机赐福抽取数量上限
        if not cm:get_saved_value("roguelike_max_slot") then
            cm:set_saved_value("roguelike_max_slot", max);
        else
            --ModLog("检测到: roguelike_max_slot = " .. cm:get_saved_value("roguelike_max_slot"));
            max = cm:get_saved_value("roguelike_max_slot")
        end


        --读取随机最大可选武将
        if not cm:get_saved_value("roguelike_max_claracter_slot") then
            cm:set_saved_value("roguelike_max_claracter_slot", max_character);
        else
            --ModLog("检测到: roguelike_max_claracter_slot = " .. cm:get_saved_value("roguelike_max_claracter_slot"));
            max_character = cm:get_saved_value("roguelike_max_claracter_slot")
        end

        --读取随机武将抽取数量上限
        if not cm:get_saved_value("roguelike_max_claracter_browser_slot") then
            cm:set_saved_value("roguelike_max_claracter_browser_slot", max_character_browser);
        else
            --ModLog("检测到: roguelike_max_claracter_browser_slot = " .. cm:get_saved_value("roguelike_max_claracter_browser_slot"));
            max_character_browser = cm:get_saved_value("roguelike_max_claracter_browser_slot")
        end

        --读取任务层级
        if not cm:get_saved_value("roguelike_level") then
            cm:set_saved_value("roguelike_level", level);
        else
            --ModLog("检测到: roguelike_level = " .. cm:get_saved_value("roguelike_level"));
            level = cm:get_saved_value("roguelike_level")
        end

        --读取恶堕者列表
        if cm:get_saved_value("dark_character") then
            --ModLog("检测到: roguelike_level = " .. cm:get_saved_value("roguelike_level"));
            dark_character = cm:get_saved_value("dark_character")
        end
        
        if not cm:get_saved_value("dark_character_pin") then
            cm:set_saved_value("dark_character_pin", dark_character_pin);
        else
            --ModLog("检测到: roguelike_level = " .. cm:get_saved_value("roguelike_level"));
            dark_character_pin = cm:get_saved_value("dark_character_pin")
        end

        --读取随机武将抽取数量上限
        if not cm:get_saved_value("roguelike_max_refresh") then
            cm:set_saved_value("roguelike_max_refresh", refresh_num);
        else
            --ModLog("检测到: roguelike_max_refresh = " .. cm:get_saved_value("roguelike_max_refresh"));
            refresh_num = cm:get_saved_value("roguelike_max_refresh")
        end

        --读取敌人增益和等级
        if not cm:get_saved_value("roguelike_enemy_effect_key") then
            cm:set_saved_value("roguelike_enemy_effect_key", enemy_effect_key);
        else
            --ModLog("检测到: roguelike_enemy_effect_key");
            enemy_effect_key = cm:get_saved_value("roguelike_enemy_effect_key")
        end

        if not cm:get_saved_value("roguelike_enemy_effect_level") then
            cm:set_saved_value("roguelike_enemy_effect_level", enemy_effect_level);
        else
            --ModLog("检测到: roguelike_enemy_effect_level");
            enemy_effect_level = cm:get_saved_value("roguelike_enemy_effect_level")
        end

        --读取派系难度列表
        if cm:get_saved_value("roguelike_faction_difficulty") then
            --ModLog("检测到: 派系难度列表");
            faction_difficulty = cm:get_saved_value("roguelike_faction_difficulty");
        end

        --读取派系难度列表
        if cm:get_saved_value("roguelike_current_regions") then
            current_regions = cm:get_saved_value("roguelike_current_regions");
        end

        --读取派系难度列表
        if cm:get_saved_value("roguelike_counter") then
            counter = cm:get_saved_value("roguelike_counter");
        end

        if cm:get_saved_value("kill_character") then
            kill_character_table = cm:get_saved_value("character_kill_table");
        end

        for i, v in pairs(dark_character_info) do
            if not gst.lib_value_in_list(dark_character, i) 
            and not gst.lib_value_in_list(kill_character_table, i) 
            then
                local dark_char = gst.character_query_for_template(i)
                if not dark_char
                or dark_char:is_null_interface() then
                    gst.lib_table_insert(dark_character, i)
                end
            end
        end
        
        for i, v in pairs(dark_character_info) do
            ModLog(i)
            local dark_char = gst.character_query_for_template(i)
            if dark_char
            and not dark_char:is_null_interface()
            then
                if dark_char:is_dead() then
                    gst.lib_table_insert(kill_character_table, i)
                end
                gst.lib_remove_value_from_list(dark_character, i)
            end
        end
        
        ModLog("已亡故恶堕者：")
        local faction = cm:query_local_faction();
        for i, v in ipairs(kill_character_table) do
            gst.lib_remove_value_from_list(dark_character, v)
            ModLog(v)
--             local dark_chars = cm:query_model():all_characters_for_template(v)
--             if dark_chars then
--                 for j = 0, dark_chars:num_items() - 1 do
--                     dark_char = dark_chars:item_at(j)
--                     if dark_char
--                     and not dark_char:is_null_interface()
--                     and not dark_char:is_dead()
--                     then
--                         gst.lib_table_insert(kill_character_table, j)
--                         cm:modify_character(dark_char):kill_character(true)
--                     end
--                 end
--             end
            if faction:is_mission_active("xyy_roguelike_kill_" .. v) then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_" .. v)
                --add_dark_character_by_difficulty(3,cm:get_saved_value("xyy_roguelike_mission_target_faction"))
            end
        end
        
        ModLog("未出现的恶堕者：")
        for i, v in ipairs(dark_character) do
            ModLog(v)
        end
        
        cm:set_saved_value("dark_character", dark_character);
        cm:set_saved_value("character_kill_table", kill_character_table);
        
        if not faction:is_mission_active("xyy_roguelike_mission_ready")
            and not faction:is_mission_active("xyy_roguelike_mission_easy")
            and not faction:is_mission_active("xyy_roguelike_mission_normal")
            and not faction:is_mission_active("xyy_roguelike_mission_hard")
            and not faction:is_mission_active("xyy_roguelike_mission_boss")
            and not faction:is_mission_active("xyy_roguelike_mission_boss_2")
            and not faction:is_mission_active("xyy_roguelike_mission_boss_3")
            and not faction:is_mission_active("xyy_roguelike_mission_xyyhlyjf")
            and not cm:get_saved_value("huanlong_dead")
        then
            ModLog("roguelike_dilemma_continue")
            cm:trigger_dilemma(faction:name(), "roguelike_dilemma_continue", true);
        end

        --         cm:trigger_dilemma(faction:name(), "roguelike_dilemma_continue", true);

        self:register_roguelike_listeners()
    end
end

local offset = {
    [1] = {
        { ["x"] = 1068, ["y"] = 347 }
    },
    [2] = {
        { ["x"] = 1001, ["y"] = 347 },
        { ["x"] = 1136, ["y"] = 347 }
    },
    [3] = {
        { ["x"] = 932,  ["y"] = 347 },
        { ["x"] = 1068, ["y"] = 347 },
        { ["x"] = 1204, ["y"] = 347 }
    },
    [4] = {
        { ["x"] = 865,  ["y"] = 347 },
        { ["x"] = 1001, ["y"] = 347 },
        { ["x"] = 1136, ["y"] = 347 },
        { ["x"] = 1272, ["y"] = 347 }
    },
    [5] = {
        { ["x"] = 932,  ["y"] = 250 },
        { ["x"] = 1068, ["y"] = 250 },
        { ["x"] = 1204, ["y"] = 250 },
        { ["x"] = 1001, ["y"] = 444 },
        { ["x"] = 1136, ["y"] = 444 }
    },
    [6] = {
        { ["x"] = 932,  ["y"] = 250 },
        { ["x"] = 1068, ["y"] = 250 },
        { ["x"] = 1204, ["y"] = 250 },
        { ["x"] = 932,  ["y"] = 444 },
        { ["x"] = 1068, ["y"] = 444 },
        { ["x"] = 1204, ["y"] = 444 }
    },
    [7] = {
        { ["x"] = 865,  ["y"] = 250 },
        { ["x"] = 1001, ["y"] = 250 },
        { ["x"] = 1136, ["y"] = 250 },
        { ["x"] = 1272, ["y"] = 250 },
        { ["x"] = 932,  ["y"] = 444 },
        { ["x"] = 1068, ["y"] = 444 },
        { ["x"] = 1204, ["y"] = 444 }
    }
}

function is_faction_have_building(faction, building_list)
    if faction
        and not faction:is_null_interface()
        and not faction:is_dead()
    then
        for i = 0, faction:region_list():num_items() - 1 do
            local region = faction:region_list():item_at(i)
            for k, v in ipairs(building_list) do
                if region:building_exists(v) then
                    return true
                end
            end
        end
    end
    if faction:name() == cm:query_local_faction(true):name() then
        effect.advice(effect.get_localised_string("mod_xyy_roguelike_icon_no_building"))
    end
    return false
end

local function add_roguelike_button(parent, effect_bundle)
    local bt_name = UI_MOD_NAME .. "_button_" .. effect_bundle;
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_roguelike")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, 120, 180, true)
    gst.lib_recordObj(bt, btn_listener_name, roguelike_btn_table);
    local button_txt = "[[col:flavour]]" ..
    effect.get_localised_string("effect_bundles_localised_title_" .. effect_bundle) .. "[[/col]]"
    local text = effect.get_localised_string("effect_bundles_localised_description_" .. effect_bundle)
    bt:SetTooltipText(
    effect.get_localised_string("mod_xyy_roguelike_info") ..
    effect.get_localised_string("mod_info_" .. effect_bundle) ..
    "\n\n" ..
    effect.get_localised_string("mod_xyy_roguelike_description_" .. effect_bundles_info[effect_bundle]["element"]), true)

    local price = effect.get_localised_string("mod_xyy_roguelike_icon_" .. effect_bundles_info[effect_bundle]["element"]) ..
    "+" .. effect_bundles_info[effect_bundle]["point"]

    bt:SetState("hover")
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("down")
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("down_off")
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("inactive")
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("active")
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            bt:SetState("selected_inactive");
            selected_effect_bundle = effect_bundle;
            --ModLog(selected_effect_bundle);
            confirm_button:SetState("active");
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
            "mod_xyy_character_browser_confirm"))
            if slot_1_button and bt ~= slot_1_button then
                slot_1_button:SetState("active");
            end
            if slot_2_button and bt ~= slot_2_button then
                slot_2_button:SetState("active");
            end
            if slot_3_button and bt ~= slot_3_button then
                slot_3_button:SetState("active");
            end
            if slot_4_button and bt ~= slot_4_button then
                slot_4_button:SetState("active");
            end
            if slot_5_button and bt ~= slot_5_button then
                slot_5_button:SetState("active");
            end
            if slot_6_button and bt ~= slot_6_button then
                slot_6_button:SetState("active");
            end
            if slot_7_button and bt ~= slot_7_button then
                slot_7_button:SetState("active");
            end
        end,
        true
    )
    return bt;
end

local function add_enemy_effect_button(parent, effect_key)
    local bt_name = UI_MOD_NAME .. "_button_" .. effect_key;
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_roguelike")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, 120, 180, true)
    gst.lib_recordObj(bt, btn_listener_name, roguelike_btn_table);
    local button_txt = "[[col:flavour]]" ..
    effect.get_localised_string("effect_bundles_localised_title_" .. effect_key) .. "[[/col]]"
    local text = effect.get_localised_string("effect_bundles_localised_description_" .. effect_key)
    bt:SetTooltipText(
    effect.get_localised_string("mod_xyy_roguelike_info") ..
    effect.get_localised_string("mod_info_" .. effect_key), true)
                
    local price = ""

    bt:SetState("hover")
    bt:SetImagePath("ui/skins/default/roguelike/"..effect_key..".png");  
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("down")
    bt:SetImagePath("ui/skins/default/roguelike/"..effect_key..".png");  
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("down_off")
    bt:SetImagePath("ui/skins/default/roguelike/"..effect_key..".png");  
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("inactive")
    bt:SetImagePath("ui/skins/default/roguelike/"..effect_key..".png");  
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("active")
    bt:SetImagePath("ui/skins/default/roguelike/"..effect_key..".png");  
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            bt:SetState("selected_inactive");
            selected_enemy_effect_key = effect_key;
            --ModLog(selected_effect_bundle);
            confirm_button:SetState("active");
            find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
            "mod_xyy_character_browser_confirm"))
            if slot_1_button and bt ~= slot_1_button then
                slot_1_button:SetState("active");
            end
            if slot_2_button and bt ~= slot_2_button then
                slot_2_button:SetState("active");
            end
        end,
        true
    )
    return bt;
end

local function add_close_button(parent)
    local bt_name = UI_MOD_NAME .. "_store_close_btn";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_close_32")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    --bt:SetTooltipText("关闭", true)
    gst.UI_Component_resize(bt, bt_close_size_x, bt_close_size_y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            close_roguelike_store_pannel()
            --ModLog(UI_MOD_NAME)
            reset_pannel_index()
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name, roguelike_btn_table);
    return bt;
end

local function add_roguelike_store_button(parent, store_item)
    local bt_name = UI_MOD_NAME .. "_character_panel_" .. store_item;
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_roguelike_store")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, 120, 180, true)
    gst.lib_recordObj(bt, btn_listener_name, roguelike_btn_table);
    bt:SetTooltipText(
    effect.get_localised_string("mod_xyy_roguelike_info") .. effect.get_localised_string("mod_info_" .. store_item), true)
    local text = effect.get_localised_string("effect_bundles_localised_description_" .. store_item);
    local button_txt = "[[col:" ..
    item_info[store_item]["quality"] ..
    "]]" .. effect.get_localised_string("effect_bundles_localised_title_" .. store_item) .. "[[/col]]";
    local price = "[[img:pooled_resource_credibility]][[/img]]" .. item_info[store_item]["price"];

    bt:SetState("hover")
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("down")
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("down_off")
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("inactive")
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    bt:SetState("active")
    find_uicomponent(bt, "button_txt"):SetStateText(button_txt)
    find_uicomponent(bt, "main_text_1"):SetStateText(text)
    find_uicomponent(bt, "price_text"):SetStateText(price)
    
    if gst.lib_value_in_list(selected_store_items, store_item) then
        bt:SetState("selected");
    end

    if store_item == "xyy_roguelike_the_seven_kings" and not check_seven_kings_available() then
        bt:SetState("inactive")
        bt:SetTooltipText(effect.get_localised_string("mod_store_disble_reason_the_seven_kings_dead") .. 
        effect.get_localised_string("mod_xyy_roguelike_info") .. effect.get_localised_string("mod_info_" .. store_item), true)
    end
    
    if store_item == "xyy_roguelike_sima_yi" then
        local sima_yi = gst.character_query_for_template("3k_main_template_historical_sima_yi_hero_water")
        if sima_yi 
        and not sima_yi:is_null_interface()
        then
            if sima_yi:is_dead() then
                bt:SetState("inactive")
                bt:SetTooltipText(effect.get_localised_string("mod_store_disble_reason_character_dead") .. 
                effect.get_localised_string("mod_xyy_roguelike_info") .. effect.get_localised_string("mod_info_" .. store_item), true)
            end
            if sima_yi:faction():name() == cm:query_local_faction():name()
            and not sima_yi:is_character_is_faction_recruitment_pool()
            then
                bt:SetState("inactive")
                bt:SetTooltipText(effect.get_localised_string("mod_store_disble_reason_already_have_character") .. 
                effect.get_localised_string("mod_xyy_roguelike_info") .. effect.get_localised_string("mod_info_" .. store_item), true)
            end
        end
    end

    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if not gst.lib_value_in_list(selected_store_items, store_item) then
                gst.lib_table_insert(selected_store_items, store_item)
                bt:SetState("selected");
            else
                gst.lib_remove_value_from_list(selected_store_items, store_item)
                bt:SetState("active");
            end

            local faction_name = cm:query_local_faction():name();
            local player_tickets = cm:get_saved_value("ticket_points_" .. faction_name)
            
            if player_tickets > 40000 then
                player_tickets = player_tickets - 500 * 98
                cm:set_saved_value("ticket_points_" .. faction_name, player_tickets)
            end
            
            if #selected_store_items > 0 then
                local string_text = "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets;
                local final_tickets = player_tickets;
                for k, v in ipairs(selected_store_items) do
                    string_text = string_text .. " - " .. item_info[v]["price"];
                    final_tickets = final_tickets - item_info[v]["price"];
                end
                string_text = string_text .. " = [[img:pooled_resource_credibility]][[/img]]" .. final_tickets;
                if final_tickets < 0 then
                    store_confirm_button:SetState("inactive")
                    find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
                    "mod_xyy_roguelike_confirm") .. string_text)
                else
                    if gst.lib_value_in_list(selected_store_items, "xyy_roguelike_craft_accessories") then
                        local building_list = gst.building_list["xyy_roguelike_craft_accessories"]
                        if not is_faction_have_building(cm:query_local_faction(), building_list) then
                            store_confirm_button:SetState("inactive")
                            find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect
                            .get_localised_string("mod_xyy_roguelike_confirm") ..
                            "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets)
                            return;
                        end
                    end
                    if gst.lib_value_in_list(selected_store_items, "xyy_roguelike_craft_accessories_1") then
                        
                        local building_list = gst.building_list["xyy_roguelike_craft_accessories_1"]
                        if not is_faction_have_building(cm:query_local_faction(), building_list) then
                            store_confirm_button:SetState("inactive")
                            find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect
                            .get_localised_string("mod_xyy_roguelike_confirm") ..
                            "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets)
                            return;
                        end
                    end
                    if gst.lib_value_in_list(selected_store_items, "xyy_roguelike_craft_weapons") then
                        local building_list = gst.building_list["xyy_roguelike_craft_weapons"]
                        if not is_faction_have_building(cm:query_local_faction(), building_list) then
                            store_confirm_button:SetState("inactive")
                            find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect
                            .get_localised_string("mod_xyy_roguelike_confirm") ..
                            "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets)
                            return;
                        end
                    end
                    if gst.lib_value_in_list(selected_store_items, "xyy_roguelike_craft_weapons_1") then
                        local building_list = gst.building_list["xyy_roguelike_craft_weapons_1"]
                        if not is_faction_have_building(cm:query_local_faction(), building_list) then
                            store_confirm_button:SetState("inactive")
                            find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect
                            .get_localised_string("mod_xyy_roguelike_confirm") ..
                            "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets)
                            return;
                        end
                    end
                    if gst.lib_value_in_list(selected_store_items, "xyy_roguelike_craft_mounts") then
                        local building_list = gst.building_list["xyy_roguelike_craft_mounts"]
                        if not is_faction_have_building(cm:query_local_faction(), building_list) then
                            store_confirm_button:SetState("inactive")
                            find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect
                            .get_localised_string("mod_xyy_roguelike_confirm") ..
                            "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets)
                            return;
                        end
                    end
                    if gst.lib_value_in_list(selected_store_items, "xyy_roguelike_craft_mounts_1") then
                        local building_list = gst.building_list["xyy_roguelike_craft_mounts_1"]
                        if not is_faction_have_building(cm:query_local_faction(), building_list) then
                            store_confirm_button:SetState("inactive")
                            find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect
                            .get_localised_string("mod_xyy_roguelike_confirm") ..
                            "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets)
                            return;
                        end
                    end
                    if gst.lib_value_in_list(selected_store_items, "xyy_roguelike_craft_armors") then
                        local building_list = gst.building_list["xyy_roguelike_craft_armors"]
                        if not is_faction_have_building(cm:query_local_faction(), building_list) then
                            store_confirm_button:SetState("inactive")
                            find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect
                            .get_localised_string("mod_xyy_roguelike_confirm") ..
                            "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets)
                            return;
                        end
                    end
                    if gst.lib_value_in_list(selected_store_items, "xyy_roguelike_craft_armors_1") then
                        local building_list = gst.building_list["xyy_roguelike_craft_armors_1"]
                        if not is_faction_have_building(cm:query_local_faction(), building_list) then
                            store_confirm_button:SetState("inactive")
                            find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect
                            .get_localised_string("mod_xyy_roguelike_confirm") ..
                            "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets)
                            return;
                        end
                    end
                    store_confirm_button:SetState("active")
                    find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
                    "mod_xyy_roguelike_confirm") .. string_text)
                end
            else
                store_confirm_button:SetState("inactive")
                find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
                "mod_xyy_roguelike_confirm") .. "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets)
            end
        end,
        true
    )
    return bt;
end

local function refresh_pannel()
    refresh_num = refresh_num - 1
    cm:set_saved_value("roguelike_max_refresh", refresh_num);

    roguelike_panel:SetVisible(false)
    for i = 1, #roguelike_btn_table do
        core:remove_listener(gst.lib_getRecordObjLisName(roguelike_btn_table[i]))
        gst.UI_Component_destroy(gst.lib_getRecordObj(roguelike_btn_table[i]))
    end
    roguelike_btn_table = {}
    slot_1_button = nil;
    slot_2_button = nil;
    slot_3_button = nil;
    slot_4_button = nil;
    slot_5_button = nil;
    slot_6_button = nil;
    slot_7_button = nil;
    gst.UI_Component_destroy(roguelike_panel)
    roguelike_panel = nil
    static_index = static_index + 1;
    --ModLog(UI_MOD_NAME)
    openRoguelikePanel(true)
end

local function add_refresh_button(parent)
    local bt_name = UI_MOD_NAME .. "_refresh_button"
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/3k_btn_battle_control")
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, 60, 60, true)
    bt:SetImagePath("ui/skins/default/roguelike/refresh.png");
    bt:SetTooltipText(effect.get_localised_string("mod_xyy_roguelike_refresh_button"), true)
    gst.lib_recordObj(bt, btn_listener_name, roguelike_btn_table);

    if refresh_num <= 0 then
        bt:SetState("inactive")
    end
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if refresh_num > 0 then
                refresh_pannel()
            end
        end,
        true
    )
    return bt;
end

local function add_store_confirm_button(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_store_confirm";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = gst.character_query_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            local clist = selected_store_items
            selected_store_items = {}
            close_roguelike_store_pannel()
            reset_pannel_index()
            cm:wait_for_model_sp(
                function()
                    for k, effect_bundle in ipairs(clist) do
                        ----ModLog(k..": "..effect_bundle)
                        local faction = cm:query_local_faction();
                        gst.faction_subtract_tickets(faction:name(), item_info[effect_bundle]["price"]);
                        local time = -1;
                        if item_info[effect_bundle]["time"] then
                            time = item_info[effect_bundle]["time"];
                        end
                        cm:modify_faction(faction):apply_effect_bundle(effect_bundle, time);
                        gst.lib_remove_value_from_list(store_table, effect_bundle);
                    end
                    cm:set_saved_value("roguelike_store_table", store_table);
                    cm:modify_model():get_modify_episodic_scripting():autosave_at_next_opportunity();
                end
            )
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name, roguelike_btn_table);
    return bt;
end

local function add_confirm_button(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_confirm";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = gst.character_query_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if selected_effect_bundle then
                --ModLog(selected_effect_bundle)
                local effect_key = selected_effect_bundle;
                selected_effect_bundle = nil
                roguelike_panel:SetVisible(false)
                for i = 1, #roguelike_btn_table do
                    core:remove_listener(gst.lib_getRecordObjLisName(roguelike_btn_table[i]))
                    gst.UI_Component_destroy(gst.lib_getRecordObj(roguelike_btn_table[i]))
                end
                roguelike_btn_table = {}
                slot_1_button = nil;
                slot_2_button = nil;
                slot_3_button = nil;
                slot_4_button = nil;
                slot_5_button = nil;
                slot_6_button = nil;
                slot_7_button = nil;
                gst.UI_Component_destroy(roguelike_panel)
                roguelike_panel = nil
                static_index = static_index + 1;
                --ModLog(UI_MOD_NAME)
                cm:wait_for_model_sp(
                    function()
                        local faction = cm:query_local_faction();
                        local time = -1;
                        if effect_bundles_info[effect_key]["time"] then
                            time = effect_bundles_info[effect_key]["time"];
                        end
                        cm:modify_faction(faction):apply_effect_bundle(effect_key, time)
                        gst.lib_remove_value_from_list(effect_bundles_table, effect_key);
                        gst.lib_table_insert(unlocked_table, effect_key);
                        cm:set_saved_value("roguelike_unlocked_table", unlocked_table);

                        if faction:has_effect_bundle("xyy_roguelike_redraw_1") then
                            refresh_num = 1
                            cm:set_saved_value("roguelike_max_refresh", refresh_num);
                        end

                        cm:set_saved_value("roguelike_effect_bundles_table", effect_bundles_table);

                        if cm:get_saved_value("roguelike_panel_list")
                            and cm:get_saved_value("roguelike_panel_list") > 0
                        then
                            --ModLog("重新打开roguelike_panel")
                            cm:set_saved_value("roguelike_panel_list", cm:get_saved_value("roguelike_panel_list") - 1)
                            openRoguelikePanel(false);
                            return;
                        end

                        if not cm:get_saved_value("roguelike_safe_trigger_2") then
                            next_level(faction)
                            return;
                        else
                            --ModLog("不创建任务")
                            cm:set_saved_value("roguelike_safe_trigger_2", false)
                        end
                        if not faction:is_mission_active("xyy_roguelike_mission_hard")
                            and not faction:is_mission_active("xyy_roguelike_mission_easy")
                            and not faction:is_mission_active("xyy_roguelike_mission_normal")
                            and not faction:is_mission_active("xyy_roguelike_mission_ready")
                            and not faction:is_mission_active("xyy_roguelike_mission_boss")
                            and not faction:is_mission_active("xyy_roguelike_mission_boss_2")
                            and not faction:is_mission_active("xyy_roguelike_mission_boss_3")
                            and not cm:get_saved_value("huanlong_dead")
                        then
                            next_level(faction)
                            return;
                        end
                        cm:modify_model():get_modify_episodic_scripting():autosave_at_next_opportunity();
                        enable_menu_button()
                        CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_false");
                        -- cm:modify_model():get_modify_episodic_scripting():disable_end_turn(false);
                        -- cm:modify_scripting():disable_shortcut("button_end_turn", "end_turn", false);
                        -- cm:modify_scripting():override_ui("disable_end_turn", false);
                    end
                )
            end
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name, roguelike_btn_table);
    return bt;
end

local function add_enemy_effect_confirm_button(parent, x, y)
    local bt_name = UI_MOD_NAME .. "_confirm";
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = gst.character_query_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if selected_enemy_effect_key then
                --ModLog(selected_effect_bundle)
                enemy_effect_key = selected_enemy_effect_key;
                selected_enemy_effect_key = nil
                roguelike_panel:SetVisible(false)
                for i = 1, #roguelike_btn_table do
                    core:remove_listener(gst.lib_getRecordObjLisName(roguelike_btn_table[i]))
                    gst.UI_Component_destroy(gst.lib_getRecordObj(roguelike_btn_table[i]))
                end
                roguelike_btn_table = {}
                slot_1_button = nil;
                slot_2_button = nil;
                slot_3_button = nil;
                slot_4_button = nil;
                slot_5_button = nil;
                slot_6_button = nil;
                slot_7_button = nil;
                gst.UI_Component_destroy(roguelike_panel)
                roguelike_panel = nil
                static_index = static_index + 1;
                --ModLog(UI_MOD_NAME)
                cm:wait_for_model_sp(
                    function()
                        change_enemy_effect(enemy_effect_key)
                        if cm:get_saved_value("roguelike_panel_list")
                            and cm:get_saved_value("roguelike_panel_list") > 0
                        then
                            --ModLog("重新打开roguelike_panel")
                            cm:set_saved_value("roguelike_panel_list", cm:get_saved_value("roguelike_panel_list") - 1)
                            openRoguelikePanel(false);
                            return;
                        end
                        cm:modify_model():get_modify_episodic_scripting():autosave_at_next_opportunity();
                        enable_menu_button()
                        CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_false");
                    end
                )
            end
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name, roguelike_btn_table);
    return bt;
end

function openRoguelikePanel(refresh)
    if not refresh then
        if roguelike_panel then
            --ModLog("roguelike_panel存在，添加至队列")
            if not cm:get_saved_value("roguelike_panel_list") then
                cm:set_saved_value("roguelike_panel_list", 1)
            else
                cm:set_saved_value("roguelike_panel_list", cm:get_saved_value("roguelike_panel_list") + 1)
            end
            return;
        end
        effect_bundles_table = gst.lib_shuffle_table(effect_bundles_table);
        --         cm:modify_model():get_modify_episodic_scripting():disable_end_turn(true);
        --         cm:modify_scripting():disable_shortcut("button_end_turn", "end_turn", true);
        --         cm:modify_scripting():override_ui("disable_end_turn", true);
    else
        for i = 1, max do
            gst.lib_move_value_to_bottom(effect_bundles_table, effect_bundles_table[1]);
        end
    end

    if max > #effect_bundles_table then
        max = #effect_bundles_table
    end

    if max < 1 then
        return
    end

    UI_MOD_NAME = "xyy_roguelike_mode_" .. static_index
    --ModLog(UI_MOD_NAME);
    local ui_root = core:get_ui_root();
    local ui_panel_name = UI_MOD_NAME .. "_panel";
    roguelike_panel = core:get_or_create_component(ui_panel_name, "ui/templates/xyy_roguelike");  --选择模板文件
    ui_root:Adopt(roguelike_panel:Address());
    roguelike_panel:PropagatePriority(ui_root:Priority());
    local x, y, w, h = gst.UI_Component_coordinates(ui_root);
    --设置panel的大小
    gst.UI_Component_resize(roguelike_panel, panel_size_x, panel_size_y, true);

    --移动panel的相对位置
    gst.UI_Component_move_relative(roguelike_panel, ui_root, (w - panel_size_x) / 2, 100, false);


    if cm:query_local_faction():has_effect_bundle("xyy_roguelike_redraw_1") then
        local refresh_button = add_refresh_button(roguelike_panel)
        gst.UI_Component_move_relative(refresh_button, roguelike_panel, 800, 665, false);
    end

    slot_1_button = add_roguelike_button(roguelike_panel, effect_bundles_table[1]);
    gst.UI_Component_move_relative(slot_1_button, roguelike_panel, offset[max][1]["x"], offset[max][1]["y"], false);

    if max >= 2 then
        slot_2_button = add_roguelike_button(roguelike_panel, effect_bundles_table[2]);
        gst.UI_Component_move_relative(slot_2_button, roguelike_panel, offset[max][2]["x"], offset[max][2]["y"], false);
    end

    if max >= 3 then
        slot_3_button = add_roguelike_button(roguelike_panel, effect_bundles_table[3]);
        gst.UI_Component_move_relative(slot_3_button, roguelike_panel, offset[max][3]["x"], offset[max][3]["y"], false);
    end

    if max >= 4 then
        slot_4_button = add_roguelike_button(roguelike_panel, effect_bundles_table[4]);
        gst.UI_Component_move_relative(slot_4_button, roguelike_panel, offset[max][4]["x"], offset[max][4]["y"], false);
    end
    if max >= 5 then
        slot_5_button = add_roguelike_button(roguelike_panel, effect_bundles_table[5]);
        gst.UI_Component_move_relative(slot_5_button, roguelike_panel, offset[max][5]["x"], offset[max][5]["y"], false);
    end
    if max >= 6 then
        slot_6_button = add_roguelike_button(roguelike_panel, effect_bundles_table[6]);
        gst.UI_Component_move_relative(slot_6_button, roguelike_panel, offset[max][6]["x"], offset[max][6]["y"], false);
    end
    if max >= 7 then
        slot_7_button = add_roguelike_button(roguelike_panel, effect_bundles_table[7]);
        gst.UI_Component_move_relative(slot_7_button, roguelike_panel, offset[max][7]["x"], offset[max][7]["y"], false);
    end
    confirm_button = add_confirm_button(roguelike_panel, 500, 50)
    gst.UI_Component_move_relative(confirm_button, roguelike_panel, 880, 670, false)

    confirm_button:SetState("down")
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
    "mod_xyy_character_browser_confirm"))

    confirm_button:SetState("inactive")
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
    "mod_xyy_character_browser_confirm"))
    if cm:get_saved_value("issued_dilemma") then
        roguelike_panel:SetVisible(false);
    else
        roguelike_panel:SetVisible(true);
    end
    disable_menu_button()
    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_true");
end

local function add_store_page_button(parent, x, y, next_or_previous)
    local bt_name
    if next_or_previous then
        bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_page_next";
    else
        bt_name = UI_MOD_NAME .. "_xyy_select_character_panel_page_previous";
    end
    local btn_listener_name = bt_name .. "_click_up"
    local bt = core:get_or_create_component(bt_name, "ui/templates/square_large_text_button")
    -- local character = gst.character_query_for_template(character_key);
    parent:Adopt(bt:Address())
    bt:PropagatePriority(parent:Priority())
    gst.UI_Component_resize(bt, x, y, true)
    if next_or_previous then
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_next_page_tooltip"), true)
    else
        bt:SetTooltipText(effect.get_localised_string("mod_xyy_character_browser_previous_page_tooltip"), true)
    end
    core:add_listener(
        btn_listener_name,
        "ComponentLClickUp",
        function(context)
            return bt == UIComponent(context.component)
        end,
        function(context)
            if next_or_previous then
                store_page = store_page + 1;
            else
                store_page = store_page - 1;
                if store_page < 0 then
                    store_page = 0;
                end
            end
            --隐藏商店面板
            if roguelike_store_panel ~= nil then
                roguelike_store_panel:SetVisible(false)
            end

            roguelike_btn_table = {}
            gst.UI_Component_destroy(roguelike_store_panel)
            roguelike_store_panel = nil

            --销毁商店面板
            gst.UI_Component_destroy(parent)
            parent = nil
            static_index = static_index + 1
            openRoguelikeStorePanel()
        end,
        false
    )
    gst.lib_recordObj(bt, btn_listener_name, roguelike_btn_table);
    return bt;
end

function openRoguelikeStorePanel()
    if roguelike_panel then
        return;
    end
    UI_MOD_NAME = "xyy_roguelike_store_" .. static_index
    --ModLog(UI_MOD_NAME);
    local ui_root = core:get_ui_root();
    local ui_panel_name = UI_MOD_NAME .. "_panel";
    roguelike_store_panel = core:get_or_create_component(ui_panel_name, "ui/templates/xyy_roguelike_store");  --选择模板文件
    ui_root:Adopt(roguelike_store_panel:Address());
    roguelike_store_panel:PropagatePriority(ui_root:Priority());
    local x, y, w, h = gst.UI_Component_coordinates(ui_root);
    --设置panel的大小
    gst.UI_Component_resize(roguelike_store_panel, panel_size_x, panel_size_y, true);

    --移动panel的相对位置
    gst.UI_Component_move_relative(roguelike_store_panel, ui_root, (w - panel_size_x) / 2, 100, false);

    --创建界面中的关闭按钮
    local bt_close = add_close_button(roguelike_store_panel)
    --移动关闭按钮的相对位置
    gst.UI_Component_move_relative(bt_close, roguelike_store_panel, panel_size_x - bt_close_size_x - 350, 100, false)
    --local shuffled = gst.lib_shuffle_table(effect_bundles_table);

    --effect_bundles_table = shuffled;
    local i = 0
    local has_next_page = false
    table.sort(store_table)
    for i = 1, #store_table do
        local store_item = store_table[i + 18 * store_page]
        if not store_item then
            has_next_page = false
            break;
        end
        if i > 18 then
            has_next_page = true
            break;
        end
        local x = 306 + (i + 18 * store_page - 1) % 9 * 136
        local y = 250 + math.floor((i + 18 * store_page - 1) / 9 - 2 * store_page) * 194
        if not item_info[store_item] then
            gst.lib_remove_value_from_list(store_table, store_item);
            i = i - 1
        else
            local store_button = add_roguelike_store_button(roguelike_store_panel, store_item);
            gst.UI_Component_move_relative(store_button, roguelike_store_panel, x, y, false);
        end
        --gst.lib_table_insert(store_table_buttons, [store_item] = store_button);
    end

    if has_next_page then
        local next_page_button = add_store_page_button(roguelike_store_panel, 50, 50, true)
        gst.UI_Component_move_relative(next_page_button, roguelike_store_panel, 1380, 720, false)
        next_page_button:SetState("down")
        find_uicomponent(next_page_button, "button_txt"):SetStateText(">>")
        next_page_button:SetState("active")
        find_uicomponent(next_page_button, "button_txt"):SetStateText(">>")
    end
    if store_page > 0 then
        local previous_page_button = add_store_page_button(roguelike_store_panel, 50, 50, false)
        gst.UI_Component_move_relative(previous_page_button, roguelike_store_panel, 490, 720, false)
        previous_page_button:SetState("down")
        find_uicomponent(previous_page_button, "button_txt"):SetStateText("<<")
        previous_page_button:SetState("active")
        find_uicomponent(previous_page_button, "button_txt"):SetStateText("<<")
    end

    store_confirm_button = add_store_confirm_button(roguelike_store_panel, 800, 50)
    gst.UI_Component_move_relative(store_confirm_button, roguelike_store_panel, 560, 720, false)

    local faction_name = cm:query_local_faction():name();
    local player_tickets = cm:get_saved_value("ticket_points_" .. faction_name)
    store_confirm_button:SetState("down")
    find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
    "mod_xyy_roguelike_confirm_wait"))

    store_confirm_button:SetState("inactive")
    find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
    "mod_xyy_roguelike_confirm") .. "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets)
    roguelike_store_panel:SetVisible(true);
    if #selected_store_items > 0 then
        local string_text = "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets;
        local final_tickets = player_tickets;
        for k, v in ipairs(selected_store_items) do
            string_text = string_text .. " - " .. item_info[v]["price"];
            final_tickets = final_tickets - item_info[v]["price"];
        end
        string_text = string_text .. " = [[img:pooled_resource_credibility]][[/img]]" .. final_tickets;
        if final_tickets < 0 then
            store_confirm_button:SetState("inactive")
            find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
            "mod_xyy_roguelike_confirm") .. string_text)
        else
            store_confirm_button:SetState("active")
            find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
            "mod_xyy_roguelike_confirm") .. string_text)
        end
    else
        store_confirm_button:SetState("inactive")
        find_uicomponent(store_confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
        "mod_xyy_roguelike_confirm") .. "[[img:pooled_resource_credibility]][[/img]]" .. player_tickets)
    end
--     cm:steal_escape_key_with_callback("xyy_roguelike_store_panel", function()
--         close_roguelike_store_pannel()
--     end)
    CampaignUI.CreateModelCallbackRequest("xyy_callback_xyy_roguelike_store_panel_open");
end

function next_level(faction)
    if faction:is_mission_active("xyy_roguelike_mission_easy")
    or faction:is_mission_active("xyy_roguelike_mission_normal")
    or faction:is_mission_active("xyy_roguelike_mission_hard")
    or faction:is_mission_active("xyy_roguelike_mission_xyyhlyjf")
    then
        return;
    end
    local count = 0;
    cm:set_saved_value("xyy_roguelike_mission", false)
    cm:set_saved_value("xyy_roguelike_mission_perfect", 0);
    for k, v in pairs(faction_difficulty) do
        if faction_difficulty[k]
            and cm:query_faction(k)
            and not cm:query_faction(k):is_dead()
        then
            ModLog(k)
            count = count + 1
        end
    end
    if count > 1 and enemy_effect_level < 6 then
        local mission = string_mission:new("xyy_roguelike_mission_ready")
        mission:set_issuer("3k_main_victory_objective_issuer");
        mission:add_primary_objective("SCRIPTED",
            { "script_key treaty_components_war",
                "override_text mission_text_text_treaty_components_war" }
        );
        mission:add_primary_payload("text_display{lookup dummy_roguelike_ready;}");
        mission:set_turn_limit(5);
        mission:trigger_mission_for_faction(faction:name())
    else
        diplomacy_manager:apply_automatic_deal_between_factions("xyyhlyjf", faction:name(), "data_defined_situation_war_proposer_to_recipient", false);
        trigger_mission(faction:name(), "xyyhlyjf")
        gst.faction_create_military_force("xyyhlyjf", cm:query_faction("xyyhlyjf"):capital_region():name(),
            cm:query_faction("xyyhlyjf"):faction_leader())
        cm:trigger_mission(faction, "xyy_roguelike_mission_boss", true);
        cm:set_saved_value("xyy_roguelike_mission_boss", true)
        cm:set_saved_value("xyy_roguelike_mission_boss_character_browser", true)
    end
    cm:modify_model():get_modify_episodic_scripting():autosave_at_next_opportunity();
    cm:modify_model():get_modify_episodic_scripting():disable_end_turn(false);
    enable_menu_button()
    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_false");
end

function close_roguelike_store_pannel()
    if roguelike_store_panel then
        roguelike_store_panel:SetVisible(false)
        for i = 1, #roguelike_btn_table do
            core:remove_listener(gst.lib_getRecordObjLisName(roguelike_btn_table[i]))
            gst.UI_Component_destroy(gst.lib_getRecordObj(roguelike_btn_table[i]))
        end
        roguelike_btn_table = {}
        gst.UI_Component_destroy(roguelike_store_panel)
        roguelike_store_panel = nil
        static_index = static_index + 1;
        --ModLog(UI_MOD_NAME)
    end
    enable_menu_button()
    CampaignUI.CreateModelCallbackRequest("xyy_callback_xyy_roguelike_store_panel_close");
end

function trigger_mission(local_faction_key, target_faction_key)
    local faction = cm:query_faction(local_faction_key)
    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_mission_ready")
    cm:set_saved_value("xyy_roguelike_mission_target_faction", target_faction_key)
    --禁用两个派系之间的和平谈判
    cm:modify_model():disable_diplomacy("faction:" .. target_faction_key, "faction:" .. local_faction_key,
        "treaty_components_peace,treaty_components_peace_no_event", "hidden")
    --开启任务（确定难度）
    local mission_key;
    local rating = faction_difficulty[target_faction_key]
    if level == 2 then --2级
        add_dark_character_by_difficulty(1, target_faction_key)
    elseif level == 4 then --3级
        add_dark_character_by_difficulty(1, target_faction_key)
    elseif level == 6 then --4级
        add_dark_character_by_difficulty(1, target_faction_key)
    elseif level == 7 then
        add_dark_character_by_difficulty(2, target_faction_key)
    elseif level == 8 then --5级
        add_dark_character_by_difficulty(2, target_faction_key)
        add_dark_character_by_difficulty(2, target_faction_key)
    elseif level == 9 then
        add_dark_character_by_difficulty(2, target_faction_key)
        add_dark_character_by_difficulty(3, target_faction_key)
    elseif level == 10 then
        add_dark_character_by_difficulty(3, target_faction_key)
        add_dark_character_by_difficulty(3, target_faction_key)
        add_dark_character_by_difficulty(3, target_faction_key)
    elseif level == 11 then
    elseif level == 12 then
    end
    for i, v in pairs(dark_character_info) do
        local dark_char = gst.character_query_for_template(i)
        if dark_char
            and not dark_char:is_null_interface()
            and not dark_char:is_dead()
        then
            if dark_char:faction():name() ~= target_faction_key then
                cm:modify_character(dark_char):move_to_faction_and_make_recruited(target_faction_key)
--                 cm:trigger_mission(cm:query_local_faction(), "kill_" .. i, true)
            end
        end
    end
    --ModLog(rating)
    if target_faction_key == "xyyhlyjf" then
        add_force_to_xyyhlyjf();
        mission_key = "xyy_roguelike_mission_xyyhlyjf"
    elseif rating > 550 then
        mission_key = "xyy_roguelike_mission_hard"
        cm:set_saved_value("xyy_roguelike_mission_perfect", 20)
        cm:set_saved_value("xyy_roguelike_mission", "xyy_roguelike_mission_hard")
    elseif rating > 350 then
        mission_key = "xyy_roguelike_mission_normal"
        cm:set_saved_value("xyy_roguelike_mission_perfect", 15)
        cm:set_saved_value("xyy_roguelike_mission", "xyy_roguelike_mission_normal")
    else
        mission_key = "xyy_roguelike_mission_easy"
        cm:set_saved_value("xyy_roguelike_mission_perfect", 10)
        cm:set_saved_value("xyy_roguelike_mission", "xyy_roguelike_mission_easy")
    end
    if not faction:is_mission_active(mission_key) then
        local mission = string_mission:new(mission_key);
        mission:add_primary_objective("DESTROY_FACTION", { "faction " .. target_faction_key });
        mission:add_primary_payload("text_display{lookup " .. mission_key .. ";}");
        
        mission:trigger_mission_for_faction(faction:name());
    end
--     if (level > 6 or cm:get_saved_value("roguelike_enemy_effect_key") == "xyy_roguelike_enemy_earth")
--     and not cm:query_faction(target_faction_key):is_world_leader() 
--     and target_faction_key ~= "xyyhlyjf"
--     then
--         if cm:query_local_faction():number_of_world_leader_regions() >= 2 then
--             for i = 0, cm:query_local_faction():region_list():num_items() - 1 do
--                 local region = cm:query_local_faction():region_list():item_at(i)
--                 if region:name() ~= cm:query_local_faction():capital_region():name() then
--                     cm:modify_model():get_modify_world():remove_world_leader_region_status(region:name());
--                 end
--                 if cm:query_local_faction():number_of_world_leader_regions() < 2 then
--                     ModLog("玩家的另一个皇位没收：" .. region:name())
--                     break;
--                 end
--             end
--         end
--         local region_key = cm:query_faction(target_faction_key):capital_region():name()
--         ModLog("添加AI皇位" .. region_key)
--         cm:modify_model():get_modify_world():add_world_leader_region_status(region_key);
--     end
    
--     diplomacy_manager:force_confederation(faction:name(), target_faction_key);
    
end

function add_dark_character_by_difficulty(difficulty, faction_key)
    if #dark_character == 0 then return end
    local add_table = {}
    for i, v in ipairs(dark_character) do
        if dark_character_info[v]["difficulty"] <= difficulty then
            gst.lib_table_insert(add_table, v)
        end
    end
    local shuffle_table = gst.lib_shuffle_table(add_table)
    return add_dark_character(shuffle_table[1], faction_key)
end

function add_dark_character(character_key, faction_key)
    if gst.lib_value_in_list(dark_character, character_key) then
        
        local character = gst.character_add_to_faction(character_key, "xyyhlyjf",
            "3k_general_" .. dark_character_info[character_key]["element"])
        cm:modify_character(character):apply_effect_bundle("dark_character", -1)
        cm:modify_character(character):add_experience(295000, 0);
        local faction = cm:query_faction(faction_key)
        if character_key == "hlyjcj_dark" then
            gst.character_add_CEO_and_equip("hlyjcj_dark", "hlyjcjwuqi_dark", "3k_main_ceo_category_ancillary_weapon")
            cm:modify_faction(faction):ceo_management():remove_ceos("hlyjcjwuqi_faction")
        end
        if character_key == "hlyjcm_dark" then
            gst.character_add_CEO_and_equip("hlyjcm_dark", "hlyjcmwuqi_dark", "3k_main_ceo_category_ancillary_weapon")
            cm:modify_faction(faction):ceo_management():remove_ceos("hlyjcmwuqi")
        end
        if character_key == "hlyjcn_dark" then
            gst.character_add_CEO_and_equip("hlyjcn_dark", "hlyjcnwuqi_dark", "3k_main_ceo_category_ancillary_weapon")
            cm:modify_faction(faction):ceo_management():remove_ceos("hlyjcnwuqi")
        end
        if character_key == "hlyjda_dark" then
            gst.character_add_CEO_and_equip("hlyjda_dark", "hlyjdawuqi_dark", "3k_main_ceo_category_ancillary_weapon")
            cm:modify_faction(faction):ceo_management():remove_ceos("hlyjdawuqi")
        end
        if character_key == "hlyjdt_dark" then
            gst.character_add_CEO_and_equip("hlyjdt_dark", "hlyjdtwuqi_dark", "3k_main_ceo_category_ancillary_weapon")
            cm:modify_faction(faction):ceo_management():remove_ceos("hlyjdtwuqi")
        end
        if character_key == "hlyjdy_dark" then
            gst.character_add_CEO_and_equip("hlyjdy_dark", "hlyjdywuqi_dark", "3k_main_ceo_category_ancillary_weapon")
            cm:modify_faction(faction):ceo_management():remove_ceos("hlyjdywuqi")
        end
        if character_key == "hlyjck_dark" then
            gst.character_CEO_unequip("hlyjck_dark", "hlyjckyanzhao");
            gst.character_add_CEO_and_equip("hlyjck_dark", "3k_main_ancillary_accessory_art_of_war",
                "3k_main_ceo_category_ancillary_accessory");
            gst.character_add_CEO_and_equip("hlyjck_dark", "hlyjckwuqi_dark", "3k_main_ceo_category_ancillary_weapon");
            cm:modify_faction(faction):ceo_management():remove_ceos("hlyjckwuqi_faction")
        end
        gst.character_add_CEO_and_equip(character_key, "hlyjdingzhiezuoqi", "3k_main_ceo_category_ancillary_mount")
        gst.character_remove_all_traits(character)
        cm:modify_character(character):ceo_management():add_ceo("dark_character");
        gst.lib_remove_value_from_list(dark_character, character_key);
        local incident = cm:modify_model():create_incident("dark_character_join");
        incident:add_character_target("target_character_1", character);
        incident:trigger(cm:modify_faction(cm:query_local_faction()), true);
        cm:modify_character(character):move_to_faction_and_make_recruited(faction_key)
        
        if character_key == "hlyjcm_dark" and gst.lib_value_in_list(dark_character, "hlyjdf_dark") then
            add_dark_character("hlyjdf_dark", faction_key)
        end
        
        if character_key == "hlyjdf_dark" and gst.lib_value_in_list(dark_character, "hlyjcm_dark") then
            add_dark_character("hlyjcm_dark", faction_key)
        end
        
        local mission_key = "xyy_roguelike_kill_" .. character_key
        local mission = string_mission:new(mission_key)
        mission:set_issuer("3k_main_victory_objective_issuer");
        mission:add_primary_objective("SCRIPTED",
            { "script_key treaty_components_war",
                "override_text mission_text_" .. mission_key }
        );
        mission:add_primary_payload("text_display{lookup kill_" .. character_key .. ";}");
        if dark_character_info[character_key]["difficulty"] == 1 then
            mission:add_primary_payload("effect_bundle{bundle_key dark_character_easy;}");
        end
        if dark_character_info[character_key]["difficulty"] == 2 then
            mission:add_primary_payload("effect_bundle{bundle_key dark_character_normal;}");
        end
        if dark_character_info[character_key]["difficulty"] == 3 then
            mission:add_primary_payload("effect_bundle{bundle_key dark_character_hard;}");
        end
        mission:trigger_mission_for_faction(cm:query_local_faction():name())
        cm:set_saved_value("dark_character", dark_character)
        ModLog(mission_key)
        
        if character_key == "hlyjcm_dark" then
            local hlyjdf_dark = gst.character_query_for_template("hlyjdf_dark")
            if hlyjdf_dark 
            and not hlyjdf_dark:is_null_interface() 
            and not hlyjdf_dark:is_dead() 
            and gst.faction_is_character_deployed(hlyjdf_dark)
            then
                local military_force = gst.faction_find_character_military_force(hlyjdf_dark)
                if military_force:character_list():num_items() < 3 then
                    cm:modify_military_force(military_force):add_existing_character_as_retinue(hlyjdf_dark)
                else
                    gst.faction_find_character_military_force(character)
                end
            else
                gst.faction_find_character_military_force(character)
            end
        end
        
        if character_key == "hlyjdf_dark" then
            local hlyjcm_dark = gst.character_query_for_template("hlyjcm_dark")
            if hlyjcm_dark 
            and not hlyjcm_dark:is_null_interface() 
            and not hlyjcm_dark:is_dead() 
            and gst.faction_is_character_deployed(hlyjcm_dark)
            then
                local military_force = gst.faction_find_character_military_force(hlyjcm_dark)
                if military_force:character_list():num_items() < 3 then
                    cm:modify_military_force(military_force):add_existing_character_as_retinue(hlyjcm_dark)
                else
                    gst.faction_find_character_military_force(character)
                end
            else
                gst.faction_find_character_military_force(character)
            end
        end
        
        local pin = cm:modify_local_faction():get_map_pins_handler():add_character_pin(cm:modify_character(character), character_key, true);
        dark_character_pin[character_key] = pin
        cm:set_saved_value("dark_character_pin", dark_character_pin)
        return character
    end
    return false
end

function add_kill_character(character_key)
    gst.lib_table_insert(kill_character_table, character_key)
    cm:set_saved_value("character_kill_table", kill_character_table)
end

function is_main_faction(faction_key)
    return (faction_difficulty[faction_key] or cm:query_local_faction():name() == faction_key);
end

function add_characters_to_military_force(modify_force, faction)
    local character_subtype = {
        ["3k_xyy_template_scripted_xyyhlyjf_wood_strong_late"] = "3k_general_wood",
        ["3k_xyy_template_scripted_xyyhlyjf_fire_strong_late"] = "3k_general_fire",
        ["3k_xyy_template_scripted_xyyhlyjf_metal_strong_late"] = "3k_general_metal"
    }
    local characters = {
        "3k_xyy_template_scripted_xyyhlyjf_wood_strong_late",
        "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late",
        "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late",
    }
    local faction_key = faction:name()
    local generate_template = characters[math.floor(gst.lib_getRandomValue(1, #characters))]
    local modify_character_2 = cm:modify_faction(faction):create_character_from_template("general",
        character_subtype[generate_template], generate_template, false);
    local generate_template_2 = characters[math.floor(gst.lib_getRandomValue(1, #characters))]
    local modify_character_3 = cm:modify_faction(faction):create_character_from_template("general",
        character_subtype[generate_template_2], generate_template_2, false);

    modify_character_2:add_experience(295000, 0);
    modify_character_3:add_experience(295000, 0);

    if modify_force:query_military_force():character_list():num_items() < 3 then
        modify_force:add_existing_character_as_retinue(modify_character_2, true);
    end
    if modify_force:query_military_force():character_list():num_items() < 3 then
        modify_force:add_existing_character_as_retinue(modify_character_3, true);
    end

    cdir_events_manager:add_or_remove_ceo_from_faction(faction_key, "hlyjdingzhibwuqi", true);
    ancillaries:equip_ceo_on_character(modify_character_2:query_character(), "hlyjdingzhibwuqi",
        "3k_main_ceo_category_ancillary_weapon");
    cdir_events_manager:add_or_remove_ceo_from_faction(faction_key, "hlyjdingzhicwuqi", true);
    ancillaries:equip_ceo_on_character(modify_character_3:query_character(), "hlyjdingzhicwuqi",
        "3k_main_ceo_category_ancillary_weapon");
end

function xyy_roguelike_mode:register_roguelike_listeners()
    core:add_listener(
        "roguelike_dilemma_continue", -- UID
        "DilemmaChoiceMadeEvent",     -- CampaignEvent
        function(context)
            return context:dilemma() == "roguelike_dilemma_continue"
        end,
        function(context)
            local faction = context:faction()
            local continue = false
            if cm:get_saved_value("xyy_roguelike_mission") then
                if cm:get_saved_value("xyy_roguelike_mission") == "xyy_roguelike_mission_hard"
                    and not faction:is_mission_active("xyy_roguelike_mission_hard")
                then
                    gst.faction_add_tickets(faction:name(), 400)
                    if cm:get_saved_value("xyy_roguelike_mission_perfect")
                        and cm:get_saved_value("xyy_roguelike_mission_perfect") > 0
                    then
                        gst.faction_add_tickets(faction:name(), 200)
                        cm:set_saved_value("xyy_roguelike_mission_perfect", 0)
                    end
                    continue = true
                elseif cm:get_saved_value("xyy_roguelike_mission") == "xyy_roguelike_mission_normal"
                    and not faction:is_mission_active("xyy_roguelike_mission_normal")
                then
                    gst.faction_add_tickets(faction:name(), 200)
                    if cm:get_saved_value("xyy_roguelike_mission_perfect")
                        and cm:get_saved_value("xyy_roguelike_mission_perfect") > 0
                    then
                        gst.faction_add_tickets(faction:name(), 100)
                        cm:set_saved_value("xyy_roguelike_mission_perfect", 0)
                    end
                    continue = true
                elseif cm:get_saved_value("xyy_roguelike_mission") == "xyy_roguelike_mission_easy"
                    and not faction:is_mission_active("xyy_roguelike_mission_easy")
                then
                    gst.faction_add_tickets(faction:name(), 100)
                    if cm:get_saved_value("xyy_roguelike_mission_perfect")
                        and cm:get_saved_value("xyy_roguelike_mission_perfect") > 0
                    then
                        gst.faction_add_tickets(faction:name(), 50)
                        cm:set_saved_value("xyy_roguelike_mission_perfect", 0)
                    end
                    continue = true
                end
                if cm:get_saved_value("xyy_roguelike_character_select") then
                    continue = true
                end
            elseif cm:get_saved_value("xyy_roguelike_mission_boss_character_browser") then
                faction_difficulty["xyyhlyjf"] = 3000
                cm:set_saved_value("roguelike_faction_difficulty", faction_difficulty);
                cm:set_saved_value("roguelike_safe_trigger", false);
                cm:set_saved_value("xyy_roguelike_mission_boss", true);
                character_browser_roguelike_select();
                continue = false;
            elseif cm:get_saved_value("xyy_roguelike_mission_boss_2_character_browser") then
                faction_difficulty["xyyhlyjf"] = 1000
                cm:set_saved_value("roguelike_faction_difficulty", faction_difficulty);
                cm:set_saved_value("roguelike_safe_trigger", false);
                cm:set_saved_value("xyy_roguelike_mission_boss_2", true);
                character_browser_roguelike_select();
                continue = false;
            else
                gst.faction_add_tickets(faction:name(), 100)
                if cm:get_saved_value("xyy_roguelike_mission_perfect")
                    and cm:get_saved_value("xyy_roguelike_mission_perfect") > 0
                then
                    gst.faction_add_tickets(faction:name(), 50)
                end
            end
            if continue then
                local dead_faction = cm:get_saved_value("xyy_roguelike_mission_target_faction")
                faction_difficulty[dead_faction] = nil;
                cm:set_saved_value("xyy_roguelike_mission", false)
                cm:set_saved_value("xyy_roguelike_mission_perfect", 0);
                cm:set_saved_value("xyy_roguelike_mission_target_faction", false);
                cm:set_saved_value("roguelike_faction_difficulty", faction_difficulty);
                level = level + 1;
                if level == 3
                or level == 5
                or level == 7
                or level == 9
                or level == 11
                or level == 12
                then
                    apply_enemy_effect()
                end
                cm:set_saved_value("roguelike_level", level);
                cm:set_saved_value("roguelike_safe_trigger", false);
                character_browser_roguelike_select();
            end
        end,
        false
    )

    core:add_listener(
        "roguelike_dilemma_choice", -- UID
        "DilemmaChoiceMadeEvent",   -- CampaignEvent
        function(context)
            return context:dilemma() == "roguelike_dilemma_first_select"
        end,               -- criteria
        function(context)  --what to do if listener fires
            if context:choice() == 0 then
                character_browser_roguelike_first_select(false)
            end
        end,
        false
    )

    core:add_listener(
        "xyy_roguelike_mission_ready_listener",
        "DiplomacyNegotiationFinished",
        function(context)
            return not cm:get_saved_value("huanlong_dead");
        end,
        function(context)
            local faction = cm:query_local_faction()
            if cm:query_local_faction():is_mission_active("xyy_roguelike_mission_xyyhlyjf") then
                return
            end
            local negotiation = context:negotiation()
            local proposers = negotiation:proposers()
            local recipients = negotiation:recipients()
            for i = 0, proposers:num_items() - 1 do
                local proposer = proposers:item_at(i);
                if proposer:primary_faction():name() ~= faction:name() then
                    return;
                end
            end
            for i = 0, recipients:num_items() - 1 do
                local recipient = recipients:item_at(i);
                local target_faction_key = recipient:primary_faction():name()
                if cm:query_faction(faction):has_specified_diplomatic_deal_with("treaty_components_war", recipient:primary_faction())
                    and is_main_faction(target_faction_key)
                then
                    if (target_faction_key == "xyyhlyjf" and not faction:is_mission_active("xyy_roguelike_mission_xyyhlyjf"))
                        or target_faction_key == faction:name()
                        or not cm:query_local_faction():is_mission_active("xyy_roguelike_mission_ready")
                    then
                        if is_main_faction(target_faction_key) and is_main_faction(faction:name()) then
                            cm:modify_model():enable_diplomacy("faction:" .. target_faction_key,
                                "faction:" .. faction:name(), "treaty_components_peace,treaty_components_peace_no_event",
                                "yellow_turban_rank_requirement_proposer")
                            diplomacy_manager:apply_automatic_deal_between_factions(target_faction_key, faction:name(),
                                "data_defined_situation_peace", true)
                        end
                    elseif is_main_faction(target_faction_key) then
                        trigger_mission(faction:name(), target_faction_key);
                    end
                end
            end
        end,
        true
    )

    core:add_listener(
        "xyy_roguelike_mission_success",
        "MissionSucceeded",
        function(context)
            return context:mission():mission_record_key() == "xyy_roguelike_mission_hard"
                or context:mission():mission_record_key() == "xyy_roguelike_mission_normal"
                or context:mission():mission_record_key() == "xyy_roguelike_mission_easy";
        end,
        function(context)
            local faction = cm:query_local_faction()
            

            if faction:is_mission_active("xyy_roguelike_kill_hlyjci_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjci_dark")
                if dark_character_pin["hlyjci_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjci_dark"])
                    dark_character_pin["hlyjci_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjcj_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjcj_dark")
                if dark_character_pin["hlyjcj_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjcj_dark"])
                    dark_character_pin["hlyjcj_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjck_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjck_dark")
                if dark_character_pin["hlyjck_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjck_dark"])
                    dark_character_pin["hlyjck_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjcm_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjcm_dark")
                if dark_character_pin["hlyjcm_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjcm_dark"])
                    dark_character_pin["hlyjcm_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjcn_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjcn_dark")
                if dark_character_pin["hlyjcn_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjcn_dark"])
                    dark_character_pin["hlyjcn_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjcy_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjcy_dark")
                if dark_character_pin["hlyjcy_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjcy_dark"])
                    dark_character_pin["hlyjcy_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjda_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjda_dark")
                if dark_character_pin["hlyjda_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjda_dark"])
                    dark_character_pin["hlyjda_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjdi_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjdi_dark")
                if dark_character_pin["hlyjdi_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjdi_dark"])
                    dark_character_pin["hlyjdi_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjdf_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjdf_dark")
                if dark_character_pin["hlyjdf_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjdf_dark"])
                    dark_character_pin["hlyjdf_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjdt_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjdt_dark")
                if dark_character_pin["hlyjdt_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjdt_dark"])
                    dark_character_pin["hlyjdt_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjdy_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjdy_dark")
                if dark_character_pin["hlyjdy_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjdy_dark"])
                    dark_character_pin["hlyjdy_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjeb_dark") then
                cm:modify_faction(faction):cancel_custom_mission("xyy_roguelike_kill_hlyjeb_dark")
                if dark_character_pin["hlyjeb_dark"] ~= 0 then
                    cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjeb_dark"])
                    dark_character_pin["hlyjeb_dark"] = 0
                    cm:set_saved_value("dark_character_pin",dark_character_pin)
                end
            end
            if context:mission():mission_record_key() == "xyy_roguelike_mission_hard" then
                gst.faction_add_tickets(context:faction():name(), 400)
                if cm:get_saved_value("xyy_roguelike_mission_perfect")
                    and cm:get_saved_value("xyy_roguelike_mission_perfect") > 0
                then
                    gst.faction_add_tickets(context:faction():name(), 200)
                end
            elseif context:mission():mission_record_key() == "xyy_roguelike_mission_normal" then
                gst.faction_add_tickets(context:faction():name(), 200)
                if cm:get_saved_value("xyy_roguelike_mission_perfect")
                    and cm:get_saved_value("xyy_roguelike_mission_perfect") > 0
                then
                    gst.faction_add_tickets(context:faction():name(), 100)
                end
            elseif context:mission():mission_record_key() == "xyy_roguelike_mission_easy" then
                gst.faction_add_tickets(context:faction():name(), 100)
                if cm:get_saved_value("xyy_roguelike_mission_perfect")
                    and cm:get_saved_value("xyy_roguelike_mission_perfect") > 0
                then
                    gst.faction_add_tickets(context:faction():name(), 50)
                end
            end
            local dead_faction = cm:get_saved_value("xyy_roguelike_mission_target_faction")
            faction_difficulty[dead_faction] = nil;
            cm:set_saved_value("xyy_roguelike_mission_target_faction", false);
            --cm:set_saved_value("xyy_roguelike_mission", false)
            cm:set_saved_value("roguelike_faction_difficulty", faction_difficulty);
            --cm:set_saved_value("xyy_roguelike_mission_perfect", 0);
            level = level + 1;
            if level > 2
                and level % 2 == 0
            then
                apply_enemy_effect()
            end
            cm:set_saved_value("roguelike_level", level);
            cm:set_saved_value("roguelike_safe_trigger", false);
            character_browser_roguelike_select();
        end,
        true
    )
    
    core:add_listener(
        "xyy_roguelike_mission_success",
        "MissionSucceeded",
        function(context)
            return context:mission():mission_record_key() == "xyy_roguelike_mission_xyyhlyjf"
        end,
        function(context)
        
        end,
        true
    )
    
    core:add_listener(
        "xyy_roguelike_mission_failed",
        "MissionFailed",
        function(context)
            return context:mission():mission_record_key() == "xyy_roguelike_mission_ready";
        end,
        function(context)
            progression:force_campaign_defeat(context:faction())
        end,
        true
    )

    core:add_listener(
        "xyy_roguelike_faction_turn_listener",
        "FactionTurnStart",
        function(context)
            return true;
        end,
        function(context)
            local faction = context:faction()
            if faction:is_human() then
                cm:modify_faction(faction):remove_effect_bundle("xyy_roguelike_38_unseen_2")
                for i = 0, faction:character_list():num_items() - 1 do
                    local character = faction:character_list():item_at(i)
                    if character
                    and not character:is_null_interface()
                    and not character:is_dead()
                    and character:character_type("general") 
                    and not character:is_character_is_faction_recruitment_pool()
                    and character:has_effect_bundle("xyy_roguelike_38_unseen_1")
                    then
                        cm:modify_character(character):remove_effect_bundle("xyy_roguelike_38_unseen_1");
                    end
                end
            end
            if cm:query_faction("3k_main_faction_rebels")
            and not cm:query_faction("3k_dlc04_faction_rebels"):is_null_interface() 
            and not cm:query_faction("3k_dlc04_faction_rebels"):is_dead() then
                cm:modify_faction("3k_dlc04_faction_rebels"):apply_effect_bundle("rebels", -1)
            end
            if cm:query_faction("3k_main_faction_rebels")
            and not cm:query_faction("3k_main_faction_rebels"):is_null_interface() 
            and not cm:query_faction("3k_main_faction_rebels"):is_dead() then
                cm:modify_faction("3k_main_faction_rebels"):apply_effect_bundle("rebels", -1)
            end
            if is_main_faction(faction:name()) then
                for i = 0, cm:query_model():world():faction_list():num_items() - 1 do
                    local filter_faction = cm:query_model():world():faction_list():item_at(i)
                    if filter_faction
                        and not filter_faction:is_null_interface()
                        and not is_main_faction(filter_faction:name())
                        or filter_faction:is_dead() then
                        cm:modify_model():enable_diplomacy("faction:" .. filter_faction:name(), "faction:" .. faction:name(),
                            diplomacy_keys, "roguelike_mode");
                        cm:modify_model():enable_diplomacy("faction:" .. faction:name(), "faction:" .. filter_faction:name(),
                            diplomacy_keys, "roguelike_mode");
                    end
                end
            end
            if faction:has_effect_bundle("xyy_roguelike_66") then
                for i = 0, faction:character_list():num_items() - 1 do
                    local character = faction:character_list():item_at(i)
                    if not character:is_dead()
                    and not character:is_character_is_faction_recruitment_pool() 
                    and character:character_type("general") 
                    then
                        local loyalty = character:loyalty()
                        if character:has_effect_bundle("xyy_roguelike_66_unseen_1") then
                            loyalty = loyalty - 25
                        end
                        if character:has_effect_bundle("xyy_roguelike_66_unseen_2") then
                            loyalty = loyalty - 50
                        end
                        if character:has_effect_bundle("xyy_roguelike_66_unseen_3") then
                            loyalty = loyalty - 75
                        end
                        if loyalty <= 25 then
                            cm:modify_character(character):remove_effect_bundle("xyy_roguelike_66_unseen_1")
                            cm:modify_character(character):remove_effect_bundle("xyy_roguelike_66_unseen_2")
                            cm:modify_character(character):apply_effect_bundle("xyy_roguelike_66_unseen_3",-1)
                        elseif loyalty > 25 and loyalty <= 50 then
                            cm:modify_character(character):remove_effect_bundle("xyy_roguelike_66_unseen_1")
                            cm:modify_character(character):remove_effect_bundle("xyy_roguelike_66_unseen_3")
                            cm:modify_character(character):apply_effect_bundle("xyy_roguelike_66_unseen_2",-1)
                        elseif loyalty > 50 then
                            cm:modify_character(character):remove_effect_bundle("xyy_roguelike_66_unseen_2")
                            cm:modify_character(character):remove_effect_bundle("xyy_roguelike_66_unseen_3")
                            cm:modify_character(character):apply_effect_bundle("xyy_roguelike_66_unseen_1",-1)
                        end
                    end
                end
            end
            
            if faction:has_effect_bundle("xyy_roguelike_44") then
                for i = 0, faction:character_list():num_items() - 1 do
                    local character = faction:character_list():item_at(i)
                    if not character:is_dead()
                    and not character:is_character_is_faction_recruitment_pool() 
                    and character:character_type("general") 
                    then
                        cm:modify_character(character):ceo_management():remove_ceos("3k_main_ceo_trait_physical_one-eyed"); 
                        cm:modify_character(character):ceo_management():remove_ceos("3k_ytr_ceo_trait_physical_sprained_ankle"); 
                        cm:modify_character(character):ceo_management():remove_ceos("3k_main_ceo_trait_physical_scarred"); 
                        cm:modify_character(character):ceo_management():remove_ceos("3k_main_ceo_trait_physical_maimed_arm"); 
                        cm:modify_character(character):ceo_management():remove_ceos("3k_main_ceo_trait_physical_maimed_leg"); 
                    end
                end
            end
            
            if faction:has_effect_bundle("xyy_roguelike_craft_accessories") then
                local building_list = gst.building_list["xyy_roguelike_craft_accessories"]
                if not is_faction_have_building(cm:query_local_faction(), building_list) then
                    cm:modify_faction(faction):remove_effect_bundle("xyy_roguelike_craft_accessories")
                    effect.advice(effect.get_localised_string(
                    "effect_bundles_localised_title_xyy_roguelike_craft_accessories") ..
                    effect.get_localised_string("mod_xyy_roguelike_icon_stopped"))
                end
            end
            if faction:has_effect_bundle("xyy_roguelike_craft_accessories_1") then
                local building_list = gst.building_list["xyy_roguelike_craft_accessories_1"]
                if not is_faction_have_building(cm:query_local_faction(), building_list) then
                    cm:modify_faction(faction):remove_effect_bundle("xyy_roguelike_craft_accessories_1")
                    effect.advice(effect.get_localised_string(
                    "effect_bundles_localised_title_xyy_roguelike_craft_accessories_1") ..
                    effect.get_localised_string("mod_xyy_roguelike_icon_stopped"))
                end
            end
            if faction:has_effect_bundle("xyy_roguelike_craft_weapons") then
                local building_list = gst.building_list["xyy_roguelike_craft_weapons"]
                if not is_faction_have_building(cm:query_local_faction(), building_list) then
                    cm:modify_faction(faction):remove_effect_bundle("xyy_roguelike_craft_weapons")
                    effect.advice(effect.get_localised_string(
                    "effect_bundles_localised_title_xyy_roguelike_craft_weapons") ..
                    effect.get_localised_string("mod_xyy_roguelike_icon_stopped"))
                end
            end
            if faction:has_effect_bundle("xyy_roguelike_craft_weapons_1") then
                local building_list = gst.building_list["xyy_roguelike_craft_weapons_1"]
                if not is_faction_have_building(cm:query_local_faction(), building_list) then
                    cm:modify_faction(faction):remove_effect_bundle("xyy_roguelike_craft_weapons_1")
                    effect.advice(effect.get_localised_string(
                    "effect_bundles_localised_title_xyy_roguelike_craft_weapons_1") ..
                    effect.get_localised_string("mod_xyy_roguelike_icon_stopped"))
                end
            end
            if faction:has_effect_bundle("xyy_roguelike_craft_mounts") then
                local building_list = gst.building_list["xyy_roguelike_craft_mounts"]
                if not is_faction_have_building(cm:query_local_faction(), building_list) then
                    cm:modify_faction(faction):remove_effect_bundle("xyy_roguelike_craft_mounts")
                    effect.advice(effect.get_localised_string(
                    "effect_bundles_localised_title_xyy_roguelike_craft_mounts") ..
                    effect.get_localised_string("mod_xyy_roguelike_icon_stopped"))
                end
            end
            if faction:has_effect_bundle("xyy_roguelike_craft_mounts_1") then
                local building_list = gst.building_list["xyy_roguelike_craft_mounts_1"]
                if not is_faction_have_building(cm:query_local_faction(), building_list) then
                    cm:modify_faction(faction):remove_effect_bundle("xyy_roguelike_craft_mounts_1")
                    effect.advice(effect.get_localised_string(
                    "effect_bundles_localised_title_xyy_roguelike_craft_mounts_1") ..
                    effect.get_localised_string("mod_xyy_roguelike_icon_stopped"))
                end
            end
            if faction:has_effect_bundle("xyy_roguelike_craft_armors") then
                local building_list = gst.building_list["xyy_roguelike_craft_armors"]
                if not is_faction_have_building(cm:query_local_faction(), building_list) then
                    cm:modify_faction(faction):remove_effect_bundle("xyy_roguelike_craft_armors")
                    effect.advice(effect.get_localised_string(
                    "effect_bundles_localised_title_xyy_roguelike_craft_armors") ..
                    effect.get_localised_string("mod_xyy_roguelike_icon_stopped"))
                end
            end
            if faction:has_effect_bundle("xyy_roguelike_craft_armors_1") then
                local building_list = gst.building_list["xyy_roguelike_craft_armors_1"]
                if not is_faction_have_building(cm:query_local_faction(), building_list) then
                    cm:modify_faction(faction):remove_effect_bundle("xyy_roguelike_craft_armors_1")
                    effect.advice(effect.get_localised_string(
                    "effect_bundles_localised_title_xyy_roguelike_craft_armors_1") ..
                    effect.get_localised_string("mod_xyy_roguelike_icon_stopped"))
                end
            end


--             if cm:get_saved_value("character_kill_table") then
--                 local kill_table = cm:get_saved_value("character_kill_table")
--                 for i, v in ipairs(kill_table) do
--                     gst.character_been_killed(v)
--                 end
--                 cm:set_saved_value("character_kill_table", false)
--             end

            for i, v in pairs(dark_character_info) do
                local dark_char = gst.character_query_for_template(i)
                local mission_key = "xyy_roguelike_kill_" .. i
                ModLog("检测："..i)
                kill_character_table = cm:get_saved_value("character_kill_table")
                if kill_character_table and gst.lib_value_in_list(kill_character_table, i) then
                    ModLog(i .. "死了")
                    if cm:query_local_faction():is_mission_active(mission_key) then
                        cm:modify_local_faction():cancel_custom_mission(mission_key)
                    end
                else
                    if dark_char
                    and not dark_char:is_null_interface()
                    then
                        if dark_char:is_dead() then
                            ModLog(i .. "死了")
                            gst.lib_table_insert(kill_character_table, i)
                            if cm:query_local_faction():is_mission_active(mission_key) then
                                cm:modify_local_faction():cancel_custom_mission(mission_key)
                            end
                        else
                            ModLog(i .. "已存在")
                            if not cm:get_saved_value("xyy_roguelike_mission_target_faction") 
                            and dark_char:faction():name() ~= "xyyhlyjf" 
                            then
                                cm:modify_character(dark_char):move_to_faction_and_make_recruited("xyyhlyjf")
                            elseif dark_char:faction():name() ~= cm:get_saved_value("xyy_roguelike_mission_target_faction") 
                            and not cm:query_local_faction():is_mission_active("xyy_roguelike_mission_ready") then
                                cm:modify_character(dark_char):move_to_faction_and_make_recruited(cm:get_saved_value(
                                "xyy_roguelike_mission_target_faction"))
                            end
                            if not cm:query_local_faction():is_mission_active("xyy_roguelike_mission_ready")
                            then
                                if not cm:query_local_faction():is_mission_active(mission_key) then
                                    local mission = string_mission:new(mission_key)
                                    mission:set_issuer("3k_main_victory_objective_issuer");
                                    mission:add_primary_objective("SCRIPTED",
                                        { "script_key treaty_components_war",
                                            "override_text mission_text_" .. mission_key }
                                    );
                                    mission:add_primary_payload("text_display{lookup kill_" .. i .. ";}");
                                    if dark_character_info[i]["difficulty"] == 1 then
                                        mission:add_primary_payload("effect_bundle{bundle_key dark_character_easy;}");
                                    end
                                    if dark_character_info[i]["difficulty"] == 2 then
                                        mission:add_primary_payload("effect_bundle{bundle_key dark_character_normal;}");
                                    end
                                    if dark_character_info[i]["difficulty"] == 3 then
                                        mission:add_primary_payload("effect_bundle{bundle_key dark_character_hard;}");
                                    end
                                    mission:trigger_mission_for_faction(cm:query_local_faction():name())
                                    cm:set_saved_value("dark_character", dark_character)
                                end
                                if not gst.faction_is_character_deployed(dark_char) then
                                    gst.faction_find_character_military_force(dark_char)
                                    local pin = cm:modify_local_faction():get_map_pins_handler():add_character_pin(cm:modify_character(dark_char), i, true);
                                    dark_character_pin[i] = pin
                                    cm:set_saved_value("dark_character_pin", dark_character_pin)
                                    ModLog(i .. "已刷新")
                                else
                                    ModLog(i .. "未刷新")
                                end
                            end
                        end
                    else
                        ModLog(i .. "不存在")
                    end
                end
            end
            
            if not faction:is_human() and not cm:query_local_faction():is_mission_active("xyy_roguelike_mission_xyyhlyjf") and is_main_faction(faction:name()) then
                cm:modify_faction(faction):enable_movement()
                if faction:subculture() == "3k_main_subculture_yellow_turban" then
                    cm:modify_faction(faction):unlock_technology("3k_ytr_tech_yellow_turban_heaven_3_3")
                end
                if faction:subculture() == "3k_main_chinese" then
                    cm:modify_faction(faction):unlock_technology("3k_main_tech_water_tier3_hostels")
                end

                if cm:query_faction(faction):has_specified_diplomatic_deal_with("treaty_components_war", cm:query_local_faction())
                then
                    if cm:get_saved_value("xyy_roguelike_mission_target_faction")
                        and cm:get_saved_value("xyy_roguelike_mission_target_faction") == faction:name() then
                        cm:modify_faction(faction):enable_movement()
                    else
                        local faction_key = cm:query_local_faction():name()
                        cm:modify_faction(faction):disable_movement()
                        cm:modify_model():enable_diplomacy("faction:" .. faction:name(), "faction:" .. faction_key,
                            "treaty_components_peace,treaty_components_peace_no_event", "hidden")
                        if cm:query_local_faction():subculture() == "3k_main_subculture_yellow_turban" then
                            enable_ytr_diplomacy(faction_key)
                            diplomacy_manager:apply_automatic_deal_between_factions(faction:name(), faction_key,
                                "data_defined_situation_peace", true)
                        end
                    end
                else
                    cm:modify_faction(faction):enable_movement()
                end
            end

            if faction:is_human() and not faction:is_mission_active("xyy_roguelike_mission_xyyhlyjf") then
                local world_list = cm:query_model():world():faction_list()
                for i = 0, world_list:num_items() - 1 do
                    local faction2 = world_list:item_at(i)
                    if not faction2:is_null_interface()
                        and not faction2:is_dead()
                        and (faction2:name() ~= "xyyhlyjf" or faction:is_mission_active("xyy_roguelike_mission_xyyhlyjf"))
                        and is_main_faction(faction2:name())
                        and faction:has_specified_diplomatic_deal_with("treaty_components_war", faction2)
                    then

                    elseif faction2:name() ~= faction:name()
                        and cm:get_saved_value("xyy_roguelike_mission_target_faction") ~= faction2:name() then
                        cm:modify_model():enable_diplomacy("faction:" .. faction2:name(), "faction:" .. faction:name(),
                            "treaty_components_peace,treaty_components_peace_no_event", "hidden")
                        if cm:query_local_faction():subculture() == "3k_main_subculture_yellow_turban" then
                            enable_ytr_diplomacy(faction:name())
                        end
                        if is_main_faction(faction2:name()) and is_main_faction(faction:name()) then
                            diplomacy_manager:apply_automatic_deal_between_factions(faction2:name(), faction:name(),
                                "data_defined_situation_peace", true)
                        end
                    end
                end
            end

            if faction:is_human()
                and cm:get_saved_value("xyy_roguelike_mission_perfect")
                and cm:get_saved_value("xyy_roguelike_mission_perfect") > 0
            then
                cm:set_saved_value("xyy_roguelike_mission_perfect",
                    cm:get_saved_value("xyy_roguelike_mission_perfect") - 1)
            end

            if faction:is_human()
                and cm:get_saved_value("have_Roguelike_Panel") then
                cm:set_saved_value("have_Roguelike_Panel", false)
                cm:set_saved_value("roguelike_safe_trigger_2", true)
                openRoguelikePanel()
            end

            if faction:is_human()
                and cm:get_saved_value("xyy_roguelike_mission_target_faction")
            then
                local target_faction = cm:query_faction(cm:get_saved_value("xyy_roguelike_mission_target_faction"))
                if target_faction
                    and not target_faction:is_null_interface()
                    and not target_faction:is_dead()
                    and not faction:has_specified_diplomatic_deal_with("treaty_components_war", target_faction)
                then
                    cm:modify_model():disable_diplomacy("faction:" .. target_faction:name(), "faction:" .. faction:name(),
                        "treaty_components_peace,treaty_components_peace_no_event", "hidden")
                    diplomacy_manager:apply_automatic_deal_between_factions(target_faction:name(), faction:name(),
                        "data_defined_situation_war_proposer_to_recipient", false);
                end
            end

            if faction:is_human()
                and faction:has_effect_bundle("title_xyy_roguelike_8")
                and cm:query_model():season() == "season_spring"
            then
                local ruan_mei = gst.character_query_for_template("hlyjct")
                if ruan_mei
                    and not ruan_mei:is_null_interface()
                    and not ruan_mei:is_dead()
                    and not ruan_mei:is_character_is_faction_recruitment_pool()
                    and ruan_mei:faction():name() == faction:name()
                then
                else
                    cm:trigger_dilemma(faction:name(), "xyy_path_blessing", true);
                end
            end

            if faction:is_human()
                and cm:get_saved_value("roguelike_return_region")
                and cm:get_saved_value("roguelike_return_region_time")
            then
                if cm:get_saved_value("roguelike_return_region_time") > 0 then
                    cm:set_saved_value("roguelike_return_region_time",
                        cm:get_saved_value("roguelike_return_region_time") - 1);
                else
                    local region = cm:get_saved_value("roguelike_return_region")

                    cm:modify_region(cm:query_region(region)):settlement_gifted_as_if_by_payload(cm:modify_faction(
                    faction))

                    cm:set_saved_value("roguelike_return_region", false)
                    cm:set_saved_value("roguelike_return_region_time", false)
                end
            end

            if faction:is_human()
                and faction:has_effect_bundle("xyy_roguelike_16")
            then
                local counter = 0
                for i = 0, faction:character_list():num_items() - 1 do
                    local character = faction:character_list():item_at(i)
                    if not character:is_null_interface()
                        and not character:is_dead()
                        and not character:is_character_is_faction_recruitment_pool()
                        and character:character_type("general")
                        and character:age() <= 20
                    then
                        cm:modify_character(character):apply_effect_bundle("xyy_roguelike_16_unseen_" .. counter, 1)
                        counter = counter + 1
                    end
                    if counter == 9 then
                        break;
                    end
                end
            end

            if faction:is_human()
                and faction:has_effect_bundle("xyy_roguelike_17")
            then
                local counter = 0
                for i = 0, faction:character_list():num_items() - 1 do
                    local character = faction:character_list():item_at(i)
                    if not character:is_null_interface()
                        and not character:is_dead()
                        and not character:is_character_is_faction_recruitment_pool()
                        and character:character_type("general")
                        and character:age() >= 50
                    then
                        cm:modify_character(character):apply_effect_bundle("xyy_roguelike_17_unseen_" .. counter, 1)
                        counter = counter + 1
                    end
                    if counter == 9 then
                        break;
                    end
                end
            end


            if faction:is_human()
                and faction:has_effect_bundle("xyy_roguelike_31")
            then
                if context:query_model():season() == "season_summer" then
                    cm:modify_faction(faction):apply_effect_bundle("xyy_roguelike_31_unseen", 1)
                    local tech_cooldown = faction:get_tech_research_cooldown()
                    if tech_cooldown and tech_cooldown > 0 then
                        cm:set_saved_value("roguelike_schemes_tech_cooldown", tech_cooldown)
                    end
                    cm:modify_faction(faction):set_tech_research_cooldown(0)
                end
                if context:query_model():season() == "season_spring" then
                    cm:modify_faction(faction):apply_effect_bundle("xyy_roguelike_31_ytr_unseen", 1)
                    cm:modify_faction(faction):set_tech_research_cooldown(0)
                end
            end

            if faction:is_human()
                and faction:region_list():num_items() > 0
            then
                for i = 0, faction:region_list():num_items() - 1 do
                    local region = faction:region_list():item_at(i)
                    if faction:has_effect_bundle("xyy_roguelike_40") then
                        if region:building_exists("3k_city_10") then
                            cm:modify_region(region):apply_effect_bundle("xyy_roguelike_40_unseen", -1)
                            ModLog(region:name() .. " xyy_roguelike_40")
                        else
                            cm:modify_region(region):remove_effect_bundle("xyy_roguelike_40_unseen")
                        end
                    end
                    if faction:has_effect_bundle("xyy_roguelike_48") then
                        if region:building_exists("3k_city_10") then
                            cm:modify_region(region):apply_effect_bundle("xyy_roguelike_48_unseen", -1)
                            ModLog(region:name() .. " xyy_roguelike_48")
                        else
                            cm:modify_region(region):remove_effect_bundle("xyy_roguelike_48_unseen")
                        end
                    end
                    if faction:has_effect_bundle("xyy_roguelike_49") then
                        if region:building_exists("3k_city_10") then
                            cm:modify_region(region):apply_effect_bundle("xyy_roguelike_49_unseen", -1)
                            ModLog(region:name() .. " xyy_roguelike_49")
                        else
                            cm:modify_region(region):remove_effect_bundle("xyy_roguelike_49_unseen")
                        end
                    end
                end
            end

            if faction:is_human() then
                if cm:get_saved_value("roguelike_besiege_regions") then
                    local besiege_regions = cm:get_saved_value("roguelike_besiege_regions")
                    local invalid_regions = {}
                    for region_key, cqi in pairs(besiege_regions) do
                        local character = cm:query_model():character_for_command_queue_index(cqi)
                        if character:is_besieging() then
                            cm:modify_region(cm:query_region(region_key)):apply_effect_bundle("xyy_roguelike_33_unseen",
                                1)
                        else
                            gst.lib_table_insert(invalid_regions, region_key);
                        end
                    end
                    for k, v in ipairs(invalid_regions) do
                        besiege_regions[v] = nil;
                    end
                    cm:set_saved_value("roguelike_besiege_regions", besiege_regions);
                end
            end

            local faction = cm:query_local_faction();
            if faction:has_mission_been_issued("xyy_roguelike_mission_boss")
            then
                local hlyjdingzhia = cm:query_faction("xyyhlyjf"):faction_leader()
                local limit
                if cm:get_saved_value("xyy_roguelike_mission_xyyhlyjf_limit") then
                    limit = cm:get_saved_value("xyy_roguelike_mission_xyyhlyjf_limit")
                else
                    limit = 0
                end
                if cm:get_saved_value("xyy_roguelike_mission_boss")
                    and faction:has_mission_been_issued("xyy_roguelike_mission_boss")
                    and not faction:is_mission_active("xyy_roguelike_mission_boss") then
                    cm:modify_faction(cm:query_faction("xyyhlyjf")):ceo_management():remove_ceos("hlyjdingzhiayifu");
                    gst.character_CEO_equip("hlyjdingzhia", "hlyjdingzhibyifu", "3k_main_ceo_category_ancillary_armour");
                    if not hlyjdingzhia:get_is_deployable() then
                        cm:modify_character(hlyjdingzhia:set_is_deployable());
                    end
                    gst.faction_create_military_force("xyyhlyjf", cm:query_faction("xyyhlyjf"):capital_region():name(),
                        hlyjdingzhia)
                    if gst.faction_is_character_deployed(hlyjdingzhia) then
                        if not hlyjdingzhia:military_force():is_null_interface() then
                            local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhia:military_force());
                            add_characters_to_military_force(modify_force, cm:query_faction("xyyhlyjf"))
                            --add_freeze(hlyjdingzhia:cqi())
                            remove_freeze(hlyjdingzhia:cqi())
                            cm:modify_character(hlyjdingzhia):apply_effect_bundle("lower_movement_range", -1)
                            local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template(
                            "general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                            local character1 = modify_character_1:query_character();
                            if character and limit < 10 then
                                gst.faction_create_military_force("xyyhlyjf",
                                    cm:query_faction("xyyhlyjf"):capital_region():name(), character);
                                add_characters_to_military_force(
                                cm:modify_model():get_modify_military_force(character:military_force()),
                                    cm:query_faction("xyyhlyjf"))
                                --add_freeze(character:cqi());
                                limit = limit + 1
                            end

                            local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template(
                            "general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                            local character2 = modify_character_2:query_character();
                            if character2 and limit < 10 then
                                gst.faction_create_military_force("xyyhlyjf",
                                    cm:query_faction("xyyhlyjf"):capital_region():name(), character2);
                                add_characters_to_military_force(
                                cm:modify_model():get_modify_military_force(character2:military_force()),
                                    cm:query_faction("xyyhlyjf"))
                                --add_freeze(character2:cqi());
                                limit = limit + 1
                            end

                            local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template(
                            "general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                            local character3 = modify_character_3:query_character();
                            if character3 and limit < 10 then
                                gst.faction_create_military_force("xyyhlyjf",
                                    cm:query_faction("xyyhlyjf"):capital_region():name(), character3);
                                add_characters_to_military_force(
                                cm:modify_model():get_modify_military_force(character3:military_force()),
                                    cm:query_faction("xyyhlyjf"))
                                --add_freeze(character3:cqi());
                                limit = limit + 1
                            end

                            local modify_character_4 = cm:modify_faction("xyyhlyjf"):create_character_from_template(
                            "general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                            local character4 = modify_character_4:query_character();
                            if character4 and limit < 10 then
                                gst.faction_create_military_force("xyyhlyjf",
                                    cm:query_faction("xyyhlyjf"):capital_region():name(), character4);
                                add_characters_to_military_force(
                                cm:modify_model():get_modify_military_force(character4:military_force()),
                                    cm:query_faction("xyyhlyjf"))
                                --add_freeze(character4:cqi());
                                limit = limit + 1
                            end
                        end
                        cm:set_saved_value("xyy_roguelike_mission_boss", false)
                        cm:trigger_mission(faction, "xyy_roguelike_mission_boss_2", true);
                        cm:set_saved_value("xyy_roguelike_mission_boss_2", true)
                        cm:set_saved_value("xyy_roguelike_mission_boss_2_character_browser", true)
                        cm:set_saved_value("xyy_roguelike_mission_xyyhlyjf_limit", limit)
                    end
                elseif cm:get_saved_value("xyy_roguelike_mission_boss_2")
                    and faction:has_mission_been_issued("xyy_roguelike_mission_boss_2")
                    and not faction:is_mission_active("xyy_roguelike_mission_boss_2")
                    and not cm:get_saved_value("huanlong_dead") then
                    local limit;
                    if cm:get_saved_value("xyy_roguelike_mission_xyyhlyjf_limit") then
                        limit = cm:get_saved_value("xyy_roguelike_mission_xyyhlyjf_limit")
                    else
                        limit = 0
                    end
                    cm:modify_faction(cm:query_faction("xyyhlyjf")):ceo_management():remove_ceos("hlyjdingzhibyifu");
                    gst.character_CEO_equip("hlyjdingzhia", "hlyjdingzhicyifu", "3k_main_ceo_category_ancillary_armour");
                    gst.faction_create_military_force("xyyhlyjf", cm:query_faction("xyyhlyjf"):capital_region():name(),
                        hlyjdingzhia)
                    if gst.faction_is_character_deployed(hlyjdingzhia) then
                        if not hlyjdingzhia:military_force():is_null_interface() then
                            if not hlyjdingzhia:get_is_deployable() then
                                cm:modify_character(hlyjdingzhia:set_is_deployable());
                            end
                            local modify_force = cm:modify_model():get_modify_military_force(hlyjdingzhia:military_force());
                            add_characters_to_military_force(modify_force, cm:query_faction("xyyhlyjf"))
                            remove_freeze(hlyjdingzhia:cqi())
                            cm:modify_character(hlyjdingzhia):apply_effect_bundle("lower_movement_range", -1)
                            local modify_character_1 = cm:modify_faction("xyyhlyjf"):create_character_from_template(
                            "general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                            local character1 = modify_character_1:query_character();
                            if character and limit < 10 then
                                gst.faction_create_military_force("xyyhlyjf",
                                    cm:query_faction("xyyhlyjf"):capital_region():name(), character);
                                add_characters_to_military_force(
                                cm:modify_model():get_modify_military_force(character:military_force()),
                                    cm:query_faction("xyyhlyjf"))
                                --add_freeze(character:cqi());
                                limit = limit + 1
                            end
                            local modify_character_2 = cm:modify_faction("xyyhlyjf"):create_character_from_template(
                            "general", "3k_general_fire", "3k_xyy_template_scripted_xyyhlyjf_fire_strong_late", false);
                            local character2 = modify_character_2:query_character();
                            if character2 and limit < 10 then
                                gst.faction_create_military_force("xyyhlyjf",
                                    cm:query_faction("xyyhlyjf"):capital_region():name(), character2);
                                add_characters_to_military_force(
                                cm:modify_model():get_modify_military_force(character2:military_force()),
                                    cm:query_faction("xyyhlyjf"))
                                --add_freeze(character2:cqi());
                                limit = limit + 1
                            end

                            local modify_character_3 = cm:modify_faction("xyyhlyjf"):create_character_from_template(
                            "general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                            local character3 = modify_character_3:query_character();
                            if character3 and limit < 10 then
                                gst.faction_create_military_force("xyyhlyjf",
                                    cm:query_faction("xyyhlyjf"):capital_region():name(), character3);
                                add_characters_to_military_force(
                                cm:modify_model():get_modify_military_force(character3:military_force()),
                                    cm:query_faction("xyyhlyjf"))
                                --add_freeze(character3:cqi());
                                limit = limit + 1
                            end

                            local modify_character_4 = cm:modify_faction("xyyhlyjf"):create_character_from_template(
                            "general", "3k_general_metal", "3k_xyy_template_scripted_xyyhlyjf_metal_strong_late", false);
                            local character4 = modify_character_4:query_character();
                            if character4 and limit < 10 then
                                gst.faction_create_military_force("xyyhlyjf",
                                    cm:query_faction("xyyhlyjf"):capital_region():name(), character4);
                                add_characters_to_military_force(
                                cm:modify_model():get_modify_military_force(character4:military_force()),
                                    cm:query_faction("xyyhlyjf"))
                                --add_freeze(character4:cqi());
                                limit = limit + 1
                            end
                            cm:set_saved_value("xyy_roguelike_mission_xyyhlyjf_limit", limit)
                        end
                    end
                    cm:set_saved_value("xyy_roguelike_mission_boss", false)
                    cm:trigger_mission(faction, "xyy_roguelike_mission_boss_3", true);
                    cm:set_saved_value("xyy_roguelike_mission_boss_3", true)
                    cm:set_saved_value("xyy_roguelike_mission_boss_3_character_browser", true)
                end
            end
            gst.character_CEO_unequip("hlyjck_dark", "3k_main_ceo_category_ancillary_accessory");
            gst.character_CEO_equip("hlyjck_dark", "3k_main_ancillary_accessory_art_of_war",
                "3k_main_ceo_category_ancillary_accessory");
        end,
        true
    )

    core:add_listener(
        "Rogurlike_SchemesResearchStarted",
        "ResearchStarted",
        function(context)
            return cm:get_saved_value("roguelike_schemes_tech_cooldown") and
            cm:get_saved_value("roguelike_schemes_tech_cooldown") > 0
        end,
        function(context) -- What to do if listener fires.
            local tech_cooldown = cm:get_saved_value("roguelike_schemes_tech_cooldown")
            if tech_cooldown > 0 then
                cm:modify_faction(context:faction()):set_tech_research_cooldown(tech_cooldown)
                cm:set_saved_value("roguelike_schemes_tech_cooldown", 0)
            end
        end,
        true
    );

    core:add_listener(
        "force_peace_listener",
        "FactionTurnEnd",
        function(context)
            return true;
        end,
        function(context)
            if context:faction():is_human()
                and context:faction():has_effect_bundle("xyy_roguelike_22")
            then
                if context:faction():treasury() <= 2000 then
                    cm:modify_faction(context:faction()):increase_treasury(5000)
                end
            end
--             if context:faction():is_human() and not context:faction():is_mission_active("xyy_roguelike_mission_ready") then
--                 local faction = context:faction()
--                 local hlyjci_dark = gst.character_query_for_template("hlyjci_dark")
--                 if hlyjci_dark
--                     and not hlyjci_dark:is_null_interface()
--                     and not hlyjci_dark:is_dead()
--                     and not faction:is_mission_active("xyy_roguelike_kill_hlyjci_dark") then
--                     cm:trigger_mission(faction, "xyy_roguelike_kill_hlyjci_dark", true);
--                 end
-- 
--                 local hlyjcj_dark = gst.character_query_for_template("hlyjcj_dark")
--                 if hlyjcj_dark
--                     and not hlyjcj_dark:is_null_interface()
--                     and not hlyjcj_dark:is_dead()
--                     and not faction:is_mission_active("xyy_roguelike_kill_hlyjcj_dark") then
--                     cm:trigger_mission(faction, "xyy_roguelike_kill_hlyjcj_dark", true);
--                 end
-- 
--                 local hlyjck_dark = gst.character_query_for_template("hlyjck_dark")
--                 if hlyjck_dark
--                     and not hlyjck_dark:is_null_interface()
--                     and not hlyjck_dark:is_dead()
--                     and not faction:is_mission_active("xyy_roguelike_kill_hlyjck_dark") then
--                     cm:trigger_mission(faction, "xyy_roguelike_kill_hlyjck_dark", true);
--                 end
-- 
--                 local hlyjcm_dark = gst.character_query_for_template("hlyjcm_dark")
--                 if hlyjcm_dark
--                     and not hlyjcm_dark:is_null_interface()
--                     and not hlyjcm_dark:is_dead()
--                     and not faction:is_mission_active("xyy_roguelike_kill_hlyjcm_dark") then
--                     cm:trigger_mission(faction, "xyy_roguelike_kill_hlyjcm_dark", true);
--                 end
-- 
--                 local hlyjcn_dark = gst.character_query_for_template("hlyjcn_dark")
--                 if hlyjcn_dark
--                     and not hlyjcn_dark:is_null_interface()
--                     and not hlyjcn_dark:is_dead()
--                     and not faction:is_mission_active("xyy_roguelike_kill_hlyjcn_dark") then
--                     cm:trigger_mission(faction, "xyy_roguelike_kill_hlyjcn_dark", true);
--                 end
-- 
--                 local hlyjda_dark = gst.character_query_for_template("hlyjda_dark")
--                 if hlyjda_dark
--                     and not hlyjda_dark:is_null_interface()
--                     and not hlyjda_dark:is_dead()
--                     and not faction:is_mission_active("xyy_roguelike_kill_hlyjda_dark") then
--                     cm:trigger_mission(faction, "xyy_roguelike_kill_hlyjda_dark", true);
--                 end
-- 
--                 local hlyjcy_dark = gst.character_query_for_template("hlyjcy_dark")
--                 if hlyjda_dark
--                     and not hlyjcy_dark:is_null_interface()
--                     and not hlyjcy_dark:is_dead()
--                     and not faction:is_mission_active("xyy_roguelike_kill_hlyjcy_dark") then
--                     cm:trigger_mission(faction, "xyy_roguelike_kill_hlyjcy_dark", true);
--                 end
-- 
--                 local hlyjdi_dark = gst.character_query_for_template("hlyjdi_dark")
--                 if hlyjdi_dark
--                     and not hlyjdi_dark:is_null_interface()
--                     and not hlyjdi_dark:is_dead()
--                     and not faction:is_mission_active("xyy_roguelike_kill_hlyjdi_dark") then
--                     cm:trigger_mission(faction, "xyy_roguelike_kill_hlyjdi_dark", true);
--                 end
-- 
--                 local hlyjdf_dark = gst.character_query_for_template("hlyjdf_dark")
--                 if hlyjdf_dark
--                     and not hlyjdf_dark:is_null_interface()
--                     and not hlyjdf_dark:is_dead()
--                     and not faction:is_mission_active("xyy_roguelike_kill_hlyjdf_dark") then
--                     cm:trigger_mission(faction, "xyy_roguelike_kill_hlyjdf_dark", true);
--                 end
--             end
            local region1 = cm:query_region("3k_main_shoufang_resource_2")
            if region1
                and not region1:is_null_interface()
                and region1:owning_faction()
                and not region1:owning_faction():is_null_interface()
                and region1:owning_faction():name() == "xyyhlyjf"
            then
                cm:modify_region(region1):raze_and_abandon_settlement_without_attacking()
            end

            local region2 = cm:query_region("3k_main_shangyong_resource_2")
            if region2
                and not region2:is_null_interface()
                and region2:owning_faction()
                and not region2:owning_faction():is_null_interface()
                and region2:owning_faction():name() == "xyyhlyjf"
            then
                cm:modify_region(region2):raze_and_abandon_settlement_without_attacking()
            end

            local region3 = cm:query_region("3k_main_poyang_resource_3")
            if region3
                and not region3:is_null_interface()
                and region3:owning_faction()
                and not region3:owning_faction():is_null_interface()
                and region3:owning_faction():name() == "xyyhlyjf"
            then
                cm:modify_region(region3):raze_and_abandon_settlement_without_attacking()
            end

            local region4 = cm:query_region("3k_main_chengdu_resource_1")
            if region4
                and not region4:is_null_interface()
                and region4:owning_faction()
                and not region4:owning_faction():is_null_interface()
                and region4:owning_faction():name() == "xyyhlyjf"
            then
                cm:modify_region(region4):raze_and_abandon_settlement_without_attacking()
            end

            local region5 = cm:query_region("3k_main_changsha_resource_2")
            if region5
                and not region5:is_null_interface()
                and region5:owning_faction()
                and not region5:owning_faction():is_null_interface()
                and region5:owning_faction():name() == "xyyhlyjf"
            then
                cm:modify_region(region5):raze_and_abandon_settlement_without_attacking()
            end

            if cm:query_local_faction():is_mission_active("xyy_roguelike_mission_xyyhlyjf")
                or cm:get_saved_value("huanlong_dead")
            then
                cm:modify_model():enable_diplomacy("all", "all", diplomacy_keys, "roguelike_mode");
                cm:modify_model():enable_diplomacy("faction:" .. cm:query_local_faction():name(), "all",
                    "treaty_components_peace,treaty_components_peace_no_event", "roguelike_mode")
            elseif not context:faction():is_human() and is_main_faction(context:faction():name()) then
                local faction = context:faction()
                local faction_key = faction:name()
                local world_list = cm:query_model():world():faction_list()
                for i = 0, world_list:num_items() - 1 do
                    local faction2 = world_list:item_at(i)
                    if not faction2:is_null_interface()
                        and not faction2:is_dead()
                        and faction:has_specified_diplomatic_deal_with("treaty_components_war", faction2)
                        and is_main_faction(faction2:name())
                    then
                        local faction2_key = faction2:name()
                        if not faction2:is_human()
                        then
                            if is_main_faction(faction_key) and is_main_faction(faction2_key) then
                                diplomacy_manager:apply_automatic_deal_between_factions(faction_key, faction2_key,
                                    "data_defined_situation_peace", true)
                            end
                        elseif not cm:get_saved_value("xyy_roguelike_mission_target_faction")
                            or faction_key ~= cm:get_saved_value("xyy_roguelike_mission_target_faction")
                        then
                            cm:modify_model():enable_diplomacy("faction:" .. faction_key, "faction:" .. faction2_key,
                                "treaty_components_peace,treaty_components_peace_no_event", "hidden")
                            if faction2:subculture() == "3k_main_subculture_yellow_turban" then
                                enable_ytr_diplomacy(faction2_key)
                            end
                            if is_main_faction(faction_key) and is_main_faction(faction2_key) then
                                diplomacy_manager:apply_automatic_deal_between_factions(faction_key, faction2_key,
                                    "data_defined_situation_peace", true)
                            end
                        end
                    end
                end
            end
        end,
        true
    )

    core:add_listener(
        "force_stop_checking_event",
        "CharacterFinishedMovingEvent",
        function(context)
            return not context:query_character():faction():is_mission_active("xyy_roguelike_mission_xyyhlyjf")
                and not cm:get_saved_value("huanlong_dead");
        end,
        function(context)
            local faction = context:query_character():faction()
            if faction:is_human() then
                if faction:is_mission_active("xyy_roguelike_mission_ready") then
                    local world_list = cm:query_model():world():faction_list()
                    for i = 0, world_list:num_items() - 1 do
                        local faction2 = world_list:item_at(i)
                        if faction2
                            and not faction2:is_null_interface()
                            and not faction2:is_dead()
                            and is_main_faction(faction2:name())
                        then
                            if (faction2:name() ~= "xyyhlyjf" or faction:is_mission_active("xyy_roguelike_mission_xyyhlyjf"))
                                and cm:query_faction(faction):has_specified_diplomatic_deal_with("treaty_components_war", faction2)
                                and not cm:get_saved_value("xyy_roguelike_mission_target_faction")
                            then
                                trigger_mission(faction:name(), faction2:name());
                            elseif faction2:name() ~= faction:name()
                                and is_main_faction(faction:name())
                            then
                                cm:modify_model():enable_diplomacy("faction:" .. faction2:name(),
                                    "faction:" .. faction:name(),
                                    "treaty_components_peace,treaty_components_peace_no_event", "hidden")
                                if faction:subculture() == "3k_main_subculture_yellow_turban" then
                                    enable_ytr_diplomacy(faction:name())
                                end
                                if faction2:subculture() == "3k_main_subculture_yellow_turban" then
                                    enable_ytr_diplomacy(faction2:name())
                                end
                                if is_main_faction(faction2:name()) and is_main_faction(faction:name()) then
                                    diplomacy_manager:apply_automatic_deal_between_factions(faction2:name(),
                                        faction:name(), "data_defined_situation_peace", true)
                                end
                            end
                        end
                    end
                end
            elseif is_main_faction(faction:name())
                and faction:has_specified_diplomatic_deal_with("treaty_components_war", cm:query_local_faction())
                and not cm:get_saved_value("xyy_roguelike_mission_target_faction")
                or context:query_character():faction():name() ~= cm:get_saved_value("xyy_roguelike_mission_target_faction") then
                local faction2 = cm:query_local_faction()
                cm:modify_model():enable_diplomacy("faction:" .. faction:name(), "faction:" .. faction2:name(),
                    "treaty_components_peace,treaty_components_peace_no_event", "hidden")
                if faction:subculture() == "3k_main_subculture_yellow_turban" then
                    enable_ytr_diplomacy(faction:name())
                end
                if faction2:subculture() == "3k_main_subculture_yellow_turban" then
                    enable_ytr_diplomacy(faction2:name())
                end
                if is_main_faction(faction2:name()) and is_main_faction(faction:name()) then
                    diplomacy_manager:apply_automatic_deal_between_factions(faction:name(), faction2:name(),
                        "data_defined_situation_peace", true)
                end
            end
        end,
        true
    )
    
    core:add_listener(
        "force_stop_checking_event2",
        "MovementPointsExhausted",
        function(context)
            --ModLog("force_stop_checking_event2")
            return context:query_character():faction():is_human();
        end,
        function(context)
            if cm:get_saved_value("xyy_roguelike_19_unseen") then
                --ModLog("触发 xyy_roguelike_19_unseen")
                local character = cm:query_model():character_for_command_queue_index(cm:get_saved_value(
                "xyy_roguelike_19_unseen"))

                cm:modify_character(character):enable_movement();
                cm:modify_character(character):replenish_action_points();
                cm:set_saved_value("xyy_roguelike_19_unseen", false)
            end
        end,
        true
    )
    core:add_listener(
        "roguelike_region_back_event",
        "RegionOwnershipChanged",
        function(context)
            if not context:previous_owner()
                or context:previous_owner():is_null_interface()
                or context:previous_owner():is_dead() then
                return false
            end
            ----ModLog("reason" .. context:reason())
            return not cm:get_saved_value("huanlong_dead") and
            not context:new_owner():is_mission_active("xyy_roguelike_mission_xyyhlyjf");
        end,
        function(context)
            if not is_main_faction(context:new_owner():name()) then
                cm:modify_model():enable_diplomacy("faction:" .. context:new_owner():name(),
                    "faction:" .. context:previous_owner():name(), diplomacy_keys, "roguelike_mode");
                cm:modify_model():enable_diplomacy("faction:" .. context:previous_owner():name(),
                    "faction:" .. context:new_owner():name(), diplomacy_keys, "roguelike_mode");
                if context:new_owner():has_specified_diplomatic_deal_with("treaty_components_vassalage", cm:query_local_faction()) then
                    if not gst.lib_value_in_list(current_regions, context:region():name()) then
                        cm:trigger_incident(cm:query_local_faction():name(), "roguelike_info_ticket", true)
                        if context:region():is_province_capital() then
                            gst.faction_add_tickets(cm:query_local_faction():name(), 50)
                            counter = counter + 50;
                            if cm:query_local_faction():has_effect_bundle("xyy_roguelike_21") then
                                gst.faction_add_tickets(cm:query_local_faction():name(), 10)
                                counter = counter + 10;
                            end
                        else
                            gst.faction_add_tickets(cm:query_local_faction():name(), 20)
                            counter = counter + 20;
                            if cm:query_local_faction():has_effect_bundle("xyy_roguelike_21") then
                                gst.faction_add_tickets(cm:query_local_faction():name(), 10)
                                counter = counter + 10;
                            end
                        end
                        if counter >= 200 then
                            counter = counter % 200 -- 减去100以保持计数器的正确状态
                            cm:set_saved_value("have_Roguelike_Panel", true)
                        end
                        cm:set_saved_value("roguelike_counter", counter)
                        gst.lib_table_insert(current_regions, context:region():name())
                    end
                end
                return;
            end

            if not (context:new_owner():name() == cm:query_local_faction():name()
                    and cm:get_saved_value("xyy_roguelike_mission_target_faction")
                    and context:previous_owner():name() == cm:get_saved_value("xyy_roguelike_mission_target_faction"))
                and is_main_faction(context:previous_owner():name())
                and not context:new_owner():has_specified_diplomatic_deal_with("treaty_components_vassalage", context:previous_owner())
            then
                if context:new_owner():name() ~= cm:get_saved_value("xyy_roguelike_mission_target_faction")
                    and not cm:get_saved_value("huanlong_dead") and not context:new_owner():is_human() then
                    cm:modify_region(context:region()):settlement_gifted_as_if_by_payload(cm:modify_faction(context
                    :previous_owner()))
                    return;
                end
            end
            if context:previous_owner():is_human()
                and context:previous_owner():has_effect_bundle("xyy_roguelike_1") then
                cm:set_saved_value("roguelike_return_region", context:region():name())
                cm:set_saved_value("roguelike_return_region_time", 5)
            end
            if context:new_owner():is_human()
            then
                if cm:get_saved_value("roguelike_return_region") then
                    cm:set_saved_value("roguelike_return_region", false)
                    cm:set_saved_value("roguelike_return_region_time", false)
                end
                if not gst.lib_value_in_list(current_regions, context:region():name()) then
                    cm:trigger_incident(cm:query_local_faction():name(), "roguelike_info_ticket", true)
                    if context:region():is_province_capital() then
                        gst.faction_add_tickets(context:new_owner():name(), 50)
                        counter = counter + 50;
                        if context:new_owner():has_effect_bundle("xyy_roguelike_21") then
                            gst.faction_add_tickets(context:new_owner():name(), 10)
                            counter = counter + 10;
                        end
                    else
                        gst.faction_add_tickets(context:new_owner():name(), 20)
                        counter = counter + 20;
                        if context:new_owner():has_effect_bundle("xyy_roguelike_21") then
                            gst.faction_add_tickets(context:new_owner():name(), 10)
                            counter = counter + 10;
                        end
                    end
                    if counter >= 200 then
                        counter = counter % 200 -- 减去100以保持计数器的正确状态
                        cm:set_saved_value("roguelike_safe_trigger_2", true)
                        openRoguelikePanel()
                    end
                    cm:set_saved_value("roguelike_counter", counter)
                    gst.lib_table_insert(current_regions, context:region():name())
                end
            end
            local AI_faction = context:previous_owner()
            local player_faction = context:new_owner()
            if not AI_faction:is_human()
            and AI_faction:region_list():is_empty()
            and player_faction:is_human()
            then
                if player_faction:has_effect_bundle("xyy_roguelike_37") then
                    local military_force_list = AI_faction:military_force_list()
                    for j = 0, military_force_list:num_items() - 1 do
                        local query_military_force = military_force_list:item_at(j);
                        local character_list = query_military_force:character_list()
                        for k = 0, character_list:num_items() - 1 do
                            local character = character_list:item_at(k);
                            if not character:is_null_interface()
                                and not character:is_dead()
                                and character:generation_template_key() ~= "3k_main_template_generic_castellan_m_01"
                                and character:generation_template_key() ~= "3k_main_template_generic_castellan_f_01"
                                and character:generation_template_key() ~= "3k_dlc06_template_generic_castellan_nanman_m_01"
                                and character:generation_template_key() ~= "3k_dlc06_template_generic_castellan_nanman_f_01"
                                and character:character_type("general")
                            then
                                cm:modify_character(character):move_to_faction_and_make_recruited("xyyhlyjf")
                            end
                        end
                    end
                    
                    if not AI_faction:is_dead() then
                        diplomacy_manager:force_confederation("xyyhlyjf", AI_faction:name());
                    end
                    
                    if not AI_faction:is_dead() 
                    and is_main_faction(AI_faction:name())
                    then
                        if player_faction:is_mission_active("xyy_roguelike_mission_easy") then
                            cm:modify_faction(player_faction):complete_custom_mission("xyy_roguelike_mission_easy")
                        elseif player_faction:is_mission_active("xyy_roguelike_mission_normal") then
                            cm:modify_faction(player_faction):complete_custom_mission("xyy_roguelike_mission_normal")
                        elseif player_faction:is_mission_active("xyy_roguelike_mission_hard") then
                            cm:modify_faction(player_faction):complete_custom_mission("xyy_roguelike_mission_hard")
                        end
                    end
                else
                    local military_force_list = AI_faction:military_force_list()
                    for j = 0, military_force_list:num_items() - 1 do
                        local query_military_force = military_force_list:item_at(j);
                        local character_list = query_military_force:character_list()
                        for k = 0, character_list:num_items() - 1 do
                            local character = character_list:item_at(k);
                            if not character:is_null_interface()
                            and not character:is_dead()
                            and character:character_type("general")
                            and string.find("_dark", character:generation_template_key())
                            then
                                cm:modify_character(character):move_to_faction_and_make_recruited("xyyhlyjf")
                                if cm:query_local_faction():is_mission_active("xyy_roguelike_kill_"..character:generation_template_key()) then
                                    cm:modify_local_faction():cancel_custom_mission("xyy_roguelike_kill_"..character:generation_template_key())
                                end
                            end
                        end
                    end
                end
            end
            if context:new_owner():name() == cm:query_local_faction():name()
                and context:previous_owner():name() == "xyyhlyjf"
                and context:region():name() == cm:query_faction("xyyhlyjf"):capital_region():name()
                and not cm:query_faction("xyyhlyjf"):region_list():is_empty()
            then
                cm:modify_region(context:region()):settlement_gifted_as_if_by_payload(cm:modify_faction(context
                :previous_owner()))
                local random_regions = {};
                cm:query_faction("xyyhlyjf"):region_list():foreach(
                    function(region)
                        if region:is_province_capital() then
                            table.insert(random_regions, region)
                        end
                    end
                )
                if #random_regions == 0 then
                    cm:query_faction("xyyhlyjf"):region_list():foreach(
                        function(region)
                            table.insert(random_regions, region)
                        end
                    )
                end
                cm:modify_faction("xyyhlyjf"):make_region_capital(random_regions[cm:random_int(#random_regions, 1)])
                cm:modify_region(context:region()):settlement_gifted_as_if_by_payload(cm:modify_faction(context
                :new_owner()))
                local mission_keys = {
                    "3k_main_victory_objective_chain_1_cao_cao",
                    "3k_main_victory_objective_chain_1_dong_zhuo",
                    "3k_main_victory_objective_chain_1_gong_du",
                    "3k_main_victory_objective_chain_1_gongsun_zan",
                    "3k_main_victory_objective_chain_1_he_yi",
                    "3k_main_victory_objective_chain_1_huang_shao",
                    "3k_main_victory_objective_chain_1_kong_rong",
                    "3k_main_victory_objective_chain_1_liu_bei",
                    "3k_main_victory_objective_chain_1_liu_biao",
                    "3k_main_victory_objective_chain_1_ma_teng",
                    "3k_main_victory_objective_chain_1_sun_jian",
                    "3k_main_victory_objective_chain_1_tao_qian",
                    "3k_main_victory_objective_chain_1_yan_baihu",
                    "3k_main_victory_objective_chain_1_yuan_shao",
                    "3k_main_victory_objective_chain_1_yuan_shu",
                    "3k_main_victory_objective_chain_1_zhang_yan",
                    "3k_main_victory_objective_chain_1_zheng_jiang"
                }
                for k,v in ipairs(mission_keys) do
                    cm:modify_local_faction():complete_custom_mission(v);
                end
                local mission_keys_2 = {
                    "3k_main_victory_objective_chain_2_han_governors",
                    "3k_main_victory_objective_chain_2_han_warlords",
                    "3k_main_victory_objective_chain_2_outlaws",
                    "3k_main_victory_objective_chain_2_yellow_turban"
                }
                for k,v in ipairs(mission_keys_2) do
                    cm:modify_local_faction():complete_custom_mission(v);
                end
                local mission_keys_3 = {
                    "3k_main_victory_objective_chain_3_han",
                    "3k_main_victory_objective_chain_3_outlaws",
                    "3k_main_victory_objective_chain_3_yellow_turban"
                }
                for k,v in ipairs(mission_keys_3) do
                    cm:modify_local_faction():complete_custom_mission(v);
                end
                cm:modify_local_faction():complete_custom_mission("3k_main_victory_objective_chain_4");
            end
        end,
        true
    )
    
    function change_capital(query_region)
        if query_region:owning_faction():name() == "xyyhlyjf" then
            if cm:query_local_faction():number_of_world_leader_regions() >= 2 then
                for i = 0, cm:query_local_faction():region_list():num_items() - 1 do
                    local region = cm:query_local_faction():region_list():item_at(i)
                    if region:name() ~= cm:query_local_faction():capital_region():name() then
                        cm:modify_model():get_modify_world():remove_world_leader_region_status(region:name());
                    end
                    if cm:query_local_faction():number_of_world_leader_regions() < 2 then
                        cm:set_saved_value("xyy_roguelike_world_leader_target_region_2nd", region:name())
                        ModLog("region_remove: 玩家的另一个皇位暂时没收：" .. region:name())
                        break;
                    end
                end
            end
            local faction = cm:query_faction("xyyhlyjf")
            local invalid_region = {}
            local query_local_faction = cm:query_local_faction()
            local military_force_list = query_local_faction:military_force_list()
            for j = 0, military_force_list:num_items() - 1 do
                local query_military_force = military_force_list:item_at(j);
                local character_list = query_military_force:character_list()
                for k = 0, character_list:num_items() - 1 do
                    local character = character_list:item_at(k);
                    if not character:is_null_interface()
                    and not character:is_dead()
                    and character:character_type("general")
                    then
                        gst.lib_table_insert(invalid_region, character:region():name())
                    end
                end
            end
            for i = 0, faction:region_list():num_items() - 1 do
                local region = faction:region_list():item_at(i)
                ModLog(region:name())
                if region:is_province_capital() 
                and region:name() ~= cm:get_saved_value("xyy_roguelike_world_leader_target_region")
                and not region:garrison_residence():is_under_siege()
                and not gst.lib_value_in_list(invalid_region, region:name())
                then
                    ModLog("region_remove: 创建新的的皇位：" .. region:name())
                    cm:set_saved_value("xyy_roguelike_world_leader_target_region", region:name())
                    cm:modify_model():get_modify_world():add_world_leader_region_status(region:name())
                    cm:modify_faction(faction):make_region_capital(region)
                    break;
                end
            end
            cm:modify_model():get_modify_world():remove_world_leader_region_status(query_region:name());
            if cm:get_saved_value("xyy_roguelike_world_leader_target_region_2nd") then
                cm:modify_model():get_modify_world():add_world_leader_region_status(cm:get_saved_value("xyy_roguelike_world_leader_target_region_2nd"));
                cm:set_saved_value("xyy_roguelike_world_leader_target_region_2nd", nil)
            end
        end
    end
    
    core:add_listener(
        "roguelike_region_back_event_xyyhlyjf",
        "CharacterBesiegesSettlement",
        function(context)
            ModLog(context:query_region():name() .. "被围攻")
            ModLog("幻胧皇位" .. cm:get_saved_value("xyy_roguelike_world_leader_target_region"))
            return not cm:get_saved_value("huanlong_dead") 
            and cm:get_saved_value("xyy_roguelike_world_leader_target_region") == context:query_region():owning_faction()
            and cm:get_saved_value("xyy_roguelike_mission_target_faction")
            and cm:get_saved_value("xyy_roguelike_mission_target_faction") == context:query_character():region():owning_faction():name()
            and cm:query_model():is_player_turn()
        end,
        function(context)
            change_capital(context:query_region())
        end,
        true
    )
    
    core:add_listener(
        "roguelike_region_back_event_xyyhlyjf_1",
        "CharacterFinishedMovingEvent",
        function(context)
--             ModLog("角色移动至："..context:query_character():region():name())
--             ModLog("幻胧皇位" .. cm:get_saved_value("xyy_roguelike_world_leader_target_region"))
            return not context:was_flee() 
            and context:query_character():region()
            and not context:query_character():region():is_null_interface()
            and not cm:get_saved_value("huanlong_dead") 
            and cm:get_saved_value("xyy_roguelike_world_leader_target_region") == context:query_character():region():name()
            and cm:get_saved_value("xyy_roguelike_mission_target_faction")
            and cm:get_saved_value("xyy_roguelike_mission_target_faction") == context:query_character():region():owning_faction():name()
            and cm:query_model():is_player_turn()
            and context:query_character():faction():is_human()
        end,
        function(context)
            change_capital(context:query_character():region())
        end,
        true
    )
    
    core:add_listener(
        "roguelike_region_back_event_xyyhlyjf_3",
        "FactionTurnStart",
        function(context)
            ----ModLog("reason" .. context:reason())
            return context:faction():is_human();
        end,
        function(context)
            local region_key = cm:query_faction("xyyhlyjf"):capital_region():name();
            if cm:get_saved_value("xyy_roguelike_world_leader_target_region") ~= region_key then
                cm:modify_model():get_modify_world():remove_world_leader_region_status(cm:get_saved_value("xyy_roguelike_world_leader_target_region"));
                cm:modify_model():get_modify_world():add_world_leader_region_status(region_key);
                cm:set_saved_value("xyy_roguelike_world_leader_target_region", region_key)
            end
        end,
        true
    )
        
    core:add_listener(
        "force_return_region_event",
        "FactionEffectBundleAwarded",
        function(context)
            return string.find(context:effect_bundle_key(), "xyy_roguelike");
        end,
        function(context)
            --ModLog(context:faction():name() .. "effect_bundle: " .. context:effect_bundle_key())
            local faction = context:faction()
            local effect_bundle_key = context:effect_bundle_key()
            if effect_bundle_key == "xyy_roguelike_max_1"
                or effect_bundle_key == "xyy_roguelike_max_2"
                or effect_bundle_key == "xyy_roguelike_max_3"
                or effect_bundle_key == "xyy_roguelike_max_4"
            then
                max = max + 1;
                cm:set_saved_value("roguelike_max_slot", max)
            end

            if effect_bundle_key == "xyy_roguelike_max_character_browser_1"
                or effect_bundle_key == "xyy_roguelike_max_character_browser_2"
                or effect_bundle_key == "xyy_roguelike_max_character_browser_3"
                or effect_bundle_key == "xyy_roguelike_max_character_browser_4"
            then
                max_character_browser = max_character_browser + 1;
                cm:set_saved_value("roguelike_max_claracter_browser_slot", max_character_browser)
            end

            if effect_bundle_key == "xyy_roguelike_max_character_1"
            then
                max_character = max_character + 1;
                cm:set_saved_value("roguelike_max_claracter_slot", max_character)
            end

            if effect_bundle_key == "xyy_roguelike_redraw_1"
            then
                refresh_num = 1;
                cm:set_saved_value("roguelike_max_refresh", refresh_num)
            end

            if effect_bundle_key == "xyy_roguelike_8"
            then
                cm:trigger_dilemma(faction:name(), "xyy_path_blessing", true);
            end

            if effect_bundle_key == "xyy_roguelike_the_seven_kings"
            then
                gst.character_add_to_faction("hlyjj", faction:name(), "3k_general_earth")
                gst.character_add_to_faction("hlyjt", faction:name(), "3k_general_earth")
                gst.character_add_to_faction("hlyjo", faction:name(), "3k_general_wood")
                gst.character_add_to_faction("hlyjl", faction:name(), "3k_general_water")
                gst.character_add_to_faction("hlyjm", faction:name(), "3k_general_metal")
                gst.character_add_to_faction("hlyjp", faction:name(), "3k_general_fire")
                gst.character_add_to_faction("hlyjq", faction:name(), "3k_general_water")
            end

            if effect_bundle_key == "xyy_roguelike_sima_yi"
            then
                gst.character_add_to_faction("3k_main_template_historical_sima_yi_hero_water", faction:name(), "3k_general_water")
            end
            
            if effect_bundle_key == "xyy_roguelike_23"
            then
                cm:set_saved_value("roguelike_safe_trigger", true)
                character_browser_roguelike_select()
            end

            if effect_bundle_key == "xyy_roguelike_51"
            then
                cm:set_saved_value("roguelike_safe_trigger", true)
                cm:set_saved_value("xyy_roguelike_51", true)
                local tickets = cm:get_saved_value("ticket_points_" .. faction:name())
                gst.faction_subtract_tickets(faction:name(), tickets);
                character_browser_roguelike_select()
            end

            if effect_bundle_key == "xyy_roguelike_25"
            then
                reapply_enemy_effect()
            end

            if effect_bundle_key == "xyy_roguelike_32"
            then
                gst.character_add_to_faction("3k_main_template_historical_zhuge_liang_hero_water",
                    faction:name(), "3k_general_water")
            end

            if effect_bundle_key == "xyy_roguelike_50"
            then
                local counter = 0
                faction:region_list():foreach(
                    function(region)
                        if region:building_exists("3k_city_10") then
                            counter = counter + 1;
                        end
                    end
                );
                gst.faction_add_tickets(faction:name(), counter * 30)
            end
            
            if effect_bundle_key == "xyy_roguelike_66" then
                for i = 0, faction:character_list():num_items() - 1 do
                    local character = faction:character_list():item_at(i)
                    if not character:is_dead()
                    and not character:is_character_is_faction_recruitment_pool() 
                    and character:character_type("general") 
                    then
                        local loyalty = character:loyalty()
                        if loyalty <= 25 then
                            cm:modify_character(character):apply_effect_bundle("xyy_roguelike_66_unseen_3",-1)
                        elseif loyalty > 25 and loyalty <= 50 then
                            cm:modify_character(character):apply_effect_bundle("xyy_roguelike_66_unseen_2",-1)
                        elseif loyalty > 50 then
                            cm:modify_character(character):apply_effect_bundle("xyy_roguelike_66_unseen_1",-1)
                        end
                    end
                end
            end
        end,
        true
    )

    core:add_listener(
        "roguelike_character_wound_event",
        "CharacterWoundReceivedEvent",
        function(context)
            return context:query_character():generation_template_key() == "hlyjdingzhia";
        end,
        function(context)
            if cm:query_local_faction():is_mission_active("xyy_roguelike_mission_boss")
                or cm:query_local_faction():is_mission_active("xyy_roguelike_mission_boss_2")
                or cm:query_local_faction():is_mission_active("xyy_roguelike_mission_boss_3")
            then
                if not context:query_character():won_battle() then
                    if cm:query_local_faction():is_mission_active("xyy_roguelike_mission_boss") then
                        cm:modify_faction(cm:query_local_faction()):complete_custom_mission("xyy_roguelike_mission_boss")
                        faction_difficulty["xyyhlyjf"] = 3000
                        cm:set_saved_value("roguelike_faction_difficulty", faction_difficulty);
                        cm:set_saved_value("roguelike_safe_trigger", false);
                        cm:set_saved_value("browser_character", true)
                        --character_browser_roguelike_select();
                    elseif cm:query_local_faction():is_mission_active("xyy_roguelike_mission_boss_2") then
                        cm:modify_faction(cm:query_local_faction()):complete_custom_mission(
                        "xyy_roguelike_mission_boss_2")
                        faction_difficulty["xyyhlyjf"] = 1000
                        cm:set_saved_value("roguelike_faction_difficulty", faction_difficulty);
                        cm:set_saved_value("roguelike_safe_trigger", false);
                        cm:set_saved_value("browser_character", true)
                        --character_browser_roguelike_select();
                    elseif cm:query_local_faction():is_mission_active("xyy_roguelike_mission_boss_3") then
                        cm:modify_faction(cm:query_local_faction()):complete_custom_mission(
                        "xyy_roguelike_mission_boss_3")
                        faction_difficulty["xyyhlyjf"] = nil
                        cm:set_saved_value("roguelike_faction_difficulty", faction_difficulty);
                        if not context:query_character():has_garrison_residence() then
                            gst.character_been_killed("hlyjdingzhia")
                        end
                        cm:set_saved_value("huanlong_dead", true);
                    end
                end
            end
        end,
        true
    )

    core:add_listener(
        "roguelike_pending_battle_41",
        "PendingBattle",
        function(context)
            return cm:query_local_faction():has_effect_bundle("xyy_roguelike_41");
        end,
        function(context)
            local faction = cm:query_local_faction()
            local pb = cm:query_model():pending_battle();
            if pb:human_involved() then
                if pb:has_attacker() and pb:attacker():faction():name() == faction:name() then
                    if pb:ambush_battle() then
                        cm:modify_character(pb:defender()):apply_effect_bundle("xyy_roguelike_41_unseen", 1)
                        if not pb:secondary_defenders():is_empty() then
                            for i = 0, pb:secondary_defenders():num_items() - 1 do
                                cm:modify_character( pb:secondary_defenders():item_at(i)):apply_effect_bundle("xyy_roguelike_41_unseen", 1)
                            end
                        end
                    end
                end
            end
        end,
        true
    )

    core:add_listener(
        "character_wound_listener",
        "CharacterWoundReceivedEvent",
        function(context)
            ModLog("CharacterWoundReceivedEvent")
            return cm:get_saved_value("has_pending_battle") and cm:get_saved_value("xyy_roguelike_character_wound_listener");
        end,
        function(context)
            local faction = cm:query_local_faction()
            if cm:get_saved_value("character_kill_table") then
                kill_character_table = cm:get_saved_value("character_kill_table")
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjci_dark") then
                if context:query_character():generation_template_key() == "hlyjci_dark" 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key()) then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjci_dark")
                    if dark_character_pin["hlyjci_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjci_dark"])
                        dark_character_pin["hlyjci_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjcj_dark") 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
                if context:query_character():generation_template_key() == "hlyjcj_dark" then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjcj_dark")
                    if dark_character_pin["hlyjcj_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjcj_dark"])
                        dark_character_pin["hlyjcj_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjck_dark") 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
                if context:query_character():generation_template_key() == "hlyjck_dark" then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjck_dark")
                    if dark_character_pin["hlyjck_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjck_dark"])
                        dark_character_pin["hlyjck_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjcm_dark") 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
                if context:query_character():generation_template_key() == "hlyjcm_dark" then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjcm_dark")
                    if dark_character_pin["hlyjcm_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjcm_dark"])
                        dark_character_pin["hlyjcm_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjcn_dark") 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
                if context:query_character():generation_template_key() == "hlyjcn_dark" then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjcn_dark")
                    if dark_character_pin["hlyjcn_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjcn_dark"])
                        dark_character_pin["hlyjcn_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjcy_dark") 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
                if context:query_character():generation_template_key() == "hlyjcy_dark" then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjcy_dark")
                    if dark_character_pin["hlyjcy_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjcy_dark"])
                        dark_character_pin["hlyjcy_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjda_dark") 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
                if context:query_character():generation_template_key() == "hlyjda_dark" then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjda_dark")
                    if dark_character_pin["hlyjda_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjda_dark"])
                        dark_character_pin["hlyjda_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjdi_dark") 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
                if context:query_character():generation_template_key() == "hlyjdi_dark" then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjdi_dark")
                    if dark_character_pin["hlyjdi_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjdi_dark"])
                        dark_character_pin["hlyjdi_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjdf_dark") 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
                if context:query_character():generation_template_key() == "hlyjdf_dark" then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjdf_dark")
                    if dark_character_pin["hlyjdf_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjdf_dark"])
                        dark_character_pin["hlyjdf_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjdt_dark") 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
                if context:query_character():generation_template_key() == "hlyjdt_dark" then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjdt_dark")
                    if dark_character_pin["hlyjdt_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjdt_dark"])
                        dark_character_pin["hlyjdt_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjdy_dark") 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
                if context:query_character():generation_template_key() == "hlyjdy_dark" then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjdy_dark")
                    if dark_character_pin["hlyjdy_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjdy_dark"])
                        dark_character_pin["hlyjdy_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
            if faction:is_mission_active("xyy_roguelike_kill_hlyjeb_dark") 
                and not gst.lib_value_in_list(kill_character_table, context:query_character():generation_template_key())then
                if context:query_character():generation_template_key() == "hlyjeb_dark" then
                    cm:modify_faction(faction):complete_custom_mission("xyy_roguelike_kill_hlyjeb_dark")
                    if dark_character_pin["hlyjeb_dark"] ~= 0 then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin["hlyjeb_dark"])
                        dark_character_pin["hlyjeb_dark"] = 0
                        cm:set_saved_value("dark_character_pin",dark_character_pin)
                    end
                end
            end
        end,
        true
    )

    core:add_listener(
        "mission_completed_listener",
        "MissionSucceeded",
        function(context)
            return true;
        end,
        function(context)
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjcy_dark" then
                local dark_character = gst.character_query_for_template("hlyjcy_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                gst.faction_add_tickets(context:faction():name(), 500)
            end
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjcn_dark" then
                local dark_character = gst.character_query_for_template("hlyjcn_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                cm:modify_local_faction():ceo_management():add_ceo("hlyjcnwuqi_dark");
                gst.faction_add_tickets(context:faction():name(), 500)
            end
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjdi_dark" then
                local dark_character = gst.character_query_for_template("hlyjdi_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                gst.faction_add_tickets(context:faction():name(), 500)
            end
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjdy_dark" then
                local dark_character = gst.character_query_for_template("hlyjdy_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdywuqi_dark");
                gst.faction_add_tickets(context:faction():name(), 500)
            end
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjeb_dark" then
                local dark_character = gst.character_query_for_template("hlyjeb_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                gst.faction_add_tickets(context:faction():name(), 700)
            end
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjda_dark" then
                local dark_character = gst.character_query_for_template("hlyjda_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdawuqi_dark");
                gst.faction_add_tickets(context:faction():name(), 700)
            end
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjci_dark" then
                local dark_character = gst.character_query_for_template("hlyjci_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                gst.faction_add_tickets(context:faction():name(), 700)
            end
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjck_dark" then
                local dark_character = gst.character_query_for_template("hlyjck_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                cm:modify_local_faction():ceo_management():add_ceo("hlyjckwuqi_dark");
                gst.faction_add_tickets(context:faction():name(), 700)
            end
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjdt_dark" then
                local dark_character = gst.character_query_for_template("hlyjdt_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdtwuqi_dark");
                gst.faction_add_tickets(context:faction():name(), 700)
            end
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjcm_dark" then
                local dark_character = gst.character_query_for_template("hlyjcm_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                cm:modify_local_faction():ceo_management():add_ceo("hlyjcmwuqi_dark");
                gst.faction_add_tickets(context:faction():name(), 1000)
            end
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjcj_dark" then
                local dark_character = gst.character_query_for_template("hlyjcj_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                cm:modify_local_faction():ceo_management():add_ceo("hlyjcjwuqi_dark");
                gst.faction_add_tickets(context:faction():name(), 1000)
            end
            if context:mission():mission_record_key() == "xyy_roguelike_kill_hlyjdf_dark" then
                local dark_character = gst.character_query_for_template("hlyjdf_dark")
                cm:modify_character(dark_character):remove_effect_bundle("dark_character")
                gst.character_been_killed(dark_character:generation_template_key())
                add_kill_character(dark_character:generation_template_key())
                cm:modify_local_faction():ceo_management():add_ceo("hlyjdingzhiezuoqi");
                gst.faction_add_tickets(context:faction():name(), 1000)
            end
        end,
        true
    )

    core:add_listener(
        "roguelike_pending_battle_38",
        "BattleCompletedCameraMove",
        function(context)
            return not cm:query_model():is_player_turn()
            and cm:query_local_faction():has_effect_bundle("xyy_roguelike_38");
        end,
        function(context)
            local faction = cm:query_local_faction()
            local pb = cm:query_model():pending_battle();
            if pb:human_involved() then
                if pb:has_defender() and pb:defender():faction():name() == faction:name() then
                    if pb:defender():has_military_force() and not pb:defender():won_battle() then
                        cm:modify_faction(faction):apply_effect_bundle("xyy_roguelike_38_unseen_2", 1)
                        cm:modify_character(pb:defender()):apply_effect_bundle("xyy_roguelike_38_unseen", 1)
                        cm:modify_military_force(pb:defender():military_force()):apply_effect_bundle("xyy_roguelike_38_unseen_3", 1)
                        for i = 0, pb:defender():military_force():character_list():num_items() - 1 do
                            local character = pb:defender():military_force():character_list():item_at(i)
                            cm:modify_character(character):apply_effect_bundle("xyy_roguelike_38_unseen_1", 1)
                            ModLog("背水一战保护角色：".. gst.character_get_string_name(character))
                        end
                        if not pb:secondary_defenders():is_empty() then
                            for i = 0, pb:secondary_defenders():num_items() - 1 do
                                local defender = pb:secondary_defenders():item_at(i)
                                cm:modify_character(defender):apply_effect_bundle("xyy_roguelike_38_unseen", 1)
                                cm:modify_military_force(defender:military_force()):apply_effect_bundle("xyy_roguelike_38_unseen_3", 1)
                                for i = 0, defender:military_force():character_list():num_items() - 1 do
                                    local character = defender:military_force():character_list():item_at(i)
                                    cm:modify_character(character):apply_effect_bundle("xyy_roguelike_38_unseen_1", 1)
                                    ModLog("背水一战保护角色：".. gst.character_get_string_name(character))
                                end
                            end
                        end
                    end
                end
            end
        end,
        true
    )

    core:add_listener(
        "character_browser_roguelike_select",
        "BattleCompletedCameraMove",
        function(context)
            return cm:get_saved_value("browser_character");
        end,
        function(context)
            character_browser_roguelike_select();
            cm:set_saved_value("browser_character", nil)
        end,
        true
    )
    
    core:add_listener(
        "roguelike_pending_battle",
        "BattleCompletedCameraMove",
        function(context)
            --local firefly = gst.character_query_for_template("hlyjdj")
            ----ModLog("PendingBattle".. context:query_character():generation_template_key())
            return cm:query_local_faction():has_effect_bundle("xyy_roguelike_2")
                or cm:query_local_faction():has_effect_bundle("xyy_roguelike_3")
                or cm:query_local_faction():has_effect_bundle("xyy_roguelike_19")
                or cm:query_local_faction():has_effect_bundle("xyy_roguelike_39");
        end,
        function(context)
            local faction = cm:query_local_faction()
            local pb = cm:query_model():pending_battle();
            --ModLog("debug pending_battle")
            if pb:human_involved() and pb:has_been_fought() then
                --ModLog("debug human_involved")
                if pb:has_attacker() and pb:attacker():faction():name() == faction:name() then
                    --ModLog("debug attacker_is_human")
                    if pb:attacker_battle_result() == "heroic_victory"
                        or pb:attacker_battle_result() == "decisive_victory"
                    then
                        if faction:has_effect_bundle("xyy_roguelike_3") then
                            --ModLog("触发 xyy_roguelike_3_unseen")
                            cm:modify_faction(faction):apply_effect_bundle("xyy_roguelike_3_unseen", 5)
                        end
                    elseif pb:attacker_battle_result() == "decisive_defeat"
                        or pb:attacker_battle_result() == "crushing_defeat"
                    then
                        if faction:has_effect_bundle("xyy_roguelike_2") then
                            --ModLog("触发 xyy_roguelike_2_unseen")
                            cm:modify_faction(faction):apply_effect_bundle("xyy_roguelike_2_unseen", 5)
                        end
                    end

                    if faction:has_effect_bundle("xyy_roguelike_19") then
                        if pb:attacker_battle_result() == "decisive_defeat"
                            or pb:attacker_battle_result() == "crushing_defeat"
                            or pb:attacker_battle_result() == "valiant_defeat"
                            or pb:attacker_battle_result() == "close_defeat"
                        then
                            cm:set_saved_value("xyy_roguelike_19_unseen", pb:attacker():cqi())
                        end
                    end

                    if faction:has_effect_bundle("xyy_roguelike_39") then
                        if pb:attacker_battle_result() == "close_victory"
                            or pb:attacker_battle_result() == "decisive_victory"
                            or pb:attacker_battle_result() == "heroic_victory"
                            or pb:attacker_battle_result() == "pyrrhic_victory"
                        then
                            cm:modify_character(pb:attacker()):enable_movement()
                            cm:modify_character(pb:attacker()):replenish_action_points()
                        end
                    end
                end

                if pb:has_defender() and pb:defender():faction():name() == faction:name() then
                    if pb:defender_battle_result() == "heroic_victory"
                        or pb:defender_battle_result() == "decisive_victory"
                    then
                        if faction:has_effect_bundle("xyy_roguelike_3") then
                            --ModLog("触发 xyy_roguelike_3_unseen")
                            cm:modify_faction(faction):apply_effect_bundle("xyy_roguelike_3_unseen", 5)
                        end
                    elseif pb:defender_battle_result() == "decisive_defeat"
                        or pb:defender_battle_result() == "crushing_defeat"
                    then
                        if faction:has_effect_bundle("xyy_roguelike_2") then
                            --ModLog("触发 xyy_roguelike_2_unseen")
                            cm:modify_faction(faction):apply_effect_bundle("xyy_roguelike_2_unseen", 5)
                        end
                    end
                end
            end
        end,
        true
    )

    core:add_listener(
        "roguelike_character_release_event",
        "CharacterPostBattleRelease",
        function(context)
            return true;
        end,
        function(context)

        end,
        true
    )

    core:add_listener(
        "roguelike_character_captive_event",
        "CharacterCaptiveOptionApplied",
        function(context)
            return true;
        end,
        function(context)
            ModLog("被俘角色: " .. gst.character_get_string_name(context:query_character()))
            ModLog("所在军队: " .. context:capturing_force():command_queue_index())
            ModLog("处置选项: " .. context:captive_option_key())
            ModLog("处置结果: " .. context:captive_option_outcome())
            if context:query_character():generation_template_key() == "3k_dlc04_template_historical_emperor_xian_earth"
            and context:captive_option_key() == "3k_main_captive_option_execute"
            then
                for k, v in pairs(faction_difficulty) do
                    if k ~= "xyyhlyjf"
                    and cm:query_faction(k)
                    and not cm:query_faction(k):is_dead()
                    then
                        ModLog(k)
                        cm:modify_faction(k):apply_effect_bundle("emperor_dead", -1)
                    end
                end
            end
        end,
        true
    )

    core:add_listener(
        "roguelike_huanlong_dead_event",
        "FactionTurnStart",
        function(context)
            local hlyjdingzhia = gst.character_query_for_template("hlyjdingzhia");
            local xyyhlyjf = context:faction();
            if not hlyjdingzhia:is_dead() and cm:get_saved_value("huanlong_dead") then
                cm:modify_character(hlyjdingzhia):kill_character(false);
            end
            if hlyjdingzhia:is_dead() and not cm:get_saved_value("huanlong_dead") then
                cm:set_saved_value("huanlong_dead", true)
            end
            return context:faction():name() == "xyyhlyjf"
                and cm:get_saved_value("huanlong_dead");
        end,
        function(context)
            remove_enemy_effect(context:faction():name())
            local faction = cm:query_local_faction()
            if not is_miyabi_unlock() then
                if not cm:get_saved_value("xyy_cheat_mode") and cm:query_model():difficulty_level() == 4 then
                    miyabi_unlock()
                    local character = gst.character_add_to_faction("hlyjdv", faction:name(), gst.all_character_detils["hlyjdv"]['subtype']);
                    cm:modify_character(character):add_experience(88000,0);
                    cm:modify_character(character):reset_skills();
                    local incident = cm:modify_model():create_incident("unlock_hlyjdv");
                    incident:add_character_target("target_character_1", character);
                    incident:add_faction_target("target_faction_1", faction);
                    incident:trigger(cm:modify_local_faction(), true);
                end
            end
            for i = 0, cm:query_model():world():region_manager():region_list():num_items() - 1 do
                local filter_region = cm:query_model():world():region_manager():region_list():item_at(i)
                if filter_region:owning_faction()
                and not filter_region:owning_faction():is_null_interface()
                and filter_region:owning_faction():is_human()
                then
                else
                    cm:modify_model():get_modify_world():remove_world_leader_region_status(filter_region:name());
                end
            end
            local xyyhlyjf = context:faction();
            -- -- --ModLog("huanlong_dead")
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

            for i = 0, region_list:num_items() - 1 do
                local region = region_list:item_at(i);
                -- -- --ModLog(region:name());
                cm:modify_region(region):raze_and_abandon_settlement_without_attacking();
            end
            for i = 0, character_list:num_items() - 1 do
                local query_character = character_list:item_at(i);
                if not query_character:is_null_interface()
                    and not query_character:is_dead()
                then
                    local key = query_character:generation_template_key()
                    --ModLog(key)
                    if key == "hlyjdingzhia"
                    or key == "hlyjdingzhid"
                    or key == "hlyjdingzhie"
                    or string.find(key, "xyyhlyjf")
                    or string.find(key, "dark")
                    and not query_character:is_dead()
                    then
                        cm:modify_character(query_character):kill_character(true);
                    end
                end
            end
            diplomacy_manager:force_confederation(rebels, "xyyhlyjf");
            cm:modify_faction("3k_dlc04_faction_rebels"):apply_effect_bundle("rebels", -1)
            
            progression:force_campaign_victory(cm:query_local_faction():name())
        end,
        true
    )

    core:add_listener(
        "roguelike_huanlong_dead_event",
        "FactionTurnStart",
        function(context)
            return cm:get_saved_value("huanlong_dead");
        end,
        function(context)
            if not is_miyabi_unlock() then
                if not cm:get_saved_value("xyy_cheat_mode") and cm:query_model():difficulty_level() == 4 then
                    miyabi_unlock()
                    local character = gst.character_add_to_faction("hlyjdv", faction:name(), gst.all_character_detils["hlyjdv"]['subtype']);
                    cm:modify_character(character):add_experience(88000,0);
                    cm:modify_character(character):reset_skills();
                    local incident = cm:modify_model():create_incident("unlock_hlyjdv");
                    incident:add_character_target("target_character_1", character);
                    incident:add_faction_target("target_faction_1", faction);
                    incident:trigger(cm:modify_local_faction(), true);
                end
                if cm:get_saved_value("xyy_cheat_mode") then
                    ModLog("无法解锁角色，检测到存档包含作弊记录")
                end
            end
        end,
        false
    )
    
    core:add_listener(
        "roguelike_faction_effect_bundle_removed_event",
        "FactionEffectBundleRemoved",
        function(context)
            return string.find(context:effect_bundle_key(), "xyy_roguelike");
        end,
        function(context)
            if context:effect_bundle_key() == "xyy_roguelike_8" then
                gst.lib_table_insert(effect_bundles_table, "xyy_roguelike_8")
                gst.lib_remove_value_from_list(unlocked_table, "xyy_roguelike_8")
                cm:set_saved_value("roguelike_effect_bundles_table", effect_bundles_table)
                cm:set_saved_value("roguelike_unlocked_table", unlocked_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_23" then
                gst.lib_table_insert(effect_bundles_table, "xyy_roguelike_23")
                gst.lib_remove_value_from_list(unlocked_table, "xyy_roguelike_23")
                cm:set_saved_value("roguelike_effect_bundles_table", effect_bundles_table)
                cm:set_saved_value("roguelike_unlocked_table", unlocked_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_51" then
                gst.lib_table_insert(effect_bundles_table, "xyy_roguelike_51")
                gst.lib_remove_value_from_list(unlocked_table, "xyy_roguelike_51")
                cm:set_saved_value("roguelike_effect_bundles_table", effect_bundles_table)
                cm:set_saved_value("roguelike_unlocked_table", unlocked_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_25" then
                gst.lib_table_insert(effect_bundles_table, "xyy_roguelike_25")
                gst.lib_remove_value_from_list(unlocked_table, "xyy_roguelike_25")
                cm:set_saved_value("roguelike_effect_bundles_table", effect_bundles_table)
                cm:set_saved_value("roguelike_unlocked_table", unlocked_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_50" then
                gst.lib_table_insert(effect_bundles_table, "xyy_roguelike_50")
                gst.lib_remove_value_from_list(unlocked_table, "xyy_roguelike_50")
                cm:set_saved_value("roguelike_effect_bundles_table", effect_bundles_table)
                cm:set_saved_value("roguelike_unlocked_table", unlocked_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_craft_accessories" then
                local building_list = gst.building_list["xyy_roguelike_craft_accessories"]
                if is_faction_have_building(context:faction(), building_list) then
                    if random < 500 then
                        create_item(context:faction(), "random_item3_accessory")
                    else
                        create_item(context:faction(), "random_item3_follower")
                    end
                end
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_accessories")
                cm:set_saved_value("roguelike_store_table", store_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_craft_weapons" then
                local building_list = gst.building_list["xyy_roguelike_craft_weapons"]
                if is_faction_have_building(context:faction(), building_list) then
                    create_item(context:faction(), "random_item3_weapon")
                end
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_weapons")
                cm:set_saved_value("roguelike_store_table", store_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_craft_mounts" then
                local building_list = gst.building_list["xyy_roguelike_craft_mounts"]
                if is_faction_have_building(context:faction(), building_list) then
                    create_item(context:faction(), "random_item3_mount")
                end
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_mounts")
                cm:set_saved_value("roguelike_store_table", store_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_craft_armors" then
                local building_list = gst.building_list["xyy_roguelike_craft_armors"]
                if is_faction_have_building(context:faction(), building_list) then
                    create_item(context:faction(), "random_item3_armour")
                end
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_armors")
                cm:set_saved_value("roguelike_store_table", store_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_craft_accessories_1" then
                local building_list = gst.building_list["xyy_roguelike_craft_accessories_1"]
                if is_faction_have_building(context:faction(), building_list) then
                    local random = math.floor(gst.lib_getRandomValue(0, 1000))
                    local random2 = math.floor(gst.lib_getRandomValue(0, 1000))
                    if random < 500 then
                        if random2 <= 600 then
                            create_item(context:faction(), "random_item1_accessory")
                        elseif random2 > 850 and random <= 160 then
                            create_item(context:faction(), "random_item2_accessory")
                        elseif random2 > 950 then
                            create_item(context:faction(), "random_item3_accessory")
                        end
                    else
                        if random2 <= 600 then
                            create_item(context:faction(), "random_item1_follower")
                        elseif random2 > 850 and random <= 160 then
                            create_item(context:faction(), "random_item2_follower")
                        elseif random2 > 950 then
                            create_item(context:faction(), "random_item3_follower")
                        end
                    end
                end
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_accessories_1")
                cm:set_saved_value("roguelike_store_table", store_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_craft_weapons_1" then
                local building_list = gst.building_list["xyy_roguelike_craft_weapons_1"]
                if is_faction_have_building(context:faction(), building_list) then
                    local random = math.floor(gst.lib_getRandomValue(0, 1000))
                    if random <= 600 then
                        create_item(context:faction(), "random_item1_weapon")
                    elseif random > 850 and random <= 160 then
                        create_item(context:faction(), "random_item2_weapon")
                    elseif random > 950 then
                        create_item(context:faction(), "random_item3_weapon")
                    end
                end
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_weapons_1")
                cm:set_saved_value("roguelike_store_table", store_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_craft_mounts_1" then
                local building_list = gst.building_list["xyy_roguelike_craft_mounts_1"]
                if is_faction_have_building(context:faction(), building_list) then
                    local random = math.floor(gst.lib_getRandomValue(0, 1000))
                    if random <= 600 then
                        create_item(context:faction(), "random_item1_mount")
                    elseif random > 850 and random <= 160 then
                        create_item(context:faction(), "random_item2_mount")
                    elseif random > 950 then
                        create_item(context:faction(), "random_item3_mount")
                    end
                end
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_mounts_1")
                cm:set_saved_value("roguelike_store_table", store_table)
            end
            if context:effect_bundle_key() == "xyy_roguelike_craft_armors_1" then
                local building_list = gst.building_list["xyy_roguelike_craft_armors_1"]
                if is_faction_have_building(context:faction(), building_list) then
                    local random = math.floor(gst.lib_getRandomValue(0, 1000))
                    if random <= 600 then
                        create_item(context:faction(), "random_item1_armour")
                    elseif random > 850 and random <= 160 then
                        create_item(context:faction(), "random_item2_armour")
                    elseif random > 950 then
                        create_item(context:faction(), "random_item3_armour")
                    end
                end
                gst.lib_table_insert(store_table, "xyy_roguelike_craft_armors_1")
                cm:set_saved_value("roguelike_store_table", store_table)
            end
        end,
        true
    )

    core:add_listener(
        "roguelike_character_besieges_settlement_event",
        "CharacterBesiegesSettlement",
        function(context)
            return context:query_region():owning_faction():is_human();
        end,
        function(context)
            if context:query_region():owning_faction():has_effect_bundle("xyy_roguelike_33") then
                cm:modify_region(context:query_region()):apply_effect_bundle("xyy_roguelike_33_unseen", 1)
            end
            ModLog(context:query_region():name() .. "被围攻")
            local besiege_regions = {}
            if cm:get_saved_value("roguelike_besiege_regions") then
                besiege_regions = cm:get_saved_value("roguelike_besiege_regions")
            end
            besiege_regions[context:query_region():name()] = context:query_character():command_queue_index()
            cm:set_saved_value("roguelike_besiege_regions", besiege_regions)
        end,
        true
    )

    core:add_listener(
        "roguelike_dilemma_hide_gui",
        "DilemmaIssuedEvent",
        function(context)
            return context:faction():is_human();
        end,
        function(context)
            cm:set_saved_value("issued_dilemma", true)
            if roguelike_panel then
                roguelike_panel:SetVisible(false)
            end
            if roguelike_store_panel then
                roguelike_store_panel:SetVisible(false)
            end
        end,
        true
    )

    core:add_listener(
        "roguelike_dilemma_show_gui",
        "DilemmaChoiceMadeEvent",
        function(context)
            cm:set_saved_value("issued_dilemma", false)
            return true;
        end,
        function(context)
            if roguelike_panel then
                roguelike_panel:SetVisible(true)
            end
            if roguelike_store_panel then
                roguelike_store_panel:SetVisible(false)
            end
--             if cm:get_saved_value("have_panel") and cm:get_saved_value("have_panel") == 1 then
--                 openRoguelikePanel()
--                 cm:set_saved_value("have_panel", nil)
--             end
--             if cm:get_saved_value("have_panel") and cm:get_saved_value("have_panel") == 2 then
--                 character_browser_roguelike_select()
--                 cm:set_saved_value("have_panel", nil)
--             end
        end,
        true
    )
    
    core:add_listener(
    "dark_character_force_created",
    "MilitaryForceCreated",
    function(context)
        return false;
    end,
    function(context)
--         local character = context:military_force_created():general_character();
--         local character_key = character:generation_template_key()
        local military_force_created = context:military_force_created();
        if military_force_created then
            for i = 0, military_force_created:character_list():num_items() -1 do
                local character = military_force_created:character_list():item_at(i)
                if not character:is_null_interface()
                and character:character_type("general")
                and not character:is_dead()
                and string.find(character:generation_template_key(), "_dark") then
                    if dark_character_pin[character:generation_template_key()] then
                        cm:modify_local_faction():get_map_pins_handler():remove_pin(dark_character_pin[character:generation_template_key()])
                    end
                    local pin = cm:modify_local_faction():get_map_pins_handler():add_character_pin(cm:modify_character(character), character:generation_template_key(), true);
                    dark_character_pin[character:generation_template_key()] = pin
                    cm:set_saved_value("dark_character_pin", dark_character_pin);
                    return;
                end
            end
        end
    end,
    true
)
end

function openEnemyBuffPanel(refresh, effect_keys)
    if not refresh then
        if roguelike_panel then
            --ModLog("roguelike_panel存在，添加至队列")
            if not cm:get_saved_value("roguelike_panel_list") then
                cm:set_saved_value("roguelike_panel_list", 1)
            else
                cm:set_saved_value("roguelike_panel_list", cm:get_saved_value("roguelike_panel_list") + 1)
            end
            return;
        end
        effect_keys = gst.lib_shuffle_table(effect_keys);
        -- cm:modify_model():get_modify_episodic_scripting():disable_end_turn(true);
        -- cm:modify_scripting():disable_shortcut("button_end_turn", "end_turn", true);
        -- cm:modify_scripting():override_ui("disable_end_turn", true);
    else
        for i = 1, 2 do
            gst.lib_move_value_to_bottom(effect_keys, effect_keys[1]);
        end
    end

    local max = 2

    UI_MOD_NAME = "xyy_roguelike_mode_" .. static_index
    --ModLog(UI_MOD_NAME);
    local ui_root = core:get_ui_root();
    local ui_panel_name = UI_MOD_NAME .. "_panel";
    roguelike_panel = core:get_or_create_component(ui_panel_name, "ui/templates/xyy_roguelike");  --选择模板文件
    ui_root:Adopt(roguelike_panel:Address());
    roguelike_panel:PropagatePriority(ui_root:Priority());
    local x, y, w, h = gst.UI_Component_coordinates(ui_root);
    --设置panel的大小
    gst.UI_Component_resize(roguelike_panel, panel_size_x, panel_size_y, true);

    --移动panel的相对位置
    gst.UI_Component_move_relative(roguelike_panel, ui_root, (w - panel_size_x) / 2, 100, false);

    find_uicomponent(roguelike_panel, "faction_council_header"):SetStateText(effect.get_localised_string("mod_xyy_character_roguelike_select_enemy_effect"))
    
    slot_1_button = add_enemy_effect_button(roguelike_panel, effect_keys[1]);
    gst.UI_Component_move_relative(slot_1_button, roguelike_panel, offset[max][1]["x"], offset[max][1]["y"], false);

    slot_2_button = add_enemy_effect_button(roguelike_panel, effect_keys[2]);
    gst.UI_Component_move_relative(slot_2_button, roguelike_panel, offset[max][2]["x"], offset[max][2]["y"], false);
    
    confirm_button = add_enemy_effect_confirm_button(roguelike_panel, 500, 50)
    gst.UI_Component_move_relative(confirm_button, roguelike_panel, 880, 670, false)

    confirm_button:SetState("down")
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
    "mod_xyy_character_browser_confirm"))

    confirm_button:SetState("inactive")
    find_uicomponent(confirm_button, "button_txt"):SetStateText(effect.get_localised_string(
    "mod_xyy_character_browser_confirm"))
    if cm:get_saved_value("issued_dilemma") then
        roguelike_panel:SetVisible(false);
    else
        roguelike_panel:SetVisible(true);
    end
    disable_menu_button()
    CampaignUI.CreateModelCallbackRequest("xyy_callback_steal_escape_key_true");
end

function apply_enemy_effect()
    if not enemy_effect_key then
        enemy_effect_keys = gst.lib_shuffle_table(enemy_effect_keys);
        local effect_key_1 = enemy_effect_keys[1];
        local effect_key_2 = enemy_effect_keys[2];
        openEnemyBuffPanel(refresh, {effect_key_1, effect_key_2})
    else
        enemy_effect_level = enemy_effect_level + 1;
        if enemy_effect_level > 6 then
            enemy_effect_level = 6
            return;
        end
        cm:set_saved_value("roguelike_enemy_effect_level", enemy_effect_level);
        local enemy_effect_bundle_key = enemy_effect_key .. "_" .. enemy_effect_level;


        for faction_key, v in pairs(faction_difficulty) do
            for k, v in ipairs(enemy_effect_keys) do
                for i = 1, 6 do
                    if cm:query_faction(faction_key):has_effect_bundle(v .. "_" .. i) then
                        cm:modify_faction(faction_key):remove_effect_bundle(v .. "_" .. i);
                    end
                end
            end
            cm:modify_faction(faction_key):apply_effect_bundle(enemy_effect_bundle_key, -1);
        end

        cm:trigger_incident(cm:query_local_faction():name(), enemy_effect_bundle_key, true)
    end
end

function get_currect_world_leader_region(faction_key)
    --local player_region_keys = {}
    local world_leader_region_keys = {}
--     --先移除玩家的皇位
--     local a = cm:query_local_faction():number_of_world_leader_regions()
--     for i = 0, cm:query_local_faction():region_list():num_items() - 1 do
--         local region = cm:query_local_faction():region_list():item_at(i)
--         cm:modify_model():get_modify_world():remove_world_leader_region_status(region:name());
--         if cm:query_local_faction():number_of_world_leader_regions() < a then
--             table.insert(player_region_keys, a)
--             a = cm:query_local_faction():number_of_world_leader_regions()
--         end
--     end
    local b = cm:query_faction(faction_key):number_of_world_leader_regions()
    for i = 0, cm:query_faction(faction_key):region_list():num_items() - 1 do
        local region = cm:query_faction(faction_key):region_list():item_at(i)
        cm:modify_model():get_modify_world():remove_world_leader_region_status(region:name());
        if cm:query_faction(faction_key):number_of_world_leader_regions() < b then
            table.insert(world_leader_region_keys, b)
            b = cm:query_faction(faction_key):number_of_world_leader_regions()
        end
    end
    for i, v in ipairs(world_leader_region_keys) do
        cm:modify_model():get_modify_world():add_world_leader_region_status(v);
    end
    return world_leader_region_keys
end

function remove_enemy_effect(faction_key)
    for k, v in ipairs(enemy_effect_keys) do
        for i = 1, 6 do
            if cm:query_faction(faction_key):has_effect_bundle(v .. "_" .. i) then
                cm:modify_faction(faction_key):remove_effect_bundle(v .. "_" .. i);
            end
        end
    end
end

function change_enemy_effect(enemy_effect_key)
    cm:set_saved_value("roguelike_enemy_effect_key", enemy_effect_key);
    cm:set_saved_value("roguelike_enemy_effect_level", enemy_effect_level);
    refresh_year()
    local enemy_effect_bundle_key = enemy_effect_key .. "_" .. enemy_effect_level;
    cm:trigger_incident(cm:query_local_faction():name(), enemy_effect_bundle_key, true);
    for faction_key, v in pairs(faction_difficulty) do
        remove_enemy_effect(faction_key)
        cm:modify_faction(faction_key):apply_effect_bundle(enemy_effect_bundle_key, -1);
    end
end

function reapply_enemy_effect()
    if not enemy_effect_key then
        enemy_effect_keys = gst.lib_shuffle_table(enemy_effect_keys);
        effect_key_1 = enemy_effect_keys[1];
        effect_key_2 = enemy_effect_keys[2];
        openEnemyBuffPanel(refresh, {effect_key_1, effect_key_2})
    else
        local old_enemy_effect_key = enemy_effect_key;
        enemy_effect_keys = gst.lib_shuffle_table(enemy_effect_keys);
        effect_key_1 = enemy_effect_keys[math.floor(gst.lib_getRandomValue(1, #enemy_effect_keys))];
        while effect_key_1 == old_enemy_effect_key do
            effect_key_1 = enemy_effect_keys[math.floor(gst.lib_getRandomValue(1, #enemy_effect_keys))];
        end
        effect_key_2 = enemy_effect_keys[math.floor(gst.lib_getRandomValue(1, #enemy_effect_keys))];
        while effect_key_2 == old_enemy_effect_key or effect_key_1 == effect_key_2 do
            effect_key_2 = enemy_effect_keys[math.floor(gst.lib_getRandomValue(1, #enemy_effect_keys))];
        end
        openEnemyBuffPanel(refresh, {effect_key_1, effect_key_2})
    end
end

function get_max_character_browser()
    return max_character_browser;
end

function get_max_character_selections()
    return max_character;
end

function enable_ytr_diplomacy(faction_key)
    cm:modify_model():enable_diplomacy("faction:" .. faction_key, "subculture:3k_main_chinese",
        "treaty_components_peace,treaty_components_alliance_to_alliance_group_peace,treaty_components_alliance_to_faction_group_peace,treaty_components_faction_to_alliance_group_peace,treaty_components_threaten,treaty_components_faction_to_alliance_war,treaty_components_alliance_to_alliance_war,treaty_components_alliance_to_faction_war,treaty_components_coercion,treaty_components_call_vassals_to_arms,treaty_components_group_war,treaty_components_proposer_declares_war_against_target,treaty_components_recipient_declares_war_against_target,treaty_components_region_demand,treaty_components_region_offer,treaty_components_payment_demand,treaty_components_payment_offer,treaty_components_payment_regular_demand,treaty_components_payment_regular_offer,treaty_components_ancillary_demand,treaty_components_ancillary_offer",
        "yellow_turban_rank_requirement_proposer")
    cm:modify_model():enable_diplomacy("subculture:3k_main_chinese", "faction:" .. faction_key,
        "treaty_components_peace,treaty_components_alliance_to_alliance_group_peace,treaty_components_alliance_to_faction_group_peace,treaty_components_faction_to_alliance_group_peace,treaty_components_threaten,treaty_components_faction_to_alliance_war,treaty_components_alliance_to_alliance_war,treaty_components_alliance_to_faction_war,treaty_components_coercion,treaty_components_call_vassals_to_arms,treaty_components_group_war,treaty_components_proposer_declares_war_against_target,treaty_components_recipient_declares_war_against_target,treaty_components_region_demand,treaty_components_region_offer,treaty_components_payment_demand,treaty_components_payment_offer,treaty_components_payment_regular_demand,treaty_components_payment_regular_offer,treaty_components_ancillary_demand,treaty_components_ancillary_offer",
        "yellow_turban_rank_requirement_recipient")
    cm:modify_model():enable_diplomacy("faction:" .. faction_key, "subculture:3k_dlc05_subculture_bandits",
        "treaty_components_peace,treaty_components_alliance_to_alliance_group_peace,treaty_components_alliance_to_faction_group_peace,treaty_components_faction_to_alliance_group_peace,treaty_components_threaten,treaty_components_faction_to_alliance_war,treaty_components_alliance_to_alliance_war,treaty_components_alliance_to_faction_war,treaty_components_coercion,treaty_components_call_vassals_to_arms,treaty_components_group_war,treaty_components_proposer_declares_war_against_target,treaty_components_recipient_declares_war_against_target,treaty_components_region_demand,treaty_components_region_offer,treaty_components_payment_demand,treaty_components_payment_offer,treaty_components_payment_regular_demand,treaty_components_payment_regular_offer,treaty_components_ancillary_demand,treaty_components_ancillary_offer",
        "yellow_turban_rank_requirement_proposer")
    cm:modify_model():enable_diplomacy("subculture:3k_dlc05_subculture_bandits", "faction:" .. faction_key,
        "treaty_components_peace,treaty_components_alliance_to_alliance_group_peace,treaty_components_alliance_to_faction_group_peace,treaty_components_faction_to_alliance_group_peace,treaty_components_threaten,treaty_components_faction_to_alliance_war,treaty_components_alliance_to_alliance_war,treaty_components_alliance_to_faction_war,treaty_components_coercion,treaty_components_call_vassals_to_arms,treaty_components_group_war,treaty_components_proposer_declares_war_against_target,treaty_components_recipient_declares_war_against_target,treaty_components_region_demand,treaty_components_region_offer,treaty_components_payment_demand,treaty_components_payment_offer,treaty_components_payment_regular_demand,treaty_components_payment_regular_offer,treaty_components_ancillary_demand,treaty_components_ancillary_offer",
        "yellow_turban_rank_requirement_recipient")
    cm:modify_model():enable_diplomacy("faction:" .. faction_key, "subculture:3k_dlc06_subculture_nanman",
        "treaty_components_peace,treaty_components_alliance_to_alliance_group_peace,treaty_components_alliance_to_faction_group_peace,treaty_components_faction_to_alliance_group_peace,treaty_components_threaten,treaty_components_faction_to_alliance_war,treaty_components_alliance_to_alliance_war,treaty_components_alliance_to_faction_war,treaty_components_coercion,treaty_components_call_vassals_to_arms,treaty_components_group_war,treaty_components_proposer_declares_war_against_target,treaty_components_recipient_declares_war_against_target,treaty_components_region_demand,treaty_components_region_offer,treaty_components_payment_demand,treaty_components_payment_offer,treaty_components_payment_regular_demand,treaty_components_payment_regular_offer,treaty_components_ancillary_demand,treaty_components_ancillary_offer",
        "yellow_turban_rank_requirement_proposer")
    cm:modify_model():enable_diplomacy("subculture:3k_dlc06_subculture_nanman", "faction:" .. faction_key,
        "treaty_components_peace,treaty_components_alliance_to_alliance_group_peace,treaty_components_alliance_to_faction_group_peace,treaty_components_faction_to_alliance_group_peace,treaty_components_threaten,treaty_components_faction_to_alliance_war,treaty_components_alliance_to_alliance_war,treaty_components_alliance_to_faction_war,treaty_components_coercion,treaty_components_call_vassals_to_arms,treaty_components_group_war,treaty_components_proposer_declares_war_against_target,treaty_components_recipient_declares_war_against_target,treaty_components_region_demand,treaty_components_region_offer,treaty_components_payment_demand,treaty_components_payment_offer,treaty_components_payment_regular_demand,treaty_components_payment_regular_offer,treaty_components_ancillary_demand,treaty_components_ancillary_offer",
        "yellow_turban_rank_requirement_recipient")
end
