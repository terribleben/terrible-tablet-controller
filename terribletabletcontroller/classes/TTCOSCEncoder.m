//
//  TTCOSCEncoder.m
//  terribletabletcontroller
//
//  Created by Ben Roth on 8/13/14.
//

#import "TTCOSCEncoder.h"
#import "F53OSC.h"

@interface TTCOSCEncoder ()

@property (nonatomic, strong) F53OSCClient *oscClient;

@end

@implementation TTCOSCEncoder

- (id) init
{
    if (self = [super init]) {
        self.oscClient = [[F53OSCClient alloc] init];
        _oscClient.host = TTC_OSC_HOST;
        _oscClient.port = TTC_OSC_PORT;
        [_oscClient connect];
    }
    return self;
}

#pragma mark delegate methods

- (void) eventHandler:(TTCEventHandler *)handler reportedStateChange:(TTCTabletPointerState)newState
{
    // TODO
    NSLog(@"State change: %u", newState);
    
    F53OSCMessage *msgStateChange = [F53OSCMessage messageWithAddressPattern:@"/ttc/state" arguments:@[ @(newState) ]];
    [_oscClient sendPacket:msgStateChange];
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
