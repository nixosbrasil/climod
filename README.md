# climod

 Modular generated command line interfaces using the same technology as the NixOS module system.

## Objective
What if you could generate CLI scripts with keyword parsing and environment variables with value validation and so on using a JSON like interface, but turing complete...

Or even generate consistent CLIs for more than one programming language... (WIP, only bash atm).

Maybe integrate in your own repo or automations.

With this library and Nix now you can. See the [example](./example.nix) to get more details about how. If you nix-build it then it should generate a script on ./result that you can play with.


# What works
- Generation of bash scripts
    - Flag parsing
    - Subcommands
    - Prelude (setup code before anything but `set -eu` and shebang)
    - Your payload code just consume environment variables
    - Positional arguments. All input values are flag based so far.
# What doesn't work
    - List of things. Each flag can only be provided once.
