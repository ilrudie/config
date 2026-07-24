# config

Portable dev environment for CNCF (Go/Rust) work — Istio, kgateway,
agentgateway — plus tmux and LazyVim. One repo, driven onto both macOS and
Linux with [GNU Stow](https://www.gnu.org/software/stow/).

## How it's organized

- **mise** (`mise/`) — portable dev toolchains (Go, Rust/rustup, kubectl, kind,
  neovim, tmux, ripgrep, ...). The same `config.toml` works on macOS + Linux.
- **Homebrew** (`brew/Brewfile`) — macOS-only OS layer that mise can't package:
  the mise bootstrap, stow, git/git-lfs, GnuPG, fonts. On Linux use apt/dnf.
- **Stow packages** — each top-level dir mirrors `$HOME` and is symlinked into
  place. The repo is the single source of truth; edit here and commit.
- **Containers** — Istio & kgateway build/test inside their own build-tools
  containers, so their exact Go version isn't pinned on the host. agentgateway
  builds Rust locally; its `rust-toolchain.toml` (1.97) is auto-selected by mise.

### Packages

| Package | Symlinks to | Notes |
|---|---|---|
| `nvim`  | `~/.config/nvim/` | LazyVim config |
| `tmux`  | `~/.config/tmux/tmux.conf` | TPM plugins |
| `git`   | `~/.gitconfig`, `~/.gitignore` | GPG signing, LFS |
| `mise`  | `~/.config/mise/config.toml` | dev tool versions |
| `zsh`   | `~/.zsh_aliases`, `~/.config/zsh/aliases/` | OS-aware aliases |
| `brew`  | *(not stowed)* | used via `brew bundle --file` |

> **Stow tip:** this repo lives deep under `~/code/ilrudie/`, so always pass
> `-t ~`. Without it, stow targets the repo's parent dir instead of `$HOME`.

## Fresh machine setup (macOS)

Order matters — the compiler and git must exist before mise builds anything.

```sh
# 1. Xcode Command Line Tools (git + C compiler/linker)
xcode-select --install

# 2. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#    open a NEW shell afterward and follow its PATH "Next steps"

# 3. Clone this repo
git clone https://github.com/ilrudie/config ~/code/ilrudie/config
cd ~/code/ilrudie/config

# 4. OS layer (mise, stow, git, git-lfs, gnupg, pinentry-mac, font)
brew bundle --file=brew/Brewfile

# 5. Symlink the packages into $HOME
stow -t ~ nvim tmux git mise zsh

# 6. Activate mise + install all dev tools
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
exec zsh
mise install
mise doctor

# 7. tmux plugin manager (one-time clone), then start tmux and press <prefix>+I
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# 8. GPG commit signing (Apple Silicon paths)
mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
echo 'pinentry-program /opt/homebrew/bin/pinentry-mac' >> ~/.gnupg/gpg-agent.conf
echo 'export GPG_TTY=$(tty)' >> ~/.zshrc
gpgconf --kill gpg-agent
gpg --import /path/to/secret-key.asc

# 9. Per-machine git identity (personal laptop -> gmail; see "Git identity")
git config -f ~/.gitconfig.local user.email ilrudie@gmail.com

# 10. Terminal: select the "GoMono Nerd Font"
# 11. Container runtime for Istio/kgateway builds:
colima start --cpu 6 --memory 12 --disk 100
```

## Fresh machine setup (Linux)

Same idea, without Homebrew:

```sh
sudo apt install -y build-essential git git-lfs gnupg stow xclip   # or dnf
sh -c "$(curl -fsSL https://mise.run)"
git clone https://github.com/ilrudie/config ~/code/ilrudie/config
cd ~/code/ilrudie/config
stow -t ~ nvim tmux git mise zsh
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
git config -f ~/.gitconfig.local user.email ian.rudie@solo.io   # work laptop
# add `eval "$(mise activate zsh)"` to ~/.zshrc, then: mise install
```

Use native Docker/Podman instead of Colima (the container tools in the mise
config are gated to macOS).

## ~/.zshrc

`.zshrc` isn't stowed (it's machine-specific). It should source the aliases and
set up tool activation, in this order:

```sh
eval "$(mise activate zsh)"          # dev tools on PATH
eval "$(atuin init zsh)"             # shell history
export GPG_TTY=$(tty)                # gpg signing in the terminal
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
```

## Editing after setup

Files in `$HOME` are symlinks back into this repo, so edit either path and
commit from here. Adding a **new** file to a package needs a restow:

```sh
cd ~/code/ilrudie/config && stow -R -t ~ <package>
```

## Git identity (per machine)

Name and GPG key are the same everywhere and stay in the tracked `.gitconfig`.
Only `user.email` differs by machine, so it lives in a **git-ignored, un-stowed**
`~/.gitconfig.local` that the tracked config `[include]`s:

- personal laptop → `ilrudie@gmail.com`
- work laptop → `ian.rudie@solo.io`

```sh
git config -f ~/.gitconfig.local user.email <the-right-email>
```

A missing `~/.gitconfig.local` is silently ignored, so a fresh machine refuses
to commit until you set the email — a deliberate failsafe against committing
under the wrong identity.

## Notes / decisions

- **No Node** by default, so no `prettier` (json/yaml/md won't auto-format in
  nvim) and no `markdownlint`. Add `node = "lts"` to the mise config if you want
  them. Build agentgateway proxy-only with `UI=0 make build`.
- **Rust** is driven per-project: `rust = "stable"` is the fallback, and
  agentgateway's `rust-toolchain.toml` (1.97) is auto-selected because
  `idiomatic_version_file_enable_tools = ["rust"]` is set.
- **Aliases** are split `common`/`darwin`/`linux` and auto-selected by `$OSTYPE`;
  the clipboard is abstracted behind `clip` (pbcopy vs xclip).
