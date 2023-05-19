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

@interface MovieDetailsViewController (){
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
