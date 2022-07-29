{% import_yaml 'salt/oam/vars/map.yaml' as oam %}
DropBox Mount:
  mount.mounted:
    - name: '{{ oam.drop_box }}'
    - device: l3corpit.wdc-03-isi01.oc.vmware.com:/ifs/corpit/pcapdropbox
    - fstype: nfs
    - opts: ro,intr,soft,rsize=32768,wsize=32768
    - mkmnt: True
    - persist: False