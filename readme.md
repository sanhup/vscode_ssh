## Prepare SSH key for login
On your local machine, create a new keypair:

Note: I kept the default name id_ed25519. If you change it, you must add it to your ssh config.

```cmd
ssh-keygen
```

Copy the public key to the docker keys folder
```cmd
copy C:\Users\<UserName>\id_ed25519.pub .\keys
```

## Setup SSH key for git

This time, don't use the default filename. Instead, use C:\Users\<UserName>\id_git. We will copy the private key this time.

```
ssh-keygen -t ed25519 -C "your_email@example.com"
copy C:\Users\<UserName>\id_git .\keys
```

Add the public key from "C:\Users\<UserName>\id_git.pub" to your Github account.

## Start docker container
```cmd
docker compose up
```

### Set correct file policies for ssh
```cmd
docker exec -it ubuntu_container /bin/bash
chmod 700 /root/.ssh
chmod 600 /root/.ssh/id_ed255519.pub
chmod 600 /root/.ssh/id_git
```


## Connect ssh

```cmd
ssh root@localhost -p 3000
```
