# /etc/default/grub - disable LSPCON and MST
`GRUB_CMDLINE_LINUX_DEFAULT="quiet i915.force_lspcon=0 i915.enable_dp_mst=0 i915.enable_psr=0"` & `sudo update-grub`

# /home/<USER>/.xinitrc
```bash
#!/bin/sh
# power saving off
xset -dpms
xset s off
xset s noblank

# hide cursor after idle
unclutter -idle 0.5 &

# launch Chromium in kiosk
exec chromium \
  --kiosk '<GRAFANA_PLAYLIST_URL>' \
  --start-fullscreen \
  --window-position=0,0 \
  --window-size=1920,1080 \
  --noerrdialogs \
  --disable-session-crashed-bubble \
  --disable-infobars \
  --incognito
```

# start command on tty1 - uses .xinitrc from the home directory
`XORG_RUN_AS_ROOT=1 startx -- :0 vt1 -keeptty -nolisten tcp`

# stop command on other tty or ssh
`pkill chromium`