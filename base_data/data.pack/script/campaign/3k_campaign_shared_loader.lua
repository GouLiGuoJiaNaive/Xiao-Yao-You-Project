---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			3k_campaign_shared_loader.lua, 
----- Description: 	Manages lua files shared between multiple startpos.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

package.path = package.path .. ";" .. cm:get_campaign_folder() .. "/_shared/?.lua"
package.path = package.path .. ";" .. cm:get_campaign_folder() .. "/_shared/validation/?.lua"

output("************ SHARED LOADER: START ************");
inc_tab();

-- MAIN --
force_require("3k_campaign_achievements"); -- Achievement script to award achievements.
force_require("3k_campaign_ancillaries"); -- Handles general spawning of ancillaries for characters and factions.
force_require("3k_campaign_ancillaries_ambient_spawning"); -- spawns ancillaries for factions baseed on the building they own.
force_require("3k_campaign_ancillaries_master_craftsmen"); -- Spawns ancillaries for factions based on master craftsmen region ownership.
force_require("3k_campaign_cdir_events_manager"); -- [semi-deprocated] Created in tentpole to handle events firing in the world. Allows 'mirror' events in MP and triggering script based on event completion.
force_require("3k_campaign_cdir_global_events"); -- Stub script for the global events system allowing events to be fired based on global triggers.
force_require("3k_campaign_cdir_mission_manager"); -- Handles SP only missions for factions.
force_require("3k_campaign_character_relationships"); -- Character relationship scripts.
force_require("3k_campaign_commentary_events"); -- Fires events for specified factions when specific in-game events occurr.
force_require("3k_campaign_diplomacy_manager"); -- Manager for handling ALL diplomacy related scripting requirements.
force_require("3k_campaign_emergent_factions"); -- Script which controls re-emergence of factions.
force_require("3k_campaign_emperor_manager"); -- Port/Update of the EP Emperor Manager script for regent/emperor decisions
force_require("3k_campaign_experience"); -- Handles updating character experience.
force_require("3k_campaign_faction_council"); -- Managed the faction council, selecting missions.
force_require("3k_campaign_historical_events"); -- Handles the Liu Bei annexing Liu Biao stuff.
force_require("3k_campaign_interventions"); -- Handles advisor on campaign.
force_require("3k_campaign_invasions"); -- Script which wraps the lib_invasion manager. Allows spawnignof invasions and armies.
force_require("3k_campaign_misc"); -- Miscellaneous small scripts which will run across multiple campaigns.
force_require("3k_campaign_progression"); -- Handles global events and playing movies when they fire.
force_require("3k_campaign_progression_groups"); -- Script system which allows progression levels to be given tags which can be looked up. Allows us to sync features between factions with unequal progresison levels.
force_require("3k_campaign_setup"); -- Shared generic stuff about creating campaigns and loading scripts.
force_require("3k_campaign_traits"); -- Handles character trait gaining.
force_require("3k_historical_missions"); -- [deprocated - use 3k_campaign_cdir_mission_manager] Triggers missions for the faction
force_require("3k_progression_missions"); -- [deprocated - use 3k_campaign_cdir_mission_manager] Triggers missions for the faction
force_require("3k_tutorial_missions"); -- [deprocated - use 3k_campaign_cdir_mission_manager] Triggers missions for the faction

-- YTR --
force_require("3k_ytr_campaign_ancillaries"); -- Yellow Turban ancillary manager. Manages YT armour upgrades.
force_require("3k_ytr_campaign_traits"); -- Yellow turban Traits, handles the learning traits.
force_require("3k_ytr_emperor_ascension"); -- Looks after the YT becoming emperor
force_require("3k_ytr_yellow_turban_assignments"); -- Handles Yt character spawning from YT only assignments.

-- DLC04 --
force_require("dlc04_faction_ceos_liu_chong"); -- Handles Liu Chong's faction CEOs

-- DLC05 --
force_require("3k_dlc05_campaign_diplomacy_faction_specific_treaties"); --Script for the specific faction treaties
force_require("3k_dlc05_campaign_mercenary_treaties"); --Script for the mercenary treaties
force_require("3k_dlc05_faction_ceos_titles"); -- Character Titles system 
force_require("3k_dlc05_faction_ceos_sun_ce"); -- Sun ce ambitions

-- DLC06 -- 
force_require("dlc06_faction_ceos_nanman_fealty"); -- Handles the nanman Uniting the Tribes/Fealty mechanics.
force_require("dlc06_faction_shi_xie_resource_manager"); -- Manager for Shi Xie's pooled resource.
force_require("dlc06_faction_nanman_lady_zhurong_feature"); -- Manager for Lady Zhurong's faction features.
force_require("dlc06_faction_nanman_king_mulu_features"); -- Manager for King Mulu's faction features.
force_require("dlc06_faction_nanman_king_shamoke_features"); -- Manager for Shamoke's faction Features
force_require("dlc06_faction_nanman_king_meng_huo_features"); -- Manager for King Meng Huos's faction features.
force_require("dlc06_nanman_shared_progression_events"); -- Shared missions and victory conditions for all nanman factions.
force_require("dlc06_nanman_skills"); -- Handles the skill gain and pinning of Nanman skills.
force_require("dlc06_nanman_tech"); -- Managed triggering missions based on technology and unlocking further techs.
force_require("dlc06_nanman_jungles_manager"); -- Manages bonus effects for Nanman factions in jungles.
force_require("dlc07_faction_cao_cao_schemes"); -- Manages the schemes mechanic for Cao Cao's faction.
force_require("dlc07_faction_yuan_shao_captain_armoury"); -- Manages the captain armoury mechanic for Yuan Shao's faction.
force_require("dlc07_faction_yuan_shao_resource_manager"); -- Manages the pooled resource generation for Yuan Shao's faction.
force_require("dlc07_faction_liu_yan_resource_manager") -- manages the pooled resource of liu yan / liu zhang
force_require("dlc07_imperial_intrigue"); -- Manages the Imperial Intrigue Mechanic (which interacts with the child emperor) for all factions.
force_require("3k_campaign_progression_extended"); -- Handles the player selected progression groups.

force_require("3k_campaign_default_diplomacy_shared"); -- Handles the player selected progression groups.

-- SHARED GLOBAL_EVENTS --
output("/global_events/");
inc_tab();
force_require("global_events/dlc06_campaign_global_events"); -- Nanman global Events.
force_require("global_events/campaign_core_global_events"); -- DLC05 related global Events
force_require("global_events/dlc06_campaign_character_spawning_events") -- Character Spawnings
dec_tab();

-- VALIDATION --
force_require("validation");


dec_tab();
output("************ SHARED LOADER: END ************");