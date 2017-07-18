# Bash-Prompt-Script
A script I use for displaying info about my systems as I work
I find it immenstly useful

## What all does it display?
Shell Name and version

Uptime (REQUIRES: procps)

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

If at any point you need extra room in your terminal, you can mute it's output with `BASHRC_PROMPTCOMMAND="0"`