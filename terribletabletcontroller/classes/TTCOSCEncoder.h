//
//  TTCOSCEncoder.h
//  terribletabletcontroller
//
//  Listens to TTCEventHandlers and encodes their data as OSC bundles.
//
//  Possible OSC messages generated are:
//
//      /ttc/state (TTCTabletPointerState state)
//          The pointer state changed.
//          See TTCEventHandler.h for state definitions.
//      /ttc/mouse (float positionX, float positionY, float pressure)
//          A mouse event happened.
//          All three parameters are in the range 0-1.
//      /ttc/tablet (float tiltX, float tiltY, float rotation)
//          A tablet event happened.
//          tiltX and tiltY are in the range -1 to 1.
//          rotation is in degrees.
//
//  If you're using a tablet, it will generate both tablet and mouse events.
//  If you're using a normal mouse/trackpad, it will only generate mouse events.
//
//  Created by Ben Roth on 8/13/14.
//

#import <Foundation/Foundation.h>
#import "TTCEventHandler.h"

// TODO: make these args
#define TTC_OSC_PORT 4242
#define TTC_OSC_HOST @"127.0.0.1"

@interface TTCOSCEncoder : NSObject <TTCEventHandlerDelegate>

@end
