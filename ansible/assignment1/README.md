Assignment1-
Complete the following steps with the help of ansible modules:
UserManager:
Add NinjaTeam (Simulate Group) ex: team1
Add a User (Simulate) under a team ex: Nitish added to team1 Ensure below constraints are met:
A user should have read,write, execute access to home directory
All the users of same team should have read and excute access to home directory of fellow team members.
In home directory of every user there should be 2 shared directories
Team: Same team members will have full access
Ninja: All ninja's will have full access
Additional Features:
Change user Shell
Change user password
Delete user
Delete Group
List user or Team

1) ansible web -m group -a "name=team1 state=present" -b
![alt text](image-1.png)

2) ansible web -m group -a "name=ninja state=present" -b
![alt text](image-2.png)

3) ansible web -m user -a "name=Nitish state=present groups=team1" -b
![alt text](image.png)

4) ansible web -m file -a "path=/home/Nitish mode=0754 group=team1" -b
![alt text](image-3.png)

5) ansible web -m file -a "path=/home/Nitish/Team owner=Nitish group=team1 mode=0774 state=directory" -b
![alt text](image-4.png)

6) ansible web -m file -a "path=/home/Nitish/Ninja owner=Nitish group=ninja mode=0777 state=directory" -b
![alt text](image-5.png)
 
7) ansible web -m user -a "name=Nitish state=present group=team1 shell=/bin/zsh" -b
 ![alt text](image-6.png)

8) ansible web -m user -a "name=Nitish state=present group=team1 password='{{ \"mohit03\" | password_hash('sha512') }}'" -b
![alt text](image-7.png)

9) ansible web -m user -a "name=Nitish state=absent remove=yes" -b
![alt text](image-8.png)

10) ansible web -m group -a "name=team1 state=absent" -b
 ![alt text](image-9.png)

11) ansible web -m command -a "cat /etc/group"
![alt text](image-10.png)

12) ansible web -m shell -a "cat /etc/passwd"
![alt text](image-11.png)