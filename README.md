# Followermaze

By Julian Simioni

## Instructions

Run followermaze.rb for the main application.
Run test/test.rb for tests.

## Design

I implemented the followermaze in Ruby as a collection of mostly-isolated
classes that chain together to form a pipeline. At one end is the event source
socket, and the last stage of the pipeline is the user client socket. The
intermediate steps of the pipeline each handle one small part of ensuring the
correct events are sent to the correct client.

### Data Classes

Separate from each step of the pipeline are classes that represent some sort of
data. These each have minimal logic and often expose member variables directly.
They're mostly used like a C struct and simply passed around without
modification as needed. The data objects are:

#### Event

Represents one of the events that has come in through the event source. There
are separate fields for sequence number, event type, the id of the to/from user
(if needed), and a string storing the full text of the event exactly as passed
in.

#### Message

Since different Event types have different requirements for notification, its
useful to have a separate class that represents a message (an event) that should
actually be sent to a connected user. The Message class stores an event, and a
single recipient (an integer user id). For events that would result in
notification of several users, several messages, each addressed to a distinct
user, will be created. Some events require no notification and would have no
messages associated with them.

#### User

A User object is simply an id and a list of followers (stored as references to
other user objects).

### Pipeline Classes

#### SocketLineReader

Takes a socket, reads from it, and passes one line of data at a time (as a
String), to the next pipeline stage.

#### EventDecoder

Takes input as a series of lines, and passes fully formed Event objects to the
next pipeline stage. All logic for parsing events lives here rather than in the
Event class.

#### Sequencer

Takes input as a series of Event objects, and simply forwards those events on to
the next pipeline stage. However, it ensures that events are forwarded strictly
in order by sequence number, with no missing sequence numbers allowed.

#### UserCollector

Event objects simply store a user id for the to/from fields as an integer. The
UserCollector looks at those fields if they are present, and instructs the
UserDatabase to create a new user for that id, if one is not already present. In
this way all subsequent pipeline steps can be sure that there are User objects
for any user ids seen in an Event.

#### FollowerManager

Tracking changes in followers is kept separate in the FollowerManager. In
general, it forwards every event it sees on to the next pipeline stage without
modification or without even taking any action. However, in the case of follow
and unfollow events, the FollowerManager ensures that the appropriate User's
follower list is updated.

#### MessageBuilder

The MessageBuilder takes events, which may have to be sent to many, one, or zero
connected clients, and builds an appropriate number of Message objects such that
for each User that should see an Event, there is exactly one Message. All of
these messages are passed on to the next pipeline step.

#### UserConnectionManager

The UserConnectionManager takes a socket, where user clients are expected to
connect, and sends each separate connection to its own UserConnection. It keeps
track of which user id is associated with each connection, and then uses that to
forward any Message objects it receives to the appropriate UserConnection. Each
UserConnection, and the main body of the connection manager that listens for new
connections, runs in its own thread.

#### UserConnection

A UserConnection is created with a socket that is expected to be an already
active connection to a specific user client. When passed a Message, it extracts
the payload from the Event contained within the Message, and writes it to the
socket.

#### UserDatabase

The UserDatabase is technically outside of the pipeline, but is used by several
steps that require access to User objects. It only has three methods:

add: takes an id and returns the User object with that id. The User will be
created if it doesn't already exist, but calling add a second time will be the
same as a call to `get`

get: returns a user for the given id or nil if it doesn't exist

all: returns an array of all users in the database


### Testing

I built each pipeline object mostly separately, in a mostly TDD fashion. It took
a few tries at implementing various bits of functionality before the overall
design became clear. In particular the separation between a Message and an Event
came about only after the logic for deciding when to message a particular user
given only an Event became complicated. All the experimental bits of code are in
spike branches to see how the design has evolved.

Once all pipeline steps was solidified individually, they were reimplemented
(sometimes by starting with the implementation from a spike) and tested a little
bit more fully, again only at the unit level.

Next I started integration testing. My biggest concern was ensuring that a real
TCP socket would behave the same as my fake sockets (using the StringIO class)
in the unit tests. There's one integration test for the event source socket, and
one for the user client socket. The integration tests actually just run a shell
command that launches a server and client ruby instance, and then makes simple
assertions about their outputs. This is a bit fragile, but it means that there
are real TCP connections involved, so the tests account for any differences
between StringIO objects and a real socket.

Additionally, the user client integration test can use multiple threads to
connect to multiple clients without blocking. Unit testing threaded code is also
scary. Initially I simply called Thread.start directly in my application code,
and called sleep for a short time in the unit test code to ensure things
happened in the correct order. After a little research, I borrowed the
`Executor` abstraction which is popular in Java, and for testing created a
FakeThread class that has a `start` method and executes a block in the same
thread. Now the unit tests operate in a single thread with no calls to sleep
required, but the integration tests DO use threads.

I also tested every internal class in the pipeline (from EventDecoder to
MessageBuilder) together, implementing a few representative test cases from the
behavior of each pipeline step. The tests certainly aren't comprehensive but I
did find quite a cases where different classes had implementations that didn't
work perfectly together. Fortunately it was mostly easy to fix and didn't
require any design changes.

Finally, I built the followermaze program itself, which is just a few lines
connecting two sockets to all the pipeline steps. I did just a couple manual
tests here using two instances of netcat. The only bug I found was an error
handling line endings for broadcast events.

Last but not least I ran the provided test suite. I'm extremely proud to say it
succeeded the first time I ran it!

## Performance and scalability

Other than using reasonably appropriate data structures for the few places where
they are present (for example using a hash instead of an array when all accesses
will be looking for one particular item), I didn't do much to ensure the
performance of this code. Almost certainly an implementation that uses fewer
objects would be faster, since every traversal through the pipeline means the
call stack grows to the size of the pipeline. That said, when run against the
provided test program, the test program was using (over) 100% CPU, while the
application itself was using only 40%. This leads me to believe that its
performance is at least decent. I also ran the code with JRuby, and it ran in
about the same time.

Instead of micro-optimizations, my focus for this code was ease of testing and a
design that has a reasonable path to scale beyond a single machine. I've
rarely written code where I listened so closely to what the tests were telling
me: many separate objects in the final implementation started as one object,
until it became clear that object would be too complicated to test. Having more
than a few lines of setup code was a clear indication a new class was needed.

Regarding scalability, while not much can be done with MRI, with JRuby each
pipeline step could be run in its own thread with just a little work to separate
pipeline classes. To scale further, most pipeline steps could send there results
to a shared data store like Redis or Memcache, and then other machines could
take items from that data store and continue processing them.
