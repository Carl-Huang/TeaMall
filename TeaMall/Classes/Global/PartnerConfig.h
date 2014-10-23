//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088611289729353"
//收款支付宝账号
#define SellerID  @"2014053497@qq.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"3d6h06sk0psgqovuxntp3en8acdbqjht"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAJapko7+5r1s2ELdN71UMFFp8rTrm4r5yjJM+aaaygdPI3YOp5tliYHg1zdazxU6Xef/tdDZAzD4/tCEmZdAXb1z0vHk3VI79C0GIVTi4371tIhUiuuKMcXOIP5XUs7n339kbRjGUk/8kKrwm4d4XeJ65U0PWzA3zxGL9YcA2fajAgMBAAECgYALlFrkTKkVVAFHGlOHZKoWB8uUpisdQleNCCeD64+tgiKal0PAiMxJxCsmYP9bhVHkW93wgE1jfS+wfRCE9Hh/0e53yOF8kc1ZjXUvLjhvG/EsiKJJGbiXWk8KUs1Vk5mFj7GAjR0liNRW7l/PDBlvhNc5GRP6ZGOV+KFcgZUbwQJBAMgScpqNr2tKNm3F3hlyGQmm4QNC2h6SuIsKmPZiMFkrDQoZEErQGST3rcGWQVQ40Fyk7e5aLMvY43fBLVRoyWECQQDAx0VvWRD8lHJccwOMbEyKtg9QHysWDKzarNp8JeoVyjDuegl3tlOcFtdVm/IIRM3mAKQ778+dDwO7S+z20SqDAkAugBsi0Mt0pEsCOHrmbx5in+asW11WvcMmjc//c9LI5rihIDIpMTSm4un/lGyappnG7o5eV5cRydcUflGKzNABAkBuuka0pTjviyiA14MjRhVU2yvCfpSV7qPeWsiH5JMm/uLKJ4iGnVA66Je40YDcpQCK6rVqw9zBPp2LGBo8znmXAkAk6Q+8E7w7TG2p8ZtqqcC1uZrAGImBsu8ugFmQ+7NYyHsxSKSdgGymUr785/2vSueUc3JqI5UGtFkCyjN9b1xL"


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCWqZKO/ua9bNhC3Te9VDBRafK065uK+coyTPmmmsoHTyN2DqebZYmB4Nc3Ws8VOl3n/7XQ2QMw+P7QhJmXQF29c9Lx5N1SO/QtBiFU4uN+9bSIVIrrijHFziD+V1LO599/ZG0YxlJP/JCq8JuHeF3ieuVND1swN88Ri/WHANn2owIDAQAB"

#endif
