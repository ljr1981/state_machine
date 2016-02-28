note
	description: "[
		Representation of a {SM_TRANSITION}
		]"
	design: "[
		Previously, the notion of a "transition" was merely a simple named-TUPLE. With the
		need to provide a UUID to the transition, it became necessary to create a class.
		This necessity came because transitions needed to be ID'd beyond simple start-stop
		values for the state IDs. It was impossible (on-the-face) to generate a unique hash
		of agents in the operation agents. So, it was decided that a simple UUID would be
		sufficient to "tag" each {SM_TRANSITION} created.
		]"

class
	SM_TRANSITION

create
	make

feature {NONE} -- Initialization

	make (a_start, a_stop: INTEGER; a_operations: like operations)
			-- `make' Current with `a_start' and `a_stop' state IDs, and with state assertion `a_operations' list.
		require
			non_zero: a_start > 0 and a_stop > 0
			has_operations: a_operations.count > 0
		do
			start := a_start
			stop := a_stop
			operations := a_operations
			create uuid.make (randomizer.random_integer.to_natural_32, randomizer.random_integer.to_natural_16, randomizer.random_integer.to_natural_16, randomizer.random_integer.to_natural_16, randomizer.random_integer.to_natural_32)
		ensure
			start_set: start = a_start
			stop_set: stop = a_stop
			operations_set: operations ~ a_operations
		end

feature -- Access

	start,
	stop: INTEGER
			-- `start' and `stop' state IDs.

	operations: ARRAY [PROCEDURE]
			-- List of `operations' for Current

	uuid: UUID
			-- `uuid' of Current.

feature {NONE} -- Implementation

	randomizer: RANDOMIZER
			-- `randomizer' once'd to provide random {NATURAL} numbers for `uuid' initialization.
		once
			create Result
		end

end
