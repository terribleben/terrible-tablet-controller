Terrible Tablet Controller
==========================
For OSX 10.6 and newer. Command line program which listens for tablet events, then broadcasts their data as OSC bundles. Use your drawing tablet as an audio controller.

You get:
- Stylus state (outside, proximate, touching)
- 2D position on the main display
- Pressure, tilt x/y, and rotation (when applicable)

Tested on OSX 10.9 with a Wacom Intuos tablet.

To build:
- Clone the repo
- Clone MetatoneOSC into /terribletabletcontroller/lib/MetatoneOSC

To use:
- ./terribletabletcontroller host port
- The OSC message protocol is detailed in TTCOSCEncoder.h
- See the /example folder for some ChucK programs that use it