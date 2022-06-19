import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestPage(),
    ),
  );
}

//定义点
class CustomPoint {
  //点的位置
  late Offset postion;

  //点初始化的的位置  移动出后需要重新初始化
  late Offset origin;

  //点的大小
  late double radius;

  //随机速度
  late double speet;

  late double leaves;
}

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  List<CustomPoint> _list = [];

  Random _random = new Random();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    
    _animationController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3500));

    //动画监听
    _animationController.addListener(() {
      setState(() {});
    });

    //重复执行
    _animationController.repeat();

    ///创建点
    Future.delayed(Duration.zero, () {
      for (int i = 0; i < 1000; i++) {
        CustomPoint point = new CustomPoint();

        //随机x 坐标
        double x = _random.nextDouble() * MediaQuery.of(context).size.width;

        //随机y坐标
        double y = _random.nextDouble() * MediaQuery.of(context).size.height;

        //点的位置
        point.postion = Offset(x, y);
        //点的半径 随机
        point.radius = 2* _random.nextDouble();

        //随机速度
        point.speet = 0.6*_random.nextDouble();

        point.origin = const Offset(0, 0);

        _list.add(point);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      ///填充布局
      body: Container(
        width: double.infinity,
        height: double.infinity,
        //层叠布局
        child: Stack(
          alignment: Alignment.center,
          children: [
            //来一个图片
            Positioned.fill(
              child: Image.asset(
                "images/1.png",
                //填充一下
                fit: BoxFit.fill,
              ),
            ),

            //绘制
            Positioned.fill(
              child: CustomPaint(
                painter: FlowerCustomPater(list: _list),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlowerCustomPater extends CustomPainter {
  //先来个画笔
  
      // ignore: prefer_final_fields
      Paint _paint = new Paint()
    ..isAntiAlias=true
    ..color=ui.Color.fromARGB(255, 246, 211, 223);
   

  //来个List
  List<CustomPoint> list;

  FlowerCustomPater({required this.list});

  //绘制操作
  @override
  void paint(Canvas canvas, Size size) {
    //在每次绘制前计算一下坐标

    list.forEach((element) {
      double x = element.postion.dx;
      double y = element.postion.dy;

      //移动屏幕后重置
      if (y >= size.height) {
        //回到最上面
        y = element.origin.dy;
      }
      if(x >=size.width+100){
        x=element.origin.dx;
      }
      //因为这里的偏移值 是一样的 所以移动 速度是一样的
      //再来个随机的速度

      element.postion = Offset(x+element.speet, y + element.speet);
    });
    
    list.forEach((element) {
      //element 就是当前的点
      //先来画个点
      canvas.drawCircle(element.postion,element.radius, _paint);
    });
  }

  //实时刷新
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}

