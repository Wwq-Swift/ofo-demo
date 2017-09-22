//
//  ViewController.swift
//  Ofo_demo
//
//  Created by 王伟奇 on 17/5/9.
//  Copyright © 2017年 王伟奇. All rights reserved.
//

import UIKit
import SWRevealViewController//导入侧边栏
import FTIndicator

class ViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate,AMapNaviWalkManagerDelegate {
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var pin: MyPinAnnotation!
    var nearBysearch = true
    var walkManager: AMapNaviWalkManager!
    
    //两个用来保存起点和终点的坐标
    var start,end: CLLocationCoordinate2D!
    //用于保存大头针视图
    var pinView: MAAnnotationView!
    
    @IBOutlet weak var panelView: UIView!
    @IBAction func locationBtnTap(_ sender: UIButton) {
        nearBysearch = true
        pin.isLockedToScreen = true
        //移除地图上添加的图层
        mapView.removeOverlays(mapView.overlays)
        
        searchBikeNearby()
    }
    
    
    //搜索周边小黄车的函数
    func searchBikeNearby(){
        searchCustomLocation(mapView.userLocation.coordinate)
    }
    //有坐标的搜索
    func searchCustomLocation(_ center: CLLocationCoordinate2D){
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "餐馆"
        //查询半径
        request.radius = 500
        request.requireExtension = true
        
        search.aMapPOIAroundSearch(request)
    }
    //搜索周边完成后的处理
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
     
        guard response.count > 0 else {
            print("周边没有小黄车")
            return
        }
        
        var annotations:[MAPointAnnotation]  = []
        
        //高级的复制数组
        annotations = response.pois.map{
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            
            if $0.distance < 200 {
                annotation.title = "红包区域内开锁任意小黄车"
                annotation.subtitle = "骑行10分钟可获得现金红包"
            } else{
                annotation.title = "正常可用"
            }
            return annotation
        }
        
        mapView.addAnnotations(annotations)
        
        if nearBysearch {
            //自动进行缩放，把所有显示的标注都放在视图中
            mapView.showAnnotations(annotations, animated: true)
            
            nearBysearch = !nearBysearch
        }
        
        
        
        
    }
    
    
    
    //点击了小黄车或者红包车时候调用的代理里的方法
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        
        start = pin.coordinate
        //所点击的annotation的坐标   每个Maanotationview对应的id
        end = view.annotation.coordinate
        
        let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(start.longitude))!
        let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))!
        
        //计算路径
        walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
    }
    
    
    //用户移动的   地图中心移动完成之后的交互    wasUserAction是否为用户移动的参数名
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction{
            //确定之后大头针不再移动
            pin.isLockedToScreen = true
            pinAnimation()
                      //查询点为 mapview的中心点
            searchCustomLocation(mapView.centerCoordinate)
        }
    }
    
    //地图初始化显示完成之后
    func mapInitComplete(_ mapView: MAMapView!) {
        pin = MyPinAnnotation()
        //地理位置经纬度的坐标
        pin.coordinate = mapView.centerCoordinate
        //屏幕上的坐标
        pin.lockedScreenPoint = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        //固定到屏幕上的位置
        pin.isLockedToScreen = true
        
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
        
    }
    
    //自定义大头针的效果
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        //用户自己定位的位置不需要自定义大头针
        if annotation is MAUserLocation{
            return nil
        }
        
        //自定义的pin大头针
        if annotation is MyPinAnnotation{
            let reuserid = "anchor"
            var av = mapView.dequeueReusableAnnotationView(withIdentifier: reuserid)
            if av == nil {
                av = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuserid)
            }
            av?.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            av?.canShowCallout = false
            
            pinView = av
            return av
        }
        
        let reuseid = "myid"
        //重用大头针的自定义图片  为了节约资源
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MAPinAnnotationView
        
        //如果第一次使用 就新建一个annotationview
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
        }
        
        if annotation.title == "正常可用" {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        } else {
            annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBikeRedPacket")
        }
        
        //气泡
        annotationView?.canShowCallout = true
        //丁上去的效果
        annotationView?.animatesDrop = true
        
        return annotationView
    }
    
    //先判断图层   然后给线段添加效果   MapViewDelegate中实现的方法
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay is MAPolyline {
            
            pin.isLockedToScreen = false
            
            //让地图缩放到路线图层的可视化区域
            mapView.visibleMapRect = overlay.boundingMapRect
            
            //初始化renderer
            let renderer = MAPolylineRenderer(overlay: overlay)
            renderer?.lineWidth = 8.0
            renderer?.strokeColor = UIColor.blue
            return renderer
        }
        return nil
    }
    

    override func viewDidLoad() {  //一般初始化都是放在程序一启动时， 不需要每次初始化，节省资源
        super.viewDidLoad()
        
        //对高德地图的mapview进行部署
        mapView = MAMapView(frame: view.bounds)
        view.addSubview(mapView)
        
        mapView.delegate = self
        //地图缩放
        mapView.zoomLevel = 17
        //显示当前位置
        mapView.showsUserLocation = true
        //追踪位置
        mapView.userTrackingMode = .follow
        
        //地图启动的时候，启动查询   搜索的初始化
        search = AMapSearchAPI()
        search.delegate = self
        
        //程序一启动就初始化walkManager  步行路径的代理和初始化
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //让面板视图出现在最前面
        view.bringSubview(toFront: panelView)
        //给单航条上设置按钮，始终是用自己的颜色渲染模式  设置中间图片 左边右边按键图片
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ofoLogo"))
        self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "leftTopImage").withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "rightTopImage").withRenderingMode(.alwaysOriginal)
        //设置返回按钮只有箭头没有文字
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        
        //获取容器视图controller
        if let revealVc = revealViewController(){
            //设置侧边栏的宽度
            revealVc.rearViewRevealWidth = 280
            //左上角item按键的目标
            navigationItem.leftBarButtonItem?.target = revealVc
            //按键执行的方法是SWRevealViewController的侧边栏的切换
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            //给它添加一个平移的手势
            view.addGestureRecognizer(revealVc.panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 大头针动画
    func pinAnimation(){
        //坠落效果，y轴加位移
        let endFrame = pinView.frame
        //offsetBy让视图便宜 然后返回原样
        pinView.frame = endFrame.offsetBy(dx: 0, dy: -15)
        //initialSpringVelocity初始速度
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: { 
            self.pinView.frame = endFrame
        }, completion: nil)
        
    }
    
    // MARK: - AMapNaviWalkManagerDelegate 导航的代理
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        print("路线规划成功")
        //移除地图上添加的图层
        mapView.removeOverlays(mapView.overlays)
        
        //用map 把一个类型的数组转换成另一个类型的数组
        var coordinates = walkManager.naviRoute!.routeCoordinates!.map{
            return CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
        }
        
        let polyline = MAPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapView.add(polyline)
        
        //提示用时和距离
        let  walkMinute = walkManager.naviRoute!.routeTime/60
        var timeDesc = "一分钟以内"
        if walkMinute > 0 {
            //description把int转换成string
            timeDesc = walkMinute.description + "分钟"
        }
        
        let hintTitle = "步行" + timeDesc
        let hintSubtitle = "距离" + walkManager.naviRoute!.routeLength.description + "米"
        
        FTIndicator.setIndicatorStyle(.dark)
        FTIndicator.showNotification(with: #imageLiteral(resourceName: "clock"), title: hintTitle, message: hintSubtitle)
        
        
        
    }


}

