//
//  MyScene.m
//  GameTutorial
//
//  Created by MEGHA GULATI on 10/26/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "MyScene.h"

static const uint32_t shipCategory =  0x1 << 0;
static const uint32_t obstacleCategory =  0x1 << 1;

static const float BG_VELOCITY = 100.0;

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}


@implementation MyScene{

    SKSpriteNode *ship;
    SKAction *actionMoveUp;
    SKAction *actionMoveDown;

    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;

}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        [self initalizingScrollingBackground];
        [self addShip];

        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
    }
    return self;
}


-(void)addShip
{
        //initalizing spaceship node
        ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        [ship setScale:0.5];
        ship.zRotation = - M_PI / 2;
    
        //Adding SpriteKit physicsBody for collision detection
        ship.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ship.size];
        ship.physicsBody.categoryBitMask = shipCategory;
        ship.physicsBody.dynamic = YES;
        ship.physicsBody.contactTestBitMask = obstacleCategory;
        ship.physicsBody.collisionBitMask = 0;
        ship.physicsBody.usesPreciseCollisionDetection = YES;
        ship.name = @"ship";
        ship.position = CGPointMake(120,160);
        actionMoveUp = [SKAction moveByX:0 y:30 duration:.2];
        actionMoveDown = [SKAction moveByX:0 y:-30 duration:.2];

        [self addChild:ship];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    if(touchLocation.y >ship.position.y){
        if(ship.position.y < 270){
            [ship runAction:actionMoveUp];
        }
    }else{
        if(ship.position.y > 50){
            
            [ship runAction:actionMoveDown];
        }
    }
}

-(void)initalizingScrollingBackground
{
    for (int i = 0; i < 2; i++) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
        bg.position = CGPointMake(i * bg.size.width, 0);
        bg.anchorPoint = CGPointZero;
        bg.name = @"bg";
        [self addChild:bg];
    }
    
}

- (void)moveBg
{
    [self enumerateChildNodesWithName:@"bg" usingBlock: ^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode * bg = (SKSpriteNode *) node;
         CGPoint bgVelocity = CGPointMake(-BG_VELOCITY, 0);
         CGPoint amtToMove = CGPointMultiplyScalar(bgVelocity,_dt);
         bg.position = CGPointAdd(bg.position, amtToMove);
         
         //Checks if bg node is completely scrolled of the screen, if yes then put it at the end of the other node
         if (bg.position.x <= -bg.size.width)
         {
             bg.position = CGPointMake(bg.position.x + bg.size.width*2,
                                       bg.position.y);
         }
     }];
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (_lastUpdateTime)
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    [self moveBg];
}



@end
