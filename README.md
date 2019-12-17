# nimgpiod
[libgpiod](https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/about/) wrapper for nim lang

tested on Rpi-2  
event tests are using bcm2835pii lib for pulling line high -> creating events  
libgpiod v1.4 wrapped, tested with 1.2.3 on Rpi2  
  
AFAIK should run as root  
  
```
  import posix
  echo "uid: ",getuid(), " euid: ", geteuid()

  block test1:
    echo "\n test#1 \n"
    var gpiochip0: ChipPtr
    try:
      gpiochip0 = chipOpen("/dev/gpiochip0")
      if gpiochip0.isNil : quit("gpiochip0 not available, quitting")
    except:
      quit("gpiochip0 not available, quitting")

    echo "gpiod_chip_num_lines(gpiochip0) ", numLines(gpiochip0)
    echo "gpiod_chip_get_line(gpiochip0, 12)"
    var line12 = getLine(gpiochip0, 12)
    if line12.isNil: 
      chipClose(gpiochip0)
      quit("failed to get line #12")

    echo "gpiod_line_is_used(line12) ", isUsed(line12)
    echo "offset", line12.offset
    echo "gpiod_line_request_input ", requestInput(line12, "gpio test")
    echo "gpiod_line_get_value(line12) ", getValue(line12)
    echo "gpiod_line_is_used(line12) ", isUsed(line12)

    release(line12)
    chipClose(gpiochip0)

```