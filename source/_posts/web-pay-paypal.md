---
title: PayPal支付接入
date: 2024-03-07 09:46:44
categories: ['WebSite', 'Pay']
tags: ['WebSite', 'Pay']
---

# 一、简述

&emsp;&emsp;**PayPal是倍受全球亿万用户追捧的国际贸易支付工具**，即时支付，即时到账，全中文操作界面，能通过中国的本地银行轻松提现，解决外贸收款难题，助您成功开展海外业务，决胜全球。 注册PayPal后就可立即开始接受信用卡付款。作为在线付款服务商，PayPal是您向全世界近2.54亿的用户敞开大门的最快捷的方式。最大的好处是，注册完全免费！集国际流行的信用卡，借记卡，电子支票等支付方式于一身。帮助买卖双方解决各种交易过程中的支付难题。PayPal是名副其实的全球化支付平台，服务范围超过200个市场，支持的币种超过100个。在跨国交易中，将近70%的在线跨境买家更喜欢用PayPal支付海外购物款项。

**PayPal提供了多种支付方式：**

- 标准支付（标准支付誉为最佳实践。）
- 快速支付

> 注意：paypal支付国内账号不能付款给国内账号

# 二、PayPal的相关URL

正式网址：https://www.paypal.com/
沙箱（开发者）网址：https://developer.paypal.com/
沙箱（测试用户）登录地址：https://www.sandbox.paypal.com/
demo地址：https://demo.paypal.com/c2/demo/code_samples
webHooks验证（调用API）：https://developer.paypal.com/docs/api/webhooks/v1#verify-webhook-signature

官方文档：
https://developer.paypal.com/docs/checkout
https://developer.paypal.com/docs/api/orders/v2

# 三、PayPal Checkout集成步骤

1. 整合Smart Payment Buttons（PayPal智能付款按钮）到页面
2. 用户点击支付按钮
3. 按钮调用PayPal Orders API来创建交易
4. 进入PayPal支付页面
5. 用户登录后确认支付
6. 按钮调用PayPal Orders API来完成交易
7. 显示支付成功信息

# 四、PayPal Checkout集成实现

## 1. 注册账号
在PayPal正式网站[https://www.paypal.com](https://www.paypal.com)中注册一个账号，如果公司没有给你相关信息的话，先注册一个个人账号也是一样的。
{% asset_img website.png PayPal官网 %}

## 2. 进入开发者控制台
在开发者平台[https://developer.paypal.com](https://developer.paypal.com)，登录刚创建的账号, 进入控制台：
{% asset_img dashboard.png 控制台 %}

登录成功后，点击菜单：Testing Tools => Sandbox Accounts, 再点击Create account按钮，添加测试账号：
{% asset_img sandbox-accounts.png 测试账号列表 %}

创建个人账号和商家账号用于测试沙箱环境。
{% asset_img sandbox-account-add.png 添加测试账号 %}

点击菜单： Apps & Credentials, 再点击Create App按钮，添加测试应用：
{% asset_img sandbox-apps.png 测试应用列表 %}

创建APP获取client id和secret。
{% asset_img sandbox-app-add.png 添加测试应用 %}

查看APP的client id和secret。
{% asset_img sandbox-app-view.png 查看APP详情 %}

查看client id和secret。
{% asset_img sandbox-app-detail.png 查看APP详情 %}

查看APP的关联账号、密码。
{% asset_img sandbox-app-user.png 查看APP详情 %}

## 3. PHP示例代码

```php
<?php

$dev = true; //是否开发模式
$clientId = '你应用的ID';
$secretKey = '你应用的秘钥';

$action = 'action'.ucfirst(isset($_GET['action']) ? $_GET['action'] : 'index');
$paypal = new paypal($clientId, $secretKey, $dev);
$method = method_exists($paypal, $action) ? $action : 'actionIndex';
$paypal->$method();
exit;

class paypal{

    const STATUS_APPROVED = 'APPROVED';
    const STATUS_COMPLETED = 'COMPLETED';
    //
    private $siteUrl = '';
    private $returnUrl = '';
    private $cancelUrl = '';
    //
    private $accessTokenUrl = "https://api-m.sandbox.paypal.com/v1/oauth2/token";
    private $createOrderUrl = "https://api-m.sandbox.paypal.com/v2/checkout/orders";
    private $paymentUrl = "https://api-m.sandbox.paypal.com/v2/checkout/orders/%s/capture";
    private $captureUrl = "https://api-m.sandbox.paypal.com/v2/checkout/orders/%s/capture";
    private $getDetailUrl = "https://api-m.sandbox.paypal.com/v2/checkout/orders/%s";
    //批准、确认了付款
    private $payUrl = 'https://www.sandbox.paypal.com/checkoutnow?token=';

    //订单已完成
    private $tokenType = 'basic';

    /**
     * App Client ID 和 SECRET
     */
    private $clientId = '';
    private $secret = '';

    public function __construct($clientId, $secret, $dev = true){
        $this->clientId = trim($clientId);
        $this->secret = trim($secret);
        if(!$dev){
            //docs: https://developer.paypal.com/api/rest/requests/
            $this->accessTokenUrl = str_replace('sandbox.', '', $this->accessTokenUrl);
            $this->createOrderUrl = str_replace('sandbox.', '', $this->createOrderUrl);
            $this->paymentUrl = str_replace('sandbox.', '', $this->paymentUrl);
            $this->captureUrl = str_replace('sandbox.', '', $this->captureUrl);
            $this->getDetailUrl = str_replace('sandbox.', '', $this->getDetailUrl);
            $this->payUrl = str_replace('sandbox.', '', $this->payUrl);
        }

        $this->siteUrl = 'http://'.$_SERVER['HTTP_HOST']. $_SERVER['PHP_SELF'];
        $this->returnUrl = $this->siteUrl.'?action=capture&tradeId=';
        $this->cancelUrl = $this->siteUrl.'?action=cancel&tradeId=';
    }

    /**
     * 入口
     *
     * @return void
     */
    public function actionIndex(){
        echo <<<HTML
<!doctype html>
<html>
<head>
    <meta charset="utf8" name="viewport" content="width=device-width, initial-scale=1">
    <title>付款页Demo</title>
</head>
<body>
<script src="https://www.paypal.com/sdk/js?client-id={$this->clientId}&commit=true"></script>
<div class="pay-box" style="margin-top: 30px;">
    方式1：

    <a href="?action=add">跳转支付</a><hr><br>

    方式2：

    <div style="margin-top: 10px;" id="paypal-button-container"></div>
</div>
<script>
    paypal.Buttons({
        env: 'sandbox', /* sandbox | production */
        style: {
            layout: 'vertical',   // 布局方式：vertical: 垂直，horizontal：水平，
            size: 'responsive',   /* medium | large | responsive*/
            shape: 'rect',         /* pill | rect*/
            color: 'blue',         /* gold | blue | silver | black*/
            label: 'paypal'
        },
        commit: true, // Show a 'Pay Now' button
        createOrder: function () {
            return fetch('?action=addAjax&t='+Date.now(), {
                method: 'post',
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    pid: 1,
                    name: '商品',
                    amount: 100,
                    quantity: 1,
                })
            }).then((response) => response.json())
                .then(function (rsp) {
                    if (rsp.code === 0)
                        return rsp.data.id;
                    else {
                        alert(rsp.msg);
                    }
                });
        },
        /* onApprove() is called when the buyer approves the payment */
        onApprove: function (data, actions) {
            var EXECUTE_URL = '?action=captureAjax&token=' + data.orderID+'&t='+Date.now();
            return fetch(EXECUTE_URL, {
                method: 'post',
                body: JSON.stringify(data)
            }).then(function (res) {
                return res.json();
            }).then(function (rsp) {
                if (rsp.code === 0)
                    window.location.href = rsp.data.url;
                else {
                    alert(rsp.msg);
                }
            });
        }, onCancel: function (data, actions) {
            return fetch('?action=cancelAjax&token=' + data.orderID+'&t='+Date.now() , {
                method: 'post',
                body: JSON.stringify(data)
            }).then(function (res) {
                return res.json();
            }).then(function (rsp) {
                if (rsp.code === 0){
                    window.location.href = rsp.data.url;
                }else {
                    alert(rsp.msg);
                }
            });
        }
    }).render('#paypal-button-container');
</script>
</body>
</html>
HTML;
    }

    /**
     * 下单
     * @return void
     */
    //下单
    public function actionAdd(){
        $tradeId = date('YmdHis'); //当前系统的业务id
        $paypalOrder = $this->createOrder($tradeId, '0.01', 'usd', '测试', $this->returnUrl.$tradeId, $this->cancelUrl.$tradeId);
        $jumpUrl = $this->buildPayUrl($paypalOrder['id']);
        foreach($paypalOrder['links'] as $link){
            if('payer-action' == $link['rel']){
                $jumpUrl = $link['href'];
            }
        }
        header('Location: '.$jumpUrl);
    }

    /**
     * 下单
     * @return void
     */
    public function actionAddAjax(){
        $tradeId = date('YmdHis'); //当前系统的业务id
        $paypalOrder = $this->createOrder($tradeId, '0.01', 'usd', '测试', $this->returnUrl.$tradeId, $this->cancelUrl.$tradeId);
        header('Content-type: application/json;charset=utf-8');
        exit(json_encode(array(
            'code' => 0,
            'msg'  => '',
            'data' => $paypalOrder
        )));
    }

    /**
     * 处理PayPal捕获订单请求
     * @return void
     */
    public function actionCaptureAjax(){
        $orderId = $_GET['token'];

        $order = $this->getOrderDetail($orderId);

        //捕获订单
        if(self::STATUS_APPROVED == $order['status']){
            $order = $this->doCapture($orderId);
        }

        //paypal支付订单已完成
        if(self::STATUS_COMPLETED === $order['status']){
            //TODO: 更新本地订单状态
        }

        //TODO: 实现你自己的逻辑

        header('Content-type: application/json;charset=utf-8');
        exit(json_encode(array(
            'code' => 0,
            'msg'  => '',
            'data' => array(
                'url'   => $this->siteUrl . '?status=paidAjax&token='.$orderId,
                'order' => $order
            )
        )));
    }

    /**
     * 处理PayPal捕获订单跳转访问
     * @notifyUrl http://localhost:8080/paypal/cgi.php?action=capture&tradeId=20240307072238&token=2HU68026EG4614156&PayerID=P9YH29QLRXGX8
     * @return void
     */
    public function actionCapture(){
        $tradeId = $_GET['tradeId'];
        $orderId = $_GET['token'];

        //获取订单信息
        $order = $this->getOrderDetail($orderId);

        //捕获订单
        if(self::STATUS_APPROVED == $order['status']){
            $order = $this->doCapture($orderId);
        }

        //paypal支付订单已完成
        if(self::STATUS_COMPLETED === $order['status']){
            //TODO: 更新本地订单状态
        }

        //TODO: 实现你自己的逻辑

        //TODO: 重定向到你想去的地方
        header('Location: '.$this->siteUrl . '?status=paid&token='.$orderId);
    }

    /**
     * 处理PayPal取消订单请求
     * @return void
     */
    public function actionCancelAjax(){
        $orderId = $_GET['token'];

        //获取订单信息
        $order = $this->getOrderDetail($orderId);
        //var_dump($order);exit;

        //TODO: 实现你自己的逻辑

        header('Content-type: application/json;charset=utf-8');
        exit(json_encode(array(
            'code' => 0,
            'msg'  => '',
            'data' => array(
                'url'   => $this->siteUrl . '?status=cancelAjax&token='.$orderId,
                'order' => $order
            )
        )));
    }

    /**
     * 处理PayPal取消订单跳转访问
     * @notifyUrl http://localhost:8080/paypal/cgi.php?action=cancel&tradeId=20240307065641&token=5X899557H87050714
     * @return void
     */
    public function actionCancel(){
        $tradeId = $_GET['tradeId'];
        $orderId = $_GET['token'];

        //获取订单信息
        $order = $this->getOrderDetail($orderId);
        //var_dump($order);exit;

        //TODO: 实现你自己的逻辑

        //TODO: 重定向到你想去的地方
        header('Location: '.$this->siteUrl. '?status=cancel&token='.$orderId);
    }

    /**
     * @url https://developer.paypal.com/docs/api/orders/v2/#orders_create
     * @return array
     */
    private function createOrder($referenceId, $amount, $currency, $desc, $returnUrl, $cancelUrl){
        $order = $this->httpPost($this->createOrderUrl, array(
            'Content-Type: application/json',
            //'PayPal-Request-Id: ',
            'Authorization: '.$this->getAuthToken(),
        ), array(
            'intent'         => 'CAPTURE',
            'purchase_units' => array(
                array(
                    //外部ID，256字符
                    'reference_id' => $referenceId,
                    //购买说明，127字符
                    'description'  => $desc,
                    'amount'       => array(
                        'currency_code' => $currency,
                        'value'         => $amount
                    )
                )
            ),
            'payment_source' => array(
                'paypal' => array(
                    'experience_context' => array(
                        'payment_method_preference' => 'UNRESTRICTED',
                        'brand_name'                => '上一网页',
                        'landing_page'              => 'LOGIN',
                        'shipping_preference'       => 'NO_SHIPPING',
                        'user_action'               => 'PAY_NOW',
                        'return_url'                => $returnUrl,
                        'cancel_url'                => $cancelUrl
                    )
                )
            )
        ));

        return array(
            'id'     => $order['id'],
            'status' => $order['status'],
            'links'  => $order['links'],
        );
    }

    /**
     * @url https://developer.paypal.com/docs/api/orders/v2/#orders_capture
     * @return array
     */
    private function doCapture($orderId){
        return $this->httpPost(sprintf($this->captureUrl, $orderId), array(
            'Content-Type: application/json',
            'PayPal-Request-Id: ',
            'Authorization: '.$this->getAuthToken()
        ), '');
    }

    /**
     * @url https://developer.paypal.com/docs/api/orders/v2/#orders_get
     * @param $orderId
     * @return array(
     *     'id'=>'',
     *     'status'=>'',
     * )
     */
    private function getOrderDetail($orderId){
        return $this->httpGet(sprintf($this->getDetailUrl, $orderId), array('Authorization: '.$this->getAuthToken()));
    }

    private function buildPayUrl($orderId){
        return $this->payUrl.$orderId;
    }

    private function getAuthToken(){
        return 'basic' == $this->tokenType ? $this->getBasicToken() : $this->getBearerToken();
    }

    /**
     * 把paypal的clientId、secret转为Base64
     */
    private function getBasicToken(){
        $token = $this->clientId.':'.$this->secret;
        $token = str_replace('"', '', $token);
        return "Basic ".base64_encode($token);
    }

    /**
     * @url https://developer.paypal.com/api/rest/authentication/
     * @return string
     */
    private function getBearerToken(){
        $rsp = $this->httpPost($this->accessTokenUrl, array('Content-Type: application/x-www-form-urlencoded'), 'grant_type=client_credentials');
        $token = isset($rsp['access_token']) ? $rsp['access_token'] : '';
        return 'Bearer '.$token;
    }

    private function httpGet($url, $headers){
        return $this->httpPost($url, $headers, null, false);
    }

    private function httpPost($url, $headers, $data, $isPost = true){
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_POST, $isPost);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
        curl_setopt($ch, CURLOPT_USERPWD, $this->clientId.':'.$this->secret);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        if(!empty($data)){
            curl_setopt($ch, CURLOPT_POSTFIELDS, is_array($data) ? json_encode($data) : $data);
        }

        curl_setopt($ch, CURLOPT_HEADER, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $response = curl_exec($ch);

        if(curl_errno($ch)){
            //return 'Error POST'. curl_error($ch);
            return array();
        }
        curl_close($ch);
        return json_decode($response, true);
    }

}
```

## 4. 测试效果

```shell
php -S localhost:8080 paypal.php
```
访问链接 [http://localhost:8080](http://localhost:8080)，页面效果如下：
{% asset_img paypal-demo.png PayPal测试页 %}

点击支付按钮，效果如下：
{% asset_img paypal-demo-pay.png PayPal支付页 %}

# 五、参考资料

- [paypal-php-library](https://github.com/angelleye/paypal-php-library)
- [JAVA - Paypal 支付接入](https://zhuanlan.zhihu.com/p/357219845)
- [PayPal支付接口方式（checkout）集成](https://www.cnblogs.com/bl123/p/13865458.html)
- [Web 站点接入 PayPal CheckOut 支付](https://www.jianshu.com/p/17452df23edf)
- [PayPal-PHP-SDK（V1.7.4）支付接口实现](https://blog.51cto.com/u_16120231/6964368)
- [接入 paypal PHP-sdk 支付 / 回调 / 退款全流程](https://learnku.com/articles/26282)
- [PayPal-PHP-SDK Docs](https://paypal.github.io/PayPal-PHP-SDK)
- [PayPal-PHP-SDK](https://github.com/paypal/PayPal-PHP-SDK)
- [使用paypal-php-sdk开发php国际支付](https://blog.csdn.net/salley2017/article/details/119004829)
- [PayPal-PHP-SDK使用](https://blog.csdn.net/markely/article/details/79044145)
