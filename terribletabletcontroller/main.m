//
//  main.m
//  terribletabletcontroller
//
//  Created by Ben Roth on 8/13/14.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "TTCEventHandler.h"
#import "TTCOSCEncoder.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        // need an application object to monitor events (for some reason)
        [NSApplication sharedApplication];
        
        // set up an event handler to interpret tablet and mouse events.
        __block TTCEventHandler *theEventHandler = [[TTCEventHandler alloc] init];
        
        // set up event monitoring globally (for other programs) and locally (for this program).
        // global monitoring only works with OSX 10.6 and newer; to support older, use InstallEventHandler(...) in Carbon.
        
        [NSEvent addGlobalMonitorForEventsMatchingMask:[TTCEventHandler acceptableEventMask] handler:^(NSEvent *event) {
            [theEventHandler handleEvent:event];
        }];
        [NSEvent addLocalMonitorForEventsMatchingMask:[TTCEventHandler acceptableEventMask] handler:^NSEvent *(NSEvent *event) {
            return [theEventHandler handleEvent:event];
        }];
        
        // disable mouse coalescing in order to get full stream of tablet events
        [NSEvent setMouseCoalescingEnabled:NO];
        
        // set up an OSC encoder to build and broadcast tablet and mouse events as OSC bundles.
        TTCOSCEncoder *theOscEncoder = [[TTCOSCEncoder alloc] init];
        theEventHandler.delegate = theOscEncoder;
        
        // TODO: read command line arguments to specify OSC address and port.
        
        // main run loop
        [NSApp run];
    }
    return 0;
}
