---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
----- Name:			dlc06_faction_nanman_king_meng_huo_features.lua
----- Description: 	This script handles king Meng Huos's faction bonuses from fealty.
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Don't load in campaigns which don't require it.
if cm.name == "ep_eight_princes" then
	output("dlc06_faction_nanman_king_meng_huo.lua: Not loaded in this campaign." );
	return;
else
	output("dlc06_faction_nanman_king_meng_huo.lua: Loading");
end;

-- self initialiser
cm:add_first_tick_callback(function() king_meng_huo_features:initialise() end); -- fires on the first tick of every game loaded.


king_meng_huo_features = {
	meng_huo_faction_key = "3k_dlc06_faction_nanman_king_meng_huo";
	meng_huo_fealty_bonus_effect_bundle_key = "3k_dlc06_effect_bundle_faction_king_meng_huo_fealty_bonus",
	meng_huo_fealty_bonus_turns = 5; -- number of turns to apply meng huo's special faction bonus for.
};

function king_meng_huo_features:initialise()
	-- Meng Huo Gains effect bundle when gaining destroying a faction.
	core:add_listener(
		"3k_dlc06_faction_nanman_king_meng_huo_bonus_listener", -- UID
		"FactionDied", -- campaign event
		function(context)
			return context:killer_or_confederator_faction_key() == self.meng_huo_faction_key;
		end,
		function(context)
			cm:modify_faction(cm:query_faction(self.meng_huo_faction_key)):apply_effect_bundle(self.meng_huo_fealty_bonus_effect_bundle_key, self.meng_huo_fealty_bonus_turns);
		end,
		true
	);

	core:add_listener(
		"3k_dlc06_faction_nanman_king_meng_huo_bonus_listener", -- UID
		"ScriptEventFactionBecomesVassal", -- campaign event
		function(custom_context)
			return custom_context:vassal_master():name() == self.meng_huo_faction_key;
		end,
		function(custom_context)
			cm:modify_faction(cm:query_faction(self.meng_huo_faction_key)):apply_effect_bundle(self.meng_huo_fealty_bonus_effect_bundle_key, self.meng_huo_fealty_bonus_turns);
		end,
		true
	);

	core:add_listener(
		"3k_dlc06_faction_nanman_king_meng_huo_bonus_listener", -- UID
		"FactionEffectBundleAwarded", -- campaign event
		function(context)
			return context:effect_bundle_key() == self.meng_huo_fealty_bonus_effect_bundle_key;
		end,
		function(context)
			output("Gained mh bundle");
			effect.call_context_command("UiMsg(\"MengHuoFealtyBonusUpdated\")");
		end,
		true
	);

	core:add_listener(
		"3k_dlc06_faction_nanman_king_meng_huo_bonus_listener", -- UID
		"FactionEffectBundleRemoved", -- campaign event
		function(context)
			return context:effect_bundle_key() == self.meng_huo_fealty_bonus_effect_bundle_key;
		end,
		function(context)
			output("Lost mh bundle");
			effect.call_context_command("UiMsg(\"MengHuoFealtyBonusUpdated\")");
		end,
		true
	);

	
end;