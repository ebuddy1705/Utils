
//======================================================================

// Github with remote server

//======================================================================

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
	
	
	
//======================================================================

// Using 

//======================================================================	

1. New git project

	cd /path/to/project

	git init
	
	git add *.h
	
	git add *.c
	
	git add *.cpp
	
	git commit -am "init project, add all source code"
	
2. git command

	git clone https://github.com/ebuddy1705/Utils.git
	
	git pull => update from remote server

	git status  => list current status about untrack, modify, delete ...
	
	git rm -f filename => delete file on disk
	
	git rm --cached filename => remove file from current tracking
	
	git checkout => the similar to 'git status'
	
	git ls-files => list all file in current folder and subfolder
	
	
3. git server in LAN network

	git remote add origin git@172.17.67.85:carmeter-ftp.git
	
	git push origin master
	
	git clone git@172.17.67.85:carmeter-ftp.git	
