package com.koreab2b.mro.buyer.mpso.controller;

import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoDelyReturnCowayService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoDlvryInfoService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderInfoService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.rfc.coway.controller.BuyerCowayRfcController;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.webservice.coway.Service1Soap;
import com.koreab2b.mro.webservice.coway.WebservicePropsBean;

@Controller("buyerMpSoDelyReturnCowayController")
public class BuyerMpSoDelyReturnCowayController {

	@Autowired
	private BuyerMpSoDelyReturnCowayService buyerMpSoDelyReturnCowayService;
	@Autowired
	private BuyerMpSoOrderInfoService buyerMpSoOrderInfoService;
	@Autowired
	private BuyerMpSoDlvryInfoService buyerMpSoDlvryInfoService;
	@Autowired
	private BuyerCowayRfcController buyerCowayRfcController;
	@Autowired
	private Service1Soap cowayService1SoapProxyid;
	@Autowired 
	WebservicePropsBean webservicePropsBean;
	// 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoDelyReturnCowayList.do", method = { RequestMethod.POST,
			RequestMethod.GET })
	public String getBuyerMpSoDelyReturnCowayList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode());
		pMap.put("st_dept", _sessionInfo.getDepartment());
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun"), "c_date"));
		pMap = CommonUtil.PagingPrc(pMap);
		pMap = CommonUtil.removeSlash(pMap);
		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		List<Map<String, String>> _data = buyerMpSoDelyReturnCowayService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		return "buyer/mpso/buyerMpSoDelyReturnCowayList";
	}

	/**
	 * 선택품목반납
	 * 
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/saveBuyerMpSoDelyReturnCowayList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpSoDelyReturnCowayList(@RequestParam Map<String, String> pMap,
			@RequestParam MultiValueMap<String, String> multiMap, HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String BUYER = _sessionInfo.getComCode();
		String USER_ID = _sessionInfo.getUserId();
		String DEPARTMENT = _sessionInfo.getDepartment();
		List<String> checkboxList = multiMap.get("st_checkbox");
		List<Map<String, String>> paramList = new ArrayList<Map<String, String>>();
		Map<String, String> paramMap = null;
		
		String PR_NO = buyerMpSoDelyReturnCowayService.getOrderNo(BUYER, "PR");
		
		for (String idx : checkboxList) {
			paramMap = new HashMap<String, String>();
			paramMap.put("st_buyer", multiMap.get("st_buyer").get(Integer.parseInt(idx)));
			paramMap.put("st_ref_pr_no", multiMap.get("st_ref_pr_no").get(Integer.parseInt(idx)));
			paramMap.put("st_gr_no", multiMap.get("st_gr_no").get(Integer.parseInt(idx)));
			paramMap.put("st_gr_seq", multiMap.get("st_gr_seq").get(Integer.parseInt(idx)));
			paramMap.put("st_lis_pr_no", multiMap.get("st_lis_pr_no").get(Integer.parseInt(idx)));
			paramMap.put("st_lis_pr_seq", multiMap.get("st_lis_pr_seq").get(Integer.parseInt(idx)));
			paramMap.put("st_return_remark", multiMap.get("st_return_remark").get(Integer.parseInt(idx)));

			paramMap.put("st_mg_note", multiMap.get("st_mg_note").get(Integer.parseInt(idx)));
			paramMap.put("st_buyer_item_no", multiMap.get("st_buyer_item_no").get(Integer.parseInt(idx)));
			paramMap.put("st_org_buyer_item_no", multiMap.get("st_org_buyer_item_no").get(Integer.parseInt(idx)));
			paramMap.put("st_target_qty", multiMap.get("st_target_qty").get(Integer.parseInt(idx)));
			paramMap.put("st_return_qty", multiMap.get("st_return_qty").get(Integer.parseInt(idx)));
			paramMap.put("st_req_user_id", multiMap.get("st_req_user_id").get(Integer.parseInt(idx)));

			paramMap.put("BUYER", BUYER);
			paramMap.put("USER_ID", USER_ID);
			paramMap.put("DEPARTMENT", DEPARTMENT);
			paramMap.put("PR_NO", PR_NO);
			paramMap.put("functionName", "ZMM_GSYS_REREQUEST_CHECK");
			paramMap.put("inTableName", "TI_IMPORT");
			paramList.add(paramMap);
		}

		paramMap = _getRfcProp(paramMap, req);
		Map<String, String> rtn = new HashMap<String, String>();
		rtn.putAll(buyerMpSoDelyReturnCowayService.setReturnPrIns(paramList));
		if("KRCOWA0003".equals(BUYER) || "KRCOWA0008".equals(BUYER))
			setCancelPoint(paramList, req);
		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("msg", rtn);
		return _response;
	}

	private void setCancelPoint(List<Map<String, String>> paramList, HttpServletRequest req) {
		String buyer = paramList.get(0).get("BUYER");
		String userId = paramList.get(0).get("USER_ID");
		String prNo = paramList.get(0).get("st_lis_pr_no");
		List<Map<String, String>> mgCodeList = buyerMpSoOrderInfoService.getCowayPointChk(buyer, prNo, userId);
		String prAmt = "";
		String cls = "";
		String legacyUserId = "";
//		String usePoint = "";
//		String usePointOK = "";
//		String result = "";
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
				}
				if(pointUseFlag){
					cancelPointRtn = cowayService1SoapProxyid.cancelPoint(prNo, prAmt, legacyUserId, webservicePropsBean.getWebServiceCon(req));
					cancelOk = cancelPointRtn.split(":");
					data.put("CANCEL_FLAG", "N");
					if (cancelOk.length > 0) {
						if (cancelOk[0].equals("OK"))
							buyerMpSoOrderInfoService.insertCowayPointHistory(data);
						else if ("ERROR".equals(cancelOk[0])) 
							TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
						prNo =  cancelOk[1];
					}
				}
			}
		} catch (RemoteException re) {
			re.printStackTrace();
		}
			
		
	}

	private Map<String, String> _getRfcProp(Map<String, String> paramMap, HttpServletRequest req) {
		return buyerCowayRfcController.getRfcPropAndConn(paramMap, req);
	}

//	public String setRfcDelyReturn(Map<String, String> paramMap, List<Map<String, String>> paramList) {
//		return buyerCowayRfcController.setRfc("ZMM_GSYS_REREQUEST_CHECK", "TI_IMPORT", "", paramMap, paramList);
//	}

//	/**
//	 * 지급요청한 문서번호 기준으로 요청상태 확인
//	 * 
//	 * @param pModel
//	 * @param req
//	 * @param pMap
//	 * @return
//	 */
//	@RequestMapping(value = "/mpso/cowayBuyerDelyReturnCheck.do", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> cowayBuyerDelyReturnCheck(ModelMap pModel, HttpServletRequest req,
//			@RequestParam MultiValueMap<String, String> multiMap, @RequestParam Map<String, String> pMap) {
//		List<String> checkboxList = multiMap.get("st_checkbox");
//		List<Map<String, String>> paramList = new ArrayList<Map<String, String>>();
//		Map<String, String> paramMap = null;
//		for (String idx : checkboxList) {
//			paramMap = new HashMap<String, String>();
//			paramMap.put("st_lis_pr_no", multiMap.get("st_lis_pr_no").get(Integer.parseInt(idx)));
//			paramMap.put("st_ref_pr_no", multiMap.get("st_ref_pr_no").get(Integer.parseInt(idx)));
//			paramMap.put("functionName", "ZMM_GSYS_REQ_STATUS_DISPLAY");
//			paramMap.put("tableName", "TE_EXPORT");
//			paramList.add(paramMap);
//		}
//		List<Map<String, String>> resultData = checkData(paramList);
//		Map<String, Object> rfcMsg = new HashMap<String, Object>();
//		Map<String, Object> _response = new HashMap<String, Object>();
//		_response.put("msg", (resultData.size() == 0 ? "Y" : "N"));
//		_response.put("rfcMsg", rfcMsg);
//		return _response;
//		return null;
//	}

	@SuppressWarnings("unused")
	private List<Map<String, String>> checkData(List<Map<String, String>> pList, HttpServletRequest req) {
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("I_MBLNR", "I_MBLNR");
		return buyerCowayRfcController.getRfc("ZMM_GSYS_REQ_STATUS_DISPLAY", "TE_EXPORT", paramMap, pList, req);
	}
}
