proc getValue*(
  device:cstring,
  offset:cuint,
  active_low:bool,
  consumer:cstring):cint{.importc: "gpiod_ctxless_get_value", header: "gpiod.h".}

proc getValueMultiple*(
  device:cstring,
  offsets:array[0..63,cuint],
  values:array[0..63,cint],
  num_lines:cuint,
  active_low:bool,
  consumer:cstring):cint{.importc: "gpiod_ctxless_get_value_multiple", header: "gpiod.h".}


type
  SetValueCb* = proc(data:pointer){.cdecl.}

proc setValue*(
  device:cstring,
  offset:cuint,
  value:cint,
  active_low:bool,
  consumer:cstring,
  cb:SetValueCb,
  data:pointer
):cint{.importc: "gpiod_ctxless_set_value", header: "gpiod.h".}

proc setValueMultiple*(
  device:cstring,
  offsets:array[0..63,cuint],
  values:array[0..63,cint],
  num_lines:cuint,
  active_low:bool,
  consumer:cstring,
  cb:SetValueCb,
  data:pointer):cint{.importc: "gpiod_ctxless_set_value_multiple", header: "gpiod.h".}

type
  EventHandleCb* = proc(
    event_type:cint,
    offset:cuint,
    timestamp:Timespec,
    data:pointer):cint{.cdecl.}

  EventPollCb* =proc(
    fd:var EventPollFd,
    timespec: var Timespec
  ):cint{.cdecl.}
  
  EventPollFd*{.importc: "gpiod_ctxless_event_poll_fd", header: "gpiod.h".} = object 
    fd:cint
    event:bool

const
  CTXLESS_EVENT_POLL_RET_STOP*: cint = -2
  CTXLESS_EVENT_POLL_RET_ERR*: cint = -1
  CTXLESS_EVENT_POLL_RET_TIMEOUT*: cint = 0

proc eventLoop*(
  device:cstring,
  offset:cuint,
  active_low:bool,
  consumer:cstring,
  timeout:var Timespec,
  poll_cb:EventPollCb,
  event_cb:EventHandleCb,
  data:pointer
):cint{.importc: "gpiod_ctxless_event_loop", header: "gpiod.h".}

proc eventLoopMultiple*(
  device:cstring,
  offsets:array[0..63,cuint],
  num_lines:cuint,
  active_low:bool,
  consumer:cstring,
  timeout:var Timespec,
  poll_cb:EventPollCb,
  event_cb:EventHandleCb,
  data:pointer
):cint{.importc: "gpiod_ctxless_event_loop_multiple", header: "gpiod.h".}

proc eventMonitor*(
  device:cstring,
  event_type:cint,
  offset:cuint,
  active_low:bool,
  consumer:cstring,
  timeout:var Timespec,
  poll_cb:EventPollCb,
  event_cb:EventHandleCb,
  data:pointer
):cint{.importc: "gpiod_ctxless_event_monitor", header: "gpiod.h".}

proc eventMonitorMultiple*(
  device:cstring,
  event_type:cint,
  offsets:array[0..63,cuint],
  num_lines:cuint,
  active_low:bool,
  consumer:cstring,
  timeout:var Timespec,
  poll_cb:EventPollCb,
  event_cb:EventHandleCb,
  data:pointer
):cint{.importc: "gpiod_ctxless_event_monitor_multiple", header: "gpiod.h".}


proc findLine*(
  name:cstring,
  chipname:cstring,
  chipname_size:culong,
  offset:var cuint
):cint{.importc: "gpiod_ctxless_find_line", header: "gpiod.h".}