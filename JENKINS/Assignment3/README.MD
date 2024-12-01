Perform CI checks on three Repositories using Jenkins, store reports, manage artifacts, and set up failure notifications.
API Repositories:
- Python:- https://github.com/OT-MICROSERVICES/attendance-api
- GoLang:- https://github.com/OT-MICROSERVICES/employee-api
- Java:- https://github.com/opstree/spring3hibernate.git
Jenkins Freestyle Jobs:
Create separate jobs for each check.
Configure to pull repositories from GitHub.
Implement Generic & Advance CI Checks (eg: Credential Scanning, Unit Testing, Code Coverage, Dependency, etc.)
Store and access reports within Jenkins.
Choose local or remote storage for artifacts.
Configure email, Slack, or Telegram notifications on CI check failures.

HERE I HAVE USED 
JAVA 
THE REPO USED HERE IS 
https://github.com/builderHub/CICD-01.git  AS https://github.com/opstree/spring3hibernate.git HAVING SOME ISSUES

 Dashboard  ON CI CHECK ONE EACH JOB 

![alt text](image.png)
![alt text](image-1.png)


1) credentiall scanning  job

![alt text](image-2.png)
![alt text](image-3.png)
![alt text](image-4.png)


2) unit testing  job

![alt text](image-2.png)
![alt text](image-5.png) ----> for archinig the jar file and also getting the unit test report
![alt text](image-6.png)
![alt text](image-7.png)

console part
![alt text](image-8.png)
report --> ![alt text](image-9.png)
![alt text](image-10.png)

3) code coverge  job 
![alt text](image-2.png)
![alt text](image-11.png)
![alt text](image-12.png)

console part

jacoco coverage report - ![alt text](image-13.png)
![alt text](image-14.png)


4) Dependency check  job / i can use this command also dependency-check --scan . --format HTML --out dependency-check-reports/
inside invoke depedency 

 ![alt text](image-2.png)
 ![alt text](image-15.png)
![alt text](image-16.png)


console part 
![alt text](image-17.png)
dependecy report ![alt text](image-18.png)
![alt text](image-19.png)



slack notification on failure of each check 
![alt text](image-20.png)
