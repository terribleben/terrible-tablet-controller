//
//  TTCOSCEncoder.m
//  terribletabletcontroller
//
//  Created by Ben Roth on 8/13/14.
//

#import "TTCOSCEncoder.h"

@implementation TTCOSCEncoder

#pragma mark delegate methods

- (void) eventHandler:(TTCEventHandler *)handler reportedStateChange:(TTCTabletPointerState)newState
{
    // TODO
    NSLog(@"State change: %u", newState);
}

- (void) eventHandler:(TTCEventHandler *)handler reportedPosition:(NSPoint)position pressure:(float)pressure
{
    // TODO
    NSLog(@"(%.0f, %.0f) @ %.2f", position.x, position.y, pressure);
}

- (void) eventHandler:(TTCEventHandler *)handler reportedTilt:(NSPoint)tilt rotation:(float)rotationDegrees
{
    // TODO
    NSLog(@"tilt (%.2f, %.2f) rotation %.0f", tilt.x, tilt.y, rotationDegrees);
}

@end
