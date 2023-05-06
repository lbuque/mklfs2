# mklfs2

Make a custom littlefs2 image

## build

```shell
$ sudo apt install git
$ git submodule update --init --recursive
$ make
```

## usage

```
usage: mklfs2 -c <pack-dir> -b <block-size> -r <read-size> -p <prog-size> -l <lookahead> -s <filesystem-size> -i <image-file-path>
```

- `pack-dir`: Make this directory the root directory of littlefs2.
- `block-size`: Size of an erasable block, generally 4096.
- `read-size`: Minimum size of a block read.
- `prog-size`: Minimum size of a block program.
- `lookahead`: Size of the lookahead buffer in bytes.
- `filesystem-size`: Size of the littlefs2 image.
- `image-file-path`: The output path of the littlefs2 mirror.

## micropython

```shell
./mklfs2 -c files -b 4096 -r 32 -p 32 -l 32 -s 0x600000 -i rootfs.bin
```
