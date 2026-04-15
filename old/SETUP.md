# 2025 edition

## nvim (mac)
```
brew install neovim
```
## nvim (linux)
```
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

export PATH="$PATH:/opt/nvim-linux-x86_64/bin" (in .zshrc)
```


# for backend js tooling for nvim
```
curl -o- https://fnm.vercel.app/install | bash

npm i -g deno
```
