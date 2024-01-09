

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
force_require("3k_early_start");

force_require("3k_campaign_gating");
force_require("3k_campaign_default_diplomacy");
force_require("3k_campaign_tutorial");
force_require("3k_extended_tutorial");
force_require("3k_campaign_global_events"); -- Main game specific global events.
