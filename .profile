#   Change Prompt
#   ------------------------------------------------------------
    export PS1="[\[\033[33;1m\]\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]^_^"; else echo "\\[\\033[31m\\]\\\>_\\\<"; fi\` \[\033[33m\]\A \[\033[36m\]\w\[\033[0m\]] "
    export PS2="| => "

#   Miscellaneous
#   ------------------------------------------------------------
    export TERM=xterm-256color
    export LANG=en_US.utf-8
    export CPUPROFILE_FREQUENCY=100                # For google profiler

#   Set Paths
#   ------------------------------------------------------------
    export PATH=$PATH
    export MANPATH=$(manpath)
    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH
    export JAVA_HOME="$(/usr/libexec/java_home)"

#   Set Default Editor (change 'Nano' to the editor of your choice)
#   ------------------------------------------------------------
    export EDITOR=emacs
    export SVN_EDITOR=/usr/bin/vim

#   MacOS stuff    
#   ------------------------------------------------------------
#   Set default blocksize for ls, df, du from this:
#   http://hints.macworld.com/comment.php?mode=view&cid=24491
    export BLOCKSIZE=1k

#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles) from
#   http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad
