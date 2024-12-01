Part 1:-

Create a Jenkins job via which you will be able to perform the below operations & if any of the steps fail a Slack and Email notification should be sent:
Create a branch
List all branches
Merge one branch with another branch
Rebase one branch with another branch
Delete a branch

Part 2:-

Create a Jenkins job that takes input parameter string <Ninja Name> and it should - 
Create a file 
Add content in the file "<Ninja Name> from DevOps Ninja"
      	
Create another Jenkins job that should - 
Publish the file content created in job 1 using a web server
      
Configurations should be such that - 
The second job must be triggered automatically only after completing the first job successfully.
If any steps fail, a Slack and Email notification should be sent.
If all jobs run successfully, Slack and Email notifications should be sent.


Overiew of jenkins dashboard 
![alt text](image.png)

PART1

![alt text](image-1.png)
![alt text](image-2.png)
![alt text](image-3.png)
![alt text](image-4.png)
![alt text](image-5.png)
![alt text](image-6.png)

CONSOLE PART
![alt text](image-7.png)
![alt text](image-8.png)

NOTIFICATION PART

Mail

![alt text](image-9.png)     ---pass
![alt text](image-10.png)     ---fail

slack
![alt text](image-11.png)


PART2 JOB1

![alt text](image.png)

![alt text](image-15.png)   --- USED UPSTEREAM AND DOWNSTREAM HERE TO RUN JOB 2 ALSO 


![alt text](image-12.png)
![alt text](image-13.png)
![alt text](image-5.png)
![alt text](image-6.png)

COSNOLE PART
![alt text](image-14.png)

NOTIFICATION PART

MAIL ----> ![alt text](image-16.png)
SLACK ----> ![alt text](image-18.png) 


PART2 JOB2


![alt text](image.png)

![alt text](image-17.png)  ----HERE USED JOB 2 AS DONWSTREAM
![alt text](image-19.png)
![alt text](image-20.png)
![alt text](image-21.png)


CONSOLE PART
![alt text](image-22.png)

PUBLISH THE MESSAGE 
![alt text](image-23.png)

NOTIFICATION PART 

MAIL --->![alt text](image-24.png) ---PASS
        ![alt text](image-25.png)   ---FAIL

SLACK ----> ![alt text](image-26.png) 


Slack notification:-
https://youtu.be/58YRWes7iaM?si=zBCGUQ5OyPM72Pm-

MAIL --https://www.youtube.com/watch?v=F01HOaklPeM&amp;t=325s