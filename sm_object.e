note
	description: "[
		Abstract notion of a {SM_MACHINE} managed {SM_OBJECT}.
		]"

deferred class
	SM_OBJECT

inherit
	PS_PUBLISHER_SUBSCRIBER [detachable ANY]
		rename
			subscriber_add_subscription as add_post_transition_event, 		-- Object subscribes to machine post-events
			publisher_add_subscription as add_transition_event_subscription	-- Object publishes trans-events to machine
		end

feature {NONE} -- Initialization

	make_with_machine (a_machine: SM_MACHINE)
			-- `make_with_machine_and_object' using `a_machine'.
		do
			initialize_state_assertions (a_machine)
			initialize_transition_operations (a_machine)
		end

	pre_make_initialization
			-- `pre_make_initialization' happens as the first step in `make_with_machine'.
		deferred
		end

	initialize_state_assertions (a_machine: SM_MACHINE)
			-- `initialize_state_assertions' in `a_machine'.
		deferred
		end

	initialize_transition_operations (a_machine: SM_MACHINE)
			-- `initialize_transition_operations' in `a_machine'.
		deferred
		end

end
