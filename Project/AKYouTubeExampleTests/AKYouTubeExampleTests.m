//
//  AKYouTubeExampleTests.m
//  AKYouTubeExampleTests
//
//  Created by Anton Pomozov on 02.10.13.
//  Copyright (c) 2013 Akademon Ltd. All rights reserved.
//

@import XCTest;

#import <EKMapper.h>
#import "AKYoutubeObjectsMapper.h"
#import "AKResponseYouTubeObject.h"
#import "AKPlaylistYouTubeObject.h"

@interface AKYouTubeExampleTests : XCTestCase

@end

@implementation AKYouTubeExampleTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testResponsePlaylistMapping {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"ResponsePlaylists" ofType:@"json"];
    NSString *jsonFixture = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [jsonFixture dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    AKResponseYouTubeObject *responseObject = [EKMapper objectFromExternalRepresentation:jsonResponse
                                                                             withMapping:[AKYoutubeObjectsMapper responsePlaylistMapping]];
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
    
    AKPlaylistYouTubeObject *playlist = responseObject.items.firstObject;
    NSString *kindPlaylist = @"youtube#playlist";
    XCTAssertEqualObjects(kindPlaylist, playlist.kind, @"Kind of first playlist should be %@", kindPlaylist);
    NSString *etagPlaylist = @"\"WD4VMEpMvsFyTbuuNulahhED0yg/aMI_U3Fiq4aJd2AYxBc2-nz1DlA\"";
    XCTAssertEqualObjects(etagPlaylist, playlist.etag, @"Etag of first playlist should be %@", etagPlaylist);
}

/*
- (void)testResponseChannelMapping {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"ResponseChannels" ofType:@"json"];
    NSString *jsonFixture = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [jsonFixture dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    YTResponseObject *responseObject = [EKMapper objectFromExternalRepresentation:jsonResponse
                                                                      withMapping:[YTMappingProvider responseChannelMapping]];
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
*/

@end
