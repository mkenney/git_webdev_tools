#!/bin/sh

#
# I should put some comments here and stuff...
#
#
#
#


# Use absolute path
script_path=$(cd `dirname "$0"` && pwd -P)
script_name=$(basename ${0})

# List required sub-modules
SUBMODULE_URL[1]="https://github.com/mkenney/git_webdev_tools.git"
SUBMODULE_PATH[1]="git-webdev-tools"

# whereami
CURRENT_MODULE=`git remote -v | tail -1 | cut -d' ' -f 1 | rev | cut -d'/' -f 1 | rev`

# First run, checkout submdules and update this script
if [[ "${1}" != "updated" ]]; then

	echo
	echo
	echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo " Configuring ${CURRENT_MODULE} for development: ${script_path}/${script_name}"
	echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo
	echo

	echo -e " Checking out submodules... \c"
	command git submodule --quiet init
	command git submodule --quiet update
	echo Done.
	echo " -------------------------------------------------------"


	echo -e " Adding missing submodules... \c"
	# remove existing modules from the list
	while read module; do
		for (( i=1; i<=${#SUBMODULE_URL[@]}; i++ )); do
			if [[ "${SUBMODULE_URL[$i]}" == "${module}" ]]; then
				SUBMODULE_URL[$i]=""
				SUBMODULE_PATH[$i]=""
			fi
		done
	done <<< "$(git submodule --quiet foreach "git remote -v | tail -1 | cut -d' ' -f 1 | cut -d':' -f 2 | rev | sed 's/^\/*//g' | cut -d'/' -f 1 | rev")"
	# add all remaining submodules
	for (( i=1; i<=${#SUBMODULE_URL[@]}; i++ )); do
		if [[ "${SUBMODULE_URL[$i]}" != "" ]] && [[ "${SUBMODULE_URL[$i]}" != "${CURRENT_MODULE}" ]]; then
			echo
			echo -e "	Adding ${SUBMODULE_URL[$i]} --> ${SUBMODULE_PATH[$i]}... \c"
			command git submodule add ${SUBMODULE_URL[$i]} ${SUBMODULE_PATH[$i]}
			echo Done.
			echo "	-------------------------------------------------------"
		fi
	done
	echo Done.
	echo " -------------------------------------------------------"


	if [ -f "${script_path}/git-webdev-tools/devsetup.sh" ]; then
		echo " *** Updating THIS script (${script_path}/${script_name}) from master... ***"
		echo " -------------------------------------------------------"
		cd ${script_path}/git-webdev-tools
		git checkout master && git pull
		cd ${script_path}
		command cp --remove-destination git-webdev-tools/devsetup.sh ${script_name}
		echo Done.
		echo " -------------------------------------------------------"
		echo " Restarting..."
		echo " -------------------------------------------------------"
		command ${0} updated
		exit 0
	fi
fi


# Second run
#	setup commit hooks
#	run submodule setup scripts
#	checkout modules in devsetup.conf and run all devsetup.sh scripts

echo -e " Setting up pre-commit hook... \c"
cd ${script_path} && command ln -fs ../../git-webdev-tools/git/hooks/pre-commit .git/hooks/pre-commit
echo Done.
echo " -------------------------------------------------------"


echo -e " Setting up prepare-commit-msg hook... \c"
cd ${script_path} && command ln -fs ../../git-webdev-tools/git/hooks/prepare-commit-msg .git/hooks/prepare-commit-msg
echo Done.
echo " -------------------------------------------------------"


echo -e " Adding commit-msg hook for Gerrit Commit-Ids... \c"
cd ${script_path} && command ln -fs ../../git-webdev-tools/git/hooks/commit-msg .git/hooks/commit-msg
echo Done.
echo " -------------------------------------------------------"


echo " Running submodule setup scripts...."
while read path; do
	if [ -f "${script_path}/${path}/devsetup.sh" ] && [[ "${path}" != "git-webdev-tools" ]]; then
		echo "	${script_path}/${path}..."
		cd ${script_path}/${path} && command sh ./devsetup.sh && cd ${script_path}
	fi
done <<< "$(git submodule --quiet foreach 'echo $path')"
echo Done.
echo " -------------------------------------------------------"


if [ -f "${script_path}/devsetup.conf" ]; then
	echo
	echo " Checking out configured modules (devsetup.conf)..."
	echo " -------------------------------------------------------"
	source ${script_path}/devsetup.conf

	for (( i=1; i<=${#MODULE_URL[@]}; i++ ))
	do
		if [ -d ${MODULE_PATH[$i]} ]; then
			echo "	${MODULE_PATH[$i]} already exists."
		else
			echo -e "	Cloning ${MODULE_URL[$i]} into ./${MODULE_PATH[$i]}/... \c"

			clone_command="git clone ssh://gerrit/${MODULE_URL[$i]}"
			if [[ -n ${BRANCH[$i]} && ${BRANCH[$i]} != "master" ]]; then
				clone_command="${clone_command} --branch ${BRANCH[$i]}"
			fi

			command ${clone_command} ${MODULE_PATH[$i]}
			if [ -f "${MODULE_PATH[$i]}/devsetup.sh" ]; then
				cd ${script_path}/${MODULE_PATH[$i]} && command sh ./devsetup.sh && cd ${script_path}
			fi

			if [ $? -ne 0 ]; then
				echo "There was a problem cloning ${MODULE_URL[$i]}, please verify your git configuration and internet connection."
				exit 1
			else
				echo Done.
			fi
		fi
	done
fi
