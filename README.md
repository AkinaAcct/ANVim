# ANVim

``` lua
      ___           ___           ___                       ___     
     /\  \         /\__\         /\__\          ___        /\__\    
    /::\  \       /::|  |       /:/  /         /\  \      /::|  |   
   /:/\:\  \     /:|:|  |      /:/  /          \:\  \    /:|:|  |   
  /::\~\:\  \   /:/|:|  |__   /:/__/  ___      /::\__\  /:/|:|__|__ 
 /:/\:\ \:\__\ /:/ |:| /\__\  |:|  | /\__\  __/:/\/__/ /:/ |::::\__\
 \/__\:\/:/  / \/__|:|/:/  /  |:|  |/:/  / /\/:/  /    \/__/~~/:/  /
      \::/  /      |:/:/  /   |:|__/:/  /  \::/__/           /:/  / 
      /:/  /       |::/  /     \::::/__/    \:\__\          /:/  /  
     /:/  /        /:/  /       ~~~~         \/__/         /:/  /   
     \/__/         \/__/                                   \/__/
```

> [!NOTE]
> NeoVim versions below 0.10 are not supported.  
> We fully dropped [neodev.nvim](https://github.com/folke/neodev.nvim), and use [lazydev.nvim](https://github.com/folke/lazydev.nvim) instead.

> [!WARNING]
> Unstable. May be updated at any time.  

## Installation

Just simply clone this repo to nvim's config dir:

```shell
mv ~/.config/nvim{,.bak}  # Back up your old configuration
git clone https://github.com/AkinaAcct/ANVim.git ${HOME}/.config/nvim
```

After this, enter nvim and wait for the plugin to be installed, and you have completed the ANVim installation.

> [!NOTE]
> If you need a more stable version, use the version with the release tag.

## Usage

ANVim is based on [LazyVim](https://github.com/LazyVim/LazyVim), so ANVim's key mapping is not very different from LazyVim's and you can get started very quickly.

In fact, you can even refer directly to LazyVim's documentation to make some modifications to ANVim.
