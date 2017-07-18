#!/bin/bash
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

if [ "$BASHRC_PROMPTCOMMAND" = "1" ]; then
	echo ""
	echo "════════════════════════════════════════════════════════════════════════════════"
	#DISPLAY System
	#echo "SYSTEM: $(cat /etc/lsb-release | grep "DESCRIPTION" | cut -d"=" -f 2 | sed 's/\"//g') $(uname -m) ($(uname -r))"

	#Display Shell
	shellname=$(ps -p $$ | awk '$1 != "PID" {print $(NF)}' | tr -d '()')
	echo "Shell: $($shellname --version | head -1)"
	unset shellname

	#Display Uptime
	if [ "$(command -v uptime)" != "" ]; then
		echo "$(uptime -p | sed 's/up/Uptime:/g')"
	fi

	#Display Time
	echo "Date:$(date +%l\:%M\ %p\ \(%Z\)\ -\ %m/%d/%y)"

	#Display HDD Info
	echo "Disk: $(df . --total -k -h  --output=source | head -2 | tail -1) [ $(df . --total -k -h  --output=used | head -2 | tail -1 | tr -d ' ')/$(df . --total -k -h  --output=size | head -2 | tail -1 | tr -d ' ') Used, $(df . --total -k -h  --output=avail | head -2 | tail -1 | tr -d ' ') Remaining ]"

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
	if [ "$(command -v acpi)" != "" ]; then
		if [ "$(acpi)" != "" ]; then
			echo "$(acpi | sed 's/Battery 0: /Laptop Battery: /g' | sed 's/Discharging, /-/g' | sed 's/ remaining/)/g' | sed 's/Charging, /+/g' | sed 's/ until charged/)/g' | sed 's/rate information unavailable/???)/g' | sed 's/, / \(/g' | sed 's/ (100%/ Power/g' | sed 's/Unknown//g')"
		fi
	fi

	#Show Jobs (if applicable)
	if [ "$(jobs -l)" != "" ]; then
		echo "Jobs: $(jobs -l | grep 'Running' | wc -l) Running, $(jobs -l | grep 'Stopped' | wc -l) Stopped"
	fi

	#Line Break
	echo "════════════════════════════════════════════════════════════════════════════════"

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