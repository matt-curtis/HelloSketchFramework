//
//  HSMain.m
//  HelloSketch
//
//  Created by Kevin Gutowski on 1/3/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

#import "HSMain.h"
@import AppKit;
@import JavaScriptCore;

//	__attribute__((weak_import)) means "hey compiler, don't expect this class to be defined in this framework, it's not"

__attribute__((weak_import)) @interface MOJavaScriptObject : NSObject

@property (readonly) JSObjectRef JSObject;

@property (readonly) JSContextRef JSContext;

@end

//	Declare a helper function we can use to call it easily

JSValue* callFunctionWithArguments(MOJavaScriptObject* boxedFunction, NSArray* argumentsArray) {
	JSContext *context = [JSContext contextWithJSGlobalContextRef:(JSGlobalContextRef)boxedFunction.JSContext];
	JSValue *function = [JSValue valueWithJSValueRef:boxedFunction.JSObject inContext:context];
	
	return [function callWithArguments:argumentsArray];
}

#define HSLog(fmt, ...) NSLog((@"HelloSketch (Sketch Plugin) %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@implementation HSMain {

//	This is called an "ivar" or "instance variable". It's similar to a property, but "lower level".
MOJavaScriptObject* _jsCallback;

}

#pragma mark - Hello World

- (NSString *)helloText {
    HSLog(@"Reading helloText");
    return @"Hey there, sending signal from HSMain, over.";
}

#pragma mark - Foundation Bridge Helpers

- (NSArray *)bridgeArray:(CFArrayRef *)cfarray {
    NSArray *array = CFBridgingRelease(cfarray);
    return array;
}

- (NSDictionary *)bridgeDict:(CFDictionaryRef *)cfdict {
    NSDictionary *dict = CFBridgingRelease(cfdict);
    return dict;
}

#pragma mark - NSTextView Notification Observation

- (void) beginObservingTextViewSelectionChanges {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	[nc addObserver:self selector:@selector(textViewSelectionDidChange:) name:NSTextViewDidChangeSelectionNotification object:nil];
}

- (void) textViewSelectionDidChange:(NSNotification*)notification {
	if(!_jsCallback) return;
	
	callFunctionWithArguments(_jsCallback, @[ notification ]);
}

#pragma mark - NSTextView JS Callback Helper

- (void) setCallbackForTextViewSelectionChange:(MOJavaScriptObject*)function {
	_jsCallback = function;
}

@end
