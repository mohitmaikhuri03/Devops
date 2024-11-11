# Create group
ansible web -m group -a "name=team1 state=present" -b
![alt text](../picture/image.png)

ansible web -m group -a "name=ninja state=present" -b
![alt text](../picture/image-1.png)
# Create user
ansible web -m user -a "name=Nitish state=present groups=team1" -b
![alt text](../picture/image-2.png)
# Change user directory permission 
ansible web -m file -a "path=/home/Nitish mode=0754 group=team1" -b
![alt text](../picture/image-3.png)

# User should have 2 directories with permissions
ansible web -m file -a "path=/home/Nitish/Team owner=Nitish group=team1 mode=0774 state=directory" -b
![alt text](../picture/image-4.png)
ansible web -m file -a "path=/home/Nitish/Ninja owner=Nitish group=ninja mode=0777 state=directory" -b
![alt text](../picture/image-5.png)

# Change user shell
ansible web -m user -a "name=Nitish state=present group=team1 shell=/bin/zsh" -b
![alt text](../picture/image-10.png)
# Change password
ansible web -m user -a "name=Nitish state=present group=team1 password='{{ \"mohit03\" | password_hash('sha512') }}'" -b
![alt text](../picture/image-8.png)
# Delete user
ansible web -m user -a "name=Nitish state=absent remove=yes" -b
![alt text](../picture/image-7.png)
# Delete group
ansible web -m group -a "name=team1 state=absent" -b
![alt text](../picture/image-9.png)
# List group 
ansible web -m command -a "cat /etc/group"
![alt text](../picture/image-11.png)
# List user 
ansible web -m shell -a "cat /etc/passwd"
![alt text](../picture/image-12.png)

