# Dockerfile_collection
This repository contains Dockerfile for stellarator-tools, Terpsichore, CHEASE, DCON

## All four section setup
Clone the four repositories mentioned above into your working directory and copy the `Dockerfile` from the outermost layer of this repository to your working directory. If you have created this image, please ignore the docker setup steps in Stellarator-Tools, TERPSICHORE, CHEASE, DCON below.

### Stellarator-tools
#### Setup
First clone the repository from stellarator-tools.
```bash
git clone https://github.com/ORNL-Fusion/Stellarator-Tools.git
```

```bash
cd Stellarator-Tools
```

Paste the `Dockerfile` under Stellarator-Tools directory in this repository then enter it.

```bash
├── CMakeLists.txt
├── Dockerfile
├── Documentation
│   ├── architecture.dox
│   ├── build_system.dox
│   ├── class anatomy.dox
│   ├── doxygen.dox
│   ├── main page.dox
│   └── testing.dox
├── images
│   ├── cmake1.png
│   ├── cmake2.png
│   ├── cmake3.png
│   └── flux_surfaces.png
├── LICENSE
├── README.md
└── setup_cmake
```

#### Docker setup
**Please make sure docker is installed.** \
Get the container from the image. You can delete `--rm` from the command if you want to reserve the current container.
```bash
docker build -t {your_image_name}
```
Create the container:
```bash
docker run -it --rm {your_image_name}
```
#### Makefile
Do the following
```bash
rm -rf build
mkdir build
cd build
```
```bash
ccmake ..
```
Then you'll see :
![](https://i.imgur.com/jj493Qm.png)
Turn on  `BUILD_DESCUR`, `BUILD_LIBSTELL`, `BUILD_MAKEGRID`, `BUILD_PARVEMC`, use the arrow keys on the keyboard for selection and press `Enter` to set it as `ON`. 

Press `c` to configure, then `g` to generate. \
(It's tricky that you may need to press `q` to quit, then command `ccmake ..` and press c again if you can't press `g`)

After generating, `Makefile` is generated. Just command :
```bash
make
```
Finally, you'll see :
![](https://i.imgur.com/hBu6BWK.png)

### Terpsichore
#### Setup
First clone the repository from Terpsichore.
```bash
git clone https://github.com/FIRST-fusion/TERPSICHORE.git
```
Paste the `Dockerfile` under Terpsichore directory in this repository then enter it.

#### Docker setup
**Please make sure docker is installed.** \
Get the container from the image. You can delete `--rm` from the command if you want to reserve the current container.
```bash
docker build -t {your_image_name}
```
Create the container:
```bash
docker run -it --rm {your_image_name}
```
#### Makefile
When the docker is setup, do the following:
```bash
source /opt/intel/oneapi/setvars.sh
```
```bash
make
```
You'll see the files made correctly.

### CHEASE
#### Setup
First clone the repository from CHEASE.
```bash
git clone https://github.com/FIRST-fusion/CHEASE.git
```
Paste the `Dockerfile` under CHEASE directory in this repository then enter it.
#### Makefile
Do the following:
```bash
make
```
You'll see the files made correctly.

### DCON
There are some compiler issues that need to be fixed.