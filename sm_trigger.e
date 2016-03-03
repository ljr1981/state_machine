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

feature -- Access

	do_event (a_data: detachable ANY)
			-- `do_event' of Current {SM_TRIGGER} with optional `a_data'.
		do
			check attached do_agent as al_agent then al_agent.call (a_data) end
		end

feature {SM_OBJECT} -- Implementation

	do_agent: detachable PROCEDURE [ANY, TUPLE [detachable ANY]]
			-- `do_agent' for `do_event' of Current {SM_TRIGGER}.

	set_do_agent (a_agent: like do_agent)
			-- `set_do_agent' with `a_agent'.
		do
			do_agent := a_agent
		end

end
