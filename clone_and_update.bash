#!/bin/bash

declare -a cloneList=($(cat ./list/ssh))

current_dir=$(cd $(dirname $0);pwd)

echo '{
	"folders": [' > oss.code-workspace

for ((i = 0; i < ${#cloneList[@]}; i++)) {
  project_name=$(echo "${cloneList[i]}" |  sed 's/.*\/\([^\/]*\)\.git$/\1/')
  ghq_repo_dir="./github.com"
  project_dir="${ghq_repo_dir}/${project_name}"
  echo $project_name

  echo '		{
			"path": "'${project_dir}'"
		},' >> oss.code-workspace

  if [ ! -d $project_dir ]; then
    git config --global ghq.${cloneList[i]}.root ${current_dir}
    echo $project_name clone start...
    ghq get ${cloneList[i]}
  else
    echo $project_name clone skip...
    echo $project_name update
    cd $project_dir
    git fetch
    git pull
    cd ../../
  fi
}

echo '	],
	"settings": {}
}' >> oss.code-workspace
