# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64/:/root/anaconda3/lib/
export PATH="/root/anaconda3/bin:$PATH"
export CDPATH=~/see/bin/:~/see/:~/see/pgm/ccc:~/see/pgm/cpp:
