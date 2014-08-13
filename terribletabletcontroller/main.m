//
//  main.m
//  terribletabletcontroller
//
//  Created by Ben Roth on 8/13/14.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "TTCEventHandler.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        // need an application object to monitor events (for some reason)
        [NSApplication sharedApplication];
        
        // set up monitoring globally (for other programs) and locally (for this program).
        // global monitoring only works with OSX 10.6 and newer; to support older, use InstallEventHandler(...) in Carbon.
        
        __block TTCEventHandler *theEventHandler = [[TTCEventHandler alloc] init];
        
        [NSEvent addGlobalMonitorForEventsMatchingMask:[TTCEventHandler acceptableEventMask] handler:^(NSEvent *event) {
            [theEventHandler handleEvent:event];
        }];
        [NSEvent addLocalMonitorForEventsMatchingMask:[TTCEventHandler acceptableEventMask] handler:^NSEvent *(NSEvent *event) {
            return [theEventHandler handleEvent:event];
        }];
        
        // disable mouse coalescing in order to get full stream of tablet events
        [NSEvent setMouseCoalescingEnabled:NO];
        
        // main run loop
        [NSApp run];
    }
    return 0;
}
