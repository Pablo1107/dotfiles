# If you come from bash you might have to change your $PATH.
export PATH=$HOME/npm-global/bin:\
$HOME/.config/composer/vendor/bin:\
$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/pablo1107/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="agnoster"
# ZSH_THEME="bira"
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

fpath+=('/home/pablo1107/.npm-global/lib/node_modules/pure-prompt/functions')
autoload -U promptinit; promptinit

PURE_GIT_UNTRACKED_DIRTY=0

prompt pure
xdotool key ctrl+l

# User configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
export TERMINAL='termite -e'
export TERMCMD='termite'

# Change LS Colors to fix 777 permission being unreadably
LS_COLORS=$LS_COLORS:'ow=1;34:tw=1;34:' ; export LS_COLORS
eval "$(dircolors ~/.dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0000000"
    echo -en "\e]P1EC5f67"
    echo -en "\e]P299C794"
    echo -en "\e]P3FAC863"
    echo -en "\e]P46699CC"
    echo -en "\e]P5C594C5"
    echo -en "\e]P65FB3B3"
    echo -en "\e]P7C0C5CE"
    echo -en "\e]P865737E"
    echo -en "\e]P9EC5f67"
    echo -en "\e]PA99C794"
    echo -en "\e]PBFAC863"
    echo -en "\e]PC6699CC"
    echo -en "\e]PDC594C5"
    echo -en "\e]PE5FB3B3"
    echo -en "\e]PFD8DEE9"

    clear # Clear artifacts
fi

ch_prompt () {
	if [ $COLUMNS -le 69 ]
	then
		DEFAULT_USER=$USER
	else
		DEFAULT_USER=
	fi
}

ch_prompt
TRAPWINCH () {
	ch_prompt
}

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias sudo='sudo '
alias pacman=aura
alias music=~/scripts/music-environment.sh
alias test=vendor/bin/phpunit

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f -H'
export FZF_GIT_ADD_COMMAND='git ls-files -m -o --exclude-standard'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#export FZF_CTRL_T_COMMAND="$FZF_GIT_ADD_COMMAND"
