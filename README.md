# MEAD

MørktHrad's Executable Auto-Ricing Dongle

## Objectives

While many people love customizing their Linux rice, some other people just want an out-of-the-box-usable OS. Usually, the latter don't choose a light-weight distribution like Arch Linux, just because of all the hassle of making everything work.

Of course, everyone that uses Arch Linux knows about this, however, I decided to create this script pack due to some friends asking me to help them config their system, given that they liked how mine worked, but didn't feel like doing it on their own.

This is how MEAD is born. It is designed to work with Arch Linux + i3-gaps with the following objectives in mind:

- Unite a bunch of daily usage scripts, that may be useful for the average desktop/laptop user
- Easily customizable
- Highly modular: Disable anything you don't need

## Instalation

Installation isn't automatic yet (Yes, the Auto-Ricing part is still WIP. For now, you have to set up some things manually.)

In the future, there will be a script which does all this process automatically, it is still being worked on.

- First, download the package and place it anywhere on your system. Default path is ` $HOME/MEAD `
- Inside the `.configs` folder, you'll find some folders containing config files for some programs. Link them to ` ~/.config ` with the ` ln -s ` command. So, inside of the `.configs` folder found in the `MEAD` folder, execute the following commands:
```sh
ln -s dunst/dunstrc ~/.config/dunst/dunstrc
ln -s i3/config ~/.config/i3/config
ln -s i3blocks/config ~/.config/i3blocks/config
ln -s rofi/MorktHrad.rasi ~/.config/rofi/MorktHrad.rasi
ln -s rofi/bar.rasi ~/.config/rofi/bar.rasi
ln -s rofi/bar.rasi2 ~/.config/rofi/bar.rasi2
ln -s rofi/barconfig ~/.config/rofi/barconfig
ln -s rofi/config ~/.config/rofi/config
```
- All scripts depend on a bunch of relative paths and vars. Edit ` ~/.bash_profile ` adding the following lines for default configuration:
```sh
export TERMINAL="kitty"
export BROWSER="firefox"
export MEAD_PATH="$HOME/MEAD"
export MEAD_PATH2="$HOME/MEAD/.auxfiles"
export ROFIBARPATH="$MEAD_PATH/.configs/rofi/barconfig"
export ROFIFULLPATH="$MEAD_PATH/.configs/rofi/config"
export SCROTDIR="$HOME/Pictures/screenshots"
```

For custom configuration:

- `TERMINAL` is to be replaced with your favourite term emulator.
- `BROWSER` is to be replaced with your favourite web browser.
- `MEAD_PATH"` is to be replaced with the full path to where you placed the root of the MEAD script package.
- `MEAD_PATH2` is to be replaced with the full path to where you'd like to place other auxiliar files which may contain sensitive information (Passwords for hotspots you create, openvpn config files...). This is why you can separate it from the main `.auxfiles` folder, but they can be the same.
- `ROFIBARPATH`  points to one of the rofi config files MEAD uses. It shouldn't really be changed unless you want to use another config file instead.
- The same goes for `ROFIFULLPATH`.
- `SCROTDIR` points to where screenshots will be saved.

MEAD scripts usually show some kind of feedback on the i3bar. This feedback is obtained by writing some info onto the files in `.auxfiles`. We need to reset these files on boot, so that we don't get wrong info on our bar. To do this, we'll create a simple systemd service.
- Modify the `scrclear.service` file found on the `MEAD` folder, and change the `ExecStart` field so that it points to where the `clear/clear.sh` script is on your system.
- Move the file to the systemd folder. `# mv scrclear.service /etc/systemd/system/`
- Enable the service. `# systemctl enable scrclear`
- Modify the `MEAD/clear/clear.sh` script, changing the path in the `auxfilesf` variable.

This should make most scripts work as intended. However, some scripts need further explanation:

## Brightness script configuration

This script changes the screen and keyboard (on Asus laptops) brightness.

So that it works as intended, you should check if the `brgpath` points to your backlight folder, as well as the `kbdpath` points to your laptop's keyboard led's folder.

## Sethotspot script configuration

This script needs to know your wifi interface name. On asus laptops, this is the 3rd entry on the `$ ip a` command output.

Check if your wifi interface is listed on the 3rd entry, and if it isn't, change the first line of the script to grep for that entry.

- `ip a`, and search for something like `wlp2s0`, `wlan`, or some similar entries.
- Check the number they're listed as
- Change the `grep 3: ` part of the first script line with whichever number you get.

## Wifi and Ethernet scripts for i3blocks configuration

Under the `i3blocks` folder, you'll find some scripts that output text to i3blocks.

2 of these scripts also need to find your internet interfaces.

- Do the same modifications to the `wifi.sh` script.
- For the `ethernet.sh`, do the same, except for the index in which `eth0` or `enp3s0` or something similar is listed.

# Usage of the scripts
WIP
