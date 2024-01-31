sudo dnf clean all
sudo dnf update -y

sudo mkdir /shared/gromacs
sudo mkdir /shared/gromacs/sources
cd /shared/gromacs/sources
sudo curl -O https://ftp.gromacs.org/gromacs/gromacs-2023.4.tar.gz
sudo tar xfz gromacs-2023.4.tar.gz
cd gromacs-2023.4
sudo mkdir build
cd build
sudo cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON
make
make check
sudo make install
source /usr/local/gromacs/bin/GMXRC
