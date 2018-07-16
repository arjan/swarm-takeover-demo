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

    iex> TakeoverDemo.force_handoff()
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

## Automatic handover on node shutdown

Not featured in this demo, but the
[graceful_stop](https://github.com/botsquad/graceful_stop) package can
catch the SIGTERM signal when a node is shutdown, so if you add that
package and the following config, the running processes will be
migrated to other in the cluster upon shutdown:

    config :graceful_stop, :hooks, [
      [TakeoverDemo, :force_handoff, []]
    ]
