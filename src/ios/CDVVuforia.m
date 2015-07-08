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
#import "CDVVuforia.h"

@implementation CDVVuforia

@synthesize pluginCallbackId;


- (void)init:(CDVInvokedUrlCommand*)command
{
    self.pluginCallbackId = command.callbackId;
    
    NSLog(@"vuforia plugin init method");
    Class vcClass = NSClassFromString(@"FrameMarkersViewController");
    id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
    
    UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
   // [vc release];
    nc.navigationBar.barStyle = UIBarStyleDefault;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDismissVuforiaController)
                                                 name:@"didDismissVuforiaController"
                                               object:nil];
    
    [self.viewController presentViewController:nc animated:YES completion:nil];

    //[nc release];
   // [self.viewController presentViewController:vc animated:nil completion:nil animated:YES];
}

-(void)didDismissVuforiaController {
    NSString * scantarget = [[NSUserDefaults standardUserDefaults] objectForKey:@"scantarget"];
    NSLog(@"Dismissed vuforia controller %@", scantarget);
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    if(scantarget != nil){
        [self sendOKMessage:scantarget];
    }else{
        [self sendErrorMessage];
    }
}

-(void) sendOKMessage:(NSString*)scantarget
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:scantarget];
    [self.commandDelegate sendPluginResult:result callbackId: self.pluginCallbackId];
}

-(void) sendErrorMessage
{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@""];
    [self.commandDelegate sendPluginResult:result callbackId: self.pluginCallbackId];
}

@end
