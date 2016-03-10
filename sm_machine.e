note
	description: "[
		Abstract notion of a Finite State Machine (i.e. {SM_MACHINE}).
		]"
	design: "[
		{SM_MACHINE} is a FSM/FSA implementation capable of managing
		states, transitions, and triggers. The triggers can be based
		on the mechanisms of {PS_PUBLISHER} and {PS_SUBSCRIBER}, where
		the machine subscribes to triggering events of managed objects.
		The machine may also publish events and data of its own to
		other {SM_MACHINE} objects.
		]"

deferred class
	SM_MACHINE

inherit
	SM_ANY

	PS_PUBLISHER_SUBSCRIBER [detachable ANY]
		rename
			subscriber_add_subscription as add_transition_event,
			publisher_add_subscription as add_post_transition_event
		export {NONE}
			subscribe_to,
			subscriptions,
			publish_by_id,
			published_by_uuid_string,
			published_by_uuid,
			add_publication,
			add_publications,
			add_subscription_agents
		end

	SM_GRAPH

feature -- Basic Operations

	transit (a_start, a_stop: INTEGER)
			-- `transit' by calling transition operations for transitions from `a_start' to `a_stop'.
		require
			one: current_state_id = a_start
			is_valid: is_valid_transition (a_start, a_stop)
		do
			across
				transitions as ic_transitions
			loop
				if
					ic_transitions.item.start = a_start and
						ic_transitions.item.stop = a_stop
				then
					across
						ic_transitions.item.operations as ic_operations
					loop
						ic_operations.item.call ([Void])
					end
					across
						ic_transitions.item.post_transition_operations as ic_post_ops
					loop
						ic_post_ops.item.call ([Void])
					end
				end
			end
			compute_current_state_id
		ensure
			perhaps_same: (old current_state_id /= current_state_id) or
							(old current_state_id = current_state_id)
			current_is_stop: current_state_id = a_stop
		end

	auto_transit
			-- `auto_transit' from `current_state_id' to next state
		require
			one_transit: transition_count_from_current_state_id = 1
			at_least_two: state_count >= 2
		local
			l_old_state: INTEGER
		do
			compute_current_state_id
			across
				transitions as ic_transitions
			from
				l_old_state := current_state_id
			until
				l_old_state /= current_state_id
			loop
				if ic_transitions.item.start = current_state_id then
					across ic_transitions.item.operations as ic_operations loop ic_operations.item.call ([Void]) end
					across ic_transitions.item.post_transition_operations as ic_post_ops loop ic_post_ops.item.call ([Void])  end
				end
			end
			compute_current_state_id
		ensure
			state_changed: old current_state_id /= current_state_id
		end

feature -- Settings

	add_states (a_states: ARRAY [attached like states_value_anchor])
			-- `add_states' from `a_states' list.
		require
			states_have_assertions: across a_states as ic_states all ic_states.item.count > 0 end
		do
			across
				a_states as ic_states
			loop
				add_state (ic_states.item)
			end
			compute_current_state_id
		ensure
			added: old states.count = (states.count - a_states.count)
		end

	add_state (a_state: attached like States_value_anchor)
			-- `add_state' `a_state' to `states'.
		require
			has_assertions: a_state.state_assertions.count > 0
		do
			states.force (a_state, states.count + 1)
			compute_current_state_id
		ensure
			added: states.count = (old states.count + 1)
		end

	add_transitions (a_transitions: ARRAY [attached like Transition_pair_value_anchor])
			-- `add_transitions' from `a_transitions' list using `add_transition'.
			-- `a_transitions' as an ARRAY of detachable {SM_TRANSITION} items.
			-- Send `a_start', `a_stop', `a_trigger_callback_agent', `a_operations', and `a_post_transition_operations'.
		do
			across a_transitions as ic_transitions loop add_transition (ic_transitions.item) end
			compute_current_state_id
		end

	add_transition (a_transition: attached like Transition_pair_value_anchor)
			-- `add_transition' in `a_transition'.
		require
			not_contains: not has_transition (a_transition)
		do
			transitions.force (a_transition, transitions.count + 1)
			compute_current_state_id
		ensure
			added: transitions.count = old transitions.count + 1
		end

feature -- Status Report

	current_state_id: INTEGER
			-- `current_state_id' of Current.

	compute_current_state_id
			-- `compute_current_state_id' to `current_state_id' as-in `states' `is_current'
		require
			has_states: state_count > 0
		local
			l_result: like current_state_id
		do
			current_state_id := 0
			across
				states as ic_states
			until
				l_result > 0
			loop
				if
					across
						ic_states.item.state_assertions as ic_state_assertions
					all
						attached {FUNCTION [ANY, TUPLE, BOOLEAN]} ic_state_assertions.item as al_assertion_agent and then
							al_assertion_agent.item ([Void])
					end
				then
					l_result := ic_states.key
				end
			end
			current_state_id := l_result
		end

	state_count: INTEGER
			-- `state_count' of internal `states'.
		do
			Result := states.count
		end

	transition_count_from_current_state_id: INTEGER
			-- What is the `transition_count_from_current_state_id'?
		require
			not_zero: current_state_id > 0
		do
			across
				transitions as ic_transitions
			loop
				if ic_transitions.item.start = current_state_id then
					Result := Result + 1
				end
			end
		ensure
			bounded_count: Result <= transitions.count
		end

	is_valid_transition (a_start,a_stop: INTEGER): BOOLEAN
			-- `is_valid_transition' for `a_start' to `a_stop'.
		do
			Result := across
				transitions as ic_transitions
			some
				ic_transitions.item.start = a_start and ic_transitions.item.stop = a_stop
			end
		ensure
			empty_implies_false: transitions.is_empty implies not Result
		end

	has_transition (a_transition: attached like transition_pair_value_anchor): BOOLEAN
			-- Does `transitions' `has_transition' `a_transition'?
		do
			if transitions.count > 0 then
				Result := across
					transitions as ic_transitions
				some
					ic_transitions.item.uuid = a_transition.uuid
				end
			else
				Result := False
			end
		end

feature -- Outputs

	graph_out: STRING
			-- <Precursor>
		local
			l_tran: SM_TRANSITION
			l_output,
			l_nodes,
			l_node: STRING
		do
			Result := graph_template.twin
			create l_nodes.make_empty
			across
				transitions as ic_transitions
			loop
				l_node := node_template.twin
				l_tran := ic_transitions.item
				l_node.replace_substring_all ("<<FROM>>", "S" + l_tran.start.out)
				l_node.replace_substring_all ("<<TO>>", "S" + l_tran.stop.out)
				l_node.replace_substring_all ("<<LABEL>>", l_tran.name)
				l_nodes.append_string_general (l_node)
			end
			Result.replace_substring_all ("<<NODES>>", l_nodes)
		end

feature {SM_OBJECT, EQA_TEST_SET} -- Implementation: Status Report

	is_only_one_current: BOOLEAN
				-- For all current states `is_only_one_current'.
		do
			Result := count_of_is_current_states = 1
		end

	count_of_is_current_states: INTEGER
			-- Count of `states' that are `is_current'.
		note
			synopsis: "[
				Iterate `states' counting how many have `state_assertions' returning all True.
				]"
			design: "[
				While the answer ought always be zero or one, this assertion is an invariant
				so it is not applied here as an ensure. See `none_or_one' invariant.
				]"
		do
			across
				states as ic_states
			loop
				if
					across
						ic_states.item.state_assertions as ic_state_assertions
					all
						attached {FUNCTION [ANY, TUPLE, BOOLEAN]} ic_state_assertions.item as al_assertion_agent and then
							al_assertion_agent.item ([Void])
					end
				then
					Result := Result + 1
				end
			end
		end

feature {NONE} -- Implementation

	states: HASH_TABLE [attached like States_value_anchor, INTEGER]
			-- `states' like `States_value_anchor' of Current {SM_MACHINE}, keyed by {INTEGER} value.
		attribute
			create Result.make (default_state_capacity)
		end

	States_value_anchor: detachable TUPLE [state_assertions: ARRAY [FUNCTION [ANY, TUPLE, BOOLEAN]] ]
			-- `states_value_anchor' with list of {Q}-qualifying `state_assertions', and list of `stop_state_ids'.
		note
			synopsis: "[
				A state is defined by its assertions (e.g. the {P} and {Q} conditions from Hoare's Triple).
				]"
		require
			do_not_access: False
		once
			Result := Void
		end

	transitions: HASH_TABLE [attached like Transition_pair_value_anchor, INTEGER]
			-- `transitions' applied to `states' to transition from `start' to `stop' states using `operations'.
		attribute
			create Result.make (default_transition_capacity)
		end

	Transition_pair_value_anchor: detachable SM_TRANSITION -- TUPLE [start, stop: INTEGER; operations: ARRAY [PROCEDURE [ANY, TUPLE]]; uuid: UUID ]
			-- `Transition_pair_value_anchor' defining `start' and `stop' transition-pairs with `operations' to effect them.
		note
			synopsis: "[
				Transition-pairs are always in the form of `start' to `stop'
				with `operations' to effect the transition.
				]"
		require
			do_not_access: False
		once
			Result := Void
		end

feature {NONE} -- Implementation: Constants

	default_state_capacity: INTEGER = 10
			-- Reasonable `default_state_capacity' of Current.

	default_transition_capacity: INTEGER = 10
			-- Reasonable `default_transition_capacity' of Current.

invariant
	none_or_one: is_only_one_current implies count_of_is_current_states = 1
	contiguous_state_ids: across states as ic_states all ic_states.key = ic_states.cursor_index end
	states_have_assertions: across states as ic_states all ic_states.item.count > 0 end
	contiguous_transition_ids: across transitions as ic_transitions all ic_transitions.key = ic_transitions.cursor_index end

;note
	design: "[
		Background
		==========
		FSAs follow the Hoare Triple pattern of: {P} S {Q}, where the
		{P} and {Q} assertions evaluate to True if the machine is in a 
		particular state. The S-part represents the transition operation(s).
			
			{P} -> Assertion(s) holding True for the Start State.
			 S	-> Transition operation(s) to change (State-1 -> State-2)
			{Q}	-> Assertion(s) holding True for the Stop State.
					{P} assertion(s) will now evaluate to False.
			
		{P} /= {Q} in all S -> S'
		{P} = {Q} in all S -> S (e.g. {P} = {P} for S -> S)

		Trigger_part
		============
		A Trigger is an Subscriber Agent (A) given to a Publisher to call as a
		result of a Publisher Event (E).
		
		Event E calls Agent A, which calls S operation(s), which transitions from {P} -> {Q}.
		
		Cooperative Machines
		====================
		Machines can be in complex Publisher-Subscriber relations with each other:
		
		M1 <-> M2
		
		M1 Subscribe to M2 Event
		M2 Subscribe to M1 Event

		Context
		=======
		The {SM_MACHINE} (Current) has a single job: Manage a set of states in a State_hash
		(or objects if appropriate), facilitating the transitions between them, and proving
		the notion of `is_in_state' once a target "stable state" has been (in theory)
		achieved.
		
		The {SM_MACHINE} is NOT the thing with the set of states. A group of one-or-more
		objects in the system are the ultimate target.
		
		Extended Finite State Machine
		=============================
		"In a conventional finite state machine, the transition is associated with a set of 
		input Boolean conditions and a set of output Boolean functions. In an extended finite 
		state machine (EFSM) model, the transition can be expressed by an “if statement” consisting 
		of a set of trigger conditions. If trigger conditions are all satisfied, the transition is 
		fired, bringing the machine from the current state to the next state and performing the 
		specified data operations." -- Wikipedia
		
		As Applied Here
		---------------
		The nuance difference is subtle, but handled within the notion of an "agent queue" (i.e.
		{ACTION_SEQUENCE} and its `do_*' features).
		
		do_all (action: {PROCEDURE} [TUPLE [G]])
		do_all_with_index (action: {PROCEDURE} [TUPLE [G, INTEGER_32]])
		do_if (action: {PROCEDURE} [TUPLE [G]]; test: {FUNCTION} [TUPLE [G], BOOLEAN])
		do_if_with_index (action: {PROCEDURE} [TUPLE [G, INTEGER_32]]; test: {FUNCTION} [TUPLE [G, INTEGER_32], BOOLEAN])
		
		Of particular note are the `do_if' and `do_if_with_index' features, where the caller
		must provide a Boolean `test' {FUNCTION}. Therefore, the only agents that will "fire"
		are the ones meeting the {FUNCTION} Boolean conditions as True. If this results in a
		state change remains to be seen. However, this is true of the `do_all' variety as well,
		where just because a series of agent calls are made, we have no way to know for sure
		if the resulting state will match any of the target transitions. Also, we cannot tell if
		the current state will be maintained. This is why states must have their own conditions,
		which are measured at the completion of the transition agents to determine precisely what
		state the {SM_MACHINE} is actually in. Therefore, the E-FSM is simply an FSM with transition
		agent applied (called) conditionally.
		
		Finally--it must be noted another fine nuance between the WikiPedia description and actual
		application. In the description, the conditions must be met in order to "fire" the transitions.
		In the case of our {ACTION_SEQUENCE} agent list, we call ("fire") the transition agents based
		on a {FUNCTION} Boolean condition. This really gets to the point of: How do you want it to work?
		Do you want to:
		
		(A) Fire (call) all transition code if one-or-more conditions are met?
		(B) Fire (call) each transition agent if a condition(s) is met?
		(C) Both (A) and (B)?
		
		In the case of (C), we would build the if-then-else-end condition ahead of the agent `do_if'
		calls, supplying an appropriate Boolean condition based on the if-then and passing it to
		the `do_if', which will (in-turn) call each agent conditionally.
		
		The net result is that the (C) Both answer gives us an extreme (but complex) mechanism for
		state-transitions. This may or may not be a good idea, when it comes to debugging. Before
		building such a mechanism generally, we would want a solid use-case with a clear set of
		boundaries and specifications.
		
		State Transition Operational Boundaries
		=======================================
		If a {SM_MACHINE} has a set of transition operations (represented by agents in a queue), then
		those operations (commands) ought not be callable by clients other than the {SM_MACHINE} itself.
		Moreover, operations performed by constituent objects must treat the {SM_MACHINE} state {P} Boolean
		assertions as a set of invariants on the {SM_MACHINE}--that is--after any command operation is
		called within a state, the conditions of the {SM_MACHINE} for its particular state must not be
		violated. This isolates the state transition to only those operations held within the transition
		agent list and no other, making the state mechanism stable.
		]"
	EXTENDED_EXAMPLE: "[
		A common FSM might be suitably named as: Persistence FSM, which has notions of:
		
		* Dirty/Clean - In-memory data that matches its persisted counterpart (clean) or not (dirty).
		* Saving - The process of persisting Dirty data to a repository as a transitional state to Clean.
		* Cancelling - The process of undoing data changes in Dirty data as a transitional state to Clean.
		
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
		
		Notions of Clean and Dirty imply state {P} Boolean assertions that can test object.data features
		of some collection of objects under the control of the {SM_MACHINE} for `is_dirty'. Usually, this
		is accomplished through the facility of a "setter" (i.e. `set_*'), where the setter examines the
		incoming data to determine if the data being set differs from what is already in the "data" feature
		and (if it is) sets the `is_dirty' on the object. A call to `set_dirty'
		]"
	BNFE: "[
		State_machine_cooperative ::=
			Primary_machine
			{Child_machine}+

		Primary_machine ::= State_machine
		
		Child_machine ::= State_machine

		State_machine ::=
			State_hash
			Transition_list
			Trigger_part
		
		State_hash ::= {Tuple_value, Integer_key}+
		
		Transition_list (1) ::= {Agent}+

		Trigger_part ::=
			Transit_part (4) | Auto_transit_part (5)
		
		Tuple_value (2)(3) ::= [Name_string], {Assertion_agent}+
		
		Informative Text
		----------------
		(1) A Transition_list is an {ACTION_QUEUE} of agents which are called based
			a triggering event (i.e. "call").
		(2) A Tuple_value has an optional Name_string. Programs do not need names.
			People need names. Thus, we only include the Name_string if there is
			some GUI (exported) need for people to read, even if that person is a
			programmer in debug mode. In that case, a Name_string will provide the
			needed orientation and context.
		(3) A Tuple_value has one-or-more Assertion_agent calls, which represent
			{P} conditions which validate the state as True (i.e. `is_in_state').
		(4) Transit_part implements the notion of transitting from a known start
			state to a known stop (end) state, where states are known by an ID number.
		(5) Auto_transit_part implements the notion of transitions where there is
			only one stop (end) state for each start.
		]"
	EIS: "name=finite_state_machine", "src=https://en.wikipedia.org/wiki/Finite-state_machine"
	EIS: "name=state_diagram", "src=https://en.wikipedia.org/wiki/State_diagram"
	EIS: "name=extended_fsm", "src=https://en.wikipedia.org/wiki/Extended_finite-state_machine"
	EIS: "name=event_driven_fsm", "src=https://en.wikipedia.org/wiki/Event-driven_finite-state_machine"

	glossary: "A Dictionary of Terms"
	term: "Weak-reference", "[
			A {WEAK_REFERENCE} has to do with memory pointers and garbage collection (GC).
			A weak reference is one that is ignored by the GC in its analysis of an object.
			Thus, if the only attached references in an object are weak, then the object
			will be collected.
			]"

end
