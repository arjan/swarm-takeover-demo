# TakeoverDemo

Demonstration for Swarm process takeover, a.k.a. how to do keep your
GenServer states without doing hot upgrades.

## Usage:

In different terminal windows, start a cluster with nodes a and b:

    $ ./run.sh a
    $ ./run.sh b

Then start a counter process in one of the `iex` sessions:

    1> TakeoverDemo.Counter.start :one
    {:ok, #PID<0.197.0>}

You see a counter starting to tick, either in your current terminal or
in the other one (Swarm decides on which node it really spawns).

Check that it is running:

    iex> Swarm.registered()
    [{{:counter, :one}, #PID<0.197.0>}]

Now force the handoff to the other node:

    iex> TakeoverDemo
    16:37:10.892 [warn]  Performing forced handoff for :one
    [:ok]

Observe the terminal other window:

    16:37:10.901 [warn]  Resuming process with state: {:one, 23}

And verify that the pid has changed:

    iex> Swarm.registered()
    [{{:counter, :one}, #PID<16169.196.0>}]

Notice that the counter keeps its value, and keeps increasing! So the
genserver has moved to the other node, while keeping its state. Bingo
:-)
