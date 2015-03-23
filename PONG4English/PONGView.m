//
//  PONGView.m
//  PONG4English
//
//  Created by Kévin Mondésir on 01/04/2014.
//  Copyright (c) 2014 Kmonde. All rights reserved.
//

#import "PONGView.h"
#import "SNKScore.h"
#define credential @"012GREGHTD06H54GQEGVQG5H45O54QZG"
#define kSpacebarKeyCode 49
int test=0;

static CVReturn Heartbeat (		CVDisplayLinkRef displayLink,
                           const CVTimeStamp *inNow,
                           const CVTimeStamp *inOutputTime,
                           CVOptionFlags flagsIn,
                           CVOptionFlags *flagsOut,
                           void *displayLinkContext)
{
	CallbackContext* ctx = (CallbackContext*) displayLinkContext;
    // this method is called on a background thread via the display link
    // make sure we have the right context
	CGLSetCurrentContext((CGLContextObj) [ctx->ctx CGLContextObj]);
    // and lock it to avoid thread conflicts
    CGLLockContext((CGLContextObj) [ctx->ctx CGLContextObj]);
	[ctx->renderer draw];
	CGLFlushDrawable((CGLContextObj) [ctx->ctx CGLContextObj]);
	
    CGLUnlockContext((CGLContextObj) [ctx->ctx CGLContextObj]);
	
	return kCVReturnSuccess;
}
@implementation PONGView

- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime
{
	// There is no autorelease pool when this method is called
	// because it will be called from a background thread.
	// It's important to create one or app can leak objects.
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self drawView];
	
	[pool release];
	return kCVReturnSuccess;
}

// This is the renderer output callback function
static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink,
									  const CVTimeStamp* now,
									  const CVTimeStamp* outputTime,
									  CVOptionFlags flagsIn,
									  CVOptionFlags* flagsOut,
									  void* displayLinkContext)
{
    CVReturn result = [(PONGView*)displayLinkContext getFrameForTime:outputTime];
    return result;
}

- (id)initWithFrame:(NSRect)frame {
	NSOpenGLPixelFormatAttribute attrs[] = {
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFADepthSize, 24,
		NSOpenGLPFAStencilSize, 8,
        NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core, //Core Profile
        0
	};
	
	cbCtx = (CallbackContext*) malloc(sizeof(CallbackContext));
	
    NSOpenGLPixelFormat *format = [[[NSOpenGLPixelFormat alloc] initWithAttributes:attrs] autorelease];
    self = [super initWithFrame:frame pixelFormat: format];
    if (self)
	{
		play=YES;
        pf = format;
		cbCtx->ctx = [self openGLContext];
		[cbCtx->ctx makeCurrentContext];
        
        // create the renderer object
		cbCtx->renderer = [[SNKOpenGLRender alloc] init];
		[cbCtx->renderer setDelegate:self];
		NSRect bounds = [self bounds];
		NSRect pixels = [self convertRectToBacking:bounds];
		[cbCtx->renderer reshapeToWidth:pixels.size.width height:pixels.size.height];
    }
	[self getScore];
    return self;
}
-(void)setFrame:(NSRect)frameRect
{
	[super setFrame:frameRect];
	
	[cbCtx->renderer reshapeToWidth:frameRect.size.width height:frameRect.size.height];
	//[rend reshapeToWidth:frameRect.bounds.size.width height:frameRect.bounds.size.height];
}
- (void)prepareOpenGL
{
    [super prepareOpenGL];
	lock=[[NSRecursiveLock alloc]init];
	[self startScreen];
	GLint swapInt = 1;
	
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
	if(![cbCtx->renderer setupGL])
	{
		NSLog(@"Could not set up GL context");
		assert(0);
	}
	
	CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
	CVDisplayLinkSetOutputCallback(displayLink, &MyDisplayLinkCallback, self);
	CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, (CGLContextObj) [cbCtx->ctx CGLContextObj], (CGLPixelFormatObj) [pf CGLPixelFormatObj]);
	CVDisplayLinkSetOutputCallback(displayLink, &Heartbeat, cbCtx);
	CVDisplayLinkStart(displayLink);
    
    [[self window] setAcceptsMouseMovedEvents:YES];
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (BOOL)becomeFirstResponder
{
	return YES;
}
-(void)drawRect:(NSRect)dirtyRect
{
	//[[self openGLContext]flushBuffer];
	//[self setNeedsDisplay:YES];
	[self drawView];
}
-(void)drawView
{
	[lock lock];
	[cbCtx->renderer draw];
	CGLFlushDrawable((CGLContextObj) [cbCtx->ctx CGLContextObj]);
	[lock unlock];
	
}
- (void) reshape
{
	[super reshape];
	
	// We draw on a secondary thread through the display link. However, when
	// resizing the view, -drawRect is called on the main thread.
	// Add a mutex around to avoid the threads accessing the context
	// simultaneously when resizing.
	//CGLLockContext([[self openGLContext] CGLContextObj]);
	CGLLockContext((CGLContextObj) [cbCtx->ctx CGLContextObj]);
	// Get the view size in Points
	NSRect viewRectPoints = [self bounds];
	
    NSRect viewRectPixels = viewRectPoints;
	// Set the new dimensions in our renderer
	[cbCtx->renderer reshapeToWidth:viewRectPixels.size.width height:viewRectPixels.size.height];
	
	CGLUnlockContext((CGLContextObj) [cbCtx->ctx CGLContextObj]);
}
- (void)dealloc
{
	CVDisplayLinkStop(displayLink);
	CVDisplayLinkRelease(displayLink);
	[pf release];
	[cbCtx->ctx release];
	[cbCtx->renderer release];
	[lock release];
	free(cbCtx);
	[super dealloc];
}
-(void)keyUp:(NSEvent *)theEvent
{
	switch ([theEvent keyCode]) {
		case 125:
			[cbCtx->renderer endDown];
			break;
		case 126:
			[cbCtx->renderer endUp];
			break;
		default:
			break;
	}
}
- (void)keyDown:(NSEvent *)theEvent
{
	switch ([theEvent keyCode]) {
		case kSpacebarKeyCode:
			[cbCtx->renderer toggleAnimation];
			break;
		case 125:
			[cbCtx->renderer down];
			break;
		case 126:
			[cbCtx->renderer up];
			break;
		case 35:
			[cbCtx->renderer addBall];
			break;
		default:
			break;
	}
}
-(void)mouseDown:(NSEvent *)theEvent
{
	
	[cbCtx->renderer click:[theEvent locationInWindow] ];
}
- (void)mouseMoved:(NSEvent *)theEvent
{
    NSPoint p = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	// eat the first event so the mouse doesn't go crazy
	if(lastPoint.x + lastPoint.y <= 0.01)
	{
		lastPoint = p;
	}
    // if lastPoint is inside the view
    if ((lastPoint.x >= 0 && lastPoint.x < self.bounds.size.width) && (lastPoint.y >= 0 & lastPoint.y < self.bounds.size.height)) {
        //float dx = lastPoint.x - p.x;
        //float dy = lastPoint.y - p.y;
        //[cbCtx->renderer applyCameraMovementWdx:dx dy:dy];
    }
    lastPoint = p;
}


-(void)inGame
{
	[sound stop];
	[sound release];
	NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"8bp129-01-yerzmyey-dark_galactica" ofType:@"mp3"];
	sound = [[NSSound alloc] initWithContentsOfFile:resourcePath byReference:YES];
	[sound play];
	[sound setLoops:YES];
}
-(void)pause
{
	if (play) {
		temp=[sound currentTime];
		[sound stop];
	}
	else{
		[sound play];
		[sound setCurrentTime:temp];
	}
	play=!play;
}
-(void)startScreen
{
	[sound stop];
	[sound release];
	NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"8bp129-02-yerzmyey-im35" ofType:@"mp3"];
	sound = [[NSSound alloc] initWithContentsOfFile:resourcePath byReference:YES];
	[sound play];
	[sound setLoops:YES];
}
-(void)sendScore:(NSString *)pseudo andScore:(int)score
{
	NSString *post;
	NSData *postData;
	NSURLConnection *conn;
	NSMutableURLRequest *request;
	post = [NSString stringWithFormat:@"hello"];
	postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
	request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kevinmondesir.fr/saveScore.php"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	[postData release];
	conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
	if(conn)
	{
		NSLog(@"Connection Successful");
		receivedData = [[NSMutableData data] retain];
	}
	else
	{
		NSLog(@"Connection could not be made");
	}
}
-(void)getScore
{
	NSString *post;
	NSData *postData;
	NSURLConnection *conn;
	NSMutableURLRequest *request;
	post = [NSString stringWithFormat:@"hello"];
	postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
	request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kevinmondesir.fr/saveScore.php"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	[postData release];
	conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
	if(conn)
	{
		NSLog(@"Connection Successful");
		receivedData = [[NSMutableData data] retain];
	}
	else
	{
		NSLog(@"Connection could not be made");
	}
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    //[connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    //NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[receivedData length]);
	NSLog(@"%@",[NSString stringWithUTF8String:[receivedData bytes]] );
    // release the connection, and the data object
    //[connection release];
    [receivedData release];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
}
@end
