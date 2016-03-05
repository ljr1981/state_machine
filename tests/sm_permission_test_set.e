note
	description: "[
		Tests of {SM_PERMISSION}.
	]"
	testing: "type/manual"

class
	SM_PERMISSION_TEST_SET

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

	sm_permission_creation
			-- New test routine
		note
			testing:  "execution/isolated"
		local
			l_mock: SM_PERMISSION
			l_machine: MOCK_MACHINE
		do
			create l_machine
			create l_mock.make_with_machine (l_machine)
		end

end


