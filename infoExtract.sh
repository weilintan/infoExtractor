#!/bin/bash
#System Info Extractor Script

#Get public IP
#the command inside the brackets is executed and stored in a variable to
#be used later on
#curl command enables data transfer/communicate over the network with 
#web/application server. the -s option is to prevent it from reporting
#the progress of the data retrieval
#"dig @resolver1.opendns.com myip.opendns.com +short" is another method
#to get the public IP by using the dns server incase the website changes
pubIP=$(curl -s ifconfig.io)

#Get private IP
#the hostname -I option is used to display all the network addresses assigned
#to the host. head -n1 will only output the first IP address associated 
#with the current host
priIP=$(hostname -I | head -n1)

#the use of -e is to enable the use of backslash interpretation
echo -e "Your Public IP is $pubIP\n"
echo -e "Your Private IP is $priIP\n"

#Get MAC address
#the awk command is used for parsing each line into fields and allowing
#you to perform actions based on patterns and conditions. it extracts
#the second field from the line containing the word ether.
macAddr=$(ifconfig | awk '/ether/ {print $2}')
#mask the first 3 octet of the mac address
#-F: is the field separator for colon symbol
#$4, $5, $6 is the field variable for the last 3 octet of MAC address
maskedMac=$(echo $macAddr | awk -F: '{print ("XX:XX:XX:"$4 ":" $5 ":" $6)}')
echo -e "Your MAC Address is $maskedMac\n"


#get top 5 process CPU usage
#ps command is used to report a snapshot of the current processes.
#it display info about active processes on the system.
#-eo option specifies the output format for the ps command. it allows you 
#to customize the fields that are displayed for each process.
#user,pid,ppid,cmd,%mem,%cpu
#--sort=-%cpu sort the output based on the CPU usage field in descending order
#head -n6 used to display the first 6 lines which includes the title and
#top 5 process
topCPUusage=$(ps -eo user,pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n6)
echo -e "Your Top 5 process's CPU usage\n $topCPUusage\n"

#total, used and available memory
#free -h display the total, used and available memory of the system in 
#human readable format in mebibytes.
#one mebibyte (MiB) is equal to 2^20 bytes, or 1,048,576 bytes. 
#it's often used in the context of computer memory and storage.
memStat=$(free -h | awk '/Mem:/ {print "Total:", $2, "Used:", $3, "Free:", $4}')
echo -e "Your total, used and available memory is\n $memStat\n"

#active system services with their status
#the command is used to list all current running services.
#providing information such as the service name, load, sub-state and description
actServices=$(systemctl --type=service --state=running)
echo -e "Your active system services are\n $actServices\n"

#find the top 10 largest files in /home directory
#find /home -type f is to look for files within the /home directory
#-exec du -Sh {} + is executed to calculate the disk usage of the file
#in human readable format, only in /home and do not include the size of
#subdirectories. The {} represents the path of each file found
#by find, and + ensures that du is invoked as few times as possible 
#with as many filenames as possible, which can be more efficient
topLargest=$(find /home -type f -exec du -Sh {} + | sort -rh | head -n10)
echo -e "Your Top 10 Largest Files in /home\n $topLargest\n"
