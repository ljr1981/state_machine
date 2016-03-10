note
	description: "[
		Representation of a {MOCK_TURNSTILE}.
		]"
	EIS: "src=https://en.wikipedia.org/wiki/Finite-state_machine#Example:_coin-operated_turnstile"
	design: "[
		There are a number of items to note in the design that are different
		from the {MOCK_DOOR} example:
		
		(1) Removed "magic numbers", which helps greatly in making state-trans 
			def's more readable.
		(2) Consolidated the BOOLEAN states of locked/unlocked to a single attribute
			with a toggled-BOOLEAN-query (`is_unlocked').
		(3) Because SM_TRIGGERs are all the same, it is more readable to put them
			in a comma-delimited list with a single type-reference for all of them.
		]"
	graph: "[
digraph finite_state_machine {
	rankdir=LR;
	size="8,5"
	node [shape = doublecircle]; Locked Unlocked;
	node [shape = circle];
	Locked -> Unlocked [ label = "Coin" ];
	Unlocked -> Locked [ label = "Push" ];
	Locked -> Locked [ label = "Push" ];
	Unlocked -> Unlocked [ label = "Coin" ];
}
		]"
	EIS: "src=$GITHUB/state_machine/docs/turnstile.png"


class
	MOCK_TURNSTILE

inherit
	SM_OBJECT

create
	make_with_machine

feature {NONE} -- Initialization: FSM

	pre_make_initialization
			-- <Precursor>
		do
			create locked_push
			create locked_coin
			create unlocked_push
			create unlocked_coin
		end

	initialize_state_assertions (a_machine: SM_MACHINE)
			-- <Precursor>
		do
			a_machine.add_state ([<<agent is_locked>>])
			a_machine.add_state ([<<agent is_unlocked>>])
		end

	initialize_transition_operations (a_machine: SM_MACHINE)
			-- <Precursor>
		do
			a_machine.add_transitions (<<		-- From		To					set on-Trigger							do Transition ops					Post-trans ops
					create {SM_TRANSITION}.make ([locked, 	locked, "Push"], 	agent locked_push.set, 			<<agent set_turnstile_lock_to (lock_it)>>, 		<<>>),
					create {SM_TRANSITION}.make ([locked, 	unlocked, "Coin"], 	agent locked_coin.set, 			<<agent set_turnstile_lock_to (unlock_it)>>, 	<<>>),
					create {SM_TRANSITION}.make ([unlocked, locked, "Push"], 	agent unlocked_push.set, 		<<agent set_turnstile_lock_to (lock_it)>>, 		<<>>),
					create {SM_TRANSITION}.make ([unlocked, unlocked, "Coin"], 	agent unlocked_coin.set, 		<<agent set_turnstile_lock_to (unlock_it)>>, 	<<>>)
										>>)
		end

feature -- Transition Operations

	set_turnstile_lock_to (a_key: BOOLEAN)
			-- `set_turnstile_lock_to' `a_key' to set `is_locked' or `is_unlocked'.
		do
			is_locked := a_key
		end

feature -- State Assertions

	is_locked: BOOLEAN

	is_unlocked: BOOLEAN
			-- `is_unlocked' is not `is_locked'
		do
			Result := not is_locked
		end

feature -- Transition Triggers

	locked_push,
	locked_coin,
	unlocked_push,
	unlocked_coin: SM_TRIGGER

feature {NONE} -- Implementation: Constants

	locked: INTEGER = 1
	unlocked: INTEGER = 2
	lock_it: BOOLEAN = True
	unlock_it: BOOLEAN = False

end
