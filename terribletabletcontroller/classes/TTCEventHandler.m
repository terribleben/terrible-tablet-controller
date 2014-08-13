//
//  TTCEventHandler.m
//  terribletabletcontroller
//
//  Created by Ben Roth on 8/13/14.
//

#import "TTCEventHandler.h"

@interface TTCEventHandler ()

- (void) printEventType: (NSEvent *)event;

@end

@implementation TTCEventHandler

+ (NSEventMask) acceptableEventMask
{
    return (NSMouseMovedMask
            | NSLeftMouseDownMask | NSLeftMouseDraggedMask | NSLeftMouseUpMask
            | NSOtherMouseDownMask | NSOtherMouseDraggedMask | NSOtherMouseUpMask
            | NSTabletPointMask | NSTabletProximityMask);
}

- (NSEvent *) handleEvent:(NSEvent *)event
{
    [self printEventType:event];
    
    return event;
}


#pragma mark internal methods

- (void) printEventType:(NSEvent *)event
{
    NSString *printableType = @"", *printableSubtype = @"";
    
    switch (event.type) {
        case NSMouseMoved:
            printableType = @"moved";
            break;
        case NSLeftMouseDown:
            printableType = @"left down";
            break;
        case NSLeftMouseUp:
            printableType = @"left up";
            break;
        case NSLeftMouseDragged:
            printableType = @"left dragged";
            break;
        case NSOtherMouseDown:
            printableType = @"other down";
            break;
        case NSOtherMouseUp:
            printableType = @"other up";
            break;
        case NSOtherMouseDragged:
            printableType = @"other dragged";
            break;
        case NSTabletPoint:
            printableType = @"point";
            break;
        case NSTabletProximity:
            printableType = @"prox";
            break;
        default:
            printableType = [NSString stringWithFormat:@"OTHER: %lu", (unsigned long)event.type];
            break;
    }
    
    switch (event.subtype) {
        case NSMouseEventSubtype: case NSTouchEventSubtype:
            // on a macbook, trackpad events mysteriously count as "touch"
            printableSubtype = @"default/touch";
            break;
        case NSTabletPointEventSubtype:
            printableSubtype = @"point";
            break;
        case NSTabletProximityEventSubtype:
            printableSubtype = @"prox";
            break;
        default:
            break;
    }
    
    NSLog(@"%@ : %@", printableType, printableSubtype);
}

@end
