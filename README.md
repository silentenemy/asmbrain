# asmbrain
A bare metal brainf*ck interpreter written in pure assembly language.

![asmbrain screenshot](https://user-images.githubusercontent.com/5739068/44005982-f07638c6-9e84-11e8-8859-f6d9f02d7832.png)

## Assembling
You need `fasm` to assemble asmbrain.

```
$ fasm main.asm
```

The resulting file `main.bin` is ready executable.

## Running in VM
Using QEMU should be okay.

```
$ qemu-system-i386 -fda main.bin
```

## Running on real hardware
I suppose you know what you do.

Write asmbrain to USB stick:

```
$ dd if=main.bin of=/dev/sdX bs=512
```

Now you can boot from your USB stick.
