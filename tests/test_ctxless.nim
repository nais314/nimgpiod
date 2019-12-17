# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import posix

import nimgpiod

test "CTXLESS":
  var 
    val:cint
    offset:cuint=12
    num_lines:cuint=1
    active_low=false
    consumer:cstring="meConsumer"
    device:cstring="/dev/gpiochip0"

  echo "\n gpiod_ctxless_get_value "
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
  echo "\n gpiod_ctxless_get_value_multiple "
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
  echo "\n gpiod_ctxless_set_value "

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
    data.addr)

  if val == -1: 
    echo "error"
  else:
    echo "errno = ",val

  #....#
  echo "\n gpiod_ctxless_set_value_multiple "

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
  echo "\n gpiod_ctxless_find_line "

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
    