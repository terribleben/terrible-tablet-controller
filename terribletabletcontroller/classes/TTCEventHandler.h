//
//  TTCEventHandler.h
//  terribletabletcontroller
//
//  Created by Ben Roth on 8/13/14.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface TTCEventHandler : NSObject

/**
 *  Gets the mask/filter for the set of events this class cares to process.
 */
+ (NSEventMask) acceptableEventMask;

/**
 *  Process an incoming event.
 */
- (NSEvent *) handleEvent: (NSEvent *)event;

@end
