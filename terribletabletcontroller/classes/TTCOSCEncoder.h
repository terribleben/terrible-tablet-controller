//
//  TTCOSCEncoder.h
//  terribletabletcontroller
//
//  Listens to TTCEventHandlers and encodes their data as OSC bundles.
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
