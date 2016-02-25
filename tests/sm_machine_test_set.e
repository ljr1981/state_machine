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
		local
			l_machine: MOCK_MACHINE
		do
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
		end

feature {NONE} -- Implementation

	current_state: INTEGER = 1

	is_one: BOOLEAN
		do
			Result := current_state = 1
		end

	is_two: BOOLEAN
		do
			Result := current_state = 2
		end

end


