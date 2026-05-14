# setopt APPEND_HISTORY unsetopt INC_APPEND_HISTORY # setopt AUTO_LIST		# these two should be turned off # setopt AUTO_REMOVE_SLASH # setopt AUTO_RESUME		# tries to resume command of same name unsetopt BG_NICE		# do NOT nice bg commands
setopt CORRECT			# command CORRECTION
setopt INC_APPEND_HISTORY # save to history before exitting
setopt EXTENDED_HISTORY		# puts timestamps in the history
setopt HIST_FIND_NO_DUPS  # ignore duplicated in history during search
setopt MULTIBYTE
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
# setopt HASH_CMDS		# turns on hashing
setopt MENUCOMPLETE
#setopt ALL_EXPORT  (THIS WAS CAUSING CRASH ON TAB PRESS)
# don't exit on ^D
setopt ignoreeof
# Set/unset  shell options
setopt   notify globdots correct pushdtohome cdablevars autolist noclobber appendcreate
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignorealldups pushdsilent 
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash beep
# Completion
zstyle ':completion:*' special-dirs false

autoload -U url-quote-magic bracketed-paste-magic
zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-magic

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line
bindkey '^X^E' edit-command-line
