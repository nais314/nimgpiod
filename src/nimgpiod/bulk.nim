

type
  ChipIterPtr* = pointer
  LineIterPtr* = pointer

proc requestInputFlags*(line:LinePtr,
consumer: cstring, flags:int): cint {.importc: "gpiod_line_request_input_flags", header: "gpiod.h".}
proc requestOutputFlags*(line:LinePtr,
consumer: cstring, flags:cint, default_val: cint): cint {.importc: "gpiod_line_request_output_flags", header: "gpiod.h".}
proc requestRisingEdgeEventsFlags*(line:LinePtr,
consumer: cstring, flags:int): cint {.importc: "gpiod_line_request_rising_edge_events_flags", header: "gpiod.h".}
proc requestFallingEdgeEventsFlags*(line:LinePtr,
consumer: cstring, flags:int): cint {.importc: "gpiod_line_request_falling_edge_events_flags", header: "gpiod.h".}
proc requestBothEdgesEventsFlags*(line:LinePtr,
consumer: cstring, flags:int): cint {.importc: "gpiod_line_request_both_edges_events_flags", header: "gpiod.h".}

# BULK #
proc bulkInit*(bulk: var LineBulk){.importc: "gpiod_line_bulk_init", header: "gpiod.h".}
proc bulkAdd*(bulk: var LineBulk,line:LinePtr){.importc: "gpiod_line_bulk_add", header: "gpiod.h".}

proc requestBulk*(bulk: var LineBulk, config: var LineRequestConfig,default_vals: var cint): cint {.importc: "gpiod_line_request_bulk", header: "gpiod.h".}
proc requestBulkInput*(bulk: var LineBulk,consumer: cstring): cint {.importc: "gpiod_line_request_bulk_input", header: "gpiod.h".}
proc requestBulkOutput*(bulk: var LineBulk,consumer: cstring, default_vals: var cint): cint {.importc: "gpiod_line_request_bulk_output", header: "gpiod.h".}

proc requestBulkRisingEdgeEvents*(bulk: var LineBulk,consumer: cstring): cint {.importc: "gpiod_line_request_bulk_rising_edge_events", header: "gpiod.h".}
proc requestBulkFallingEdgeEvents*(bulk: var LineBulk,consumer: cstring): cint {.importc: "gpiod_line_request_bulk_falling_edge_events", header: "gpiod.h".}
proc requestBulkBothEdgesEvents*(bulk: var LineBulk,consumer: cstring): cint {.importc: "gpiod_line_request_bulk_both_edges_events", header: "gpiod.h".}

proc requestBulkInputFlags*(bulk: var LineBulk,consumer: cstring, flags:cint): cint {.importc: "gpiod_line_request_bulk_input_flags", header: "gpiod.h".}
proc requestBulkOutputFlags*(bulk: var LineBulk,consumer: cstring, flags:cint, default_vals: var cint): cint {.importc: "gpiod_line_request_bulk_output_flags", header: "gpiod.h".}
proc requestBulkRisingEdgeEventsFlags*(bulk: var LineBulk,consumer: cstring, flags:cint): cint {.importc: "gpiod_line_request_bulk_rising_edge_events_flags", header: "gpiod.h".}
proc requestBulkFallingEdgeEventsFlags*(bulk: var LineBulk,consumer: cstring, flags:cint): cint {.importc: "gpiod_line_request_bulk_falling_edge_events_flags", header: "gpiod.h".}
proc requestBulkBothEdgesEventsFlags*(bulk: var LineBulk,consumer: cstring, flags:cint): cint {.importc: "gpiod_line_request_bulk_both_edges_events_flags", header: "gpiod.h".}


proc releaseBulk*(bulk: var LineBulk){.importc: "gpiod_line_release_bulk", header: "gpiod.h".}

proc getValueBulk*(bulk: var LineBulk, values: openarray[cint]){.importc: "gpiod_line_get_value_bulk", header: "gpiod.h".}
proc setValueBulk*(bulk: var LineBulk, values: openarray[cint]){.importc: "gpiod_line_set_value_bulk", header: "gpiod.h".}

proc eventWaitBulk*(bulk: var LineBulk, timeout: ptr Timespec, event_bulk: var LineBulk):cint{.importc: "gpiod_line_event_wait_bulk", header: "gpiod.h".}