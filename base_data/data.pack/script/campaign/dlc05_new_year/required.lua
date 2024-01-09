

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
force_require("3k_dlc05_start");

force_require("3k_dlc05_gating");
force_require("3k_dlc05_default_diplomacy");
force_require("dlc05_campaign_global_events");
force_require("3k_dlc05_campaign_lu_bu_features");
force_require("3k_dlc05_faction_ceos_lu_bu");