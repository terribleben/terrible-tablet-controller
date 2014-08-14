//
//  TTCEventHandler.h
//  terribletabletcontroller
//
//  Parses a series of incoming NSEvents and reports them to its delegate in a useful way.
//
//  Created by Ben Roth on 8/13/14.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

typedef enum TTCTabletPointerState {
    kTTCTabletPointerStateOutside,
    kTTCTabletPointerStateProximate,
    kTTCTabletPointerStateTouching
} TTCTabletPointerState;

@class TTCEventHandler;

@protocol TTCEventHandlerDelegate <NSObject>

@optional

- (void) eventHandler: (TTCEventHandler *)handler reportedStateChange: (TTCTabletPointerState)newState;
- (void) eventHandler:(TTCEventHandler *)handler reportedPosition: (NSPoint)position pressure: (float)pressure;
- (void) eventHandler:(TTCEventHandler *)handler reportedTilt: (NSPoint)tilt rotation: (float)rotationDegrees;

@end

@interface TTCEventHandler : NSObject

@property (nonatomic, assign) id <TTCEventHandlerDelegate> delegate;

/**
 *  Gets the mask/filter for the set of events this class cares to process.
 */
+ (NSEventMask) acceptableEventMask;

/**
 *  Process an incoming event.
 */
- (NSEvent *) handleEvent: (NSEvent *)event;

@end
