note
	description: "[
		Representation of a {MOCK_DATA_ONE}
		]"
	design: "[
		(1) Has basic data like numbers, strings, booleans.
		(2) Here to be managed by {MOCK_PERSISTENCE_MACHINE}
		]"

class
	MOCK_DATA_ONE

feature

	name: STRING attribute Result := "Undefined" end

	rate: REAL_32

	index: INTEGER

end
