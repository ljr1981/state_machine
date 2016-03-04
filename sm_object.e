note
	description: "[
		Abstract notion of a {SM_MACHINE} managed {SM_OBJECT}.
		]"
	example: "[
		inherit
			SM_OBJECT

		create
			make_with_machine
			
		NOTE: Be sure to always use `make_with_machine' as the
		creation procedure and then implement the deferred
		features as noted in this class:
		
		`pre_make_initialization'
		`initialize_state_assertions'
		`initialize_transition_operations'

		These three features (above) handle the entire process
		of initializing this class properly.
		]"


deferred class
	SM_OBJECT

inherit
	SM_ANY

	PS_PUBLISHER_SUBSCRIBER [detachable ANY]
		rename
			subscriber_add_subscription as add_post_transition_event, 		-- Object subscribes to machine post-events
			publisher_add_subscription as add_transition_event_subscription	-- Object publishes trans-events to machine
		end

feature {NONE} -- Initialization

	make_with_machine (a_machine: SM_MACHINE)
			-- `make_with_machine_and_object' using `a_machine'.
			-- Basic intialization operations are:
			-- 1. `pre_make_initialization'
			-- 2. `initialize_state_assertions'
			-- 3. `initialize_transition_operations'
		do
			pre_make_initialization
			initialize_state_assertions (a_machine)
			initialize_transition_operations (a_machine)
		end

	pre_make_initialization
			-- `pre_make_initialization' happens as the first step in `make_with_machine'.
		deferred
		end

	initialize_state_assertions (a_machine: SM_MACHINE)
			-- `initialize_state_assertions' in `a_machine'.
			-- Use {SM_MACHINE}.add_state to implement.
			-- First item is Default_state at end of creation cycle.
			-- See {MOCK_DOOR}.initialize_state_assertions in test target.
		deferred
		end

	initialize_transition_operations (a_machine: SM_MACHINE)
			-- `initialize_transition_operations' in `a_machine'.
			-- Use {SM_MACHINE}.add_transitions to implement.
			-- See {MOCK_DOOR}.initialize_transition_operations in test target.
		deferred
		end

end
