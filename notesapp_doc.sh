#!/bin/bash

command=$1 # can be find with 'help' command 
action=$2 # what we want
if [ $# = "0" ];then
echo "Usage : ./noteapp help"
fi


# create a note with ext .note
if [ "$command" = "create" ]; then  
str=$(find . -name $action".note")
filename="${str%.*}"
filename=${filename##*.}
filename=${filename///}
if [ "$action" = "$filename" ]; then
echo "Already there..."

else
touch $action".note"
echo "note created : $action".note""
date_created=`date +"%d-%m-%Y"`
echo -e "\e[31mdate_created\e[0m  : {$date_created}" > $action".note"
fi
fi


# add contents to note
if [ "$command" = "add" ] && [ $# = 2 ] ; then  
str=$(find . -name $action".note")
filename="${str%.*}"
filename=${filename##*.}
filename=${filename///}
if [ "$action" = "$filename" ]; then
#echo "Already there..."
while read lines
do
  # break if the line is empty
  [ -z "$lines" ] && break
  echo "  $lines" >> "$filename.note"
done
fff=$filename".note"
modified=`stat -c %y "$fff"`
echo -e "\e[30mdate_modified\e[0m  : {$modified}" >> $action".note"

else
#touch $action".note"
echo "note found : False\n create one."
# we can also show the option to create a note here
fi
fi

# add task
if [ "$command" = "add" ] && [ $action = "task" ]  && [ $# = 3 ]; then  
#echo "[ ] $3 " >> all".task"
echo "$3 " >> all".task"
echo task added
fi


# find a note
if [ "$command" = "find" ] && [ $action = "note" ] ; then  
str=$(find . -name $3".note")
filename="${str%.*}"
filename=${filename##*.}
filename=${filename///}
if [ "$3" = "$filename" ]; then
echo "YES..."
echo $str
else
echo "Not found"
fi
fi


# find phrase in all notes
if [ "$command" = "find" ] && [ $action = "data" ]; then  
grep -liR "$3" *
fi

# show note
if [ "$command" = "show" ] && [ $# = 2 ] && [ $2 != "task" ]; then  
cat < "$action".note 
fi

# delete a note
if [ "$command" = "delete" ] ; then  
rm "$action".note 
fi

if [ "$command" = "help" ] ; then  
#echo "Welcome"
clear
#figlet Bash-Note-Task
echo "Bash : NoteApp"
echo "List of commands"
echo "./noteapp create note1 "
echo "./noteapp add note1" 
echo "./noteapp show note1 "
echo "./noteapp delete note1 "
echo "./noteapp find note note "
echo "./noteapp find data "
echo "./noteapp add task 'task name' "
echo "./noteapp show task  "
fi


# show all tasks
if [ "$command" = "show" ] && [ $action = "task" ] ; then  
options=()
readarray -t a < all.task
for i in "${a[@]}"; do 
options+=("$i")
done

menu() {
    i=1;
    echo "All Task''s:"
	while read -r line; do name="$line"; 
	echo "$i) $name" ; i=$((i+1)); done < all.task 
   }

prompt="Check task (ENTER when done): "
while menu && read -rp "$prompt" num && [[ "$num" ]]; do
	msg_task=$(sed "${num}q;d"  all.task)
	msg_task_checked=$(echo -e "\e[9m$msg_task\e[0m")
	flag=$(echo $?)
	if [[ $msg_task == *"[0m"* ]]; then
 		 msg_task_unchecked=$(echo ${msg_task:4:${#msg_task}})
 		 echo $msg_task_unchecked # we got that, 
 		 # echo remove last 3 char
 		# sed -i "$num s/$msg_task_checked/$v2/" all.task # problem
 	else
	 	sed -i "$num s/$msg_task/$msg_task_checked/" all.task
	fi
   done
fi
