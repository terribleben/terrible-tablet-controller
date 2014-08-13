//
//  TTCEventHandler.h
//  terribletabletcontroller
//
//  Created by Ben Roth on 8/13/14.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface TTCEventHandler : NSObject

+ (NSEventMask) acceptableEventMask;

- (NSEvent *) handleEvent: (NSEvent *)event;

@end
