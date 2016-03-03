note
	description: "[
		Representation of a {MOCK_TURNSTILE}.
		]"
	EIS: "src=https://en.wikipedia.org/wiki/Finite-state_machine#Example:_coin-operated_turnstile"

class
	MOCK_TURNSTILE

inherit
	SM_OBJECT

create
	make_with_machine

feature {NONE} -- Initialization: FSM

	pre_make_initialization
			-- <Precursor>
		do
			create locked_push
			create locked_coin
			create unlocked_push
			create unlocked_coin
		end

	initialize_state_assertions (a_machine: SM_MACHINE)
			-- <Precursor>
		do
			a_machine.add_state ([<<agent is_locked>>])
			a_machine.add_state ([<<agent is_unlocked>>])
		end

	initialize_transition_operations (a_machine: SM_MACHINE)
			-- <Precursor>
		do
			a_machine.add_transitions (<<
					create {SM_TRANSITION}.make (1, 1, agent locked_push.set_event_agent, <<agent set_locked>>, <<>>),
					create {SM_TRANSITION}.make (1, 2, agent locked_coin.set_event_agent, <<agent set_unlocked>>, <<>>),
					create {SM_TRANSITION}.make (2, 1, agent unlocked_push.set_event_agent, <<agent set_locked>>, <<>>),
					create {SM_TRANSITION}.make (2, 2, agent unlocked_coin.set_event_agent, <<agent set_unlocked>>, <<>>)
										>>)
		end

feature -- Transition Operations

	set_locked
			-- Set `is_locked'.
		do
			is_locked := True
			is_unlocked := False
		end

	set_unlocked
			-- Set `is_unlocked'.
		do
			is_locked := False
			is_unlocked := True
		end

feature -- State Assertions

	is_locked: BOOLEAN

	is_unlocked: BOOLEAN

feature -- Transition Triggers

	locked_push,
	locked_coin,
	unlocked_push,
	unlocked_coin: SM_TRIGGER

end
