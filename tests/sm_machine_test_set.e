note
	description: "[
		Tests of {SM_MACHINE}
	]"
	testing: "type/manual"

class
	SM_MACHINE_TEST_SET

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

	sm_machine_creation
			-- `sm_machine_creation'
		note
			synopsis: "[
				The {MOCK_MACHINE} is managing the state of Current
				(e.g. this test class). See the non-exported implementation
				feature group for state-related features.
				]"
		local
			l_machine: MOCK_MACHINE
		do
			blah_data := 1 -- Sets up for the initial state.

			create l_machine
			
				-- No states means zero count.
			assert_integers_equal ("zero_count", 0, l_machine.state_count)

				-- Add a state and test for the `current_state_id'
			l_machine.add_states (<<[<<agent is_one>>]>>)
			assert_integers_equal ("state_1", 1, l_machine.current_state_id)

				-- Add another state and test to ensure first is still `current_state_id'.
			l_machine.add_states (<<[<<agent is_two>>]>>)
			assert_integers_equal ("state_1", 1, l_machine.current_state_id)
			assert_integers_not_equal ("not_other", 2, l_machine.current_state_id)

				-- Add a couple of transitions ...
			l_machine.add_transition ([1, 2, <<agent one_to_two>>])
			l_machine.add_transition ([2, 1, <<agent two_to_one>>])

				-- We are state one, now go to two ...
			l_machine.transit (1, 2)
			assert_integers_equal ("on_wants_two", 2, l_machine.current_state_id)

				-- Now, back to one from two ...
			l_machine.transit (2, 1)
			assert_integers_equal ("on_wants_one", 1, l_machine.current_state_id)

				-- Does auto_transit work?
			l_machine.auto_transit -- 1 -> 2
			assert_integers_equal ("on_wants_two", 2, l_machine.current_state_id)
			l_machine.auto_transit -- 2 -> 1
			assert_integers_equal ("on_wants_one", 1, l_machine.current_state_id)
		end

feature {NONE} -- Implementation: State-related

	blah_data: INTEGER
			-- `blah_data' of Current.

	is_one: BOOLEAN
			-- `blah_data' `is_one'?
		do
			Result := blah_data = 1
		end

	is_two: BOOLEAN
			-- `blah_data' `is_two'?
		do
			Result := blah_data = 2
		end

	one_to_two
			-- Set `blah_data' to 1
		do
			blah_data := 2
		end

	two_to_one
			-- Set `blah_data' to 1
		do
			blah_data := 1
		end

end


