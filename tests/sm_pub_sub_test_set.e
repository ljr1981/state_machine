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

	turnstile_graph_out
			-- `turnstile_graph_out'
		note
			EIS: "name=correctness_proof", "src=$GITHUB/state_machine/turnstile_2.png"
		local
			l_mock: MOCK_TURNSTILE
			l_machine: MOCK_MACHINE
		do
			create l_machine
			create l_mock.make_with_machine (l_machine)
			assert_strings_equal ("graphviz", turnstile_graph, l_machine.graph_out)

			generate_graph_outs (l_machine, "turnstile_2", "dot_turnstile")
		end

	door_graph_out
			-- `door_graph_out'
		note
			EIS: "name=correctness_proof", "src=$GITHUB/state_machine/door.png"
		local
			l_mock: MOCK_DOOR
			l_machine: MOCK_MACHINE
			l_process: PROCESS_IMP
			l_file: PLAIN_TEXT_FILE
		do
			create l_machine
			create l_mock.make_with_machine (l_machine)
--			assert_strings_equal ("graphviz", turnstile_graph, l_machine.graph_out)

			generate_graph_outs (l_machine, "door", "dot_door")
		end

feature {NONE} -- Test Support: Graph Out

	generate_graph_outs (a_machine: SM_MACHINE; a_output_name, a_cmd_name: STRING)
		local
			l_process: PROCESS_IMP
			l_file: PLAIN_TEXT_FILE
		do
				-- Generate to file
			create l_file.make_create_read_write (a_output_name + ".txt")
			l_file.put_string (a_machine.graph_out)
			l_file.close

				-- Generate CMD file
			create l_file.make_create_read_write (a_cmd_name + ".cmd")
			l_file.put_string ("bin\dot.exe " + a_output_name + ".txt -Tpng > " + a_output_name + ".png")
			l_file.close

			create l_process.make_with_command_line (a_cmd_name + ".cmd", Void)
			l_process.set_hidden (False)
			l_process.launch
		end

	turnstile_graph: STRING = "digraph finite_state_machine {rankdir=LR;size=%"8,5%" node [shape = circle];S1 -> S1 [ label = %"Push%" ];S1 -> S2 [ label = %"Coin%" ];S2 -> S1 [ label = %"Push%" ];S2 -> S2 [ label = %"Coin%" ];}"

feature -- Other tests

	turnstile_tests
			-- `turnstile_tests'
		local
			l_mock: MOCK_TURNSTILE
		do
			create l_mock.make_with_machine (create {MOCK_MACHINE})

			l_mock.locked_push.start ([Void])
			assert ("test_is_locked_1", l_mock.is_locked)
			l_mock.locked_coin.start ([Void])
			assert ("test_is_unlocked_1", l_mock.is_unlocked)
			l_mock.unlocked_coin.start ([Void])
			assert ("test_is_unlocked_2", l_mock.is_unlocked)
			l_mock.unlocked_push.start ([Void])
			assert ("test_is_locked_2", l_mock.is_locked)
		end

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
			l_mock.open.start ([Void])
			assert ("test_is_opened", l_mock.is_opened)
			assert ("test_is_fully_opened", l_mock.is_fully_opened)

				-- Attempt to close ...
			l_mock.close.start ([Void])
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


