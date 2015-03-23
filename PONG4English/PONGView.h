//
//  PONGView.h
//  PONG4English
//
//  Created by Kévin Mondésir on 01/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CVDisplayLink.h>
#define pasdesa
#import "SNKOpenGLRender.h"

typedef struct _CallbackContext
{
	NSOpenGLContext* ctx;
	SNKOpenGLRender* renderer;
} CallbackContext;

@interface PONGView : NSOpenGLView<PongRendererDelegate,NSURLConnectionDelegate>{
	CallbackContext* cbCtx;
	NSMutableData * receivedData;
	NSOpenGLPixelFormat* pf;
	CVDisplayLinkRef displayLink;
	NSPoint lastPoint;
	NSRecursiveLock * lock;
	NSSound *sound;
	BOOL play;
	NSTimeInterval temp;
}

@end
