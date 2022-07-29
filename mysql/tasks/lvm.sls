Creating PV:
  lvm.pv_present:
    - name: /dev/sdb
Creating Volume Group:
  lvm.vg_present:
    - name: mysqldata
    - devices: /dev/sdb
Creating data LV:
  lvm.lv_present:
    - name: data
    - vgname: mysqldata
    - size: 100G
Creating log LV:
  lvm.lv_present:
    - name: log
    - vgname: mysqldata
    - size: 50G
Creating backup LV:
  lvm.lv_present:
    - name: backup
    - vgname: mysqldata
    - size: 50G
Format data LV:
  blockdev.formatted:
    - name: /dev/mysqldata/data
    - fs_type: ext4
Format log LV:
  blockdev.formatted:
    - name: /dev/mysqldata/log
    - fs_type: ext4
Format backup LV:
  blockdev.formatted:
    - name: /dev/mysqldata/backup
    - fs_type: ext4
mount data mountpoint:
  mount.mounted:
    - name: /opt/mysql
    - device: /dev/mysqldata/data
    - fstype: ext4
    - opts: defaults
    - dump: 0
    - pass_num: 0
    - persist: True
    - mkmnt: True
mount backup mountpoint:
  mount.mounted:
    - name: /backup
    - device: /dev/mysqldata/backup
    - fstype: ext4
    - opts: defaults
    - dump: 0
    - pass_num: 0
    - persist: True
    - mkmnt: True
mount log mountpoint:
  mount.mounted:
    - name: /var/log/mysql
    - device: /dev/mysqldata/log
    - fstype: ext4
    - opts: defaults
    - dump: 0
    - pass_num: 0
    - persist: True
    - mkmnt: True