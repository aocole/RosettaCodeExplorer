PairUp!™
========

A Pair Programming Station that runs as a Stackato Application.

This Stackato app will create a pairing programming environment that is clean,
secure, repeatable, and quick-n-easy to setup.

Initial Setup
-------------

You'll need admin access to a Stackato (1.2 or higher) VM. There are several
ways to gain such access, but one way is to install your own with this
command:

    curl get.stackato.com/microcloud | bash
    # Note, as of the middle of 2012, this only works for Ubuntu and OSX
    # Other systems will have to tweak the script, or otherwise install the VM
    # image manually.

If you don't already have it (or need the latest version) download the
[Stackato client](http://www.activestate.com/stackato/download_client), and
install it in your path as `stackato`.

Now you need to outline which users will be in the group for the session. You
can use the web UI for this, or the stackato command line client. Starting
from a new VM, it would look something like this:

    git clone git@github.com:PairUp/pairup.git
    cd pairup
    alias s=stackato # (for convenience)
    s target api.your.stackato.vm.domain
    s register yourself@example.com
    s register yourpair@example.com
    s login yourself@example.com
    s groups create pair
    s groups add-user pair yourself@example.com
    s groups add-user pair yourpair@example.com
    s group pair
    bin/pairup conf confs/rkingy-pairup-conf.sh

This `conf/*.sh` file defines these parts:
* `$PAIRUP_DOTS_CONF_REPO`, for example
  `git@github.com:ouicode/rkingy-dots-conf.git`. This is a repo with a
  `./configure` script that downloads your dotfile-installer (in this case
  [...](http://github.com/ingydotnet/....git), then uses it to put you and
  yourpair's config files into `$HOME`.
  <!-- Actually, bin/pairup does this based on the env var. rkingy-dots-conf
  is going to end up being a simple conf file, perhaps in a gist. -->
* `$PAIRUP_START_COMMANDS`, which is a snippet that is run per user, per
  session. In our case it looks for an existing `tmux` and attaches, or else
  starts `tmux`.
* `$PAIRUP_UPDATE_COMMANDS`, which probably:
    * Uses `apt-get` to install any Ubuntu packages that we want to have
      available in our session.
    * Downloads personal project repos into `~/src/` so you're ready to get to
      the coding right away.
    * Runs miscellaneous program-specific installers.
* Optionally primes the `~/.ssh/authorized_keys` into
  `$PAIRUP_SSH_KNOWN_HOSTS` to elimitnate the need to tell `ssh` "yes" during
  the rest of the install.

Note: These parts are still in flux, and are getting better every day, so
expect the preferred practices to change a bit. Still, keep in mind that this
is merely levels of improvement on top of the existing Stackato VM. If you
wanted, you could use some other config+screen sharing mechanism, or even run
all the setup manually every time.

Per-Pairup Setup
----------------

You will want to start a PairUp!™ instance:

* Initially.
* Whenever starting a new project, especially if with a new "yourpair".
* Whenever you want a "clean room", e.g. if your previous session involved
  some intense config, and you want to verify that it works if from scratch.

Each time you do this, you will:

    stackato group # To verify that you have `stackato group pair` set.
    bin/pairup create pairup-proj1
    bin/pairup ssh pairup-proj1

<!-- add section about 1.2 forward bug and also 1.2 ssh bug -->

Now you are inside the pairing container. Run (something like) these commands:

   pairup init
   pairup update

If you want to do other stuff while `pairup update` runs, you can insert a
`pairup start` command in between those two (or, actually, simply `pairup` ┈
since `start` is the default command).

Yourpair's Setup
----------------

While you're running the "Per-Pairup Setup" section, yourpair@ can go ahead
and get the [Stackato
client](http://www.activestate.com/stackato/download_client).

…then do:

    alias s=stackato
    s target api.your.stackato.vm.domain
    s login yourpair@example.com
    s group pair

After the host's `pairup create pairup-proj1`` is done, yourpair@ can then do

    bin/pairup ssh pairup-proj1

Still, they won't have much to do until `pairup init` is run, and then after
that they'll still have to wait for `pairup update` to finish before they can
`pairup start` into a nicely-setup session.  But, of course, this all depends
on your needs. If your pair is better at setting systems up, perhaps they
should be the `pairup update`er, or you could watch it happen together.

Per-session Commands
--------------------

After the above prep has been done once, whenever it's time to work on that
VM, both you and your pair will do the following:

    bin/pairup ssh pairup-proj1

Then from within the VM:

    pairup

Whoever is the first to do it creates a `tmux` session, and the second one
will do a `tmux attach`. Note that, currently, the person who starts the
session is the one whose SSH keys are used, and also note that these keys will
only forward from `tmux` window 0.

Destroying Sessions
-------------------

Any time you do 'stackato stop pairup-proj1', the disk will be reset (that is,
for now ┈ before long we will persist this storage). Then, you can clean out
the app itself by doing `stackato delete pairup-proj1`. A `stackato apps` will
show you the list, which no longer includes `pairup-proj1`.


Happy hacking.
