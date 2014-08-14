//
//  TTCEventHandler.m
//  terribletabletcontroller
//
//  Created by Ben Roth on 8/13/14.
//

#import "TTCEventHandler.h"

@interface TTCEventHandler ()

@property (nonatomic, assign) TTCTabletPointerState state;

- (void) printEventType: (NSEvent *)event;

@end

@implementation TTCEventHandler

#pragma mark static methods

+ (NSEventMask) acceptableEventMask
{
    return (NSMouseMovedMask
            | NSLeftMouseDownMask | NSLeftMouseDraggedMask | NSLeftMouseUpMask
            | NSOtherMouseDownMask | NSOtherMouseDraggedMask | NSOtherMouseUpMask // haven't seen these three actually happen
            | NSTabletPointMask | NSTabletProximityMask);
    // TODO: do we care about NSMouseEntered and NSMouseExited?
}


#pragma mark external methods

- (id) init
{
    if (self = [super init]) {
        self.state = kTTCTabletPointerStateOutside;
    }
    return self;
}

- (NSEvent *) handleEvent:(NSEvent *)event
{
    if (event.type == NSTabletProximity) {
        // proximity events are called once when the stylus enters or leaves the proximity of the tablet.
        self.state = (event.isEnteringProximity) ? kTTCTabletPointerStateProximate : kTTCTabletPointerStateOutside;
    } else {
        // most events contain location and pressure.
        // in the case of a normal mouse/trackpad, pressure is 1 for down/drag events and 0 otherwise.
        float pressure = (event.type == NSMouseMoved) ? 0 : event.pressure;
        NSPoint position = event.locationInWindow;
        
        if (_delegate) {
            [_delegate eventHandler:self reportedPosition:position pressure:pressure];
        }
        
        // recompute state based on the event type.
        switch (event.type) {
            case NSLeftMouseDown: case NSLeftMouseDragged: case NSOtherMouseDown: case NSOtherMouseDragged: case NSTabletPoint:
                self.state = kTTCTabletPointerStateTouching;
                break;
            case NSLeftMouseUp: case NSOtherMouseUp: case NSMouseMoved: default:
                self.state = kTTCTabletPointerStateProximate;
        }
        
        // only tablet events contain additional parameters.
        //
        // Type NSTabletPoint means there is no mouse activity, but tablet-specific params are still changing.
        // For example, holding the stylus in place and varying pressure.
        //
        // When there is an analogous mouse event, like clicking or dragging,
        // subtype NSTabletPointEventSubtype is attached to it, indicating it came from a tablet.
        
        if (event.type == NSTabletPoint || event.subtype == NSTabletPointEventSubtype) {
            NSPoint tilt = event.tilt;
            float rotationDegrees = event.rotation;
            // NSPoint positionAbsolute = { event.absoluteX, event.absoluteY };
            // NSUInteger deviceId = event.deviceID;
            // TODO: do we get Z?
            
            if (_delegate) {
                [_delegate eventHandler:self reportedTilt:tilt rotation:rotationDegrees];
            }
        }
    }
    
    return event;
}


#pragma mark internal methods

- (void) setState:(TTCTabletPointerState)state
{
    if (state != _state) {
        _state = state;
        
        if (_delegate) {
            [_delegate eventHandler:self reportedStateChange:_state];
        }
    }
}

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
    
    if (event.type != NSTabletPoint && event.type != NSTabletProximity) {
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
    }
    
    NSLog(@"%@ : %@", printableType, printableSubtype);
}

@end
