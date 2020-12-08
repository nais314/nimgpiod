## wrapper for /usr/include/gpiod.h - SPDX-License-Identifier: LGPL-2.1-or-later
## wrapper for /usr/include/gpiod.h - Copyright (C) 2017-2018 Bartosz Golaszewski <bartekgola@gmail.com>
## https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/about/
## clone it && make install
## apt install libgpiod on Rpi Buster
##
## wrapper by István Nagy - SPDX-License-Identifier: LGPL-2.1-or-later (...)
##
## no Pull-Up/Down or Alt function support for GPIO
##   - use board specific companion lib
## https://elinux.org/images/9/9b/GPIO_for_Engineers_and_Makers.pdf Linus Walleij
## https://archive.fosdem.org/2018/schedule/event/new_gpio_interface_for_linux/ 	Bartosz Golaszewski
##
## tested on Rpi-2
## event tests are using bcm2835pii lib for pulling line high -> creating events
## libgpiod v1.4 wrapped, tested with 1.2.3 on Rpi2
{.passL: "-lgpiod".}

from posix import Timespec, Time
#-------------------------------------------------------


type
  ChipPtr* = pointer # underlying struct is not exposed :(
  LinePtr* = pointer # underlying struct is not exposed :(

type 
  LineRequestConfig* {.importc:"struct gpiod_line_request_config",
                                  header:"gpiod.h".}= object
    consumer*: cstring
    request_type*: cint
    flags*: cint

  LineEvent* {.importc:"struct gpiod_line_event", header:"gpiod.h".} = object
    ts*: Timespec
    event_type*: cint

const
  LINE_BULK_MAX_LINES* = 64

type LineBulk* {.importc: "struct gpiod_line_bulk", header: "gpiod.h".} = object
  lines*:array[0..LINE_BULK_MAX_LINES-1, LinePtr]
  num_lines*:cuint

#----#

const
  LINE_DIRECTION_INPUT*: cint = 1
  LINE_DIRECTION_OUTPUT*: cint  = 2

  LINE_ACTIVE_STATE_HIGH*: cint  = 1
  LINE_ACTIVE_STATE_LOW*: cint  = 2

  LINE_EVENT_RISING_EDGE*: cint = 1
  LINE_EVENT_FALLING_EDGE*: cint = 2

  # REQUEST TYPES #
  LINE_REQUEST_DIRECTION_AS_IS*: cint = 1
  LINE_REQUEST_DIRECTION_INPUT*: cint = 2
  LINE_REQUEST_DIRECTION_OUTPUT*: cint = 3
  LINE_REQUEST_EVENT_FALLING_EDGE*: cint = 4
  LINE_REQUEST_EVENT_RISING_EDGE*: cint = 5
  LINE_REQUEST_EVENT_BOTH_EDGES*: cint = 6
  # FLAGS TYPES #
  LINE_REQUEST_FLAG_OPEN_DRAIN* = 0b00
  LINE_REQUEST_FLAG_OPEN_SOURCE* = 0b01
  LINE_REQUEST_FLAG_ACTIVE_LOW* = 0b10


proc versionString*():cstring{.importc: "gpiod_version_string", header: "gpiod.h".}

# INIT #----------------------------------------------

proc chipOpen*(path: cstring): ChipPtr {.importc: "gpiod_chip_open", header: "gpiod.h".}
proc chipClose*(chip: ChipPtr) {.importc: "gpiod_chip_close", header: "gpiod.h".}
proc numLines*(chip: ChipPtr): cuint {.importc: "gpiod_chip_num_lines", header: "gpiod.h".}

proc isUsed*(line:LinePtr):bool{.importc: "gpiod_line_is_used", header: "gpiod.h".}
proc getLine*(chip:ChipPtr, offset: cuint): LinePtr {.importc: "gpiod_chip_get_line", header: "gpiod.h".}


# REQUEST & EVENT #------------------------------------

proc request*(line:LinePtr,
              config: var LineRequestConfig,
              default_val: cint): cint
              {.importc: "gpiod_line_request", header: "gpiod.h".}
proc release*(line:LinePtr){.importc: "gpiod_line_release", header: "gpiod.h".}
proc requestInput*(line:LinePtr,
                   consumer: cstring): cint 
                   {.importc: "gpiod_line_request_input", header: "gpiod.h".}
proc requestOutput*(line:LinePtr,
                    consumer: cstring,
                    default_val: cint): cint 
                    {.importc: "gpiod_line_request_output", header: "gpiod.h".}
# TEST #
proc isRequested*(line:LinePtr):bool{.importc: "gpiod_line_is_requested", header: "gpiod.h".}
proc isFree*(line:LinePtr):bool{.importc: "gpiod_line_is_free", header: "gpiod.h".}
# EVENTS #
proc requestRisingEdgeEvents*(line:LinePtr,
consumer: cstring): cint {.importc: "gpiod_line_request_rising_edge_events", header: "gpiod.h".}
proc requestFallingEdgeEvents*(line:LinePtr,
consumer: cstring): cint {.importc: "gpiod_line_request_falling_edge_events", header: "gpiod.h".}
proc requestBothEdgesEvents*(line:LinePtr,
consumer: cstring): cint {.importc: "gpiod_line_request_both_edges_events", header: "gpiod.h".}
# POLL #
## @return 0 if wait timed out, -1 if an error occurred, 1 if an event occurred.
proc eventWait*(line:LinePtr,
        timeout:var Timespec): cint {.importc: "gpiod_line_event_wait", header: "gpiod.h".}
proc eventGetFd*(line:LinePtr): cint {.importc: "gpiod_line_event_get_fd", header: "gpiod.h".}
proc eventReadFd*(fd:cint, event:var Line_Event): cint {.importc: "gpiod_line_event_read_fd", header: "gpiod.h".}


# READ WRITE #-------------------------------------------

proc getValue*(line:LinePtr): cint {.importc: "gpiod_line_get_value", header: "gpiod.h".}
proc setValue*(line:LinePtr, value: cint): cint {.importc: "gpiod_line_set_value", header: "gpiod.h".}


# GET INFO #------------------------------------------

proc update*(line:LinePtr):cuint{.importc: "gpiod_line_update", header: "gpiod.h".}
proc needsUpdate*(line:LinePtr):bool{.importc: "gpiod_line_needs_update", header: "gpiod.h".}

proc offset*(line:LinePtr):cuint{.importc: "gpiod_line_offset", header: "gpiod.h".}
proc name*(line:LinePtr):cstring{.importc: "gpiod_line_name", header: "gpiod.h".}
proc direction*(line:LinePtr):cint{.importc: "gpiod_line_direction", header: "gpiod.h".}
proc consumer*(line:LinePtr):cstring{.importc: "gpiod_line_consumer", header: "gpiod.h".}
proc activeState*(line:LinePtr): cint {.importc: "gpiod_line_active_state", header: "gpiod.h".}

proc isOpenDrain*(line:LinePtr):bool{.importc: "gpiod_line_is_open_drain", header: "gpiod.h".}
proc isOpenSource*(line:LinePtr):bool{.importc: "gpiod_line_is_open_source", header: "gpiod.h".}


# MISC #-------------------------------------------------
proc find*(name:cstring): LinePtr {.importc: "gpiod_line_find", header: "gpiod.h".}
proc closeChip*(line:LinePtr): LinePtr {.importc: "gpiod_line_close_chip", header: "gpiod.h".}
proc getChip*(line:LinePtr): ChipPtr {.importc: "gpiod_line_get_chip", header: "gpiod.h".}

# BULK FUNCTIONS #
when defined(bulk):
  include "nimgpiod/bulk.nim"
# CTXLESS FUNCTIONS #
when defined(ctxless):
  include "nimgpiod/ctxless.nim"

# ----------------------------------------------------- #






####        ######## ########  ######  ######## 
####           ##    ##       ##    ##    ##    
####           ##    ##       ##          ##    
####           ##    ######    ######     ##    
####           ##    ##             ##    ##    
####           ##    ##       ##    ##    ##    
####           ##    ########  ######     ##    
                                  
when isMainModule:
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









  block event_test:
    echo "\n event_test \n"
    var gpiochip0: ChipPtr
    try:
      gpiochip0 = chipOpen("/dev/gpiochip0")
      if gpiochip0.isNil : quit("gpiochip0 not available, quitting")
    except:
      quit("gpiochip0 not available, quitting")

    echo "numLines(gpiochip0) ",numLines(gpiochip0)
    echo "getLine(gpiochip0, 12)"
    var line12 = getLine(gpiochip0, 12)
    if line12.isNil: quit("failed to get line #12")
    echo "isUsed(line12) ",isUsed(line12)
    echo "requestBothEdgesEvents", requestBothEdgesEvents(line12, "gpio test")
    echo "getValue(line12) ",getValue(line12)
    echo "isUsed(line12) ",isUsed(line12)
    var ts : Timespec
    ts.tv_sec = 1.Time
    echo "eventWait ",eventWait(line12,ts)

    release(line12)
    chipClose(gpiochip0)





  block lineptr_test:
    echo "\n lineptr_test \n"
    var gpiochip0: ChipPtr
    try:
      gpiochip0 = chipOpen("/dev/gpiochip0")
      if gpiochip0.isNil : quit("gpiochip0 not available, quitting")
    except:
      quit("gpiochip0 not available, quitting")

    echo "getLine(gpiochip0, 12)"
    var line12 = getLine(gpiochip0, 12)
    if line12.isNil: quit("failed to get line #12")
    echo "isUsed(line12) ",isUsed(line12)
    echo "requestBothEdgesEvents", requestBothEdgesEvents(line12, "gpio test")
    echo "getValue(line12) ",getValue(line12)
    echo "isUsed(line12) ",isUsed(line12)
    #var ts : Timespec
    #ts.tv_sec = 1.Time
    #echo "eventWait ",eventWait(line12,ts.addr)

    echo "offset ", offset(line12)
    echo "name ", name(line12)
    echo "direction ", direction(line12)
    echo "consumer ", consumer(line12)

    echo "eventGetFd ", eventGetFd(line12)

    release(line12)
    chipClose(gpiochip0)




#[ 
  import bcm2835pii, os
  block thread_poll_test:
    echo "\n thread_poll_test \n"
    var gpiochip0: ChipPtr
    try:
      gpiochip0 = chipOpen("/dev/gpiochip0")
      if gpiochip0.isNil : quit("gpiochip0 not available, quitting")
    except:
      quit("gpiochip0 not available, quitting")

    echo "getLine(gpiochip0, 12)"
    var line12 = getLine(gpiochip0, 12)
    if line12.isNil: quit("failed to get line #12")
    echo "isUsed(line12) ",isUsed(line12)
    echo "requestBothEdgesEvents", requestBothEdgesEvents(line12, "gpio test")
    echo "getValue(line12) ",getValue(line12)
    echo "isUsed(line12) ",isUsed(line12)

    echo "offset ", offset(line12)
    echo "name ", name(line12)
    echo "direction ", direction(line12)
    echo "consumer ", consumer(line12)

    echo "eventGetFd ", eventGetFd(line12)

    
    
    var errno = bcm2835pii.init()
    if errno < 0:
      echo "init failure ", errno
    else:
      echo "init success"

    gpio_set_pull(12, Pull.DOWN)

    proc callback(){.gcsafe.}= echo "\n\tBANG!"

    #[ var thr: Thread[LinePtr]
    proc poller(line: LinePtr){.thread.}=
      var ts : Timespec
      ts.tv_sec = 3.Time
      echo "eventWait "
      var res = eventWait(line,ts.addr)
      if res == 1: callback()
    createThread(thr,poller,line12) ]#
    type thr_arg = object
      line: LinePtr
      cb:proc():void

    var 
      thr: Thread[thr_arg]
      tharg: thr_arg
    tharg.line = line12
    tharg.cb=callback

    proc poller(v:thr_arg){.thread.}=
      var ts : Timespec
      ts.tv_sec = 3.Time
      echo "eventWait "
      var res = eventWait(v.line,ts.addr)
      {.gcsafe.}:
        if res == 1: v.cb()
    createThread(thr,poller,tharg)

    gpio_set_pull(12, Pull.UP)
    os.sleep(10)
    gpio_set_pull(12, Pull.DOWN)

    release(line12)
    chipClose(gpiochip0)



  import bcm2835pii, os
  block bulk_test:
    echo "\n bulk_test \n"
    var gpiochip0: ChipPtr
    try:
      gpiochip0 = chipOpen("/dev/gpiochip0")
      if gpiochip0.isNil : quit("gpiochip0 not available, quitting")
    except:
      quit("gpiochip0 not available, quitting")

    var errno = bcm2835pii.init()
    if errno < 0:
      echo "init failure ", errno
    else:
      echo "init success"

    echo "getLine(gpiochip0, 12)"
    var line12 = getLine(gpiochip0, 12)
    if line12.isNil: quit("failed to get line #12")

    var blines: Line_Bulk
    blines.bulkInit()
    blines.bulkAdd(line12)

    var grequest: LineRequestConfig
    grequest.consumer = "me"
    grequest.request_type = LINE_REQUEST_DIRECTION_INPUT
    var def_value: cint = 0

    echo "isUsed(line12) ",isUsed(line12)
    echo "requestBulk 0? ", requestBulk(blines, grequest,def_value)
    echo "isUsed(line12) ",isUsed(line12)
    echo "releaseBulk"
    releaseBulk(blines)

    echo "isUsed(line12) ",isUsed(line12)

    proc callback(){.gcsafe.}= echo "\n\tBANG!"
    echo "requestBulkRisingEdgeEvents ",requestBulkRisingEdgeEvents(blines,"consumer")
    var thr: Thread[LinePtr]
    proc poller(line: LinePtr){.thread.}=
      var blines_triggered: Line_Bulk
      var ts : Timespec
      ts.tv_sec = 3.Time
      echo "eventWait "
      var res = eventWait_bulk(blines,ts.addr, blines_triggered)
      if res == 1: callback()
    createThread(thr,poller,line12)

    gpio_set_pull(12, Pull.UP)
    os.sleep(10)
    gpio_set_pull(12, Pull.DOWN)

    echo "releaseBulk"
    releaseBulk(blines)

    release(line12)
    chipClose(gpiochip0)

  ]#








  block ctxless:
    when defined(ctxless):
      var 
        val:cint
        offset:cuint=12
        num_lines:cuint=1
        active_low=false
        consumer:cstring="meConsumer"
        device:cstring="/dev/gpiochip0"

      echo "\n getValue "
      val = getValue(
        device,
        offset,
        active_low,
        consumer)
      if val == -1: 
        echo "error"
      else:
        echo "value = ",val

      #....#
      echo "\n getValueMultiple "
      var
        offsets:array[0..63,cuint]
        values:array[0..63,cint]

      offsets[0]=12

      val = getValueMultiple(
        device,
        offsets,
        values,
        num_lines,
        active_low,
        consumer)

      if val == -1: 
        echo "error"
      else:
        echo "errno = ", val, " values[0] = ", values[0]

      #....#
      echo "\n setValue "

      var data:cint = 262
      proc cb(data:pointer){.cdecl.}=
        echo "\t BANGG! ", cint(cast[ptr cint](data)[])

      offsets[0]=12

      val = setValue(
        device,
        offset,
        value=1.cint,
        active_low,
        consumer,
        cb,
        data=data.addr)

      if val == -1: 
        echo "error"
      else:
        echo "errno = ",val

      #....#
      echo "\n setValueMultiple "

      data = 109

      val = setValueMultiple(
        device,
        offsets,
        values,
        num_lines,
        active_low,
        consumer,
        cb,
        data=data.addr)

      if val == -1: 
        echo "error"
      else:
        echo "errno = ", val, " values[0] = ", values[0]

      #....#
      echo "\n findLine "

      var 
        chipname:cstring="01234567890123456789012345678912"
        res_offset:cuint=0
      val = findLine(
        name="GPIO12",
        chipname,
        chipname_size=32.culong,
        offset=res_offset
      )

      if val == -1: 
        echo "error"
        echo "errno = ", val
      else:
        echo "errno = ", val, " chipname = ", chipname
        