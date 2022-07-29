Create swap PV:
    lvm.pv_present:
        - name: /dev/sdb

Create oracle PV:
    lvm.pv_present:
        - name: /dev/sdc

Create oracle data PV:
    lvm.pv_present:
        - name: /dev/sdd

Create swap VG:
    lvm.vg_present:
        - name: vgswap2
        - devices: /dev/sdb

Create vgoracle VG:
    lvm.vg_present:
        - name: vgoracle
        - devices: /dev/sdc

Create vgoradata VG:
    lvm.vg_present:
        - name: vgoradata
        - devices: /dev/sdd

Creating swap LV:
  lvm.lv_present:
    - name: lvswap2
    - vgname: vgswap2
    - extents: '+100%FREE'

Creating lvoracle LV:
  lvm.lv_present:
    - name: lvoracle
    - vgname: vgoracle
    - extents: '+100%FREE'

Creating lvoradata LV:
  lvm.lv_present:
    - name: lvoradata
    - vgname: vgoradata
    - extents: '+100%FREE'

Format swap partirtion:
    cmd.run:
        - name: /usr/sbin/mkswap /dev/vgswap2/lvswap2

Format lvoracle LV:
  blockdev.formatted:
    - name: /dev/vgoracle/lvoracle
    - fs_type: ext4

Format lvoradata LV:
  blockdev.formatted:
    - name: /dev/vgoradata/lvoradata
    - fs_type: ext4

Mount swap mountpoint:
    mount.swap:
        - name: /dev/vgswap2/lvswap2
        - persist: True
Activate swap partition:
    cmd.run:
        - name: swapon -a
Mount oracle mountpoint:
    mount.mounted:
        - name: /oracle
        - device: /dev/vgoracle/lvoracle
        - fstype: ext4
        - opts: defaults
        - dump: 0
        - pass_num: 0
        - persist: True
        - mkmnt: True

Mount oradata mountpoint:
    mount.mounted:
        - name: /oracle/oradata
        - device: /dev/vgoradata/lvoradata
        - fstype: ext4
        - opts: defaults
        - dump: 0
        - pass_num: 0
        - persist: True
        - mkmnt: True
Set permission for Oracle mount:
    file.directory:
        - name: /oracle
        - user: oracle
        - group: oinstall
        - dir_mode: 755
        - recurse:
            - user
            - group
            - mode