/* vim: set ai noet ts=4 sw=4 tw=115: */
//
// Copyright (c) 2014 Nikolay Zapolnov (zapolnov@gmail.com).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
#import "NZVKAuthDelegate.h"
#import <yip-imports/ios/NSNotificationCenter+ExtraMethods.h>
#import <yip-imports/ios/util.h>

NSString * const NZVKontakteReceivedToken = @"NZVKontakteReceivedToken";
NSString * const NZVKontakteAccessDenied = @"NZVKontakteAccessDenied";
NSString * const NZVKontakteTokenExpired = @"NZVKontakteTokenExpired";

NZVKAuthDelegate * g_Instance;

@implementation NZVKAuthDelegate

@synthesize accessToken;

-(id)init
{
	return [super init];
}

-(void)dealloc
{
	[accessToken release];
	accessToken = nil;

	[super dealloc];
}

+(NZVKAuthDelegate *)sharedInstance
{
	if (!g_Instance)
		g_Instance = [[NZVKAuthDelegate alloc] init];
	return g_Instance;
}

-(void)vkSdkNeedCaptchaEnter:(VKError *)error
{
	VKCaptchaViewController * viewController = [VKCaptchaViewController captchaControllerWithError:error];
	[viewController presentIn:iosTopmostViewController()];
}

-(void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken
{
	NSLog(@"VK token has expired.");
	self.accessToken = nil;
	[NSNotificationCenter postNotificationName:NZVKontakteTokenExpired];
}

-(void)vkSdkUserDeniedAccess:(VKError *)error
{
	self.accessToken = nil;
	[NSNotificationCenter postNotificationName:NZVKontakteAccessDenied];
}

-(void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
	[iosTopmostViewController() presentViewController:controller animated:YES completion:nil];
}

-(void)vkSdkReceivedNewToken:(VKAccessToken *)newToken
{
	[NSNotificationCenter postNotificationName:NZVKontakteReceivedToken];
}

@end
