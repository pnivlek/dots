#!/usr/bin/env python3
import struct
import codecs

def nohash(hex):
  return hex.lstrip('#')

def to_rgb(hex):
  return struct.unpack('BBB', codecs.decode(nohash(hex), 'hex'))

# alpha: 0 - 255
def to_rgba(hex, alpha=0):
  return '{}'.format(', '.join(map(
    lambda x: str(x), to_rgb(hex) + (alpha,)
  )))
