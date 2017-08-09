# HFChart
a beautiful  line chart
效果图是这样的：

 ![image](https://github.com/Li-Qun/HFChart/blob/master/pic.png)

关键是在

基本策略 是描点 和 连线。

折线基础版本，我找到网上的第三方，UUChart 。 特点是朴素，简单，扩展性强。

效果图重点是在折线要有阴影，于是 重点 放在 折线发散的阴影 和 拆解第三方 整理出符合需求的面向对象良好的折线模型。

一 拆解：

分三个文件 HFChart,HFChartLineView,HFChartConst

HFChart : 折线视图控制器角色  控制展示数值范围，颜色，横线 等 必要UI 元素展示规则

HFChartConst : 折线需要展示的一些静态参数 比如 45设定为行间距 就可以设置在 Const 里面。

HFChartLine:  主要是实施绘制 描点 连线 和 绘制我们需要的阴影

二 阴影

说是阴影，实际 是颜色的渐变。

（1）之前 思考方向  这个阴影 是两点之间的连线 发散出来的， 就是这个执拗思路莫名把问题难度加大。因为 折线的若干个点，相邻 每两个点之间的连线都要有阴影 那么阴影方向？ 阴影重叠？ 等问题怎么解决？ 越想越复杂

（2）从颜色渐变考虑

创建渐变图层，根据折线点，mask遮罩区域，剩下的渐变图层放在视图背景图上 就是阴影啦。有没有一种豁然开朗的感觉？

举例子：

(2.1)绘制渐变图层：CAGradientLayer  是用来绘制渐变图层的工具，作为关键字可以搜索到很多参考资料

复制代码
//实现背景渐变
//初始化我们需要改变背景色的UIView，并添加在视图上
self.theView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, self.view.hf_width)];
[self.view addSubview:self.theView];
//初始化CAGradientlayer对象，使它的大小为UIView的大小
self.gradientLayer = [CAGradientLayer layer];
self.gradientLayer.frame = self.theView.bounds;
//将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
[self.theView.layer addSublayer:self.gradientLayer];
//设置渐变区域的起始和终止位置（范围为0-1）
//不设置默认从上到下渐变，如果使用startPoint endPoint 就是右下角对角线 方向渐变 也可以自定义方向
// self.gradientLayer.startPoint = CGPointMake(0, 0);
// self.gradientLayer.endPoint = CGPointMake(1, 1);
//设置颜色数组(我写的是白色的渐变)
CGColorRef color1 = [UIColor colorWithWhite:1.000 alpha:0.7].CGColor;
CGColorRef color2 = [UIColor colorWithWhite:1.000 alpha:0.0].CGColor;
[_gradientLayer setColors:@[(__bridge id)color1,(__bridge id)color2]];//设置颜色分割点（范围：0-1）
self.gradientLayer.locations = @[@(0.0f), @(0.9f)];
复制代码
效果图如下：（为了看清楚 白色的渐变遮罩 我选择了醒目的 紫色做背景色）





(2.2) 在知道已知点集（有序点 折点顺序）合添加遮罩方法

复制代码
//给渐变层设置 mask 属性
{
// 设置只显示一个三角形范围的渐变色
UIBezierPath *shapeLayerPath = [[UIBezierPath alloc] init];
// 点的坐标是相对于渐变层的
[shapeLayerPath moveToPoint:CGPointMake(0,self.view.hf_width)];//第一个点
[shapeLayerPath addLineToPoint:CGPointMake(self.view.hf_width/2, 0)];//第二个点
[shapeLayerPath addLineToPoint:CGPointMake(self.view.hf_width, self.view.hf_width)];//第三个点
CAShapeLayer *shapeLayer = [CAShapeLayer layer];
shapeLayer.path = shapeLayerPath.CGPath;
self.gradientLayer.mask = shapeLayer;
}
复制代码
效果图：





三 剩下的就是组织自己的折线模型结构了 已经是很简单了有没有？

整理HFChart HFChartConst HFChartLine 给 HFChartLine 添加遮罩 完成

参考 ：

1 . https://github.com/ZhipingYang/UUChartView

2.http://www.jb51.net/article/79948.htm
