# dotfiles


## Minimal setup
CentOS:
```
sudo dnf install openssl git zsh util-linux-user tilix python3-pip jq gem open-vm-tools open-vm-tools-desktop gcc cpan unzip -y
```

Ubuntu:
```
sudo apt install zsh openssl git jq open-vm-tools gcc curl wget zip -y
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
chsh -s $(which zsh)
```

```
git init .
git remote add origin https://github.com/davidphay/dotfiles.git
git pull origin main
```
