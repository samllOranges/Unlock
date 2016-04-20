//
//  LockView.m
//  手势解锁
//
//  Created by MXQ on 16/4/20.
//  Copyright © 2016年 MXQ. All rights reserved.
//

#import "LockView.h"
#define kScreenW [[UIScreen mainScreen] bounds].size.width
@interface LockView()

@property (nonatomic, assign) CGPoint movePoint;
@property (nonatomic, strong) NSMutableArray *buttons;

@end
@implementation LockView

-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray new];
    }
    
    return _buttons;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self addButton];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    if (!self.buttons.count)return;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 8);
    CGContextSetLineJoin(contextRef, kCGLineJoinRound);
    [[UIColor greenColor] set];
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        if (btn && btn.selected) {
            if (i==0) {
                CGContextMoveToPoint(contextRef, btn.center.x, btn.center.y);
            }else{
                CGContextAddLineToPoint(contextRef, btn.center.x, btn.center.y);
            }
        }
    }
    CGContextAddLineToPoint(contextRef, self.movePoint.x, self.movePoint.y);
    CGContextStrokePath(contextRef);

   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    //判断接触点是否在自己某一个按钮身上
    CGPoint point = [self touchPoint:touches];
    UIButton *btn = [self locationBtnWithPoint:point];
    if (btn && !btn.selected) {
        btn.selected = YES;
        [self.buttons addObject:btn];
        self.passWordBlock(btn.tag);
    }
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [self touchPoint:touches];
    self.movePoint = point;
    UIButton *btn = [self locationBtnWithPoint:point];
    if (btn && !btn.selected) {
        btn.selected = YES;
        [self.buttons addObject:btn];
        self.passWordBlock(btn.tag);
    }
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.subviews makeObjectsPerformSelector:@selector(setSelected:) withObject:NO];
    if (self.buttons.count) {
        [self.buttons removeAllObjects];
    }
    [self setNeedsDisplay];
    self.passWordBlock(10);
}
-(void)addButton{
    
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected ];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
    }
    
}

-(void)layoutSubviews{
    
    CGFloat width = 74.f;
    CGFloat height = width;
    CGFloat x = 0.f;
    CGFloat y = 0.f;
    int colCount = 3;
    CGFloat margin = (kScreenW-colCount*width)/(colCount+1);
    int col = 0;
    int row = 0;
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        col = i%colCount;
        row = i/colCount;
        x = margin + col*(margin+width);
        y = margin + row*(margin+height);
        btn.frame = CGRectMake(x, y, width, height);
        
    }
}

-(CGPoint)touchPoint:(NSSet<UITouch *> *)touches{
    UITouch *touch =[touches anyObject];
    CGPoint point =[touch locationInView:self];
    return point;
}

-(UIButton *)locationBtnWithPoint:(CGPoint)point{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}
@end
