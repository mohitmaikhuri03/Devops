#!/bin/bash

cond=$1
path=$2
name=$3
cont=$4
cont2=$5
#Create a directory
case $cond in 
addDir)
mkdir $path/$name
;;
#Delete a directory
deleteDir)
rm -rf $path/$name
;;
#List content of directory
listContent)
ls $path
;;
#Only list files of directory
listFiles)
find $path -maxdepth 1 -type f
;;
#Only list directories
listDirs)
find $path -maxdepth 1 -type d
;;
#list all content of directory
listAll)
ls -a $path
;;
#Create an empty file
addFile)
touch $path/$name | echo "$cont" >> $path/$name
;;
#Add content to file
addContentToFile)
echo "$cont" >> $path/$name
;;
#Add content to begining 
addContentToFileBegining)
echo "$cont" | cat - $path/$name > $path/temp && mv $path/temp $path/$name
;;
#Show top n lines of a file
showFileBeginingContent)
head -n $cont $path/$name
;;
#Show last n lines of a file
showFileEndContent)
tail -n $cont $path/$name
;;
#Show contents of a specific line number
showFileContentAtLine)
awk "NR==$cont" $path/$name
;;
#Show conteint of a specfific line number range
showFileContentForLineRange)
awk "NR>=$cont && NR<=$cont2" $path/$name
;;
#Move file from one location to another
moveFile)
mv $path $name
;;
#Copy file from one location to another
copyFile)
cp $path $name
;;
#Delete file
deleteFile)
rm -r $path/$name
;;
esac
