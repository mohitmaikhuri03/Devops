Assignment -02

Topics Covered:  (User Authentication, User Authorization)

Part 1
There is an organization which has 3 teams based on user roles : 
            - Developer
            - DevOps
            - Testing
        
First, you need to create 9 Jenkins jobs. Each job will print its job name, and build number.
            For the Developer, create 3 dummy jobs, visible in the developer view
                job1:- dev-1
                job2:- dev-2
                job3:- dev-3
            For Testing, create 3 dummy jobs, visible in the testing view
                job1:- test-1
                job2:- test-2
                job3:- test-3
            For DevOps, create 3 dummy jobs, visible in the devops view
                job1:- devops-1
                job2:- devops-2
                job3:- devops-3

Users in each team: 
            developer: [ They can see only dev jobs, can build it, see workspace and configure it ]
                - developer-1 
                - developer-2 
            testing: [ They can see all test jobs, can build it, see workspace and can configure it, | They can also view dev jobs ]
                - testing-1 
                - testing-2 
            devops:  [ They can see all devops jobs, can build it, see workspace and can configure it, | They can also view dev and test jobs  ]
                - devops-1 
                - devops-2
            Administration
                -  admin-1 [ It will have full access ]        

See what Authorization strategy suits it and implement it.
Also, go through all authorization strategies.

Legacy mode
Project Based
Matrix Based
Role-Based

Part 2
Enable SSO with Google for admin user


PART 1 
CREATING JOBS IN THEIR VIEW

Dev view ----->  ![alt text](image.png)
Devops view ---> ![alt text](image-1.png)
Test view ----> ![alt text](image-2.png)

ALL DEV EXECUTE SHELL ----> ![alt text](image-3.png)
ALL DEVOPS EXECUTE SHELL --> ![alt text](image-4.png)
ALL TEST ECECUTE SHELL ----> ![alt text](image-5.png)

CONSOLE PART 
DEV VIEW ---> ![alt text](image-6.png)
DEVOPS VIEW ----> ![alt text](image-7.png)
TEST VIEW --->  ![alt text](image-8.png)

USERS IN EACH TEAM 

![alt text](image-9.png)

USING ROLE BASED STATEGY TO GIVE ACCES TO PARTICULAR USER AND ALL

![alt text](image-10.png)

MANAGE ROLES 

![alt text](image-11.png)
![alt text](image-12.png)

ASSIGN ROLES 
![alt text](image-13.png)
![alt text](image-14.png)

TO CHECK LOGGING IN EACH USER AND CHECK 

developer-1 , 2 
[ They can see only dev jobs, can build it, see workspace and configure it ]
![alt text](image-15.png) 
we can see developer view here

testing -1 ,2
[ They can see all test jobs, can build it, see workspace and can configure it, | They can also view dev jobs ]
![alt text](image-16.png)
can see and do everything in test view ----> ![alt text](image-17.png)
only can see dev view --->![alt text](image-18.png)

devops -1,2
[ They can see all devops jobs, can build it, see workspace and can configure it, | They can also view dev and test jobs  ]
![alt text](image-19.png)
can see and do everything in devops view ---->![alt text](image-20.png)
only can see dev view ---> ![alt text](image-21.png)
only can see test view ---> ![alt text](image-22.png)


ADMIN-1 HHAVING FULL ACCESS 
like it will have all access for devops , test, and developer view with all thing 
![alt text](image-23.png)


PART 2  SSO ADMIN 

AS IAM CURRENTLY DOING IN LOCALHOST SO I HAVE CREATED NEW JENKINS INSTANCE HAVE GIVEN ITS URL IN IT 
 
JENKINS INSTANCE ---->  ![alt text](image-24.png)

CREATED LOAD BALANCER TO SET UP DNS NAME 

![alt text](image-25.png)

CONFIGURE IT IN USING GOOGLE DEV CONSOLE WITH OUR GMAIL 

![alt text](image-26.png)

IN JENKINS INSTALL THE GOOGLE PLUIGN AND SET UP IT 

![alt text](image-27.png)
![alt text](image-28.png)

LOGGING IN JENKINS USING THE URL SET USING GOOGGLE SSO 

![alt text](image-29.png)
![alt text](image-30.png)


GGOGLE SSO REFERENCE 
https://opstree.com/blog/2023/05/09/how-to-setup-sso-in-jenkins/