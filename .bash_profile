# .bash_profile
# This will only be run when logging in

# Source .profile for environment variables
if [[ -s ~/.profile ]]; then
    . ~/.profile
fi

# Source .bashrc for handy functions and settings
if [[ -s ~/.bashrc ]]; then
    . ~/.bashrc
fi
