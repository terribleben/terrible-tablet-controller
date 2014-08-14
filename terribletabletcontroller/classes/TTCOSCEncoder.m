//
//  TTCOSCEncoder.m
//  terribletabletcontroller
//
//  Created by Ben Roth on 8/13/14.
//

#import "TTCOSCEncoder.h"
#import "F53OSC.h"

NSString * const kTTCOSCAddressPatternBase = @"ttc";
NSString * const kTTCOSCAddressPatternState = @"state";
NSString * const kTTCOSCAddressPatternMouse = @"mouse";
NSString * const kTTCOSCAddressPatternTablet = @"tablet";

@interface TTCOSCEncoder ()
{
    NSRect screenFrame;
}

@property (nonatomic, strong) F53OSCClient *oscClient;

- (void) sendMessageWithRelativeAddress: (NSString *)address arguments: (NSArray *)arguments;

@end

@implementation TTCOSCEncoder

- (id) init
{
    if (self = [super init]) {
        self.oscClient = [[F53OSCClient alloc] init];
        screenFrame = [NSScreen mainScreen].frame;
    }
    return self;
}

- (id) initWithHost:(NSString *)host port:(NSInteger)port
{
    if (self = [self init]) {
        _oscClient.host = host;
        _oscClient.port = port;
        [_oscClient connect];
        
        NSLog(@"Sending to %@:%d...", _oscClient.host, _oscClient.port);
    }
    return self;
}

- (void) dealloc
{
    if (_oscClient.isConnected)
        [_oscClient disconnect];
    
    // [super dealloc];
}

#pragma mark delegate methods

- (void) eventHandler:(TTCEventHandler *)handler reportedStateChange:(TTCTabletPointerState)newState
{
    [self sendMessageWithRelativeAddress:kTTCOSCAddressPatternState arguments:@[ @(newState) ]];
}

- (void) eventHandler:(TTCEventHandler *)handler reportedPosition:(NSPoint)position pressure:(float)pressure
{
    NSPoint normalizedPosition = { ((position.x - screenFrame.origin.x) / screenFrame.size.width),
                                    ((position.y - screenFrame.origin.y) / screenFrame.size.height) };

    [self sendMessageWithRelativeAddress:kTTCOSCAddressPatternMouse arguments:@[ @(normalizedPosition.x), @(normalizedPosition.y), @(pressure) ]];
}

- (void) eventHandler:(TTCEventHandler *)handler reportedTilt:(NSPoint)tilt rotation:(float)rotationDegrees
{
    [self sendMessageWithRelativeAddress:kTTCOSCAddressPatternTablet arguments:@[ @(tilt.x), @(tilt.y), @(rotationDegrees) ]];
}


#pragma mark internal methods

- (void) sendMessageWithRelativeAddress:(NSString *)address arguments:(NSArray *)arguments
{
    NSString *addressPattern = [NSString stringWithFormat:@"/%@/%@", kTTCOSCAddressPatternBase, address];
    F53OSCMessage *message = [F53OSCMessage messageWithAddressPattern:addressPattern arguments:arguments];
    [_oscClient sendPacket:message];
}

@end
