# Dockerfile_collection
This repository contains Dockerfile for stellarator-tools, ...
### Stellarator-tools
#### Setup
#### Docker setup
**Please make sure docker is installed.** \
Get the container from the image. You can delete `--rm` from the command if you want to reserve the current container.
```bash
docker run -it --rm  wangjasonx62301/fortran-stellarator-tools
```
Do the following
```bash
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



