//
//  TTCOSCEncoder.m
//  terribletabletcontroller
//
//  Created by Ben Roth on 8/13/14.
//

#import "TTCOSCEncoder.h"
#import "F53OSC.h"

@interface TTCOSCEncoder ()
{
    NSRect screenFrame;
}

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
        
        screenFrame = [NSScreen mainScreen].frame;
    }
    return self;
}

- (void) dealloc
{
    [_oscClient disconnect];
    
    // [super dealloc];
}

#pragma mark delegate methods

- (void) eventHandler:(TTCEventHandler *)handler reportedStateChange:(TTCTabletPointerState)newState
{
    // TODO: break out the addressing logic
    F53OSCMessage *msgStateChange = [F53OSCMessage messageWithAddressPattern:@"/ttc/state" arguments:@[ @(newState) ]];
    [_oscClient sendPacket:msgStateChange];
}

- (void) eventHandler:(TTCEventHandler *)handler reportedPosition:(NSPoint)position pressure:(float)pressure
{
    NSPoint normalizedPosition = { ((position.x - screenFrame.origin.x) / screenFrame.size.width),
                                    ((position.y - screenFrame.origin.y) / screenFrame.size.height) };
    F53OSCMessage *msgSimple = [F53OSCMessage messageWithAddressPattern:@"/ttc/simple"
                                                              arguments:@[ @(normalizedPosition.x), @(normalizedPosition.y), @(pressure) ]];
    [_oscClient sendPacket:msgSimple];
}

- (void) eventHandler:(TTCEventHandler *)handler reportedTilt:(NSPoint)tilt rotation:(float)rotationDegrees
{
    F53OSCMessage *msgComplex = [F53OSCMessage messageWithAddressPattern:@"/ttc/complex"
                                                              arguments:@[ @(tilt.x), @(tilt.y), @(rotationDegrees) ]];
    [_oscClient sendPacket:msgComplex];
}

@end
