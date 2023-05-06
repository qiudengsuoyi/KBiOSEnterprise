//
//  RPSAPIConst.m
//  ReservedParkingSpace
//
//  Created by Administrator on 2019/1/15.
//  Copyright © 2019 yunqwi. All rights reserved.
//

#import "APIConst.h"

#ifdef DEBUG
//RPSSERVER_API const ENTERPRISE_SERVER_HOST = @"https://www.einstall.cn/";
RPSSERVER_API const ENTERPRISE_SERVER_HOST = @"http://www.einstall.cn:8036/";
RPSSERVER_API const ENTERPRISE_SERVER_OTHER_HOST = @"http://39.98.52.205:8001/";

#else
//RPSSERVER_API const SERVER_HOST = @"https://www.einstall.cn/";
RPSSERVER_API const ENTERPRISE_SERVER_HOST = @"https://www.einstall.cn/";
RPSSERVER_API const ENTERPRISE_SERVER_OTHER_HOST = @"http://39.98.52.205:8001/";
#endif
RPSSERVER_API const ENTERPRISE_CONST_PROTOCOL_URL = @"http://www.einstall.cn/interface_Einstall/law.asp";
RPSSERVER_API const ENTERPRISE_CONST_PROTOCOL_01_URL= @"http://www.einstall.cn/Interface_Einstall/law1.asp";
RPSSERVER_API const ENTERPRISE_USERID = @"userID";
RPSSERVER_API const ENTERPRISE_PARENTID = @"parentID";
RPSSERVER_API const ENTERPRISE_BROWSETYPE = @"browseType";
RPSSERVER_API const STRTELPHONE = @"4008321696";
//微信支付
RPSSERVER_API const WE_CHAT_APPID = @"wx89acf4edb3f0f38b";
RPSSERVER_API const UNIVERSAL_LINK = @"https://www.einstall.net/einstallcompany/";


RPSSERVER_API const ENTERPRISE_LOGIN_URL = @"Interface_Einstall/logincheck1.asp";
RPSSERVER_API const ENTERPRISE_REGISTER_CODE_URL = @"Interface_Einstall/code.asp";
RPSSERVER_API const ENTERPRISE_REGISTER_URL = @"Interface_Einstall/register1.asp";
RPSSERVER_API const ENTERPRISE_MAIN_NUM_URL = @"Interface_Einstall/mainview1.asp";
RPSSERVER_API const ENTERPRISE_PERSON_URL = @"Interface_Einstall/personaldata1.asp";
RPSSERVER_API const ENTERPRISE_WAIT_ORDER_LIST_URL = @"Interface_Einstall/myAssignOrder.asp";
RPSSERVER_API const WAIT_ORDER_DETAIL_URL = @"Interface_Einstall/myAssignOrderDetail.asp";
RPSSERVER_API const WAIT_ORDER_ITEM_DETAIL_URL = @"Interface_Einstall/myAssignOrderTaskDetail.asp";
RPSSERVER_API const INSRTALL_ORDER_ITEM_DETAIL_URL = @"Interface_Einstall/orderTaskUnfinishedDetail1.asp";
RPSSERVER_API const WAIT_ORDER_ACCEPT_URL = @"Interface_Einstall/ordercheck.asp";
RPSSERVER_API const ORDER_PICTURE_URL = @"Interface_Einstall/orderPicture.asp";
RPSSERVER_API const NOTICE_LIST_URL = @"Interface_Einstall/NoticeList.asp";
RPSSERVER_API const WALLET_NO_PAY_LIST_URL = @"Interface_Einstall/UnpaidOrder.asp";
RPSSERVER_API const UPLOAD_PICTURE_URL = @"Interface_Einstall/uppic1.asp";
RPSSERVER_API const INSTALL_ORDER_LIST_URL = @"Interface_Einstall/orderUnfinishedDetail2.asp";
RPSSERVER_API const GRAB_ORDER_LIST_URL = @"Interface_Einstall/orderUnfinishedDetail.asp";
RPSSERVER_API const RELEASE_SUBMIT_URL = @"Interface_Einstall/orderreleasesubmit.asp";
RPSSERVER_API const RELEASE_PERSON_URL = @"Interface_Einstall/FastOrderDefault.asp";
RPSSERVER_API const WALLET_TRIAL_URL = @"Interface_Einstall/Unpaidapply.asp";
RPSSERVER_API const WALLET_HAVE_PAY_URL = @"Interface_Einstall/Paidapply.asp";
RPSSERVER_API const MODIFY_PASSWORD_URL = @"Interface_Einstall/ChangePassword1.asp";
RPSSERVER_API const APPLY_PAY_URL = @"Interface_Einstall/PaymentApply.asp";
RPSSERVER_API const PAY_RATE_URL = @"Interface_Einstall/serverproportion.asp";
RPSSERVER_API const WITHDRAW_URL = @"Interface_Einstall/UnpaidApplySumbit.asp";
RPSSERVER_API const EDIT_PERSON_MODIFY_URL = @"Interface_Einstall/personaldatachange1.asp";
RPSSERVER_API const APPLY_PAY_DETAIL_URL = @"Interface_Einstall/UnpaidApplyorder.asp";
RPSSERVER_API const INSTALL_ORDER_STATISTIC_LIST_URL = @"Interface_Einstall/brand.asp";
RPSSERVER_API const BRAND_LIST_URL = @"Interface_Einstall/BrandProject.asp";
RPSSERVER_API const BRAND_LIST_DETAIL_URL = @"Interface_Einstall/orderUnfinishedDetail1.asp";
RPSSERVER_API const RELEASE_LIST_URL = @"Interface_Einstall/FastOrderList1.asp";
RPSSERVER_API const INSTALL_TYPE_URL = @"Interface_Einstall/installTypeSelect.asp";
RPSSERVER_API const RELEASE_ITEM_LIST_URL = @"Interface_Einstall/FastOrderApplyList1.asp";
RPSSERVER_API const RELEASE_CANCEL_URL = @"Interface_Einstall/FastOrderCancelSubmit.asp";
RPSSERVER_API const RELEASE_CONFIRM_MASTER_URL = @"Interface_Einstall/FastOrderAssignSubmit.asp";
RPSSERVER_API const ADDRESS_URL = @"Interface_Einstall/city.asp";
RPSSERVER_API const PAY_URL = @"wechatpay/src/pay.php";
RPSSERVER_API const ORDER_INFO_URL = @"interface_Einstall/FastOrderPey.asp";
RPSSERVER_API const ORDER_EDIT_INFO_URL = @"Interface_Einstall/FastOrderView.asp";
RPSSERVER_API const ORDER_EDIT_SUBMIT_URL = @"Interface_Einstall/FastOrdermodify.asp";

RPSSERVER_API const ORDER_MESSAGE_URL = @"Interface_Einstall/FastOrderSms.asp";
RPSSERVER_API const ORDER_MESSAGE_INFO_URL = @"interface_Einstall/smsType.asp";
RPSSERVER_API const PASSWORD_INFO_URL = @"interface_Einstall/password1view.asp";
RPSSERVER_API const CASE_LIST_URL = @"interface_Einstall/CompleteProjectList.asp";
RPSSERVER_API const ADD_COMPLAIN_URL = @"interface_Einstall/ComplaintSubmit.asp";
RPSSERVER_API const MODIFY_COMPLAIN_URL = @"interface_Einstall/ComplaintModify.asp";
