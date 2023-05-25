//
//  MovieDetailsViewController.m
//  Flixter
//
//  Created by Miguel Arriaga Velasco on 19/05/23.
//

#import "MovieDetailsViewController.h"

#import <ComponentKit/CKCollectionViewDataSource.h>
#import <ComponentKit/CKComponentFlexibleSizeRangeProvider.h>
#import <ComponentKit/CKComponentProvider.h>
#import <ComponentKit/CKDataSourceChangeset.h>
#import <ComponentKit/CKDataSourceConfiguration.h>
#import "MovieDetailsComponent.h"

@interface MovieDetailsViewController () <UICollectionViewDelegateFlowLayout>{
    Movie *_movie;
    CKCollectionViewDataSource *_dataSource;
    UICollectionView *_collectionView;
    ImageDownloader *_imageDownloader;
}

@end

@implementation MovieDetailsViewController

+ (instancetype)viewControlerWithMovie:(Movie *)movie imageDownloader:(ImageDownloader *)imageDownloader{
    return [[MovieDetailsViewController alloc]initWithMovie:movie imageDownloader:imageDownloader];
}

- (instancetype)initWithMovie: (Movie *)movie
              imageDownloader:(nonnull ImageDownloader *)imageDownloader
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _movie = movie;
        _imageDownloader = imageDownloader;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // add root views
    
    [self.view addSubview:_collectionView];
    [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
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
                                  initWithComponentProvider:[self class]
                                  context:_imageDownloader
                                  sizeRange:[[CKComponentFlexibleSizeRangeProvider
                                              providerWithFlexibility:CKComponentSizeRangeFlexibleHeight]
                                             sizeRangeForBoundingSize:self.view.bounds.size]]];

    // render initial data
    CKDataSourceChangesetBuilder *builder = [CKDataSourceChangesetBuilder dataSourceChangeset];
    [builder withInsertedSections:[NSIndexSet indexSetWithIndex:0]];
    [builder withInsertedItems:@{[NSIndexPath indexPathForRow:0 inSection:0]: _movie}];
    [_dataSource applyChangeset:[builder build] mode:CKUpdateModeAsynchronous userInfo:nil];
}

#pragma mark CKComponentProvider
+ (CKComponent *)componentForModel:(id<NSObject>)model context:(id<NSObject>)context;
{
    CKFlexboxSpacing padding = {
        .top = 10,    // Initialize top with a dimension of 10 points
        .bottom = 10, // Initialize bottom with a dimension of 20 points
        .start = 20,      // Initialize start with automatic dimension
        .end = 20,   // Initialize end with a dimension of 50% of the container
    };
    return [MovieDetailsComponent newWithMovie:(Movie *)model imageDownloader:(ImageDownloader *)context padding:padding];
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

@end
