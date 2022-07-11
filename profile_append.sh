# start cron job to reclaim WSL2 memory for windows OS re-use every minute
# run following:
# sudo echo 3 > /proc/sys/vm/drop_caches && sudo touch /root/drop_caches_last_run
# Do not forget to set:
# `%sudo ALL=NOPASSWD: /etc/init.d/cron start`
# via `sudo visudo` - see content of ./etc/sudoers.tmp
# https://github.com/microsoft/WSL/issues/4166#issuecomment-604707989
if [ -n "$WSL_DISTRO_NAME" ]; then
  # sudo /etc/init.d/cron start &> /dev/null
  umask 022
fi

mkdir -p $HOME/.local/bin

if [ -d "$HOME/dotfiles/scripts" ] ; then
    PATH="$HOME/dotfiles/scripts:$PATH"
fi
