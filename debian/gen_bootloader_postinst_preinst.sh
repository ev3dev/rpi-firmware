#!/bin/sh

if ! [ -d ../boot ]; then
  printf "Can't find boot dir. Run from debian subdir\n"
  exit 1
fi

printf "#!/bin/sh\n" > raspberrypi-bootloader.postinst
for FN in ../boot/* ../boot/*/*; do
  if ! [ -d "$FN" ]; then
    FN=${FN#../boot/}
    printf "rm -f /boot/$FN\n" >> raspberrypi-bootloader.postinst
    printf "dpkg-divert --package rpikernelhack --remove --rename /boot/$FN\n" >> raspberrypi-bootloader.postinst
    printf "sync\n" >> raspberrypi-bootloader.postinst
  fi
done
printf "#DEBHELPER#\n" >> raspberrypi-bootloader.postinst

printf "#!/bin/sh\n" > raspberrypi-bootloader.preinst
printf "mkdir -p /usr/share/rpikernelhack/overlays\n" >> raspberrypi-bootloader.preinst
for FN in ../boot/* ../boot/*/*; do
  if ! [ -d "$FN" ]; then
    FN=${FN#../boot/}
    printf "dpkg-divert --package rpikernelhack --divert /usr/share/rpikernelhack/$FN /boot/$FN\n" >> raspberrypi-bootloader.preinst
  fi
done
printf "#DEBHELPER#\n" >> raspberrypi-bootloader.preinst
