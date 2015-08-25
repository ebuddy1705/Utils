#======================================================================
# Github with remote server
#======================================================================
 
1. Setup SSH
    login Github
    Enter Settings
    Enter SSH Keys
    Click "generating SSH keys" for detail
 
 
2. New project
 
    touch README.md
    git init 
    git add README.md
    git commit -m "Init project"
    git remote add origin https://github.com/ebuddy1705/Utils.git
    git push -u origin master
     
#======================================================================
# Install git server
#======================================================================
#Install on server
    yum install git-all
 
# create the user (the -d option specifies the home directory)
    useradd -m -d /home/git git
 
 
# set the git user's shell
    usermod -s /bin/git-shell git
#or (using which git-shell) 
    usermod -s /usr/bin/git-shell git 
 
# set up public key authentication (as the git user)
    su -s /bin/bash git
    cd /home/git
    mkdir .ssh && chmod 700 .ssh && cd .ssh
    touch authorized_keys && chmod 600 authorized_keys  
 
#And your Git user is ready. Everyone who needs access must
#have their public key in /home/git/.ssh/authorized_keys
 
 
#Add a repository on your server; create bare repo (as the git user)
    su -s /bin/bash git
    cd /home/git
    mkdir myrepo.git && cd myrepo.git
    git init --bare
 
 
#Configure the remote on a repo
    git remote add myremote git@myserver.com:myrepo.git
    git push myremote master
  
 
 
 
     
#======================================================================
# Using 
#====================================================================== 
 
1. New git project
    cd /path/to/project
 
    git init
    git add *.h
    git add *.hpp
    git add *.c
    git add *.cpp
    git commit -am "init project, add all source code"
     
2. git command
 
    git status                      => list current status about untrack, modify, delete ...
    git rm -f filename              => delete file on disk
    git rm --cached filename        => remove file from current tracking
    git checkout                    => the similar to 'git status'
    git ls-files                    => list all file in current folder and subfolder
    git diff oldkey newkey          => trace difference on screen, red text are old content, blue text are new content
         
     
3. git client in  LAN network
 
    git remote add origin git@172.17.67.85:carmeter-ftp.git  (only one)
    git push origin master
     
    git clone git@172.17.67.85:carmeter-ftp.git 
    git pull
