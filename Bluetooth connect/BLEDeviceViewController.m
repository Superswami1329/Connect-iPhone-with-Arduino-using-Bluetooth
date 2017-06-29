//
//  BLEDeviceViewController.h
//  HMSoft
//
//  Created by HMSofts on 7/13/12.
//  Copyright (c) 2012 jnhuamao.cn. All rights reserved.
//

#import "BLEDeviceViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "QuartzCore/QuartzCore.h"

@interface BLEDeviceViewController ()

@end

@implementation BLEDeviceViewController
@synthesize MsgToArduino;
@synthesize HMSoftUUID;
@synthesize tvRecv;
@synthesize lbDevice;
@synthesize connectionLabel;

@synthesize rssi_container;


//@synthesize timer;

@synthesize peripheral;
@synthesize sensor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = self.sensor.activePeripheral.name;
    self.sensor.delegate = self;

    tvRecv.layer.borderWidth = 1;
    tvRecv.layer.borderColor = [[UIColor grayColor] CGColor];
    tvRecv.layer.cornerRadius = 8;
    tvRecv.layer.masksToBounds = YES;
    
    HMSoftUUID.layer.borderWidth = 1;
    HMSoftUUID.layer.borderColor = [[UIColor grayColor] CGColor];
    HMSoftUUID.layer.cornerRadius = 8;
    HMSoftUUID.layer.masksToBounds = YES;
    
    lbDevice.layer.borderWidth = 1;
    lbDevice.layer.borderColor = [[UIColor grayColor] CGColor];
    lbDevice.layer.cornerRadius = 8;
    lbDevice.layer.masksToBounds = YES;
}

- (void)viewDidUnload
{
    [self setHMSoftUUID:nil];
    [self setMsgToArduino:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//recv data
-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    tvRecv.text= [tvRecv.text stringByAppendingString:value];
}

//button actions
- (IBAction)sendUnlockMessage:(id)sender {
   
    [self sendMesage:@"a"];

}

- (IBAction)sendForwardMessage:(id)sender {
    
    [self sendMesage:@"forward"];
    
}

- (IBAction)sendLeftMessage:(id)sender {
    
   [self sendMesage:@"turn_left"];
    
}
- (IBAction)sendRightMessage:(id)sender {
    
    [self sendMesage:@"turn_right"];
    
}
- (IBAction)sendStopMessage:(id)sender {
    
    [self sendMesage:@"stop"];
    
}
- (IBAction)sendScanMessage:(id)sender {
    
    [self sendMesage:@"scan"];
    
}



- (void)sendMesage:(NSString *)String{
    NSData *data = [String dataUsingEncoding:[NSString defaultCStringEncoding]];
    if(data.length > 20)
    {
        int i = 0;
        while ((i + 1) * 20 <= data.length) {
            NSData *dataSend = [data subdataWithRange:NSMakeRange(i * 20, 20)];
            [sensor write:sensor.activePeripheral data:dataSend];
            i++;
        }
        i = data.length % 20;
        if(i > 0)
        {
            NSData *dataSend = [data subdataWithRange:NSMakeRange(data.length - i, i)];
            [sensor write:sensor.activePeripheral data:dataSend];
        }
        
    }else
    {
        //NSData *data = [MsgToArduino.text dataUsingEncoding:[NSString defaultCStringEncoding]];
        [sensor write:sensor.activePeripheral data:data];
    }
}
 




-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);
    NSTimeInterval anm = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:anm];
    if(offset > 0)
    {
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([[[UIDevice currentDevice] systemVersion]floatValue] >= 7)
    {
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }else
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)setConnect
{
    
    [connectionLabel setText:@"Connected"];
    [connectionLabel setTextColor:[UIColor greenColor]];
    
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    HMSoftUUID.text = (__bridge NSString*)s;
    tvRecv.text = @"OK+CONN";
}

-(void)setDisconnect
{
    [connectionLabel setText:@"Disconnected"];
    [connectionLabel setTextColor:[UIColor redColor]];
    
    tvRecv.text= [tvRecv.text stringByAppendingString:@"OK+LOST"];
}


@end
