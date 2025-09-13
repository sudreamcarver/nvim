# My nvim configuration
A nvim set for beginner as a nvim distribution.<br>
just called it CBINvim.
```
   __________  _____   __      _         
  / ____/ __ )/  _/ | / /   __(_)___ ___ 
 / /   / __  |/ //  |/ / | / / / __ `__ \
/ /___/ /_/ // // /|  /| |/ / / / / / / /
\____/_____/___/_/ |_/ |___/_/_/ /_/ /_/ 
```

## Fast setting.
```bash
cd 
cd .config
git clone <this_repository>
```

## For none rolling distribution(if U use an old ubuntu or debian for example)
Considerer none rolling distribution may get an old Ver for it own package manager.<br>
Plz install NVIM from Pre-built archives.<br>
The provides pre-built binaries for Linux systems.
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```
Then add this to your shell config (~/.bashrc, ~/.zshrc, ...):
```bash
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

