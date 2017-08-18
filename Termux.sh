#!/data/data/com.termux/files/usr/bin/bash
#Informational Prompt Script
#
#Compatabillity Tested: GNU Bash, zsh

lastcmdexit="$?"

echo -ne "\e[32m"
#Check to see if run prompt
if [ "$BASHRC_PROMPTCOMMAND" = "" ]; then
	#Variable not set, set to default
	BASHRC_PROMPTCOMMAND="1"
else
	echo -n ""
fi

if [ "$BASHRC_PROMPTCOMMAND" = "1" -o "$BASHRC_PROMPTCOMMAND" = "3" ]; then
	echo ""
	echo "════════════════════════════════════════════════════════════════════════════════"
	#DISPLAY System
	#echo "SYSTEM: $(cat /etc/lsb-release | grep "DESCRIPTION" | cut -d"=" -f 2 | sed 's/\"//g') $(uname -m) ($(uname -r))"

	#Display Shell
	shellname=$(ps -o pid,comm | grep "^$$" | cut -d' ' -f 2)
	echo "Shell: $($shellname --version | head -1)"
	unset shellname

	#Display Uptime
	if [ "$(command -v uptime)" != "" ]; then
		echo "Uptime: $(uptime | sed 's/up /up\n/g' | tail -1 | sed 's/  / /g' | sed 's/, load.*$//g')"
	fi

	#Display Time
	echo "Date:$(date +%l\:%M\ %p\ \(%Z\)\ -\ %m/%d/%y)"

	#Display HDD Info
	#df $(pwd) | tail -1 | tr ' '  | grep -v "^$" | tr '\n' '|'
	echo "Disk: $(df $(pwd) | tail -1 | tr ' ' '\n' | grep -v "^$" | grep -v "^\/" | tr '\n' '/' | cut -d'/' -f 2)/$(df $(pwd) | tail -1 | tr ' ' '\n' | grep -v "^$" | grep -v "^\/" | tr '\n' '/' | cut -d'/' -f 1) Used, $(df $(pwd) | tail -1 | tr ' ' '\n' | grep -v "^$" | grep -v "^\/" | tr '\n' '/' | cut -d'/' -f 3) Remaining"

	#Display GIT status
	if [ "$(command -v git)" != "" ]; then
		gitstatus=$(git status 2>&1)
		if [ "$(echo "$gitstatus" | grep "fatal: Not a git repository")" = "" ]; then
			echo -n "Git: "
			#Display Branch Name
			if [ "$(echo "$gitstatus" | grep "Untracked files:")" != "" -o "$(echo "$gitstatus" | grep "Changes not staged for commit:")" != "" -o "$(echo "$gitstatus" | grep "Your branch is ahead of")" != "" ]; then
				echo -en "\e[31m"
				gitcheck="true"
			fi

			echo -en "$(echo "$gitstatus" | grep "On branch" | sed 's/On branch //g')"
			if [ "$gitcheck" = "true" ]; then
				echo -ne " (See 'git status')\e[32m"
			else
				echo -ne " (Normal)\e[32m"
			fi


			unset gitcheck
			echo ""
		fi
	fi

	#Display Battery info
	#Android does this on it's own

	#Show Jobs (if applicable)
	if [ "$(jobs -l)" != "" ]; then
		echo "Jobs: $(jobs -l | grep 'Running' | wc -l) Running, $(jobs -l | grep 'Stopped' | wc -l) Stopped"
	fi

	#Line Break
	echo "════════════════════════════════════════════════════════════════════════════════"
fi

if [ "$BASHRC_PROMPTCOMMAND" = "1" -o "$BASHRC_PROMPTCOMMAND" = "2" ]; then
	#Insert Indicator for Command Exit
	if [ "$lastcmdexit" != "0" ]; then
		echo -en "\e[31;2mError Code: $lastcmdexit - "
		if [ "$lastcmdexit" = "1" ]; then
			echo "Misc. Error"
		elif [ "$lastcmdexit" = "2" ]; then
			echo "Missing Keyword/Command, permission problem, or diff comparison fail"
		elif [ "$lastcmdexit" = "126" ]; then
			echo "Cannot Execute. (Permission Denied or Not an executable)"
		elif [ "$lastcmdexit" = "127" ]; then
			echo "Command Not Found"
		elif [ "$lastcmdexit" = "128" ]; then
			echo "Invalid Argument to exit"
		elif [ "$lastcmdexit" = "128+n" ]; then
			echo "Fatal Error Signal, Killed."
		elif [ "$lastcmdexit" = "130" ]; then
			echo "Signal Interrupt (CTRL+C)"
		elif [ "$lastcmdexit" = "255*" ]; then
			echo "Exit Status Out of Range"
		else
			echo "Unknown Error"
		fi
		echo -en "\e[0m"
		unset lastcmdexit
	fi
fi
