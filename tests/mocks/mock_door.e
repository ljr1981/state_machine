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

feature {NONE} -- Initialization

	pre_make_initialization
			-- <Precursor>
		do
			-- Prep with start state
			make_closed
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
										create {SM_TRANSITION}.make (1, 2, agent set_open_agent, <<agent set_opened>>, <<agent set_fully_opened>>),
										create {SM_TRANSITION}.make (2, 1, agent set_close_agent, <<agent set_closed>>, <<agent set_fully_closed>>)
										>>)
		end

feature {NONE} -- Initialization: Current

	make_opened
			-- `make_opened'.
		do
			is_opened := True
			is_fully_opened := True
		end

	make_closed
			-- `make_closed'.
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
			-- Set `is_opened'
		do
			is_opened := True
			is_fully_opened := False
			is_closed := False
			is_fully_closed := False
		end

	set_fully_opened
		do
			is_opened := True
			is_fully_opened := True
			is_closed := False
			is_fully_closed := False
		end

	set_closed
		do
			is_opened := False
			is_fully_opened := False
			is_closed := True
			is_fully_closed := False
		end

	set_fully_closed
		do
			is_opened := False
			is_fully_opened := False
			is_closed := True
			is_fully_closed := True
		end

feature -- Transition Triggers

	open (a_data: detachable ANY)
			-- `open' Current {MOCK_DOOR}.
		do
			check attached open_agent as al_agent then al_agent.call (a_data) end
		end

	open_agent: detachable PROCEDURE [ANY, TUPLE [detachable ANY]]

	set_open_agent (a_agent: like open_agent)
		do
			open_agent := a_agent
		end

	close (a_data: detachable ANY)
			-- `close' Current {MOCK_DOOR}.
		do
			check attached close_agent as al_agent then al_agent.call (a_data) end
		end

	close_agent: detachable PROCEDURE [ANY, TUPLE [detachable ANY]]

	set_close_agent (a_agent: like close_agent)
		do
			close_agent := a_agent
		end

invariant
	some_opened: (is_opened or is_fully_opened) implies (not is_closed and not is_fully_closed)
	some_closed: (is_closed or is_fully_closed) implies (not is_opened and not is_fully_opened)

end
