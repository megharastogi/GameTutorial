//
//  GameOverScene.m
//  GameTutorial
//
//  Created by MEGHA GULATI on 11/13/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "GameOverScene.h"
#import "MyScene.h"
#import <Parse/Parse.h>

@implementation GameOverScene

-(id)initWithSize:(CGSize)size score: (NSInteger)player_score{
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        NSString * message;
        message = @"Game Over";

        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
        
        
        NSString * retrymessage;
        retrymessage = @"Replay Game";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = retrymessage;
        retryButton.fontColor = [SKColor blackColor];
        retryButton.position = CGPointMake(self.size.width/2, 50);
        retryButton.name = @"retry";
        [retryButton setScale:.5];
        
        [self addChild:retryButton];

        

        NSString * playerscoremsg = [NSString stringWithFormat:@"Player Score: %ld",(long)player_score];

        SKLabelNode *playerscore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        playerscore.text = playerscoremsg;
        playerscore.fontColor = [SKColor blackColor];
        playerscore.position = CGPointMake(self.size.width/2, 250);
        playerscore.name = @"Player Score";
        [playerscore setScale:.5];
        
        [self addChild:playerscore];
        
        UIDevice * currentDevice = [UIDevice currentDevice];
        NSString *deviceIDString = [currentDevice.identifierForVendor UUIDString]; //getting unique id for the user

        
        NSNumber *playerScoreNum = [NSNumber numberWithInt:player_score]; //converting score into NSNumber format in which Parse expect the score

        PFQuery *query = [PFQuery queryWithClassName:@"PlayerScore"];
        [query whereKey:@"user_id" equalTo:deviceIDString];
        [query orderByDescending:@"score"]; //Sorting the score so we have highest score on the top
        
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *scoreArray, NSError *error) {
            
            
            NSNumber* hightestScore = [scoreArray.firstObject objectForKey:@"score"];
            NSLog(@"highest score %@ devise %@",hightestScore, deviceIDString);
            
            if (hightestScore < playerScoreNum){
                hightestScore = playerScoreNum;
                NSLog(@"current score is highest");
            }
            NSString * highscoremsg = [NSString stringWithFormat:@"Highest Score: %@",hightestScore];
            
            SKLabelNode *highscore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            highscore.text = highscoremsg;
            highscore.fontColor = [SKColor greenColor];
            highscore.position = CGPointMake(self.size.width/2, 200);
            [highscore setScale:.5];
            [self addChild:highscore];

        }];


        
       PFObject *scoreObject = [PFObject objectWithClassName:@"PlayerScore"];
        [scoreObject setObject:deviceIDString forKey:@"user_id"];

        [scoreObject setObject:playerScoreNum forKey:@"score"];

        [scoreObject saveInBackground];
        
        
        
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"retry"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        
        MyScene * scene = [MyScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];

    }
    
}
@end
