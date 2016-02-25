note
	description: "[
		Mock {SM_MACHINE}
		]"

class
	MOCK_MACHINE

inherit
	SM_MACHINE

	-- Clean
	-- Dirty-valid
	-- Dirty-invalid

	-- Clean 			-(apply_edit)> 	Dirty-valid
	-- Clean 			-(apply_edit)> 	Dirty-invalid

	-- Dirty-valid		-(apply_edit)>	Dirty-valid
	-- Dirty-valid 		-(apply_edit)> 	Dirty-invalid
	-- Dirty-valid 		-(save_data)> 	Clean
	-- Dirty-valid 		-(cancel)> 		Clean

	-- Dirty-invalid 	-(apply_edit)> 	Dirty-valid
	-- Dirty-invalid 	-(cancel)> 		Clean

	-- apply_edit: store old Clean data in buffer
	-- save_data: save Dirty-valid data to DB
	-- cancel: restore Clean data from buffer

end
