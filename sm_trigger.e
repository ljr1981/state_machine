note
	description: "[
		Representation of a {SM_TRIGGER}.
		]"
	example: "[
		In an class inheriting from SM_OBJECT:
		
		1. Create a new feature group: Transition Triggers
		2. Add one SM_TRIGGER feature for every trigger.
		
		Ex: close: SM_TRIGGER
		
		Be sure to "create" the trigger feature in the
		`pre_make_intialization' feature of the SM_OBJECT.
		
		See: {MOCK_DOOR}.pre_make_initialization and {MOCK_DOOR}.close
		]"

class
	SM_TRIGGER

inherit
	SM_ANY
	
feature -- Access

	start (a_data: detachable ANY)
			-- `start' of Current {SM_TRIGGER} with optional `a_data'.
		do
			check attached start_agent as al_agent then al_agent.call (a_data) end
		end

feature {SM_OBJECT} -- Implementation

	start_agent: detachable PROCEDURE [ANY, TUPLE [detachable ANY]]
			-- `start_agent' for `start' of Current {SM_TRIGGER}.

	set (a_agent: like start_agent)
			-- `set' `start_agent' with `a_agent'.
		do
			start_agent := a_agent
		end

end
