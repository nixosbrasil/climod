## action

Attr of the action code itself of the command or subcommand for each language that you want to support

#### type

attribute set of string


#### default

```nix
{
  action = {
    bash = "exit 0";
    c = "exit(0);";
  };
}
```


## allowExtraArguments

Allow the command to receive unmatched arguments

#### type

boolean


#### default

```nix
{
  allowExtraArguments = false;
}
```


## description

Command description

#### type

string


#### default

```nix
{
  description = "Example cli script generated with nix";
}
```


## flags

Command flags

#### type

list of submodule


#### default

```nix
{
  flags = [];
}
```


## flags.*.description

Description of the flag value

#### type

string


#### default

```nix
{
  flags.*.description = "";
}
```


## flags.*.keywords

Which keywords refer to this flag

#### type

non-empty list of string matching the pattern -[a-zA-Z0-9]|-(-[a-z0-9]*)


#### default

```nix
{
  flags.*.keywords = [];
}
```


## flags.*.required

Is the value required?

#### type

boolean


#### default

```nix
{
  flags.*.required = false;
}
```


## flags.*.validator

Command to run passing the input to validate the flag value

#### type

string


#### default

```nix
{
  flags.*.validator = "any";
}
```


## flags.*.variable

Variable to store the result

#### type

string matching the pattern [A-Z][A-Z_]*




## name

Name of the command shown on --help

#### type

string matching the pattern [a-zA-Z0-9_][a-zA-Z0-9_\-]*


#### default

```nix
{
  name = "example";
}
```


## subcommands

Subcommands has all the attributes of commands, even subcommands...

#### type

attribute set of submodule


#### default

```nix
{
  subcommands = {};
}
```


## subcommands.&lt;name&gt;.name

This is a recursive from command

#### type

string


#### default

```nix
{
  subcommands.<name>.name = "...";
}
```


## target.bash.code

Code output

#### type

strings concatenated with "\n"




## target.bash.drv

Package using the shell script version as a binary

#### type

package




## target.bash.prelude

Stuff that must be added before the argument parser

#### type

strings concatenated with "\n"


#### default

```nix
{
  target.bash.prelude = "";
}
```


## target.bash.shebang

Script shebang

#### type

string


#### default

```nix
{
  target.bash.shebang = "#!/usr/bin/env bash";
}
```


## target.bash.validators

Parameter validators

#### type

attribute set of string



