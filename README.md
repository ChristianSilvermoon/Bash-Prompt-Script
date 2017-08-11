# Bash-Prompt-Script
A script I use for displaying info about my systems as I work
I find it immenstly useful

## What all does it display?
Shell Name and version

Uptime (REQUIRES: `procps`)

Time and Date

Disk usage for current file system (that the working directory is on)

Git Branch name (Green if nomal, red if ahead of remote, uncommited changes, or untracked files) (REQUIRES: `git`)

Battery info if a battery is present (REQUIRES: `acpi`)

Jobs if any are running

Exit Code info if last process exited with non-zero

## How do I use this?
The script was designed to work with GNU Bash, but should also run in ZSH

Add the following lines to your `.bashrc`

```bash
PROMPT_COMMAND="source ~/.path-to-script.sh"
```

## Modes
The prompt script relies on the variable `BASHRC_PROMPTCOMMAND` for how it should behave.

| Value | Behavior |
| :---: | ---------|
| NULL  | Sets `BASHRC_PROMPTCOMMAND` to "1" |
| 0     | Outputs Nothing |
| 1     | Outputs Info Box and Exit Code |
| 2     | Outputs Exit Code Only |
| 3     | Outputs Info Box Only |