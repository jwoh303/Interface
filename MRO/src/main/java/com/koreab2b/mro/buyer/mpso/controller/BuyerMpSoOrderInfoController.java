package com.koreab2b.mro.buyer.mpso.controller;

import java.io.IOException;
import java.io.OutputStream;
import java.rmi.RemoteException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.eclipse.jst.ws.util.JspUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoCartService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoExternalService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderInfoService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.rfc.coway.controller.BuyerCowayRfcController;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.webservice.coway.Service1Soap;
import com.koreab2b.mro.webservice.coway.WebservicePropsBean;

@Controller("buyerMpSoOrderInfoController")
public class BuyerMpSoOrderInfoController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoOrderInfoController.class);
	
	@Autowired
	private BuyerMpSoOrderInfoService buyerMpSoOrderInfoService;

	@Autowired
	private BuyerMpSoCartService buyerMpSoCartService;

	@Autowired
	private BuyerMpSoExternalService buyerMpSoExternalService;
	
	@Autowired
	private Service1Soap cowayService1SoapProxyid;
//	private Service1SoapProxy sampleService1SoapProxyid;
	
	@Autowired
	private BuyerCowayRfcController buyerCowayRfcController;
	
	@Autowired 
	WebservicePropsBean webservicePropsBean;

	// 조회 PG_06_B_008_00
	@RequestMapping(value = "/mpso/getBuyerMpSoOrderInfoList.do", method = RequestMethod.POST)
	public String getBuyerMpSoOrderInfoList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {
		pMap = CommonUtil.PagingPrc(pMap);
		List<Map<String, String>> _Hdata = null;
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId());
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("comCode", _sessionInfo.getComCode());
		pMap.put("byca_comorg_code", _sessionInfo.getBycaComorgCode());
		pMap.put("paging", "0");
		if (pMap.get("st_query_cart") == null) {
			pMap.put("st_query_cart", "");
		}

		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			List<Map<String, String>> _data = buyerMpSoOrderInfoService.getList_v2(pMap);
			pModel.addAttribute("data", CommonUtil.getListNvl(_data));

			return "buyer/mpso/buyerMpSoOrderInfoList_v2";
		}else{
			List<Map<String, String>> _data = buyerMpSoOrderInfoService.getList(pMap);
			String pre_goods_count = buyerMpSoOrderInfoService.getNotPreGoodsCompany(pMap);
			_Hdata = buyerMpSoCartService.getHongIkType(pMap);
			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			pModel.addAttribute("pre_goods_count", pre_goods_count);
			//선입고 장바구니 구분 값 추가. Y면 선입고 장바구니면 해당발주는 선입고 발주 필수 처리. 
			pModel.addAttribute("HdataPreGrFlag", CommonUtil.nvl(pMap.get("st_pre_gr_flag"),"N"));
			if (_Hdata == null) {
				pModel.addAttribute("Hdata", "");
			} else {
				pModel.addAttribute("Hdata", CommonUtil.nvl(_Hdata.get(0).get("FLAG"), "0"));
			}

			List<Map<String, String>> _HdataSheetType = buyerMpSoCartService.getHongIkSheetType(pMap);
			if (_Hdata == null) {
				pModel.addAttribute("HdataSheetType", "");
			} else {
				pModel.addAttribute("HdataSheetType", CommonUtil.nvl(_HdataSheetType.get(0).get("FLAG"), ""));
			}
			return "buyer/mpso/buyerMpSoOrderInfoList";
		}
	}
	
	@RequestMapping(value = "/mpso/excelBuyerMpSoOrderEndList_v2.do", method = RequestMethod.POST)
	public void excelBuyerMpSoOrderEndList_v2(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {

		// 조회일 슬래시 제거
		pMap = CommonUtil.xss_kep_filter(pMap);
		List<Map<String, String>> _data = null;
	   	
		String title = "";
		String headers = "";
		String docu_name = "주문품목.xls";
		
		_data = buyerMpSoOrderInfoService.getOrderInfo_v2(pMap);
		title = "주문요청번호|품목코드|품목명|단가|수량|합계|수령희망일|배송지명|배송지|인수자명";
		headers = "PR_NO|BUYER_ITEM_NO|DESCRIPTION_LOC|TARGET_PRICE|TARGET_QTY|TOT_PRICE|RD_DATE|DELY_TO_LOCATION_NAME|DELY_TO_LOCATION_TEXT|RECV_USER_NAME";
		
		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, docu_name);
	}
	
	@RequestMapping(value = "/mpso/buyerNewCreateGroupware.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerNewCreateGroupware(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("userid", _sessionInfo.getUserId());
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("comCode", _sessionInfo.getComCode());

		if (pMap.get("st_query_cart") == null) {
			pMap.put("st_query_cart", "");
		} else {
			LOGGER.debug(pMap.get("st_query_cart"));
		}
		
		Map<String, String> rMap	= buyerMpSoOrderInfoService.buyerNewCreateGroupware(pMap);

		_msg.put("LEGACY_USER_ID", rMap.get("LEGACY_USER_ID"));
		_msg.put("MSG", rMap.get("DOC_NO"));
		_response.put("msg", _msg);
		
		return _response;
	}

	/**
	 * buyerNewCreateBenit
	 * 
	 * @param pMap
	 * @return
	 * 
	 *         /kr/customer/shopping_cart/buyer_new_create_benit.jsp
	 */
	@RequestMapping(value = "/mpso/buyerNewCreateBenit.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerNewCreateBenit(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId());
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("comCode", _sessionInfo.getComCode());

		if (pMap.get("st_query_cart") == null) {
			pMap.put("st_query_cart", "");
		} else {
			LOGGER.debug(pMap.get("st_query_cart"));
		}

		String msg = buyerMpSoOrderInfoService.buyerNewCreateBenit(pMap);

		_msg.put("MSG", msg);
		_response.put("msg", _msg);
		return _response;
	}

	/**
	 * buyerNewCreateOrder
	 * 
	 * @param pMap
	 * @return
	 * 
	 *         /kr/customer/shopping_cart/buyer_new_create_order.jsp
	 */
	@RequestMapping(value = "/mpso/buyerNewCreateOrder.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerNewCreateOrder(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();
		String createOk = "";
		String msg = "";
		try {			
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			pMap.put("userid", _sessionInfo.getUserId());
			pMap.put("buyer", _sessionInfo.getComCode());
			pMap.put("comCode", _sessionInfo.getComCode());
			pMap.put("budget_flag", _sessionInfo.getBudgetFlag());
			pMap.put("st_user_dept", _sessionInfo.getDepartment());
			pMap.put("st_legacy_user_id", _sessionInfo.getEmpNo());
			
			// 서버 운용 모두 확인 ---- 2:운영 , 0:개발
			String st_server_mode	= "0";
			st_server_mode	= CommonUtil.getDevRealLocalFlag(req);
			pMap.put("st_server_mode", st_server_mode);
			
			String com_code = _sessionInfo.getComCode();
			if (pMap.get("st_po_create_date") == null) {
				pMap.put("st_po_create_date", "");
			}
			if (pMap.get("st_recv_date2") == null) {
				pMap.put("st_recv_date2", "");
			}

			// DI 사무용품 거래 구매사 적용
			if (com_code.equals("KRDAEW0043") || com_code.equals("KRDHIM0002")) {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
				Date po_date_type = formatter.parse(pMap.get("st_po_create_date").toString());
				Date recv_date_type = formatter.parse(pMap.get("st_recv_date2").toString());
				long gap_time = (po_date_type.getTime() - recv_date_type.getTime()) / 86400 / 1000;
				if (gap_time == 0) {
					pMap.put("st_recv_date2", CommonUtil.addDate(recv_date_type, "D", 5, 1));
				}
				if (gap_time > 0) {
					pMap.put("st_recv_date2", CommonUtil.addDate(recv_date_type, "D", 7, 1));
				}
				if (gap_time == -1 || gap_time == -2) {
					pMap.put("st_recv_date2", CommonUtil.addDate(recv_date_type, "D", 3, 1));
				}
			}
			if(pMap.get("ak_docu_no") != null && !"".equals(pMap.get("ak_docu_no"))) {		
				pMap.put("st_user_dept_name", _sessionInfo.getDepartmentName());
				LOGGER.info("##### buyerNewCreateOrder pMap :  "+ pMap );
				msg = buyerMpSoOrderInfoService.aekyApprPriceSend(pMap);				
			}else {
				msg = buyerMpSoOrderInfoService.buyerNewCreateOrder(pMap);
			}

			createOk = msg;
		} catch (Exception e) {
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("INTERFACE_ID", "ORDER");
			logMap.put("CONTENTS", "ORDERpMap"+ pMap + "buyerMsg : " + e.getMessage());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", "");
			
			buyerMpSoExternalService.saveLog(logMap);
			
			LOGGER.debug("buyerNewCreateOrder end " + e.getMessage());
			createOk	= "ERR:"+e.getMessage();
		}
		String[] sp = createOk.split(":");
		_msg.put("MSG", sp[0]);
		
		if (sp.length > 1) {
			for(int k = 1 ; k < sp.length ; k++) {
				_msg.put("ATTR"+k,sp[k]);
			}
		}
		if(sp.length>2){
			_msg.put("MSGTYPE", sp[1]);
			_msg.put("MESSAGE", sp[2]);
		}
		_response.put("msg", _msg);
		return _response;
	}
	
	@RequestMapping(value = "/mpso/buyerNewCreateOrder_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerNewCreateOrder_v2(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();
		String createOk = "";
		String msg = "";
		try {			
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			pMap.put("userid", _sessionInfo.getUserId());
			pMap.put("buyer", _sessionInfo.getComCode());
			pMap.put("comCode", _sessionInfo.getComCode());
			pMap.put("budget_flag", _sessionInfo.getBudgetFlag());
			pMap.put("st_user_dept", _sessionInfo.getDepartment());
			pMap.put("st_legacy_user_id", _sessionInfo.getEmpNo());
			
			// 서버 운용 모두 확인 ---- 2:운영 , 0:개발
			String st_server_mode	= "0";
			st_server_mode	= CommonUtil.getDevRealLocalFlag(req);
			pMap.put("st_server_mode", st_server_mode);
			
			String com_code = _sessionInfo.getComCode();
			if (pMap.get("st_po_create_date") == null) {
				pMap.put("st_po_create_date", "");
			}
			if (pMap.get("st_recv_date2") == null) {
				pMap.put("st_recv_date2", "");
			}

			// DI 사무용품 거래 구매사 적용
			if(pMap.get("ak_docu_no") != null && !"".equals(pMap.get("ak_docu_no"))) {		
				pMap.put("st_user_dept_name", _sessionInfo.getDepartmentName());
				LOGGER.info("##### buyerNewCreateOrder pMap :  "+ pMap );
				msg = buyerMpSoOrderInfoService.aekyApprPriceSend(pMap);				
			}else {
				pMap = CommonUtil.xss_kep_filter(pMap);
				msg = buyerMpSoOrderInfoService.buyerNewCreateOrder_v2(pMap);
			}

			createOk = msg;
		} catch (Exception e) {
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("INTERFACE_ID", "ORDER");
			logMap.put("CONTENTS", "ORDERpMap"+ pMap + "buyerMsg : " + e.getMessage());
			logMap.put("FLAG", "Y");
			logMap.put("ERROR_MSG", "");
			
			buyerMpSoExternalService.saveLog(logMap);
			
			LOGGER.debug("buyerNewCreateOrder end " + e.getMessage());
			createOk	= "ERR:"+e.getMessage();
		}
		String[] sp = createOk.split(":");
		_msg.put("MSG", sp[0]);
		
		if (sp.length > 1) {
			for(int k = 1 ; k < sp.length ; k++) {
				_msg.put("ATTR"+k,sp[k]);
			}
		}
		if(sp.length>2){
			_msg.put("MSGTYPE", sp[1]);
			_msg.put("MESSAGE", sp[2]);
		}
		_response.put("msg", _msg);
		return _response;
	}

	private String setCowayPoint(Map<String, String> pMap, String comCode, String prNo, HttpServletRequest req) {
		String userId = pMap.get("userid").toString();
		List<Map<String, String>> mgCodeList = buyerMpSoOrderInfoService.getCowayPointChk(comCode, prNo, userId);
		String prAmt = "";
		String cls = "";
		String legacyUserId = "";
		String usePoint = "";
		String usePointOK = "";
		String result = "";
		boolean pointUseFlag = false;
		String cancelPointRtn = "";
		String[] cancelOk = null;
		Map<String, Object> data = new HashMap<String, Object>();
		try {
			for (Map<String, String> map : mgCodeList) {
				prAmt = String.valueOf(map.get("PR_AMT"));
				cls = map.get("CLS");
				if ("O".equals(cls)) {
					legacyUserId = userId.substring(2);
					usePoint = String.valueOf(cowayService1SoapProxyid.usePoint(prNo, legacyUserId, "PRODNAME", prAmt, webservicePropsBean.getWebServiceCon(req)));
					String[] sp = null;
					sp = usePoint.split(":");
					if (sp.length > 0) {
						if ("OK".equals(sp[0])) {
							usePointOK = String.valueOf(cowayService1SoapProxyid.usePointOK(prAmt, prNo, webservicePropsBean.getWebServiceCon(req)));
							pointUseFlag = true;
							String[] spOk = null;
							spOk = usePointOK.split(":");
							if (spOk.length > 0) {
								if (spOk[0].equals("OK")) {
									data.put("COMPANY", comCode);
									data.put("KEY_1", prNo);
									data.put("CANCEL_FLAG", "N");

									buyerMpSoOrderInfoService.insertCowayPointHistory(data);

									result	= prNo;
								} else if ("ERROR".equals(spOk[0])) {
									result = sp[1];
								}
							}
						}
					}
				}
			}
		} catch (Exception e) {
			try {
				if(pointUseFlag){
					cancelPointRtn = cowayService1SoapProxyid.cancelPoint(prNo, prAmt, legacyUserId, webservicePropsBean.getWebServiceCon(req));
					cancelOk = cancelPointRtn.split(":");
					data.put("CANCEL_FLAG", "N");
					if (cancelOk.length > 0) {
						if (cancelOk[0].equals("OK"))
							buyerMpSoOrderInfoService.insertCowayPointHistory(data);
						else if ("ERROR".equals(cancelOk[0])) 
							TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
						result =  cancelOk[1];
					}
				}
			} catch (Exception re) {
				re.printStackTrace();
			}
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 코웨이 포인트 사용하는 고객사일 경우
	 * 
	 * @param pMap
	 * @return
	 * 
	 *         /kr/customer/shopping_cart/coway_buyer_admin_point_temp_check.jsp
	 */
	@RequestMapping(value = "/mpso/cowayBuyerAdminPointTempCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cowayBuyerAdminPointTempCheck(@RequestParam Map<String, String> pMap,
			HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();
		String totPrice = pMap.get("tot_price");
		String recvFlag = pMap.get("recvFlag");
		String legacy_user_id = _sessionInfo.getUserId().substring(2);
		int price = 0;
		int point = 0;
		price = Integer.parseInt(totPrice);
		String getPoint13mtemp = "";
		try {
			getPoint13mtemp = cowayService1SoapProxyid.getPoint(legacy_user_id, webservicePropsBean.getWebServiceCon(req)); 
		} catch (RemoteException e) {
			e.printStackTrace();
		}
		String val = JspUtils.markup(String.valueOf(getPoint13mtemp));
		String[] sp = val.split(":");
		if (sp.length > 0) {
			if (sp[0].equals("OK") && !sp[1].equals("")) {
				point = Integer.parseInt(sp[1]);
				if (point - price > 0) {
					_msg.put("STATUS", "OK");
					_msg.put("RESULT", sp[1]);
					_msg.put("OUT", "Point:" + sp[1]);

				} else {
					_msg.put("STATUS", "ERROR");
					_msg.put("RESULT", "포인트가 부족합니다.");

				}
			} else {
				_msg.put("OUT", "Point:0");
				_msg.put("STATUS", "ERROR");
				_msg.put("RESULT", "0");
			}
		}
		_msg.put("MSG", "WEBSERVICE");
		_msg.put("RECV_FLAG", recvFlag);
		_response.put("msg", _msg);
		return _response;
	}

	/**
	 * newBuyerCommonPassbiz
	 * 
	 * @param pMap
	 * @return
	 * 
	 *         /kr/customer/common/popup/pop_pass/new_buyer_common_passbiz.jsp
	 */
	@RequestMapping(value = "/mpso/newBuyerCommonPassbiz.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> newBuyerCommonPassbiz(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, String> _map = new HashMap<String, String>();
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();
		String checkpass = "";
		String pass_flag = "N";
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId());
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("comCode", _sessionInfo.getComCode());
		List<Map<String, String>> _data = buyerMpSoOrderInfoService.getCompanyPassflag(pMap);
		if (_data != null) {
			if (_data.size() > 0) {
				_map = _data.get(0);
				pass_flag = _map.get("PASS_FLAG").toString();
			}
		}
		String cnt = "0";
		cnt = buyerMpSoOrderInfoService.getPassCheck(pMap);
		if ("0".equals(cnt)) {
			checkpass = "false";
		} else {
			checkpass = "true";
		}
		_msg.put("PASS_FLAG", pass_flag);
		_msg.put("CHECKPASS", checkpass);
		_response.put("msg", _msg);
		return _response;
	}

	/**
	 * adminBuyerMasterPrCreateMailReg
	 * 
	 * @param pMap
	 * @return
	 * 
	 *         /kr/customer/shopping_cart/admin_buyer_master_pr_create_mail_reg.jsp
	 */
	@RequestMapping(value = "/mpso/adminBuyerMasterPrCreateMailReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> adminBuyerMasterPrCreateMailReg(@RequestParam Map<String, String> pMap,
			HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId());
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("comCode", _sessionInfo.getComCode());

		String buyer = _sessionInfo.getComCode();
		String byca_comorg_code = pMap.get("st_byca_comorg_code").toString();

		StringBuilder mail_recv = new StringBuilder();

		if (buyer.equals("KRDONG0154")) // 동부한농화학 (주)상토공장
		{
			mail_recv.append("DBHN" + "##");
			mail_recv.append("KIMBH" + "##");
			mail_recv.append("KEP200057" + "##");
			mail_recv.append("KEP200032" + "##");
			mail_recv.append("KEP200033" + "##");

		} else if (buyer.equals("KRDONG0153")) // 동부한농화학 (주) 제주공장
		{
			mail_recv.append("CCLIM" + "##");
			mail_recv.append("KEP200057" + "##");
			mail_recv.append("KEP200032" + "##");
			mail_recv.append("KEP200033" + "##");

		} else if (buyer.equals("KRDONG0099")) // 동부한농화학(주)비료공장
		{
			mail_recv.append("LSI8767" + "##");
			mail_recv.append("KEP200057" + "##");
			mail_recv.append("KEP200032" + "##");
			mail_recv.append("KEP200033" + "##");
		}

		if (byca_comorg_code.equals("KRDONGG004")) {
			mail_recv.append("CSPARK" + "##");
			mail_recv.append("JOUNG1" + "##");
			mail_recv.append("GKSRKDL" + "##");
			mail_recv.append("CHJANG537" + "##");
			mail_recv.append("CC8587" + "##");
			mail_recv.append("JHLEE2" + "##");
			mail_recv.append("HYPARK" + "##");
			mail_recv.append("CT15TH" + "##");
			mail_recv.append("CSKANG" + "##");
			mail_recv.append("YJH0001" + "##");
			mail_recv.append("BSSHIN" + "##");
			mail_recv.append("NAYK" + "##");
			mail_recv.append("INJI0" + "##");
			mail_recv.append("YSB" + "##");
			mail_recv.append("KEP200057" + "##");
			mail_recv.append("KEP200032" + "##");
			mail_recv.append("KEP200033" + "##");
		}

		// 특수로직 P06-0000045
		if (buyer.equals("KRDONG0107") || buyer.equals("KRDONG0128")) {
			LOGGER.debug("특수로직 P06-0000045 ");
		}

		pMap.put("mail_recv", mail_recv.toString());

		String msg = "false";
		msg = buyerMpSoOrderInfoService.adminBuyerMasterPrCreateMailReg(pMap);

		String createOk = msg;
		_msg.put("MSG", createOk);
		_response.put("msg", _msg);
		return _response;
	}

	/**
	 * cowayBuyerAdminBdgtTempCheck
	 * 
	 * @param pMap
	 * @return
	 * 
	 *         /kr/customer/proxybuy/bdgt/coway_buyer_admin_bdgt_temp_check.jsp
	 */
	@RequestMapping(value = "/mpso/cowayBuyerAdminBdgtTempCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cowayBuyerAdminBdgtTempCheck(@RequestParam Map<String, String> pMap,
			HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId());
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("comCode", _sessionInfo.getComCode());
		if (pMap.get("st_query_cart") == null) {
			pMap.put("st_query_cart", "");
		}
		List<Map<String, String>> _data = buyerMpSoOrderInfoService.cowayBuyerAdminBdgtTempCheck(pMap);
		_response.put("data", _data);
		return _response;
	}

	/**
	 * buyerAdminBdgtTempCheck
	 * 
	 * @param pMap
	 * @return
	 * 
	 *         /kr/customer/proxybuy/bdgt/buyer_admin_bdgt_temp_check.jsp
	 *         /kr/coway_buyer/proxybuy/bdgt/buyer_admin_bdgt_temp_check.jsp
	 */
	@RequestMapping(value = "/mpso/buyerAdminBdgtTempCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerAdminBdgtTempCheck(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId());
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("comCode", _sessionInfo.getComCode());

		if (pMap.get("st_query_cart") == null) {
			pMap.put("st_query_cart", "");
		} else {
			LOGGER.debug(pMap.get("st_query_cart"));
		}

		List<Map<String, String>> _data = buyerMpSoOrderInfoService.buyerAdminBdgtTempCheck(pMap);
		_response.put("data", _data);
		return _response;
	}

	/**
	 * 재구매 예산 체크 -- 사용안함 /mppo/buyerAdminBdgtTempOrderCheck.do 를 같이 사용합니다. buyerAdminBdgtTempOrderCheck
	 * 
	 * @param pMap
	 * @return
	 * 
	 *         /kr/customer/proxybuy/bdgt/buyer_admin_bdgt_temp_order_check.jsp?
	 */
	@RequestMapping(value = "/mpso/buyerAdminBdgtTempOrderCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerAdminBdgtTempOrderCheck(@RequestParam Map<String, String> pMap,
			HttpServletRequest req) {

		return null;
	}

	/**
	 * 
	 * 재구매 buyerNewReCreateOrder
	 * 
	 * @param pMap
	 * @return
	 * 
	 *         /kr/customer/shopping_cart/buyer_new_recreate_order.jsp
	 */
	@RequestMapping(value = "/mpso/buyerNewReCreateOrder.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerNewReCreateOrder(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();
		String createOk = "";

		try {

			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			pMap.put("userid", _sessionInfo.getUserId());
			pMap.put("buyer", _sessionInfo.getComCode());
			pMap.put("comCode", _sessionInfo.getComCode());
			pMap.put("budget_flag", _sessionInfo.getBudgetFlag());
			pMap.put("st_user_dept", _sessionInfo.getDepartment());
			pMap.put("st_tel_no", _sessionInfo.getTel());
			pMap.put("st_user_name", _sessionInfo.getUserNameLoc());

			String msg = buyerMpSoOrderInfoService.buyerNewReCreateOrder(pMap);
			createOk = msg;

		} catch (Exception e) {
			LOGGER.debug("buyerNewCreateOrder end ");
		}

		_msg.put("MSG", createOk);
		_response.put("msg", _msg);
		return _response;
	}
	
	@SuppressWarnings("unused")
	private Map<String, String> _getRfcProp(Map<String, String> paramMap, HttpServletRequest req) {
		return buyerCowayRfcController.getRfcPropAndConn(paramMap, req);
	}
	
	
	/**
	 * 
	 * 큐라티스
	 * 
	 * @param pMap
	 * @return
	 * 
	 *         /kr/customer/shopping_cart/buyer_new_recreate_order.jsp
	 */
	@RequestMapping(value = "/mpso/QuratisGetContents.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String QuratisGetContents(ModelMap pModel, HttpServletRequest req,@RequestParam Map<String, String> pMap) throws IOException {
		
		List<Map<String, String>> _data = new ArrayList<Map<String, String>>();
		Map<String,String> iMap = new HashMap<String,String>();
//		System.out.println("pMap : " + pMap);
		
		_data = buyerMpSoOrderInfoService.getQuratisGetContents(pMap);
		
		pModel.addAttribute("qura_data", _data);

		return "buyer/mpso/buyerMpSoQuratis";
	}

	/**
	 * 큐라티스-bizbox 결재본문 조회.
	 *  : 본문을 구성할 데이터를 조회하고, 구성 프로그램 (buyerMpSoQuratis_bizbox.jsp) 을 호출한다.
	 * @param pModel
	 * @param req
	 * @param pMap
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "/mpso/QuratisGetContents_bizbox.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String QuratisGetContents_bizbox(ModelMap pModel, HttpServletRequest req,@RequestParam Map<String, String> pMap) throws IOException {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String empNo = _sessionInfo.getEmpNo();
		List<Map<String, String>> _data = new ArrayList<Map<String, String>>();
		_data = buyerMpSoOrderInfoService.getQuratisGetContents(pMap);
		pModel.addAttribute("qura_data", _data);
		return "buyer/mpso/buyerMpSoQuratis_bizbox";
	}
	
	/**
	 * 
	 * 홍익대학교
	 * 
	 * @param pMap
	 * @return
	 * 
	 */
	@RequestMapping(value = "/mpso/HongikGetContents.do", method =  {RequestMethod.GET, RequestMethod.POST})
	public String HongikGetContents(ModelMap pModel, HttpServletRequest req,@RequestParam Map<String, String> pMap) throws IOException {
		
		List<Map<String, String>> _data = new ArrayList<Map<String, String>>();
		Map<String,String> iMap = new HashMap<String,String>();
		
		_data = buyerMpSoOrderInfoService.getHongikGetContents(pMap);
		
		pModel.addAttribute("H_data", _data);
		
//		System.out.println("Hongik pMap : " + pMap);
//		System.out.println("Hongik _data : " + _data);
		
		return "buyer/mpso/buyerMpSoHongik";
	}

	public String AES128_Encode(String str, String Key) throws Exception {
		byte[] keyData = Key.getBytes();
		SecretKey secureKey = new SecretKeySpec(keyData, "AES");
		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.ENCRYPT_MODE, secureKey, new IvParameterSpec(Key.getBytes()));
		byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
		String enStr = new String(Base64.encodeBase64(encrypted));
		return enStr;
	}
	
	
	/**
	 * 엔씨켐 
	 *  :결재 상신 시, 결재 항목을 저장 한다.
	 * @param pModel
	 * @param req
	 * @param pMap
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "/mpso/buyerApItemType.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerApItemType(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("buyer", _sessionInfo.getComCode());
		
		String msg = buyerMpSoOrderInfoService.updateBuyerApItemType(pMap);
		
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	

}
