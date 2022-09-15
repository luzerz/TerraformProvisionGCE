# Teraform Provisioning GCP AND Using Ansible to Install Jenkins

## Before you run
runing this command to create ssh key file
```
$ ssh-keygen -t rsa -f ~/.ssh/<filename> -C <user_to_access_server> -b 2048 
``` 


## Run Teraform
```
$ cd terraform
$ terraform init
$ terraform plan
$ terroform apply
```

## Run Ansilble playbook install Jenkins

```
$ cd ansible
$ ansible-playbook playbooks/jenkins.yml