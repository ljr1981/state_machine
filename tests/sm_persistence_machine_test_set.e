note
	description: "[
		Tests of {SM_PERSISTENCE_MACHINE}
	]"
	testing: "type/manual"

class
	SM_PERSISTENCE_MACHINE_TEST_SET

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

	sm_persistence_machine_creation
			-- `sm_persistence_machine_creation'
		local
			l_machine: MOCK_PERSISTENCE_MACHINE
		do
			create l_machine
		end

end


