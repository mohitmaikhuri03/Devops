
Ansible is mainly a configuration management and automation tool. It excels at managing software updates, applying patches, configuring servers, and maintaining systems. While it can provision infrastructure, it’s better suited for tasks within existing infrastructure (e.g., installing applications, setting configurations).

Terraform is a dedicated infrastructure-as-code tool. It is designed specifically for creating, provisioning, and managing infrastructure (e.g., networks, servers, databases) across cloud providers. Terraform’s approach to managing infrastructure state and its support for cloud-native resources make it more efficient and reliable for infrastructure creation than Ansible.

![image](https://github.com/user-attachments/assets/1dbae0bc-3508-43d1-8e46-e6a14f623e70)




In summary: Ansible is ideal for managing and automating existing infrastructure, while Terraform is better for creating and provisioning infrastructure from scratch.ansible is a config management tool whcih is used for software update install 
Ansible is a automation toll used to simplify tasks like servers seeting up deploy applications
and managing config 
in devops we usewd to make our task easy to run it faster insted of  doinh manually it saves times 
and reduces mistakes 

file and stat difference 
file module is like it is used to crerat delete or modify any file attributes it is useful when you nedd 
to change something about file /directory
stat is used to check thae status without making any changes for validation if file exists or   see 
file ize or permission 

to inlcude taks in main file we use task name 
- name: nginx install
  ansible.builtin.include_tasks: install.yaml
  to include in playbook only we use 
  - name: nginx install
  ansible.builtin.include_vars: variable.yaml

---
- name: mock example 
  hosts: all
  become: true
  gather_facts: yes
  remote_user: ubuntu


  tasks:
  - name: install nginx
    apt:
     name: nginx
     state: present
    notify: restart nginx
    3
    4
    5


# handlers use case now
  - name: restart nginx
    service :
     name: nginx
     state: restarted
    - name:  nginx
    service :xxxx
     name: nginx
     state: restarted

# if we have 2 handlers of same name it will execute the last one and if we have different name then it will 
#execute one by one as mnetioned and handlers usally run at the ned of task if we have any changes or modification
# otherwise it will not run and if we want some handler to run after completeing that taks only i can use flush handlers
# ex:  - name: Flush handlers immediately
      #  meta: flush_handlers

# 1.... Inventory Variables
#Defined in the inventory file, these variables are tied to specific hosts or groups of hosts.
[webservers]
server1 ansible_host=192.168.1.10 http_port=80
server2 ansible_host=192.168.1.11 http_port=8080

usage in playbook
- hosts: webservers
tasks:
  - name: Display HTTP port
    debug: 
      msg: "HTTP port is {{ http_port }}" like here 

#2) Playbook Variable Defind within a playbook, these variables are specific to that playbook and are usually set at the beginning.
- hosts: all
vars:
  http_port: 8080
  max_clients: 200
tasks:
  - name: Display HTTP port and max clients
    debug:
      msg: "HTTP port is {{ http_port }}, Max clients are {{ max_clients }}"
# the variables are defined in curly braces {{ }} 
#3) task vars are variables which are defined inside the task 
- hosts: all
  tasks:
    - name: Install a specific package version
      ansible.builtin.package:
        name: "{{ pkg_name }}"
        version: "{{ pkg_version }}"
        state: present
      vars:
        pkg_name: "nginx"
        pkg_version: "1.18.0"
#4) extra variables this are that variable  which we defined using command line forexample 
# ansible-playbook playbook.yml -e "variable1=value1 variable2=value2"
# for passing list or directories we can use 
ansible-playbook playbook.yml -e '{"users": ["alice", "bob"], "settings": {"theme": "dark"}}'
When to Use Extra Variables
Extra variables are useful when you want to:

Override default variables in the playbook.
Quickly change configuration for a single run without editing the playbook.
Inject sensitive data (like passwords) or other specific values at runtime.
 
Now precedence f the variabble whcih is freqquntly asked
Extra variables – Command-line variables passed using -e. These have the highest priority and will override any other variable.
Task variables – Defined at the task level within a playbook.
Block variables – Defined inside a block within a playbook.
Role variables – roles/role_name/vars/main.yml
Playbook variables – Defined in vars section of a playbook.
host vars adn then group variables , inventory files and last is defiault roles variables inside roles 

Inventory files
web1(alias) ansible_host=23.214.212.23
web2 (alias) ansible_host=23.214.212.24
app1 (alias) ansible_host=23.214.212.28
app2 (alias) ansible_host=23.214.212.29

[web]
web1
web2
group variables if icall web it should run on both server and same for app
[app]
app1
app2

groups of groups 
[site:children]
web
app

[site:vars]
ansibel_user=ubuntu
ansible_ssh_private_key_file=./filename

we can use vars here so it will be appiicabke to all the user present here 


LOOP USE IN PLAYBOOK AND  HOW TO DEFINE IT 

In Ansible, the concept of with_items is used to loop over a list of
 items within a task. This allows you to perform repetitive actions, 
 like installing multiple packages or creating multiple users, in a concise and efficient way. 
 Each item in the list can be accessed as a variable called item.

 HOW TO USE IT
 - name: Install multiple packages
  ansible.builtin.package:
    name: "{{ item }}"
    state: present
  with_items:
    - nginx
    - git
    - curl
HERE IN PLACE OF ITEM ONE BY ONE EACH VALUE WILL BE SUBSTITUTED 

USING WITH ITEM WITH VARIABLE 
- hosts: all
  vars:
    packages:
      - nginx
      - git
      - curl
  tasks:
    - name: Install packages from a variable list
      ansible.builtin.package:
        name: "{{ item }}"
        state: present
      with_items: "{{ packages }}"

USING VARIABLES STORED IN DIFFERNT FILE FROM THERE WITH NESTED VARIABLES
DIFFERENT FILE : 
-users:
  - name: "carol"
    home: "/home/carol"
  - name: "dave"
    home: "/home/dave"

USE IN PLAYBOOK

- hosts: myserver
  tasks:
    - name: Create users from host variable list
      ansible.builtin.user:
        name: "{{ item.name }}"
        home: "{{ item.home }}"
        state: present
      with_items: "{{ users }}"


STRATEGY :-
1) LINEAR STRATEGY -
BY DEFAULT LINEAR IS EXECUTED IN ALL PLAYBOOK
HERE ONE TASK IS EXECUTED IN ALL HOSTS THEN IT MOVES TO OTHER TASK 
TASK [Update packages] ****************************************************************
changed: [webserver1]
changed: [webserver2]
changed: [webserver3]

TASK [Install Nginx] *****************************************************************
changed: [webserver1]
changed: [webserver2]
changed: [webserver3]

2) FREE STRATEGY:-
In the free strategy, tasks can run in parallel on all hosts, 
and there is no specific order or pattern followed. 
Multiple tasks can execute simultaneously across different hosts.

- hosts: webservers
  strategy: free     USE HERE STRATEGY AS FREE TO MAKE SURE IT RUNS ACCORDING TO THAT
  tasks:
    - name: Update packages
      apt:
        update_cache: yes

    - name: Install Nginx
      apt:
        name: nginx
        state: present

TASK [Update packages] ****************************************************************
changed: [webserver3]
changed: [webserver1]
changed: [webserver2]

TASK [Install Nginx] *****************************************************************
changed: [webserver1]
changed: [webserver3]
changed: [webserver2]

3) SERIAL STRATEGY :-
HERE IF WE MENTION ANY NO ON IT LIKE IT WILL WORK ON THAT NO OF HOSTS FOR EXAMPLE IF WE HAVE 6 WE MNETION
2 SO IT WILL RUN 2 BY 2 HERE WHATEVER THE TASK IS THERE IT WILL EXECUTE IN 2 HOST 
AND THEN MOVES TO OTHER TASK SO AFTER FINISHING ALL THE TASK IN 2 HOST 
IT WILL BE MOVE TO NEXT 2 

- hosts: webservers
  serial: 2   HERE WE HAVE MENTIONED 
  tasks:
    - name: Update packages
      apt:
        update_cache: yes

    - name: Install Nginx
      apt:
        name: nginx
        state: present
4) HOST PINNED STATEGY 

HERE WE COMPLET ALL TASK IN ONE HOST AND THEN MOVE TOWARDS OTHERS
- hosts: webservers
  strategy: host_pinned HERE WE HAVE MENTIONED
  tasks:
    - name: Update packages
      apt:
        update_cache: yes

    - name: Install Nginx
      apt:
        name: nginx
        state: present

TASK [Update packages] ****************************************************************
changed: [webserver1]

TASK [Install Nginx] *****************************************************************
changed: [webserver1]

TASK [Update packages] ****************************************************************
changed: [webserver2]

TASK [Install Nginx] *****************************************************************
changed: [webserver2]

TASK [Update packages] ****************************************************************
changed: [webserver3]

TASK [Install Nginx] *****************************************************************
changed: [webserver3]

5) THROTTLE STRATEGY :- IMP HERE IF ONE HOST COMPLETES FULL WORK 
NEXT HOST WIL LSTART WORKING SIRECTLY 
With throttle: 2, only 2 hosts are working at any one time. 
The other hosts remain idle and wait until the currently active hosts finish before they begin their tasks.
All hosts will eventually run through all the tasks, 
but they will do so in a staggered manner controlled by the throttle setting.

- hosts: webservers
  strategy: throttle
  throttle: 2  # Only two hosts will be processed at a time
  tasks:
    - name: Update packages
      apt:
        update_cache: yes

    - name: Install Nginx
      apt:
        name: nginx
        state: present

      ![image](https://github.com/user-attachments/assets/5405e19b-855c-4411-abf9-9aaac817ae02)



CONDITIONAL CLAUSES
when clause: This is the most commonly used way to apply conditions in Ansible. 
The when clause checks whether the provided condition is true, and if it is, it executes the task.

THIS IS SIMPLE WHE CONDIITON WHCIH WE CAN DO WITHER THIS OR THAT 

---
- name: nginx in ubutu or  centos
  hosts: all
  become: true
  gather_facts: yes

  tasks:
    - name: Install Nginx on Debian/Ubuntu
      apt:
        name: nginx
        state: present
      when: ansible_os_family == "Debian"

    - name: Install Nginx on CentOS
      yum:
        name: nginx
        state: present
      when: ansible_os_family == "CentOS"

      Example 2: Using when with Registered Variables
Sometimes, you might want to execute a task based on the result of a previous task. 
For this, you can register a variable and use it in a conditional clause

- name: Check if Nginx is installed
  command: which nginx
  register: nginx_check
  ignore_errors: true

  ***
  The ignore_errors: true parameter is used to allow a task to complete even if it encounters an error. 
  By default, if a task fails, Ansible stops execution and does not proceed to the next task.
   This is useful when you want to continue regardless of the outcome of a particular task.

***
register
The register keyword is used to capture the output or result of a task and save it to a variable. 
This variable can then be referenced in later tasks, conditions, or templates.

- name: Install Nginx if not present
  apt:
    name: nginx
    state: present
  when: nginx_check.rc != 0


TEMPLATES 

Ansible templates let you create dynamic configuration files using Jinja2 templating. 
Templates are used when you need configuration files that vary slightly for each server.
 Instead of writing separate configuration files for each server, you write a single template file,
 and Ansible fills in the specific details for each server during playbook execution.

 Basic Structure of an Ansible Template
Templates in Ansible are usually stored as .j2 files (Jinja2 files) 
in your playbook's templates directory. 
These files contain placeholders that Ansible replaces with actual values during execution.

PLAYBOOK
---
- name: Check for file existence and print message
  hosts: all
  become: true
  gather_facts: no
  vars:
    name_id: Mohit
  tasks:
    - name: template
      ansible.builtin.template:
        src: index.html.j2
        dest: /var/www/html/index.nginx-debian.html
      notify: restart nginx

  handlers:
    - name: restart nginx
      ansible.builtin.service:
        name: nginx
        state: restarted

  index.html.j2
  This is me {{ name_id }} the goat of football


INCLUSIONS :- 
INCLUDE VARS INCLUDE TASK 
IMPORT TASK AND IMPORT PLAYBOOK 

Inclusion refers to the mechanism of reusing code (tasks, handlers, or entire playbooks) by including or importing them into another playbook.

Summary
import :  ( STATIC ) Conditions are checked before running the playbook because import_* statements 
are loaded as the playbook is parsed.

include: ( DYNAMIC )Conditions are checked while the playbook is running because include_* statements 
are evaluated dynamically during execution.

This difference makes include better for conditional and flexible loading during playbook execution, 
while import is used when you want to load tasks or playbooks at the start, regardless of conditions.

VAULT 
if some important data we nedd to store it somewhere we can use vault 
ansible-vault encrpyt folename
to see ---> ansible-vault view fn
to edit --> ansible-vault edit fn
to decrppyt ---> ansible-vault decrpyt fn 
to change password ---> ansible-vault rekry fn 


ansible galaxy 
Ansible Galaxy is like an app store for Ansible. It’s a place where
 you can find and share Ansible roles, which are reusable pieces of code that 
automate specific tasks (like setting up a database, configuring a web server, etc.).

ansible-galaxy init rolename


Here's a super simple explanation:

Forward Proxy: Think of it as a gateway for users. 
When you try to access a website, a forward proxy takes your request, 
sends it to the site, gets the response, and passes it back to you. 
This can hide your identity from the website and can be used for things like security,
 caching, or content filtering.

Reverse Proxy: This is like a gateway for websites. 
When you access a website that uses a reverse proxy, 
the proxy sits between you and the actual servers hosting the website.
 It takes your request, forwards it to one of 
 the website’s servers, gets the response, and sends it back to you. 
 It helps with load balancing, security, and hiding the details of the backend servers.

In short:

Forward Proxy protects or hides clients (users).
Reverse Proxy protects or hides servers.


In Ansible, state is a setting that tells Ansible what you want 
the final state of a resource (like a file, package, or service) to be. 
It lets Ansible know if something should exist, be absent, 
or be in a particular status.

For example:

state: present means "make sure this thing exists."
state: absent means "make sure this thing is removed."
state: started means "make sure this service is running."
state: stopped means "make sure this service is stopped."

In Ansible, the cron job module is used to create, manage, or 
remove scheduled tasks (cron jobs) on a system. Cron jobs are 
commands or scripts that automatically run at specified times or intervals, 
like every day, every week, or even every minute.

Ansible has two main types of inventory:

Static Inventory: Defined in a file (e.g., hosts), listing hosts and groups manually. Common for small, fixed environments.

Dynamic Inventory: Generated in real-time using scripts or plugins, pulling hosts from cloud services like AWS or other dynamic sources,
 useful for scaling environments.


Difference between block and rescue in Ansible (in simple words):
Block:

A block is used to group multiple tasks together so that they can be managed as a single unit. If any task in the block fails, you can define how to handle the failure using the rescue section.
It's useful when you want to logically group tasks and manage their failure conditions together.
Example:

yaml
Copy
Edit
tasks:
  - block:
      - name: Install nginx
        apt:
          name: nginx
          state: present
      - name: Start nginx service
        service:
          name: nginx
          state: started
    rescue:
      - name: Log an error if nginx fails
        debug:
          msg: "Nginx installation failed!"
In this example, both the tasks to install and start Nginx are grouped in a block, and if any task fails, the rescue section will handle the failure (like logging an error).
Rescue:

The rescue section is used in combination with a block to handle errors. If any task inside a block fails, the tasks defined in rescue will be executed to handle the failure, like providing error messages or performing cleanup.
Rescue is not used by itself; it must be part of a block.
In the example above, if either the installation or the starting of Nginx fails, the rescue section will print an error message.

delegate_to vs local_action in Ansible (in simple words):
delegate_to:

delegate_to is used to run a task on a different host than the one currently being targeted by Ansible. This is useful when you need to run a task on a specific host, regardless of the host you are working on in the playbook.
It allows you to delegate the execution of a task to another host in your inventory.
Example:

yaml
Copy
Edit
tasks:
  - name: Run a command on a remote server
    command: echo "Hello World"
    delegate_to: remote_server
In this example, the task will be run on remote_server, even if it is defined in a play that targets another host.
local_action:

local_action is used to execute a task on the local machine where Ansible is running, not on the remote hosts defined in the playbook.
It's useful when you need to perform a task on the machine running Ansible itself, like copying a file to the local machine.
Example:

yaml
Copy
Edit
tasks:
  - name: Copy file to the local machine
    copy:
      src: /tmp/file.txt
      dest: /home/user/file.txt
    local_action: copy
In this example, even though the task is defined to copy a file, the local_action ensures that it happens on the local machine where Ansible is being run.
Summary:
Block: Groups tasks together for easy management and error handling.
Rescue: Handles errors for tasks in a block by defining actions to take if a task fails.
delegate_to: Runs a task on a different host than the one being targeted by the play.
local_action: Executes a task on the local machine where Ansible is running.


[12:27 PM, 1/18/2025] Mohit ♥️: In summary:

Role: A reusable unit of automation (like setting up a web server).
Collection: A package containing roles, modules, and plugins for a specific purpose.
Ansible Galaxy: A platform where you can share and download roles and collections.
[12:36 PM, 1/18/2025] Mohit ♥️: Difference:
Play: A single section in the playbook targeting specific hosts with tasks to run.
Playbook: A file that contains multiple plays, allowing you to automate tasks across various systems in a sequence.

![image](https://github.com/user-attachments/assets/5ad6125d-fe2c-468d-ad0b-621ab2a75529)



Slave (Managed Node):

Python is required for most Ansible modules like apt, service, and ping.
If Python is missing, you can still use the raw module to run shell commands (e.g., to install Python).
Without Python, only raw and script modules work.
AWS Instances:

Most AWS AMIs (like Amazon Linux or Ubuntu) come with Python pre-installed.
That’s why your playbook worked on new AWS instances—Python was already present.
In short: Slaves need Python for most modules, but you can use the raw module to install Python if it’s missing. On AWS, Python is usually pre-installed, so it works out of the box


[10:09 AM, 1/18/2025] Mohit ♥️: Patching means updating software or the operating system to fix bugs, improve security, or add new features. It ensures systems stay secure and reliable by addressing vulnerabilities or issues in outdated versions.

Ubuntu:- 
ansible all -m apt -a "update_cache=yes upgrade=dist" -b


Redhat-
ansible all -m yum -a "name='*' state=latest" -b
[10:12 AM, 1/18/2025] Mohit ♥️: Yes, bilkul sahi hai!

Boto3: High-level Python SDK for working with AWS services easily. It provides user-friendly methods to interact with AWS (e.g., creating an S3 bucket, launching an EC2 instance).
Botocore: Low-level library that does the actual communication with AWS APIs. It’s the backbone of Boto3 and handles requests, retries, and responses.
Botocore ka kaam hai "backend mein AWS ke saath communication karna," aur Boto3 usko use karke high-level functionalities provide karta hai


Boto3 ek high-level Python library hai jo AWS ke saath kaam karna easy banati hai (jaise S3 bucket banana, EC2 launch karna).
Botocore low-level library hai jo AWS APIs ke saath actual communication karti hai – ye Boto3 ke peeche ka engine hai.
Bina Botocore ke, Boto3 kaam nahi karta.
Lekin Botocore ko alag se bhi use kar sakte hain, lekin wo complex hota hai.



Boto3 user ke liye hai, Botocore AWS ke liye



![image](https://github.com/user-attachments/assets/d92f7ac5-9621-4985-8fb4-a000c4be912d)

![image](https://github.com/user-attachments/assets/1f868cd1-98c4-49de-8862-9d79fe457871)


