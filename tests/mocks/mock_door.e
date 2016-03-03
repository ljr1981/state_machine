note
	description: "[
		Representation of a {MOCK_DOOR}
		]"

class
	MOCK_DOOR

inherit
	SM_OBJECT

create
	make_with_machine

feature {NONE} -- Initialization: FSM

	pre_make_initialization
			-- <Precursor>
		do
			make_closed
			create open
			create close
		ensure then
			closed: is_closed and is_fully_closed
		end

	initialize_state_assertions (a_machine: SM_MACHINE)
			-- <Precursor>
		do
			a_machine.add_state ([<<agent is_fully_closed>>])
			a_machine.add_state ([<<agent is_fully_opened>>])
		end

	initialize_transition_operations (a_machine: SM_MACHINE)
			-- <Precursor>
		do
			a_machine.add_transitions (<<
					create {SM_TRANSITION}.make (1, 2, agent open.set_event_agent, <<agent set_opened>>, <<agent set_fully_opened>>),
					create {SM_TRANSITION}.make (2, 1, agent close.set_event_agent, <<agent set_closed>>, <<agent set_fully_closed>>)
										>>)
		end

feature {NONE} -- Initialization: Current

	make_opened
			-- Initialize Current {MOCK_DOOR} with `make_opened'.
		do
			is_opened := True
			is_fully_opened := True
		end

	make_closed
			-- Initialize Current {MOCK_DOOR} with `make_closed'.
		do
			is_closed := True
			is_fully_closed := True
		end

feature -- State Assertions

	is_opened: BOOLEAN

	is_fully_opened: BOOLEAN

	is_closed: BOOLEAN

	is_fully_closed: BOOLEAN

feature -- Transition Operations

	set_opened
			-- Set `is_opened'.
		do
			is_opened := True
			is_fully_opened := False
			is_closed := False
			is_fully_closed := False
		end

	set_fully_opened
			-- Set `is_fully_opened'.
		do
			is_opened := True
			is_fully_opened := True
			is_closed := False
			is_fully_closed := False
		end

	set_closed
			-- Set `is_closed'.
		do
			is_opened := False
			is_fully_opened := False
			is_closed := True
			is_fully_closed := False
		end

	set_fully_closed
			-- Set `is_fully_closed'.
		do
			is_opened := False
			is_fully_opened := False
			is_closed := True
			is_fully_closed := True
		end

feature -- Transition Triggers

	open: SM_TRIGGER
			-- Trigger `open' Current {MOCK_DOOR}.

	close: SM_TRIGGER
			-- Trigger `close' Current {MOCK_DOOR}.

invariant
	some_opened: (is_opened or is_fully_opened) implies (not is_closed and not is_fully_closed)
	some_closed: (is_closed or is_fully_closed) implies (not is_opened and not is_fully_opened)

end
