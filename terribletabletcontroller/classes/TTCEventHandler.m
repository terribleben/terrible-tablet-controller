//
//  TTCEventHandler.m
//  terribletabletcontroller
//
//  Created by Ben Roth on 8/13/14.
//

#import "TTCEventHandler.h"

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
    // TODO
    
    return event;
}

@end
