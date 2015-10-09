//
//  XYAlertView.h
//
//  Created by Samuel Liu on 7/25/12.
//  Copyright (c) 2012 Telenavsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYAlertViewManager.h"

typedef void (^XYAlertViewBlock)(int buttonIndex);

@interface XYAlertView : NSObject
@property (copy, nonatomic) UIView *parent;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *message;
@property (retain, nonatomic) NSArray *buttons;
@property (readonly, nonatomic) NSMutableArray *buttonsStyle;
@property (copy, nonatomic) XYAlertViewBlock blockAfterDismiss;
@property (copy, nonatomic) UIColor *titleFontColor;
@property (copy, nonatomic) UIColor *messageFontColor;


+(id)alertViewWithTitle:(NSString*)title
            message:(NSString*)message
            buttons:(NSArray*)buttonTitles
       afterDismiss:(XYAlertViewBlock)block;

-(id)initWithTitle:(NSString*)title
           message:(NSString*)message
           buttons:(NSArray*)buttonTitles
      afterDismiss:(XYAlertViewBlock)block;

-(void)setButtonStyle:(XYButtonStyle)style atIndex:(int)index;

/*-(void)setTitleFontColor:(UIColor *)color;
-(void)setMessageFontColor:(UIColor *)color;
*/
-(void)show;
-(void)dismiss:(int)buttonIndex;

@end
