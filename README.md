# sh.roz.ninja

Curlable shell scripts served at `https://sh.roz.ninja/<script-name>`.

## Usage

```bash
curl -sSL https://sh.roz.ninja/<script-name> | bash
```

## Available Scripts

### `install.sh`

Sets up a fresh Arch Linux machine with:

- [yay](https://github.com/Jguer/yay) (AUR helper)
- [mise](https://mise.jdx.dev/) (dev tool manager)
- [chezmoi](https://www.chezmoi.io/) (dotfile manager)
- [1Password](https://1password.com/) (desktop app + CLI)

Then initializes chezmoi with the `roziscoding` dotfiles.

```bash
curl -sSL https://sh.roz.ninja/install.sh | bash
```
