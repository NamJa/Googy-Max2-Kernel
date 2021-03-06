#!/sbin/busybox sh

extract_payload()
{
  payload_extracted=1
  chmod 755 /sbin/read_boot_headers
  eval $(/sbin/read_boot_headers /dev/block/mmcblk0p5)
  load_offset=$boot_offset
  load_len=$boot_len
  cd /
  dd bs=512 if=/dev/block/mmcblk0p5 skip=$load_offset count=$load_len | tar x
}

. /res/customconfig/customconfig-helper
read_defaults
read_config

mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs
payload_extracted=0

cd /

if [ "$install_root" == "on" ];
then
  if [ -s /system/xbin/su ];
  then
    echo "Superuser already exists"
  else
    if [ "$payload_extracted" == "0" ];then
      extract_payload
    fi
    rm -f /system/bin/su
    rm -f /system/xbin/su
    mkdir /system/xbin
    chmod 755 /system/xbin
    xzcat /res/misc/payload/su.xz > /system/xbin/su
    chown 0.0 /system/xbin/su
    chmod 6755 /system/xbin/su

    rm -f /system/bin/daemonsu
    rm -f /system/xbin/daemonsu
    mkdir /system/xbin
    chmod 755 /system/xbin
    xzcat /res/misc/payload/daemonsu.xz > /system/xbin/daemonsu
    chown 0.0 /system/xbin/daemonsu
    chmod 6755 /system/xbin/daemonsu
    
#    rm -f /system/app/*uper?ser.apk
#    rm -f /system/app/?uper?u.apk
#    rm -f /system/app/*chainfire?supersu*.apk
#    rm -f /data/app/*uper?ser.apk
#    rm -f /data/app/?uper?u.apk
#    rm -f /data/app/*chainfire?supersu*.apk
#    rm -rf /data/dalvik-cache/*uper?ser.apk*
#    rm -rf /data/dalvik-cache/*chainfire?supersu*.apk*
#    xzcat /res/misc/payload/Superuser.apk.xz > /system/app/Superuser.apk
#    chown 0.0 /system/app/Superuser.apk
#    chmod 644 /system/app/Superuser.apk
  fi
fi;

# if [ ! -f /data/app/STweaks_Googy-Max.apk ] && [ ! -f /data/app/STweaks.apk ] ;then
#  rm -f /system/app/STweaks.apk
#  rm -f /system/app/STweaks_Googy-Max.apk
#  rm -f /data/app/STweaks.apk
#  rm -f /data/app/STweaks_Googy-Max.apk
#  rm -f /data/app/com.gokhanmoral.STweaks*
#  rm -f /data/app/*.STweaks*
#  rm -f /data/dalvik-cache/*STweaks*.*
#  rm -f /data/app/com.gokhanmoral.stweaks*
#  rm -f /data/app/*.stweaks*
#  rm -f /data/dalvik-cache/*stweaks*

#  chown 0.0 /res/STweaks_Googy-Max.apk
#  chmod 644 /res/STweaks_Googy-Max.apk
#  cp /res/STweaks_Googy-Max.apk /data/app/STweaks_Googy-Max.apk
#  chown 0.0 /data/app/STweaks_Googy-Max.apk
#  chmod 644 /data/app/STweaks_Googy-Max.apk
#  chmod 644 /system/app/STweaks_Googy-Max.apk
#fi

rm -rf /res/misc/payload

/sbin/busybox mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
