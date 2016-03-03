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
				Create a machine and a mock to manage. Give the machine to the
				mock and so the mock can set up its own state management through
				the given machine.
				
				Test the mock to ensure that calls to its "trigger features" has
				the desired effect (transitions fire and state changes).
				
				Test the machine to ensure that calls to its transit features
				will also cause the states to change.
				]"
		local
			l_machine: MOCK_MACHINE
			l_mock: MOCK_DOOR
		do
			create l_machine
			create l_mock.make_with_machine (l_machine)

				-- Attempt to open ...
			l_mock.open (Void)
			assert ("test_is_opened", l_mock.is_opened)
			assert ("test_is_fully_opened", l_mock.is_fully_opened)

				-- Attempt to close ...
			l_mock.close (Void)
			assert ("test_is_closed", l_mock.is_closed)
			assert ("test_is_fully_closed", l_mock.is_fully_closed)

				-- Attempt to auto_transit ...
			l_machine.auto_transit
			assert ("test_is_opened", l_mock.is_opened)
			assert ("test_is_fully_opened", l_mock.is_fully_opened)

				-- Attempt to transit ...
			l_machine.transit (2, 1)
			assert ("test_is_closed", l_mock.is_closed)
			assert ("test_is_fully_closed", l_mock.is_fully_closed)
		end

end


