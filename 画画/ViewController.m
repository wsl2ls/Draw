//
//  ViewController.m
//  画画
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 WSL. All rights reserved.
//

#import "ViewController.h"
#import "drawView.h"

typedef NS_ENUM(NSInteger, Attribute)
{
    NULLL,
    color,
    width,
    alpha,
};
@interface ViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImage * image;
    Attribute    attribute;
}
@property(nonatomic,strong) drawView * drawV;
@property(nonatomic,strong)  UIButton * colorBtn;
@property(nonatomic,strong)  UIButton * widthBtn;
@property(nonatomic,strong)  UIButton * arfBtn;
@property(nonatomic,strong)  UIButton * cleanBtn;
//橡皮擦
@property(nonatomic,strong)  UIButton * rubberBtn;
@property(nonatomic,strong)  UIButton * nextBtn;
@property(nonatomic,strong)  UIButton * backBtn;
@property(nonatomic,strong)  UIButton * saveBtn;
@property(nonatomic,strong)   UIButton * setBtn;

@property(nonatomic,strong)  UIView * setBtnView;
@property(nonatomic,strong)  UITableView * attributeTableView;
@property(nonatomic,strong)  NSMutableArray * colorsArray;
@property(nonatomic,strong)  NSMutableArray  * widthsArray;
@property(nonatomic,strong)  NSMutableArray  * alphasArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark ---setupUI
-(void)setupUI
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //imageView.image = [UIImage imageNamed:@"head.png"];
    [self.view  addSubview:imageView];
    
    [self.view  addSubview:self.drawV];
    [self.view   addSubview:self.setBtnView];
    [self.view  addSubview:self.saveBtn];
    [self.view   addSubview:self.setBtn];
    [self.view   addSubview:self.attributeTableView];
}
#pragma mark ---Help  Methods

#pragma mark ----- Events Handle
-(void)colorBtnClick
{
    static int isBtnHidden = 1;
    self.attributeTableView.scrollsToTop = YES;
    attribute = color;
    [self.attributeTableView  reloadData];
    if (isBtnHidden == 1) {
            self.attributeTableView.hidden = NO;
            isBtnHidden = 0;
    }
    else
    {
              self.attributeTableView.hidden = YES;
              isBtnHidden = 1;
    }
}
-(void)widthChangeBtnClick
{    attribute = width;
    self.attributeTableView.scrollsToTop = YES;
    [self.attributeTableView  reloadData];
    static int  isWidthHiddening  = 1;
    if (isWidthHiddening == 1) {
        self.attributeTableView.hidden = NO;
        isWidthHiddening = 0;
    }else
    {
        self.attributeTableView.hidden = YES;
        isWidthHiddening = 1;
    }
}
-(void)alphaChangeClick
{    attribute = alpha;
      self.attributeTableView.scrollsToTop = YES;
    [self.attributeTableView reloadData];
    static int  isAlphaHiddening  = 1;
    if (isAlphaHiddening == 1) {
        self.attributeTableView.hidden = NO;
        isAlphaHiddening = 0;
    }else
    {
        self.attributeTableView.hidden = YES;
        isAlphaHiddening = 1;
    }
}
-(void)cleanBtnClick:(UIButton *)btn
{
    [self.drawV cleanAll];
}
-(void)rubberBtnClick
{
     static UIColor * lineColor ;
     static  NSNumber  *  lineWidth ;
     static  float lineArf ;
     static int isRubber = 0;
    if (isRubber == 0) {
        lineColor=  self.drawV.lineColor ;
        lineWidth =  self.drawV.lineWidth;
         lineArf =  self.drawV.lineArf;
        self.drawV.lineColor = [UIColor whiteColor];
        self.drawV.lineWidth = [NSNumber numberWithFloat:10.0f];
        self.drawV.lineArf = 1.0f;
        isRubber = 1;
    }else
    {
        self.drawV.lineColor = lineColor;
        self.drawV.lineWidth = lineWidth;
        self.drawV.lineArf = lineArf;
        isRubber = 0;
    }
}
-(void)backBtnClick
{
    [self.drawV  backStep];
}
-(void)nextBtnClick
{
    [self.drawV nextStep];
}
-(void)saveBtnClick
{
    //创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
     image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message: @"确定要保存至手机相册吗?"delegate:nil cancelButtonTitle:@"取消"otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"保存至相册失败" message:   [NSString  stringWithFormat:@"error是%@",error.localizedDescription]delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
    }
}
//#pragma mark UIAlertViewDelegate
//点击按钮触发
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
    UIImageWriteToSavedPhotosAlbum(image, self, @selector (image:didFinishSavingWithError:contextInfo:), nil);}
}
-(void)setBtnClick
{
    static int setBtnIsHidden = 1;
    if (setBtnIsHidden == 1) {
        self.setBtnView.hidden = NO;
        setBtnIsHidden = 0;
    }else
    {
        self.setBtnView.hidden = YES;
        self.attributeTableView.hidden = YES;
        setBtnIsHidden = 1;
    }
    
}
#pragma mark ---- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (attribute) {
        case color:
            return self.colorsArray.count;
            break;
          case width:
            return self.widthsArray.count;
            break;
            case alpha:
            return self.alphasArray.count;
            break;
        default:
           return 0;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIde = @"cellIde";
    UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];
    }
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    switch (attribute) {
        case color:
            cell.backgroundColor = self.colorsArray[indexPath.row];
            cell.textLabel.text = @"";
            break;
        case width:
            cell.textLabel.text = self.widthsArray[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            break;
        case alpha:
            cell.textLabel.text = self.alphasArray[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView   deselectRowAtIndexPath:indexPath animated:YES];
    switch (attribute) {
        case color:
            self.drawV.lineColor = self.colorsArray[indexPath.row];
            break;
        case width:
        self.drawV.lineWidth = [NSNumber  numberWithInt:[self.widthsArray[indexPath.row] intValue]];
            break;
        case alpha:
         self.drawV.lineArf = [self.alphasArray[indexPath.row] floatValue];
            break;
        default:
            break;
    }
}
#pragma mark ----Getter
  // 画布
-(drawView *)drawV
{
    if (_drawV == nil) {
        _drawV = [[drawView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _drawV.backgroundColor = [UIColor clearColor];
        
        
    }return _drawV;
    
}
-(UIButton *)colorBtn
{
    if (_colorBtn == nil) {
         _colorBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_colorBtn setTitle:@"颜色" forState:UIControlStateNormal];
        _colorBtn.backgroundColor = [UIColor greenColor];
        [_colorBtn addTarget:self action:@selector(colorBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _colorBtn;
}
-(UIButton *)widthBtn
{
    if (_widthBtn == nil){
          _widthBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 50, 50)];
        [_widthBtn setTitle:@"粗细" forState:UIControlStateNormal];
        [_widthBtn addTarget:self action:@selector(widthChangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _widthBtn.backgroundColor = [UIColor redColor];
    }return _widthBtn;
}
-(UIButton *)arfBtn
{    if(_arfBtn == nil){
    _arfBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
    _arfBtn.backgroundColor = [UIColor blueColor];
    [_arfBtn setTitle:@"透明" forState:UIControlStateNormal];
    [_arfBtn addTarget:self action:@selector(alphaChangeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arfBtn;
}
-(UIButton *)cleanBtn
{
    if (_cleanBtn == nil) {
        _cleanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 50, 50)];
        _cleanBtn.backgroundColor = [UIColor  orangeColor];
        [_cleanBtn setTitle:@"清除" forState:UIControlStateNormal];
        [_cleanBtn addTarget:self action:@selector(cleanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanBtn;
}
-(UIButton *)rubberBtn
{
    
    if (_rubberBtn == nil) {
        _rubberBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 50, 50)];
        _rubberBtn.backgroundColor = [UIColor blueColor];
        [_rubberBtn setTitle:@"橡皮" forState:UIControlStateNormal];
        [_rubberBtn  addTarget:self action:@selector(rubberBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }return _rubberBtn;
}
-(UIButton *)backBtn
{
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 250, 50, 50)];
        _backBtn.backgroundColor = [UIColor redColor];
        [_backBtn setTitle:@"back" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
-(UIButton *)nextBtn
{
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, 50, 50)];
        _nextBtn.backgroundColor = [UIColor cyanColor];
        [_nextBtn setTitle:@"next" forState:UIControlStateNormal];
        [_nextBtn  addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
-(UIButton *)saveBtn
{
    if (_saveBtn == nil) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 20, 50, 44)];
        _saveBtn.backgroundColor = [UIColor blueColor];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn  addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
-(UIButton *)setBtn
{
    if (_setBtn == nil) {
        _setBtn = [[UIButton alloc] initWithFrame:CGRectMake(320, 20, 50, 44)];
        [_setBtn setTitle:@"设置" forState:UIControlStateNormal];
        _setBtn.backgroundColor = [UIColor orangeColor];
        [_setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setBtn;
}
-(UIView *)setBtnView
{
    if (_setBtnView == nil) {
        _setBtnView = [[UIView alloc] initWithFrame:CGRectMake(320, 64, 50, 350)];
        _setBtnView.backgroundColor = [UIColor  cyanColor];
        [_setBtnView  addSubview:self.colorBtn];
        [_setBtnView  addSubview:self.widthBtn];
        [_setBtnView  addSubview:self.arfBtn];
        [_setBtnView  addSubview:self.cleanBtn];
        [_setBtnView  addSubview:self.rubberBtn];
        [_setBtnView  addSubview:self.backBtn];
        [_setBtnView  addSubview:self.nextBtn];
        _setBtnView.hidden = YES;
    }return _setBtnView;
}
-(UITableView *)attributeTableView
{
    if (_attributeTableView == nil) {
        _attributeTableView = [[UITableView alloc] initWithFrame:CGRectMake(260, 64, 50, 350) style:UITableViewStylePlain];
        _attributeTableView.delegate = self;
        _attributeTableView.dataSource = self;
        _attributeTableView.showsVerticalScrollIndicator = NO;
        _attributeTableView.hidden = YES;
    }
    return _attributeTableView;
}
-(NSMutableArray *)colorsArray
{
    if (_colorsArray == nil) {
        NSArray * colorArray = @[[UIColor greenColor],[UIColor blueColor],[UIColor blackColor],[UIColor redColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor cyanColor],[UIColor purpleColor],[UIColor brownColor],[UIColor magentaColor],[UIColor grayColor],[UIColor darkGrayColor]];
        _colorsArray = [[NSMutableArray alloc] initWithArray:colorArray];
        for (int i = 0; i < 70 ; i++) {
            UIColor * color = [UIColor  colorWithRed:arc4random()%256/256.0f green:arc4random()%256/256.0f blue:arc4random()%256/256.0f alpha:1.0];
            [_colorsArray  addObject:color];
        }
    }return _colorsArray;
}
-(NSMutableArray *)widthsArray
{
    if (_widthsArray == nil) {
        _widthsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 100; i++) {
            NSString * widthStr = [NSString stringWithFormat:@"%d",i];
            [_widthsArray  addObject:widthStr];
        }
    }return _widthsArray;
}
-(NSMutableArray *)alphasArray
{
    if (_alphasArray == nil) {
        _alphasArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 11; i++) {
            NSString * alphaStr = [NSString stringWithFormat:@"%.1f",i/10.0f];
            [_alphasArray  addObject:alphaStr];
        }
    }return _alphasArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
