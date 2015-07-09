/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#include <sys/types.h>
#include <sys/sysctl.h>

#import <Cordova/CDV.h>
#import "CDVPanframePlugin.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "SimplePlayerViewController.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]


@implementation CDVPanframePlugin
/*
    params:
    #1: video url
    #2: view mode:  0 for spherical,
                    1 for flat,
                    2 for cylindrical,
                    3 for side-by-side VR (non-stereoscopic),
                    4 for top-down VR formatted content (stereoscopic).
*/
- (void)init:(CDVInvokedUrlCommand*)command
{
    self.pluginCallbackId = command.callbackId;
    NSLog(@"player plugin init method called");

    NSString *videoUrl = [command.arguments objectAtIndex:0];
    NSString *viewMode = [command.arguments objectAtIndex:1];

    if([allTrim( videoUrl ) length] == 0) {
        NSLog(@"video url empty!");
        [self sendErrorMessage:@"error: video url is empty!"];
        return;
    } else if ([allTrim(viewMode) length] == 0) {
        NSLog(@"view mode empty!");
        [self sendErrorMessage:@"error: view mode is empty!"];
        return;
    }

    //[Parse setApplicationId:appId clientKey:clientKey];
    Class vcClass = NSClassFromString(@"SimplePlayerViewController");
    if (vcClass) {
        NSLog(@"player plugin videoUrl: %@, viewMode: %@", videoUrl, viewMode);

        SimplePlayerViewController *vc = [[vcClass alloc] initWithNibName:nil bundle:nil];
        [vc initParams:videoUrl mode:viewMode.intValue];
        UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
        nc.navigationBar.barStyle = UIBarStyleDefault;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDismissPlayerController)
                                                     name:@"didDismissPlayerController"
                                                   object:nil];
        [self.viewController presentViewController:nc animated:YES completion:nil];

    }
    //id vc = [[vcClass alloc] initWithNibName:nil bundle:nil];


    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)didDismissPlayerController {
    NSLog(@"Dismissed player controller");
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [self sendOKMessage:@"test"];
}

-(void) sendOKMessage:(NSString*)scantarget
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:scantarget];
    [self.commandDelegate sendPluginResult:result callbackId: self.pluginCallbackId];
}

-(void) sendErrorMessage:(NSString*)error
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
    [self.commandDelegate sendPluginResult:result callbackId: self.pluginCallbackId];
}

@end