#!/bin/bash

mkdir result

for bug_num in 72 75
do
    project_name="math$bug_num"
    echo $project_name
    mkdir result/$project_name
    defects4j checkout -p Math -v ${bug_num}b -w ./${project_name}
    
    rm -rf ${project_name}
done

#defects4j checkout -p Math -v ${bug_num}b -w ./d4j-tmp
#./gradlew run 