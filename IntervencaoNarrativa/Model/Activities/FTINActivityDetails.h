//
//  FTINMasterActivity.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/05.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINSubActivityDetails.h"
#import "JSONModel.h"

@class Activity, Patient;

// Luiz: talvez, seria interessante criar uns métodos para adição
// ou remoção de subatividades, mas, no momento, é desnecessário.
@protocol FTINActivityDetails;
@interface FTINActivityDetails : JSONModel

// Serializable
@property (nonatomic) NSString *title;
@property (nonatomic) NSArray<FTINSubActivityDetails> *subActivities;

// Non-Serializable
@property (nonatomic) Activity *data;
@property (nonatomic) Patient *patient;

- (NSArray *)subActivitiesOfType:(FTINActivityType)type difficultyLevel:(NSInteger)difficultyLevel;

- (NSArray *)subActivitiesThatRespond:(BOOL (^)(FTINSubActivityDetails *subActivity))handler;

@end
