# state_machine
State Machine FSM Library

Finite state machines are an excellent mechanism for controlling complex object state (both deterministic and non). This library simplifies the job of complex state management with a very simple and easy to use API.

The SM_MACHINE is the heart of the library. Using the notion of "pub-sub", the machine is "told" by an SM_OBJECT how to define:

1. State assertions (Agent Boolean conditions that determine when and if an object is in-state X)
2. Transition operations (Agent features that are executed when a state-change event is triggered)
3. Trigger events (Agent features that--when called--will execute the agent transitions for a given state-to-state transition)

SM_OBJECT is a "state managed" object. Given a SM_MACHINE to this object at creation and form up the state assertions and their transitions and triggers. Once defined, all that is required to move from state to state is to call an appropriate trigger feature.

SM_TRIGGER captures the basic elements required to define a triggering event. These are easily created and added to the transitions at SM_OBJECT creation time. A call like "my_event.start ([Void]) will get the ball rolling.

If you make a call to a transition that is not legal for the current state and if you have Design-by-Contract turned on, your program will complain if you ever make an "illegal" transition.


ALSO: You will want to also get several other libraries referenced in this library: The pub-sub library, uuid, and randomizer to name a few. See the project ECF for more details on what is required. Please let us know if there are any remaining full-paths in the ECF. We try to eliminate them, but sometimes, we miss a few.
