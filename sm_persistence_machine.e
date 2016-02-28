note
	description: "[
		Representation of a {SM_PERSISTENCE_MACHINE}
		]"
	synopsis: "[
		A machine capable of monitoring object(s) with
		data needing to be moved from less to more
		durable storage.
		]"

deferred class
	SM_PERSISTENCE_MACHINE

inherit
	SM_MACHINE
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- <Precursor>
		note
			design: "[
				Transitions:
				============
				Clean 			-(apply_edit)> 	Dirty-valid
				Clean 			-(apply_edit)> 	Dirty-invalid
				
				Dirty-valid		-(apply_edit)>	Dirty-valid
				Dirty-valid 	-(apply_edit)> 	Dirty-invalid
				Dirty-valid 	-(save_data)> 	Clean
				Dirty-valid 	-(cancel)> 		Clean
				
				Dirty-invalid 	-(apply_edit)> 	Dirty-valid
				Dirty-invalid 	-(cancel)> 		Clean
				]"
		do
			add_states (<<
						[<<agent is_clean>>],
						[<<agent is_dirty_valid>>],
						[<<agent is_dirty_invalid>>]
						>>)

			add_transitions (<<
							-- From Clean -> ...
						create {SM_TRANSITION}.make (1, 2, <<agent apply_edit>>),
						create {SM_TRANSITION}.make (1, 3, <<agent apply_edit>>),
							-- From Dirty-valid -> ...
						create {SM_TRANSITION}.make (2, 2, <<agent apply_edit>>),
						create {SM_TRANSITION}.make (2, 3, <<agent apply_edit>>),
						create {SM_TRANSITION}.make (2, 1, <<agent save_data>>),
						create {SM_TRANSITION}.make (2, 1, <<agent cancel>>),
							-- From Dirty-invalid -> ...
						create {SM_TRANSITION}.make (3, 2, <<agent apply_edit>>),
						create {SM_TRANSITION}.make (3, 1, <<agent cancel>>)
						>>)
		end

feature -- Status Report

	is_clean: BOOLEAN
			-- `current_state_id' `is_clean'.
		do
			Result := current_state_id = 1
		ensure
			not_dirty_valid: not is_dirty_valid
			not_dirty_invalid: not is_dirty_invalid
		end

	is_dirty_valid: BOOLEAN
			-- `current_state_id' `is_dirty_valid'.
		do
			Result := current_state_id = 2
		ensure
			not_clean: not is_clean
			not_dirty_invalid: not is_dirty_invalid
		end

	is_dirty_invalid: BOOLEAN
			-- `current_state_id' `is_dirty_invalid'.
		do
			Result := current_state_id = 3
		ensure
			not_clean: not is_clean
			not_dirty_valid: not is_dirty_valid
		end

	is_valid: BOOLEAN
			-- Content of Current `is_valid'.
		deferred
		end

feature {NONE} -- Basic Ops

	apply_edit
			-- `apply_edit': store old Clean data in `buffer'.
		deferred
		end

	save_data
			-- `save_data': save Dirty-valid data to `repository'.
		deferred
		end

	cancel
			-- `cancel': restore Clean data from `buffer'.
		deferred
		end

end
