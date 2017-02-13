#
# repo-management install Makefile
#

DEST_REPOMANAGER = /usr/local/bin/gitmanager
DEST_UPDATEREPOS = /usr/local/bin/updaterepos

executable:
	@echo "#!/bin/sh" > gitmanager.sh
	@echo "python $(CURDIR)/repo_manager.py" >> gitmanager.sh
	@echo "#!/bin/sh" > updaterepos.sh
	@echo "cd $(CURDIR) && sh check_repo.sh" >> updaterepos.sh

gitaliases:
	@git config --global alias.update '!git remote update -p; git merge --ff-only @{u}'
	@git config --global alias.lg = '!"git lg2"'
	@git config --global alias.lg2 = '!"git lg2-specific --all"'
	@git config --global alias.lg2-specific = 'log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'

install:
	@echo "May need sudo rights to invoke!"
	@make gitaliases
	@make executable
	@chmod +x $(CURDIR) check_repo.sh
	@chmod +x $(CURDIR) repo_manager.py
	@chmod a+x $(CURDIR) gitmanager.sh
	@chmod a+x $(CURDIR) updaterepos.sh
	@cp -p $(CURDIR)/gitmanager.sh $(DEST_REPOMANAGER)
	@cp -p $(CURDIR)/updaterepos.sh $(DEST_UPDATEREPOS)
	@echo "Installation complete"

clean:
	@rm $(DEST_REPOMANAGER)
	@rm $(DEST_UPDATEREPOS)
	@rm $(CURDIR)/gitmanager.sh 
	@rm $(CURDIR)/updaterepos.sh
	@rm $(CURDIR)/repos.conf
	@rm $(CURDIR)/repo_manager.conf

