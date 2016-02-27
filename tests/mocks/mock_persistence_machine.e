note
	description: "[
		Representation of a {MOCK_PERSISTENCE_MACHINE}
		]"

class
	MOCK_PERSISTENCE_MACHINE

inherit
	SM_PERSISTENCE_MACHINE

feature

	is_valid: BOOLEAN

	apply_edit do  end

	save_data do  end

	cancel do  end

end
