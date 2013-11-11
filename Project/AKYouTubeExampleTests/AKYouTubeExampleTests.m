//
//  AKYouTubeExampleTests.m
//  AKYouTubeExampleTests
//
//  Created by Anton Pomozov on 02.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

@import XCTest;

#import <EasyMapping/EKMapper.h>
#import <AKYouTube/YTResponsePlaylistObject.h>
#import <AKYouTube/YTPlaylistObject.h>
#import <AKYouTube/YTMappingProvider.h>

@interface AKYouTubeExampleTests : XCTestCase

@property (nonatomic, copy) NSDictionary *jsonResponse;

@end

@implementation AKYouTubeExampleTests

- (void)setUp {
    [super setUp];

    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"Response" ofType:@"json"];
    NSString *jsonFixture = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [jsonFixture dataUsingEncoding:NSUTF8StringEncoding];
    self.jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testResponsePlaylistMapping {
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    
    YTResponsePlaylistObject *responseObject = [EKMapper objectFromExternalRepresentation:self.jsonResponse
                                                                      withMapping:[YTMappingProvider responsePlaylistMapping]];
    NSString *kind = @"youtube#playlistListResponse";
    XCTAssertEqualObjects(kind, responseObject.kind, @"Kind of playlist response should be %@", kind);
    NSString *etag = @"\"WD4VMEpMvsFyTbuuNulahhED0yg/aA01UQ9o3PNDZDy9HHdwJCSmBSI\"";
    XCTAssertEqualObjects(etag, responseObject.etag, @"Etag of playlist response should be %@", etag);
    NSUInteger totalResults = 17;
    XCTAssertEqual(totalResults, responseObject.totalResults, @"Total received items in playlist response should be equals %d", totalResults);
    NSUInteger resultsPerPage = 5;
    XCTAssertEqual(resultsPerPage, responseObject.resultsPerPage, @"Items per page in playlist response should be equals %d", resultsPerPage);
    NSUInteger itemsCount = 5;
    XCTAssertEqual(itemsCount, responseObject.items.count, @"There should be %d items in the playlist response", itemsCount);
    
    YTPlaylistObject *playlist = responseObject.items.firstObject;
    NSString *kindPlaylist = @"youtube#playlist";
    XCTAssertEqualObjects(kindPlaylist, playlist.kind, @"Kind of first playlist should be %@", kindPlaylist);
    NSString *etagPlaylist = @"\"WD4VMEpMvsFyTbuuNulahhED0yg/aMI_U3Fiq4aJd2AYxBc2-nz1DlA\"";
    XCTAssertEqualObjects(etagPlaylist, playlist.etag, @"Etag of first playlist should be %@", etagPlaylist);
}

@end
