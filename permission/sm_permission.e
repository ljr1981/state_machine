note
	description: "[
		Representation of a {SM_PERMISSION} as a type of {SM_OBJECT}
		]"
	design: "[
		Objects that manage various forms of "permission" (e.g rights).
		The basic permissions are (from low to high):
		
		(0) No-Access		- None (none-exported)
		(1) View-Access		- Read-only (Query)
		(2) Edit-Access		- Read-write (Compute)
		(3) Add-Access		- Create
		(4) Delete-Access	- Delete
		
		CRUD = Create / Read / Update / Delete
		
		The [1-5] list includes the additional notion of No-Access,
		which means the data is below "Read-only" (View-Access). The
		basic "take-away" from an examination of these ideas is that
		the [1-5] notions are relatively complete in terms of the
		notion of "permission" (i.e. "access rights").
		
		Higher notions will extend out from single entities to groups.
		]"

class
	SM_PERMISSION

inherit
	SM_OBJECT

create
	make_with_machine

feature {NONE} -- Initialization: FSM

	pre_make_initialization
			-- <Precursor>
		do
			do_nothing -- Yet ...
		end

	initialize_state_assertions (a_machine: SM_MACHINE)
			-- <Precursor>
		do
			do_nothing -- Yet ...
		end

	initialize_transition_operations (a_machine: SM_MACHINE)
			-- <Precursor>
		do
			do_nothing -- Yet ...
		end

feature -- Transition Operations

	set_permission_level (a_level: INTEGER)
			-- `set_permission_level' `a_level' to set `permission_level'.
		do
			permission_level := a_level
		end

feature -- State Assertions

	permission_level: INTEGER
			-- `permission_level' of Current {SM_PERMISSION}.

		-- Computed State Assertions based on `permission_level'.
	is_no_access: BOOLEAN 		do Result := permission_level = 0 end
	is_view_access: BOOLEAN 	do Result := permission_level = 1 end
	is_edit_access: BOOLEAN 	do Result := permission_level = 2 end
	is_add_access: BOOLEAN 		do Result := permission_level = 3 end
	is_delete_access: BOOLEAN 	do Result := permission_level = 4 end

feature -- Transition Triggers

feature {NONE} -- Implementation: Constants

invariant
	five_levels: (0 |..| 4).has (permission_level)

end
