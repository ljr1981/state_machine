note
	description: "[
		Representation of a {MOCK_DOOR}
		]"
	design: "[
		Basic Workflow
		==============
		The following represents the basic workflow/use-case for this object.
		
		Pre-requisite/Precondition
		--------------------------
		- Create DOOR
		- DOOR is in Closed state

		Open
		----
		- DOOR receives "open-door" signal (from itself or external)
		- DOOR processes "open-door" signal
		- DOOR signals "open-door" event trigger command

		- FSM receives "open-door" event trigger command
		- FSM processes "open-door" transitions
		- FSM signals "post-open-door" event trigger command

		- DOOR receives/processes "post-open-door" event trigger command
		- DOOR processes "post-open-door" operation
		
		Prep-based-on-Open
		------------------
		- 
		]"

class
	MOCK_DOOR

inherit
	PS_SUBSCRIBER [ANY]
		rename
			add_subscription as add_post_transition_event
		end

	PS_PUBLISHER [ANY]
		rename
			add_subscription as add_transition_event
		end

create
	make_closed,
	make_opened

feature {NONE} -- Initialization

	make_opened
			-- `make_opened'.
		do
			opened := True
			fully_opened := True
			initialize
		ensure
			open: opened
			not_closed: not closed and not fully_closed
		end

	make_closed
			-- `make_closed'.
		do
			closed := True
			fully_closed := True
			initialize
		ensure
			closed: closed and fully_closed
			not_open: not opened and not fully_opened
		end

	initialize
			-- `initialize' Current {MOCK_DOOR}.
		do
				-- Publish an event for opening the door
			create on_open_publication
			add_publication (on_open_publication)
				-- Handle a subscription to the post-opening event
			create on_post_open_subscription
			add_subscriptions (<<on_post_open_subscription>>)
		end

feature -- Event Publications

	on_open_publication: PS_PUBLICATION [ANY]

feature -- Event Subscriptions

	on_post_open_subscription: PS_SUBSCRIPTION [ANY]

feature -- Basic Operations

	open
			-- `open' to `opened' through state machine.
		do
			on_open_publication.set_data_and_publish (Void)
		end

	close
			-- `close' to `closed' through state machine.
		do

		end

feature -- Settings

	set_opened
		do
			closed := False
			fully_closed := False
			opened := True
		end

	set_closed
		do

		end

feature -- Event Handlers

	on_open (a_data: ANY)
			-- What happens `on_open' event?
		require
			closed: closed and fully_closed
		do
			set_opened
		ensure
			not_closed: not closed and not fully_closed
			opened: opened
		end

	on_post_open (a_data: ANY)
			-- What happens after `on_open_event'
		require
			not_closed: not closed and not fully_closed
			opened: opened
		do
			fully_opened := True
		ensure
			not_closed: not closed and not fully_closed
			opened: opened and fully_opened
		end

	on_close
			-- What happens `on_close' event?
		do

		end

feature -- Status Report

	opened: BOOLEAN

	fully_opened: BOOLEAN

	closed: BOOLEAN

	fully_closed: BOOLEAN

end
