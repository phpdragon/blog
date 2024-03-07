---
title: Stripe支付接入
date: 2024-03-07 09:46:44
tags:
---

# 一、简述

&emsp;&emsp; Stripe 服务于全世界数百万家不同规模的公司，为他们实现线上线下支付共通，提供打款提现支持，促进财务流程自动化，从而助力企业增加收入。

# 二、Stripe的相关URL

正式网址：https://stripe.com
官方文档：https://docs.stripe.com/
官方API文档：https://stripe.com/docs/api
Stripe官方完整php案例：https://docs.stripe.com/payments/quickstart
Webhooks验证：https://dashboard.stripe.com/test/webhooks/create

# 三、Stripe集成步骤

1. 注册他们平台的账号[Sign Up and Create a Stripe Account | Stripe](https://dashboard.stripe.com/register)。
2. 然后得到私钥（注册账号，测试阶段可以不用去填写信息）, [获取测试秘钥](https://dashboard.stripe.com/test/apikeys)。
3. 设置事件通知地址，[添加端点](https://dashboard.stripe.com/test/webhooks/create)。
3. 获取测试银行卡号信息，[测试银行卡（按品牌）](https://docs.stripe.com/testing#cards)， [无效卡号信息](https://docs.stripe.com/payments/dashboard-payment-methods#testing)。
4. 访问支付链接，调用Stripe API来创建交易。
5. 进入Stripe支付页面，输入测试银行卡信息，完成交易。
6. 显示支付成功信息。

# 四、Stripe集成实现

## 1. 注册账号
在Stripe正式网站[https://www.stripe.com](https://dashboard.stripe.com/register)中注册一个账号。
{% asset_img website.png Stripe官网 %}

## 2. 进入开发者控制台
在开发者平台[https://dashboard.stripe.com](https://dashboard.stripe.com/login)，登录刚创建的账号, 进入控制台：
登录成功后，点击菜单: 开发人员API秘钥：
{% asset_img dashboard.png 控制台 %}

查看公钥和密钥。
{% asset_img stripe-key.png 开发人员API秘钥 %}

## 3. PHP示例代码

```php
<?php

$clientId = '你应用的ID';
$secretKey = '你应用的秘钥';

$action = 'action'.ucfirst(isset($_GET['action']) ? $_GET['action'] : 'index');
$paypal = new stripe($clientId, $secretKey);
$method = method_exists($paypal, $action) ? $action : 'actionIndex';
$paypal->$method();
exit;

class stripe{
    const  CREATE_PRD_URL = 'https://api.stripe.com/v1/products';
    const CREATE_PRICE_URL = 'https://api.stripe.com/v1/prices';
    const  CREATE_SESSION_URL = "https://api.stripe.com/v1/checkout/sessions";

    const STATUS_PAID = 'paid';
    const STATUS_UNPAID = 'unpaid';

    /**
     * App Client ID 和 SECRET
     */
    private $clientId = '';
    private $secret = '';

    private $siteUrl = '';
    private $successUrl = '';
    private $cancelUrl = '';

    public function __construct($clientId, $secret){
        $this->clientId = trim($clientId);
        $this->secret = trim($secret);

        $this->siteUrl = 'http://'.$_SERVER['HTTP_HOST']. $_SERVER['PHP_SELF'];
        $this->successUrl = $this->siteUrl.'?action=success&oid=';
        $this->cancelUrl = $this->siteUrl.'?action=cancel&oid=';
    }

    /**
     * 入口
     *
     * @return void
     */
    public function actionIndex(){
        echo  <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>付款页Demo</title>
</head>
<body>
<div>
    点击此链接： <a href="?action=pay">跳转Stripe支付</a>
</div>
</body>
</html>
HTML;
    }

    public function actionPay(){
        $orderId = date('YmdHis'); //当前系统的业务id

        $prd = $this->createPrd('测试商品');
        $price = $this->createPrdPrice($prd['id'], 50, 'usd');
        $session = $this->createSession($orderId, $price['id'], $this->successUrl.$orderId, $this->cancelUrl.$orderId);
        if(isset($session['error'])){
            exit('Stripe error：'.$session['error']['message']);
        }

        //通过cookie记下会话id
        setcookie('stripe_sid', $session['id'], time() + 3600);

        header('Location:'.$session['url']);
        exit;
    }

    /**
     * @notifyUrl http://localhost:8080/?action=cancel&oid=20240307105425
     * @return void
     */
    public function actionCancel(){
        $orderId = $_GET['oid'];

        //TODO: 通过cookie获取，真实业务根据tradeId关联查询到sessionId
        $sessionId = isset($_COOKIE['stripe_sid']) ? $_COOKIE['stripe_sid'] : '';
        if(empty($sessionId)){
            exit('error');
        }

        //TODO: 编写业务逻辑

        //获取支付结果
        $session = $this->getSessionDetail($sessionId);
        //订单未支付
        if(stripe::STATUS_UNPAID === $session['payment_status']){
            //TODO: 更新你的订单信息
        }

        //TODO: 调整到你想去的地址
        header('Location:'. $this->siteUrl . '?state=cancel&oid='.$orderId);
        exit;
    }

    /**
     * 处理stripe支付成功跳转
     *
     * @return void
     */
    public function actionSuccess(){
        $orderId = $_GET['oid'];

        //TODO: 通过cookie获取，真实业务根据tradeId关联查询到sessionId
        $sessionId = isset($_COOKIE['stripe_sid']) ? $_COOKIE['stripe_sid'] : '';
        if(empty($sessionId)){
            exit('error');
        }

        //TODO: 编写业务逻辑

        //获取支付结果
        $session = $this->getSessionDetail($sessionId);
        //订单已支付
        if(stripe::STATUS_PAID === $session['payment_status']){
            //TODO: 更新你的订单信息
        }

        //TODO: 调整到你想去的地址
        header('Location:'. $this->siteUrl . '?state=paid&oid='.$orderId);
        exit;
    }

    /**
     * 处理stripe事件通知
     * @url https://docs.stripe.com/webhooks#%E7%A4%BA%E4%BE%8B%E4%BA%8B%E4%BB%B6%E6%9C%89%E6%95%88%E8%B4%9F%E8%BD%BD
     * @url https://docs.stripe.com/webhooks?lang=php#%E7%94%A8%E5%AE%98%E6%96%B9%E5%BA%93%E9%AA%8C%E8%AF%81-webhook-%E7%AD%BE%E5%90%8D
     * @url https://docs.stripe.com/api/events/types#event_types-checkout.session.completed
     * @url https://docs.stripe.com/webhooks?lang=php#%E4%BF%AE%E5%A4%8D-http-%E7%8A%B6%E6%80%81%E4%BB%A3%E7%A0%81
     * @return void
     */
    public function actionEvent(){
        $json = file_get_contents('php://input');

        $sig_header = $_SERVER['HTTP_STRIPE_SIGNATURE'];

        //TODO: 完成鉴伪验证

        $event = json_decode($json, true);
        if(empty($event) || empty($event['object']) || 'event' != $event['object'] || !isset($event['data']['object'])){
            http_response_code(507);
            exit('ok');
        }

        //不是支付完成的事件都返回真
        if('checkout.session.completed' != $event['type']){
            http_response_code(200);
            exit('ok');
        }

        $eventData = $event['data']['object'];
        $orderId = $eventData['client_reference_id'];
        $tradeNo = $eventData['id'];

        $detail = $this->sdk->getSessionDetail($tradeNo);
        if(sdk_stripe::STATUS_PAID === $detail['payment_status']){

            //TODO: 更新本地订单信息

            http_response_code(200);
            exit('ok');
        }

        http_response_code(500);
        exit('Order status cannot be processed!');
    }

    /**
     * 创建产品
     *
     * @url https://stripe.com/docs/api/products/create
     * @return array
     */
    private function createPrd($prdName){
        return $this->httpPost(self::CREATE_PRD_URL, array(
            'name' => $prdName
        ));
    }

    /**
     * 创建产品价格
     *
     * @url https://stripe.com/docs/api/prices/create
     * @return array
     */
    private function createPrdPrice($pid, $amount, $currency){
        return $this->httpPost(self::CREATE_PRICE_URL, array(
            'product'     => $pid,
            'unit_amount' => (int)$amount,
            'currency'    => $currency
        ));
    }

    /**
     * 创建支付会话
     *
     * @url https://developer.paypal.com/docs/api/orders/v2/#orders_capture
     * @return array
     */
    private function createSession($orderId, $priceId, $successUrl, $cancelUrl){
        $order = $this->httpPost(self::CREATE_SESSION_URL, array(
            'client_reference_id' => $orderId,
            'line_items'          => array(
                array(
                    'price'    => $priceId,
                    'quantity' => 1,
                )
            ),
            'mode'                => 'payment',
            'success_url'         => $successUrl,
            'cancel_url'          => $cancelUrl,
            'metadata'            => array(
                'order_id' => $orderId,
            )
        ));
        return $order;
    }

    /**
     * 获取支付会话详情
     * @url https://docs.stripe.com/api/checkout/sessions
     * @param $sessionId
     * @return array|mixed
     */
    private function getSessionDetail($sessionId){
        return $this->httpGet(self::CREATE_SESSION_URL.'/'.$sessionId);
    }

    private function httpGet($url){
        return $this->httpPost($url, null, false);
    }

    private function httpPost($url, $data, $isPost = true){
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_POST, $isPost);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
        curl_setopt($ch, CURLOPT_USERPWD, $this->secret.':');
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/x-www-form-urlencoded'
        ));

        if(!empty($data)){
            curl_setopt($ch, CURLOPT_POSTFIELDS, is_array($data) ? http_build_query($data) : $data);
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
php -S localhost:8080 stripe.php
```
访问链接 [http://localhost:8080](http://localhost:8080)，页面效果如下：
{% asset_img stripe-demo.png Stripe测试页 %}

点击支付按钮，效果如下：
{% asset_img stripe-demo-pay.png Stripe支付页 %}

使用测试银行卡完成交易:

# 五、参考资料

- [Stripe PHP SDK](https://github.com/stripe/stripe-php)
- [Stripe 官方对接文档](https://docs.stripe.com/payments/quickstart)
- [stripe海外支付php教程](https://blog.csdn.net/Language453/article/details/108535840)
- [java 对接 stripe支付](https://blog.csdn.net/Japhet_jiu/article/details/129838657)
