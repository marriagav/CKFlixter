//
//  FlixterViewController.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 16/05/23.
//

#import "FlixterViewController.h"
#import "HelloWorldComponent.h"

#import <ComponentKit/CKCollectionViewDataSource.h>
#import <ComponentKit/CKComponentFlexibleSizeRangeProvider.h>
#import <ComponentKit/CKComponentProvider.h>
#import <ComponentKit/CKDataSourceChangeset.h>
#import <ComponentKit/CKDataSourceConfiguration.h>

#import <CKComponentHostingView.h>
#import "RootComponentProvider.h"
#import "Movie.h"
#import "MoviesViewModel.h"

@interface FlixterViewController () <UICollectionViewDelegateFlowLayout> {
    UICollectionView *_collectionView;
    CKCollectionViewDataSource *_dataSource;
//    NSMutableArray<Movie *> *_movies;
    //PAListViewModel *_viewModel;
    // PAImageDownloader *_imageDownloader;
}

@end

@implementation FlixterViewController

+ (instancetype)viewController
{
    return [[FlixterViewController alloc] initWithNibName:nil bundle:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                            collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        //_viewModel = [[PAListViewModel alloc] init];
        //_imageDownloader = [[PAImageDownloader alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    
    // add root views
    [self.view addSubview:_collectionView];
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_collectionView insertSubview:refreshControl atIndex:0];
    
    NSArray<NSString *> *formats = @[@"H:|[C]|", @"V:|[C]|"];
    for (NSString *format in formats) {
        [self.view
         addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format
                                                                options:0
                                                                metrics:nil
                                                                  views:@{@"C": _collectionView}]];
    }

    _collectionView.delegate = self;
    
    self.view.backgroundColor = [UIColor grayColor];

    // set up data source
    _dataSource = [[CKCollectionViewDataSource alloc]
                   initWithCollectionView:_collectionView
                   supplementaryViewDataSource:nil
                   configuration:[[CKDataSourceConfiguration alloc]
                                  initWithComponentProvider:[RootComponentProvider class]
                                  context:self
                                  sizeRange:[[CKComponentFlexibleSizeRangeProvider
                                              providerWithFlexibility:CKComponentSizeRangeFlexibleHeight]
                                             sizeRangeForBoundingSize:self.view.bounds.size]]];

    // render initial data
    CKDataSourceChangeset *initialData = [[[CKDataSourceChangesetBuilder dataSourceChangeset]
                                           withInsertedSections:[NSIndexSet indexSetWithIndex:0]]build];
    
    [_dataSource applyChangeset:initialData mode:CKUpdateModeAsynchronous userInfo:nil];
    
    [self showMovies];
    
    
}

- (NSMutableDictionary<NSIndexPath *, NSObject *> *)createMoviesDictionaryFromDataDictionary:(NSDictionary *)dataDictionary {
    NSMutableDictionary<NSIndexPath *, NSObject *> *moviesDictionary = [NSMutableDictionary dictionary];
    int counter = 0;
    
    for (id element in dataDictionary[@"results"]) {
        Movie *movie = [[Movie alloc] initWithTitle:element[@"title"]
                                           overview:element[@"overview"]
                                          posterUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"https://image.tmdb.org/t/p/original", element[@"poster_path"]]]];
        [moviesDictionary setObject:movie forKey:[NSIndexPath indexPathForRow:counter inSection:0]];
        counter++;
    }
    
    return moviesDictionary;
}

- (void)updateDataSourceWithMoviesDictionary:(NSMutableDictionary<NSIndexPath *, NSObject *> *)moviesDictionary{
    CKDataSourceChangeset *changeset = [[[CKDataSourceChangesetBuilder dataSourceChangeset] withUpdatedItems:moviesDictionary] build];
    [self->_dataSource applyChangeset:changeset mode:CKUpdateModeAsynchronous userInfo:nil];
}

- (void)showMovies
{
    
    MoviesViewModel *moviesModel = [[MoviesViewModel alloc] init];
    [moviesModel fetchMoviesWithCompletion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary<NSIndexPath *, NSObject *> *moviesDictionary = [self createMoviesDictionaryFromDataDictionary:dataDictionary];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CKDataSourceChangeset *loadingData = [[[CKDataSourceChangesetBuilder dataSourceChangeset] withInsertedItems:moviesDictionary] build];
                [self->_dataSource applyChangeset:loadingData mode:CKUpdateModeAsynchronous userInfo:nil];
            });
            
        }
    }];
    
}

- (void)onTap:(Movie *)movie
{
//    NSLog(@"%@", movie.title);
        [self
         showViewController:[FlixterViewController viewController]
         sender:self];
//    [self
//     showViewController:[FlixterViewController viewControlerWithPhoto:photo imageDownloader:_imageDownloader]
//     sender:self];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource sizeForItemAtIndexPath:indexPath];
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataSource announceWillDisplayCell:cell];
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataSource announceDidEndDisplayingCell:cell];
}

#pragma mark RefreshControl

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchMoviesWithRefreshControl:refreshControl];
}

- (void)fetchMoviesWithRefreshControl:(UIRefreshControl *)refreshControl {
    MoviesViewModel *moviesModel = [[MoviesViewModel alloc] init];
    [moviesModel fetchMoviesWithCompletion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary<NSIndexPath *, NSObject *> *moviesDictionary = [self createMoviesDictionaryFromDataDictionary:dataDictionary];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateDataSourceWithMoviesDictionary:moviesDictionary];
                [refreshControl endRefreshing];
            });
        }
    }];
}


@end
