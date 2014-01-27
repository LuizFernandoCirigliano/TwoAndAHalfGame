/*
 * CC3Backgrounder.m
 *
 * cocos3d 2.0.0
 * Author: Bill Hollings
 * Copyright (c) 2010-2013 The Brenwill Workshop Ltd. All rights reserved.
 * http://www.brenwill.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * http://en.wikipedia.org/wiki/MIT_License
 * 
 * See header file CC3Backgrounder.h for full API documentation.
 */

#import "CC3Backgrounder.h"
#import "CC3OpenGL.h"
#import "CC3CC2Extensions.h"

/** The default backgrounder task queue name. */
#define kCC3BackgrounderDefaultTaskQueueName	"org.cocos3d.backgrounder.default"


#pragma mark CC3Backgrounder

@implementation CC3Backgrounder

-(void) dealloc {
	[self deleteTaskQueue];
	[super dealloc];
}


#pragma mark Task queue

-(long) queuePriority { return _queuePriority; }

-(void) setQueuePriority: (long) queuePriority {
	if (queuePriority == _queuePriority) return;
	_queuePriority = queuePriority;
	[self updateTaskQueuePriority];
}

/** Set the appropriate initial queue priority based on the OS version. */
-(void) initQueuePriority {
	
#if CC3_IOS
	self.queuePriority = ((CCConfiguration.sharedConfiguration.OSVersion >= kCCiOSVersion_5_0)
						  ? DISPATCH_QUEUE_PRIORITY_BACKGROUND
						  : DISPATCH_QUEUE_PRIORITY_LOW);
#endif	// CC3_IOS
	
#if CC3_OSX
	self.queuePriority = DISPATCH_QUEUE_PRIORITY_BACKGROUND;
#endif	// CC3_OSX
	
}

/** Initialize the serial task queue. */
-(void) initTaskQueue {
	_taskQueue = dispatch_queue_create(kCC3BackgrounderDefaultTaskQueueName, NULL);
}

/** Delete the serial task queue. */
-(void) deleteTaskQueue {
	if ( !_taskQueue) return;
	dispatch_release(_taskQueue);
	_taskQueue = NULL;
}

/** Update the underlying target queue of the serial task queue to match the queue priority. */
-(void) updateTaskQueuePriority {
	if ( !_taskQueue ) return;
	dispatch_set_target_queue(_taskQueue, dispatch_get_global_queue(_queuePriority, 0));
}


#pragma mark Backgrounding tasks

-(void) runBlock: (void (^)(void))block {
	if ( !_taskQueue) return;
	dispatch_async(_taskQueue, block);
}


#pragma mark Allocation and initialization

-(id) init {
	if ( (self = [super init]) ) {
		[self initTaskQueue];
		[self initQueuePriority];
	}
	return self;
}

+(id) backgrounder { return [[[self alloc] init] autorelease]; }

@end


#pragma mark CC3GLBackgrounder

@implementation CC3GLBackgrounder : CC3Backgrounder

@synthesize glContext=_glContext;

-(void) dealloc {
	[_glContext release];
	[super dealloc];
}


#pragma mark Backgrounding tasks

/** Overridden to ensure that the contained GL context is active on the current thread. */
-(void) runBlock: (void (^)(void))block {
	[super runBlock: ^{
		[_glContext ensureCurrentContext];
		block();
	}];
}


#pragma mark Allocation and initialization

-(id) initWithGLContext: (CC3GLContext*) glContext {
	if ( (self = [super init]) ) {
		_glContext = [glContext retain];
	}
	return self;
}

+(id) backgrounderWithGLContext: (CC3GLContext*) glContext {
	return [[[self alloc] initWithGLContext: glContext] autorelease];
}

@end
