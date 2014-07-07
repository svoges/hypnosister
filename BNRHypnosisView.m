//
//  BNRHipnosisView.m
//  Hypnosister
//
//  Created by Steffan Voges on 7/6/14.
//  Copyright (c) 2014 Steffan. All rights reserved.
//

#import "BNRHypnosisView.h"

@interface BNRHypnosisView()

@property (strong, nonatomic) UIColor *circleColor;

@end

@implementation BNRHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    
    
    
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // The circle will be the largest taht will fit in the view
//    float radius = (MIN(bounds.size.width, bounds.size.height) / 2.0);
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        [path addArcWithCenter:center radius:currentRadius startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
        
    }

    path.lineWidth = 10;
    [self.circleColor setStroke];
    [path stroke];
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(currentContext);
    CGRect smallFrame = CGRectMake(bounds.size.width / 4, bounds.size.height / 4, (bounds.size.width) / 2.0, (bounds.size.height) / 2.0);
    
    UIBezierPath *trianglePath = [[UIBezierPath alloc] init];
    [trianglePath moveToPoint:CGPointMake(center.x, smallFrame.origin.y)];
    [trianglePath addLineToPoint:CGPointMake(smallFrame.origin.x, smallFrame.origin.y + smallFrame.size.height)];
    [trianglePath addLineToPoint:CGPointMake(smallFrame.origin.x + smallFrame.size.width, smallFrame.origin.y + smallFrame.size.height)];
    [trianglePath closePath];
    
    [trianglePath addClip];
    
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {0.0, 1.0, 0.0, 1.0,
        1.0, 1.0, 0.0, 1.0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGPoint startPoint = CGPointMake(center.x, smallFrame.origin.y);
    CGPoint endPoint = CGPointMake(center.x, smallFrame.origin.y + smallFrame.size.height);
    
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGContextRestoreGState(currentContext);

    
    CGContextSaveGState(currentContext);
    CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3);
    [logoImage drawInRect:smallFrame blendMode:NO alpha:01.0];
    
    CGContextRestoreGState(currentContext);
    
}

// When a finger touchges a screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ was touched", self);
    
    // Get 3 random numbers between 0 and 1
    float red= (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue= (arc4random() % 100) / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    self.circleColor = randomColor;
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

@end
