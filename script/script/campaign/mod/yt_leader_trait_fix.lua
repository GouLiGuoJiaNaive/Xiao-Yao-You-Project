if cm.name == "ep_eight_princes" then
	return;
end;


function yt_traits:setup_listeners()

	-- When a character becomes the faction leader, we should convert their studentness to teacherness.
	core:add_listener(
        "yt_traits_faction_leader", 
        "CharacterTurnStart",
        function (context) 
			if not self:character_can_have_learning_traits( context:query_character() ) then
				return false;
			end;

			if not context:query_character():is_faction_leader() then
				return false;
			end;
			return true;
		end, --Conditions for firing
		function(context) 
			self:convert_student_to_teacher( context:query_character(), context:modify_character() );
			self:convert_teacher_to_emperor( context:query_character(), context:modify_character() );
		end, -- function to fire: change teacher trait when new FL in a YT faction
        true -- Is Persistent?
    );


	-- Listens for YT factions and triggers learning trait updates on the characters.
	core:add_listener(
		"yt_traits_character_turn_start", -- Unique handle
		"CharacterTurnStart", -- Campaign Event to listen for
		function(context) -- Criteria
			if context:query_model():turn_number() < 2 then
				return false;
			end;

			if not self:character_can_have_learning_traits( context:query_character() ) then
				return false;
			end;
			
			return true;
		end,
		function(context) -- What to do if listener fires.
			if self:has_teacher_trait() and not context:query_character():is_faction_leader() then
				self:convert_teacher_to_student();
			end;

			self:turn_start_learning_growth( context:modify_character() );
		end,
		true --Is persistent
	);


	-- Listens for YT factions and triggers learning trait updates on the characters.
	core:add_listener(
        "yt_traits_relationship_changed", 
        "FactionRoundStart",
		function (context) 
			if context:query_model():turn_number() < 2 then
				return false;
			end;

			if context:faction():subculture() ~= "3k_main_subculture_yellow_turban" then
				return false;
			end;

			return true;
		end, --Conditions for firing
		function(context) 
			self:apply_learning_to_relationships( context:faction() ) 
		end, -- function to fire: this is the trigger for spreading student trait
        true -- Is Persistent?
	);
	
	
	-- Listens for faction leaders being removed from their posts.
	core:add_listener(
		"yt_traits_removed_from_post", -- Unique handle
		"CharacterUnassignedFromPost", -- Campaign Event to listen for
		function(context) -- Criteria
			if not context:query_character() or context:query_character():is_null_interface() then
				return false;
			end
			
			if not self:character_can_have_learning_traits( context:query_character() ) then
				return false;
			end;

			if not self:has_teacher_trait() then
				return false;
			end;

			return true;
		end,
		function(context) -- What to do if listener fires.
			self:convert_teacher_to_student( context:query_character(), context:modify_character() );
		end,
		true --Is persistent
	);
end

