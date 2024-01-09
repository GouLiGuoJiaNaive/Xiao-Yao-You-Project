

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	REQUIRED FILES
--
--	Add any files that need to be loaded for this campaign here
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

package.path = package.path .. ";" .. cm:get_campaign_folder() .. "/?.lua";

--	general campaign behaviour
force_require("3k_campaign_setup");
force_require("3k_campaign_shared_loader"); -- Load scripts shared between campaigns.

--	campaign-specific files
force_require("3k_dlc04_mandate_start");

force_require("dlc04_campaign_gating"); -- Custom gating for DLC04.
force_require("dlc04_mandate_war_manager"); -- Controls the mandate of heaven war mechanic
force_require("dlc04_campaign_shared_faction_events"); -- Shared  events for all factions.
force_require("dlc04_campaign_default_diplomacy"); -- Start pos diplomacy for all factions. Also controls some ewmergent diplomacy stuff.
force_require("dlc04_faction_ceos_lu_zhi"); -- Manager for Lu Zhi's faction ceos
force_require("dlc04_faction_emperor_imperial_court"); -- Manager for the Han Dynasty's Imperial Court mechanic
force_require("dlc04_faction_yellow_turban_fervour"); -- Manager for the Yellow Turban fervour mechanics (both global and regional)
force_require("dlc04_campaign_global_events"); -- Global events for the mandate campaign
force_require("dlc04_campaign_emergent_factions"); -- Emergent Factions scripting
force_require("dlc04_campaign_liang_rebellion"); -- Liang Rebellion system manager.