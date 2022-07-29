Create physical volume for oracle:
    lvm.pv_present:
        - name: /dev/sdb

Create volume group for oracle:
    lvm.vg_present:
        - name: vgoracle
        - devices: /dev/sdb

Create logical volume for oracle:
    lvm.lv_present:
        - name: lvoracle
        - vgname: vgoracle
        - extents: '+100%FREE'

Format logical volume to ext4:
    blockdev.formatted:
        - name: /dev/vgoracle/lvoracle
        - fs_type: ext4

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