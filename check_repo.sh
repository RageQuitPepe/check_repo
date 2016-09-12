#!/bin/sh
#author: RageQuitPepe
#              _      _    _        
#__ ____ _ _ _(_)__ _| |__| |___ ___
#\ V / _` | '_| / _` | '_ \ / -_|_-<
# \_/\__,_|_| |_\__,_|_.__/_\___/__/
#            
PWD=${PWD}
config_file="$PWD/repos.conf"
log_file="$PWD/repo.log"
DATE=$(date)

RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;33=4m'
NC='\033[0m'

#            _      
# _ __  __ _(_)_ _  
#| '  \/ _` | | ' \ 
#|_|_|_\__,_|_|_||_|
#                
if [ ! -e $config_file ]; then
    echo "No repo-list given!"
    echo "# _ _ ___ _ __  ___ ___" >> $config_file
    echo "#| '_/ -_) '_ \/ _ (_-<" >> $config_file
    echo "#|_| \___| .__/\___/__/" >> $config_file
    echo "#|       |_|           " >> $config_file
    echo "#----------------------"
    echo "#If you want a repositorie to be skipped just add '#' at the beginning of the line" >> $config_file
    echo "#Empty lines will be skipped too, so one can structure its repository list" >> $config_file
    echo "path/to/your/repository" >> $config_file
    exit
else
    rm -f $log_file
    echo "-------------------------------" | tee -a $log_file
    echo "Repository status for $DATE" | tee -a $log_file
    echo "-------------------------------" | tee -a $log_file
    sed -e '/^\s*$/ d' -e '/^#/ d' $config_file | while read repo; do
	if [ -e $repo ]; then
		update=$false
		echo "$repo" | tee -a $log_file 
		cd "${repo}"

		git fetch 2&>1 | tee -a $log_file

		LOCAL=$(git rev-parse @)
		REMOTE=$(git rev-parse @{u})
		BASE=$(git merge-base @ @{u})

		#check is based on: http://stackoverflow.com/a/3278427
		if [ $LOCAL = $REMOTE ]; then
		    echo -e "${GREEN}Up-to-date${NC}"
		    echo "Up-to-date" >> $log_file
		elif [ $LOCAL = $BASE ]; then
		    echo -e "${ORANGE}Need to pull${NC}"
		    echo "Need to pull" >> $log_file
		    update=$true
		elif [ $REMOTE = $BASE ]; then
		    echo -e "${BLUE}Need to push${NC}"
		    echo "Need to push" >> $log_file
		else
		    echo -e "${RED}Diverged${NC}"
		    echo "Diverged" >> $log_file
		fi

		#git update is explained by http://stackoverflow.com/a/17101140
		#i.e: git config --global alias.update '!git remote update -p; git merge --ff-only @{u}'
		if [ $update == $true ]; then
			git update | tee -a $log_file
		fi
		echo "-------------------------------" | tee -a $log_file
	else
		echo -e "${RED}Repository $repo does not exist!${NC}"
		echo "Repository $repo does not exist!" >> $log_file
	fi
    done #<$config_file
fi
