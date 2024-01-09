

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
force_require("ep_eight_princes_start");

force_require("ep_events");
force_require("ep_campaign_default_diplomacy");
force_require("ep_storybook");
force_require("ep_gating");
force_require("ep_emperor_manager");