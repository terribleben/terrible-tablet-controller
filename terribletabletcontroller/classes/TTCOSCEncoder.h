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

@interface TTCOSCEncoder : NSObject <TTCEventHandlerDelegate>

@end
