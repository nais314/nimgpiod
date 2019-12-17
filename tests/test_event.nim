# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import posix

import nimgpiod

test "event_test":
    echo "\n event_test \n"
    var gpiochip0: ChipPtr
    try:
      gpiochip0 = chipOpen("/dev/gpiochip0")
      if gpiochip0.isNil : quit("gpiochip0 not available, quitting")
    except:
      quit("gpiochip0 not available, quitting")

    echo "gpiod_chip_num_lines(gpiochip0) ", numLines(gpiochip0)
    echo "gpiod_chip_get_line(gpiochip0, 12)"
    var line12 = getLine(gpiochip0, 12)
    if line12.isNil: quit("failed to get line #12")
    echo "gpiod_line_is_used(line12) ", isUsed(line12)
    echo "gpiod_line_request_both_edges_events", requestBothEdgesEvents(line12, "gpio test")
    echo "gpiod_line_get_value(line12) ", getValue(line12)
    echo "gpiod_line_is_used(line12) ", isUsed(line12)
    var ts : Timespec
    ts.tv_sec = 1.Time
    echo "gpiod_line_event_wait ",eventWait(line12,ts)

    release(line12)
    chipClose(gpiochip0)
