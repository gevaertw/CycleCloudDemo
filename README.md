Use at your own risk responsibility etc.  for POC purposes only, designed for functionality, not security.  Im not giving support, nor does my employer.

# Post deployment tasks:
Log on to the management windows 11 workstation and run the following command:
```
ssh-keygen
```

Log on to the cyclecloud server using Bastion and run the following command:
```bash 
cyclecloud initialize
```

This command will create a .cycle folder with the config.ini file in the cyclecloud user's home directory.  From this point you can work with the CLI and the API.

# Working images
Some Almalinx images are not working, the following are working:

x64 almalinux-hpc almalinux 8_6-hpc-gen2  almalinux:almalinux-hpc:8_6-hpc-gen2:8.6.2023012402  8.6.2023012402

! x64 almalinux-hpc almalinux 8_6-hpc-gen2  almalinux:almalinux-hpc:8_6-hpc-gen2:8.6.2023022301  8.6.2023022301

! x64 almalinux-hpc almalinux 8_6-hpc-gen2  almalinux:almalinux-hpc:8_6-hpc-gen2:8.6.2023031501  8.6.2023031501

! x64 almalinux-hpc almalinux 8_6-hpc-gen2  almalinux:almalinux-hpc:8_6-hpc-gen2:8.6.2023041401  8.6.2023041401

! x64 almalinux-hpc almalinux 8_7-hpc-gen2  almalinux:almalinux-hpc:8_7-hpc-gen2:8.7.2023060101  8.7.2023060101

! x64 almalinux-hpc almalinux 8_7-hpc-gen2  almalinux:almalinux-hpc:8_7-hpc-gen2:8.7.2023111401  8.7.2023111401

