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
						create {SM_TRANSITION}.make (1, 2, agent trigger_feature, <<agent apply_edit>>, <<agent post_trigger_feature>>),
						create {SM_TRANSITION}.make (1, 3, agent trigger_feature, <<agent apply_edit>>, <<agent post_trigger_feature>>),
							-- From Dirty-valid -> ...
						create {SM_TRANSITION}.make (2, 2, agent trigger_feature, <<agent apply_edit>>, <<agent post_trigger_feature>>),
						create {SM_TRANSITION}.make (2, 3, agent trigger_feature, <<agent apply_edit>>, <<agent post_trigger_feature>>),
						create {SM_TRANSITION}.make (2, 1, agent trigger_feature, <<agent save_data>>, <<agent post_trigger_feature>>),
						create {SM_TRANSITION}.make (2, 1, agent trigger_feature, <<agent cancel>>, <<agent post_trigger_feature>>),
							-- From Dirty-invalid -> ...
						create {SM_TRANSITION}.make (3, 2, agent trigger_feature, <<agent apply_edit>>, <<agent post_trigger_feature>>),
						create {SM_TRANSITION}.make (3, 1, agent trigger_feature, <<agent cancel>>, <<agent post_trigger_feature>>)
						>>)
		end

	trigger_feature (a_data: detachable ANY)
		do

		end

	post_trigger_feature (a_data: detachable ANY)
		do

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
