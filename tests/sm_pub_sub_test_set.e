note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	SM_PUB_SUB_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

feature -- Test routines

	state_machine_pub_sub_tests
			-- `state_machine_pub_sub_tests' for testing FSM's with the PUB-SUB model.
		note
			testing:  "execution/isolated"
			design: "[
				Create a single MOCK_DOOR object, which will be our "test subject".
				The mock will be the thing needing its state managed. It will communicate
				with the state machine by way of pub-sub built into the state machine.
				
				The MOCK_DOOR will be a simple "door" with two states:
				
					Opened
					Closed
					 
				and two commands: 
					
					Open
					Close 
				
				where:
					
					Open -> Opened  
					Close -> Closed
				]"
		local
			l_mock: MOCK_DOOR
			l_machine: MOCK_MACHINE
			l_subscription: PS_SUBSCRIPTION [ANY]
			l_transition: SM_TRANSITION
		do
			create l_mock.make_closed
			create l_machine
				-- Prep the machine with the mock ...
--			l_machine.subscribe_to (l_mock.on_open_publication, agent l_mock.on_open)
			l_machine.add_state ([<<agent l_mock.closed>>])
			l_machine.add_state ([<<agent l_mock.opened>>])
			create l_transition.make (1, 2, <<agent l_mock.set_opened>>)
			l_machine.add_transition (l_transition)
			create l_transition.make (2, 1, <<agent l_mock.set_closed>>)
			l_machine.add_transition (l_transition)
			l_machine.add_post_transition_event (l_mock.on_post_open_subscription)
				-- Attempt to open?
			l_mock.open
--			assert ("opened", l_mock.opened)
--			assert ("fully_opened", l_mock.fully_opened)
		end

end


