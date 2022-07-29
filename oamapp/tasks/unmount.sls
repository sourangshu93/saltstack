{% import_yaml 'salt/oam/vars/map.yaml' as oam %}
Unmount DropBox from server:
  mount.unmounted:
    - name: "{{ oam.drop_box }}"
    - device: l3corpit.wdc-03-isi01.oc.vmware.com:/ifs/corpit/pcapdropbox
Unmount iam mount from Server:
  mount.unmounted:
    - name: "{{ oam.iam_mount }}"
    - device: l3corpit.wdc-03-isi01.oc.vmware.com:/ifs/corpit/bp