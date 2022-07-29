{% import_yaml 'salt/oam/vars/map.yaml' as oam %}
IAM Share Mount:
    mount.mounted:
        - name: "{{ oam.iam_mount }}"
        - device: l3corpit.wdc-03-isi01.oc.vmware.com:/ifs/corpit/bp
        - fstype: nfs
        - opts: rw,intr,soft,rsize=32768,wsize=32768,vers=3
        - mkmnt: True
        - persist: False