Contains steps that are only required once for the demo.
# Populate the NFS share with the required files for the tests and download all experiments to the NFS share and set all permissions
```bash
sudo -i
chmod -R 755 /cyclenfs
cd /cyclenfs
git clone https://github.com/gevaertw/CycleCloudDemo.git
mkdir /cyclenfs/results
chmod -R 666 /cyclenfs/results

```
- This will populate the NFS share with the required files for the tests and download all experiments to the NFS share and set all permissions.