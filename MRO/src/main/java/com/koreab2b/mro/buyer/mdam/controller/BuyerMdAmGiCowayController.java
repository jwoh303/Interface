package com.koreab2b.mro.buyer.mdam.controller;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmGiCowayService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.rfc.coway.controller.BuyerCowayRfcController;

@Controller("buyerMdAmGiCowayController")
public class BuyerMdAmGiCowayController {

	@Autowired
	private BuyerCowayRfcController buyerCowayRfcController;
	@Autowired
	private BuyerMdAmGiCowayService buyerMdAmGiCowayService;

	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmGiCowayList.do", method = { RequestMethod.POST, RequestMethod.GET })
	public String getBuyerMdAmGiCowayList(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		String st_mblnr_list	= "";
		
		pMap = CommonUtil.PagingPrc(pMap);
		
		String screen_id	= pMap.get("st_screen_id");
		String I_RESTATUS	= pMap.get("I_RESTATUS");

		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		List<Map<String, String>> _data = getList(formData, req);
		
		if ("N".equals(I_RESTATUS)) {

			for( int i = 0 ; i < _data.size() ; i++ ) {
				st_mblnr_list	= _data.get(i).get("MBLNR") + "@@" + st_mblnr_list;
			}
			pModel.addAttribute("st_mblnr_list",st_mblnr_list);
			
			pMap.put("", "");
		}
		
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		return "buyer/mdam/buyerMdAmGiCowayList";
	}

	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmGiCowayDetailPop.do", method = { RequestMethod.POST, RequestMethod.GET })
	public String getBuyerMdAmGiCowayDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, String> resultMap = new HashMap<String, String>();
		
		pMap.put("SCREEN_ID", "1");
		
		resultMap	= buyerMdAmGiCowayService.getGiDetailInfo(pMap);
		
		List<Map<String, String>> reqUserInfo = buyerMdAmGiCowayService.getReqUserInfo(resultMap);
		resultMap.put("ADD_USER_ID", reqUserInfo.get(0).get("ADD_USER_ID"));
		List<Map<String, String>> recvUserInfo = buyerMdAmGiCowayService.getRecvUserInfo(resultMap);
		List<Map<String, String>> passUserInfo = new ArrayList<Map<String, String>>();
		passUserInfo = buyerMdAmGiCowayService.getPassUserInfo(resultMap);
		pModel.addAttribute("reqUserInfo", reqUserInfo.get(0));
		pModel.addAttribute("recvUserInfo", recvUserInfo.get(0));
		if (passUserInfo.size() == 0) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("PASS_TP", "");
			map.put("USER_NAME_LOC", recvUserInfo.get(0).get("USER_NAME_LOC"));
			map.put("MOBILE_PHONE", recvUserInfo.get(0).get("MOBILE_PHONE"));
			map.put("EMAIL", recvUserInfo.get(0).get("EMAIL"));
			map.put("PASS_DATE", "");
			passUserInfo.add(map);
		}
		pModel.addAttribute("passUserInfo", CommonUtil.getListNvl(passUserInfo));
		passUserInfo.clear();
		resultMap.put("PASS_TP", "1");
		passUserInfo = buyerMdAmGiCowayService.getPassUserInfo(resultMap);
		pModel.addAttribute("passUserInfo1", CommonUtil.getListNvl(passUserInfo));
		passUserInfo.clear();
		resultMap.put("PASS_TP", "2");
		passUserInfo = buyerMdAmGiCowayService.getPassUserInfo(resultMap);
		pModel.addAttribute("passUserInfo2", CommonUtil.getListNvl(passUserInfo));;
		List<Map<String, String>> itemInfo = buyerMdAmGiCowayService.getPrDetail(resultMap);
		pModel.addAttribute("itemInfo", CommonUtil.getListNvl(itemInfo));
		pModel.addAllAttributes(resultMap);
		return "buyer/mdam/buyerMdAmGiCowayDetailPop";
	}

	/**
	 * ZmmGsysDeRerDisplay
	 * 
	 * @param pMap
	 * @return
	 */
	private List<Map<String, String>> getList(Map<String, String> pMap, HttpServletRequest req) {
		String curDate = CommonUtil.getCurrentDay_Time("yyyyMMdd");
		String fromDate = "";
		String toDate = "";
		fromDate = pMap.get("st_from_date");
		if (fromDate.equals("")) {
			toDate = curDate;
			fromDate = CommonUtil.addDate(new Date(), "M", -1, 1);
		} else {
			toDate = pMap.get("st_to_date");
		}
		/**
		 * 조직명
		 */
		String ST_ORGEH = pMap.get("I_ORGEH");
		/**
		 * 처리상태(Y:완료, N:미처리, A:전체, F:반려)
		 */
		String ST_RESTATUS = pMap.get("I_RESTATUS");
		if ("".equals(ST_RESTATUS)) {
			ST_RESTATUS = "N";
		}
		/**
		 * 출고:D , 반납:R
		 */
		String ST_KEY = pMap.get("I_KEY");
		if ("".equals(ST_KEY)) {
			ST_KEY = "D";
		}
		/**
		 * 요청번호
		 */
		String ST_RE_MBLNR = pMap.get("I_RE_MBLNR");	// 요청코드번호(출고)/반납요청코드(반납)
		String i_key = ST_KEY;
		String i_stext = ST_ORGEH;
		String i_orgeh = "";
		String i_re_mblnr = ST_RE_MBLNR;
		String i_budat_from = fromDate;
		String i_budat_to = toDate;
		String i_restatus = ST_RESTATUS;
		String i_gubun = "N";	// 조회구분(S:스팀기, N: 일반)
		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		Map<String, String> paramMap = new HashMap<String, String>();

		paramMap.put("i_key", i_key);
		paramMap.put("i_stext", i_stext);
		paramMap.put("i_orgeh", i_orgeh);
		paramMap.put("i_re_mblnr", i_re_mblnr);
		paramMap.put("i_budat_from", i_budat_from);
		paramMap.put("i_budat_to", i_budat_to);
		paramMap.put("i_restatus", i_restatus);
		paramMap.put("i_gubun", i_gubun);
		resultList = buyerCowayRfcController.getRfc("ZMM_GSYS_DE_RER_DISPLAY", "", "TE_EXPORT", paramMap, req);
		
		buyerMdAmGiCowayService.delGsysDeliveryDispaly(pMap);
		
		for( int i = 0 ; i < resultList.size() ; i++) {
			resultList.get(i).put("SCREEN_ID", pMap.get("st_screen_id"));
			resultList.get(i).put("USER_ID", pMap.get("st_user_id"));
		}
		
		if(resultList.size() > 0) {
			buyerMdAmGiCowayService.setGsysDeliveryDispalyBatch(resultList);
			buyerMdAmGiCowayService.setGsysDeliveryDispalyPrInfo(pMap);
		}
		
		List<Map<String, String>> _data	= buyerMdAmGiCowayService.getGsysDeliveryDispaly(pMap);
		
		return _data;
	}

	/**
	 * 출고확정
	 * @param pModel
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdam/saveBuyerMdAmGiCowayList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdAmGiCowayList(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {
		Map<String, String> rtn = new HashMap<String, String>();
		rtn.putAll(setGiReg(pMap, req));
		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("rfcMsg", rtn);
		return _response;
	}

	private Map<String, String> setGiReg(Map<String, String> pMap, HttpServletRequest req) {
		String I_KEY = String.valueOf(pMap.get("st_key"));
		String I_MBLNRS = String.valueOf(pMap.get("st_mblnr"));
		String I_DEL_RE = "";
		String I_AENAM = "20002099";
		if (I_KEY.equals("D"))
			I_DEL_RE = "1";
		else if (I_KEY.equals("R"))
			I_DEL_RE = "2";
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("I_KEY", I_KEY);
		paramMap.put("I_MBLNRS", I_MBLNRS);
		paramMap.put("I_DEL_RE", I_DEL_RE);
		paramMap.put("I_AENAM", I_AENAM);
		return buyerCowayRfcController.setRfc("ZMM_GSYS_DE_RE_CHECK", "TI_IMPORT", "TE_EXPORT", paramMap, req);
	}

	/**
	 * EXCEL 다운로드
	 * 
	 * @param pModel
	 * @param pMap
	 * @param response
	 * @param outputStream
	 */
	@RequestMapping(value = "/mdam/excelBuyerMdAmGiCowayList.do", method = RequestMethod.POST)
	public void excelBuyerMdAmGiCowayList(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletResponse response, HttpServletRequest request, OutputStream outputStream) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap = CommonUtil.removeSlash(pMap);
		pMap.put("BUYER", _sessionInfo.getComCode());
		List<Map<String, String>> _data = getExcelList(pMap, request);

		String title = "요청일|요청번호|조직명|조직장|품목코드|품목명|요청수량|확정수량|우편번호|주소|상세주소|전화번호|";
		String headers = "LAEDA|MBLNR|STEXT|S_USER_NM|MATNR|S_ITEM_NM|RQMENGE|RQCMENGE|POST_CODE1|CITY1|STREET|S_USER_TEL|";
		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "출고확정.xls");
	}
	
	@RequestMapping(value = "/mdam/excelBuyerMdAmGiCowayReqListSAP.do", method = RequestMethod.POST)
	public void excelBuyerMdAmGiCowayListSAP(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletResponse response, HttpServletRequest request, OutputStream outputStream) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap = CommonUtil.removeSlash(pMap);
		pMap.put("BUYER", _sessionInfo.getComCode());
		List<Map<String, String>> _data = getExcelListSAP(pMap, request);

		String title = "요청일|요청번호|조직명|조직장|품목코드|품목명|요청수량|확정수량|우편번호|주소|상세주소|전화번호|";
		String headers = "LAEDA|MBLNR|STEXT|S_USER_NM|MATNR|S_ITEM_NM|RQMENGE|RQCMENGE|POST_CODE1|CITY1|STREET|S_USER_TEL|";

		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "출고확정SAP.xls");
	}

	/**
	 * ZmmGsysDeliveryDisplaySum
	 * 
	 * @param pMap
	 * @return
	 */
	private List<Map<String, String>> getExcelList(Map<String, String> pMap, HttpServletRequest req) {
		String I_BUDAT_FROM = pMap.get("st_from_date");
		String I_BUDAT_TO = pMap.get("st_to_date");
		String I_MBLNRS = pMap.get("st_mblnr");

		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		Map<String, String> paramMap = new HashMap<String, String>();

		paramMap.put("I_BUDAT_FROM", I_BUDAT_FROM);
		paramMap.put("I_BUDAT_TO", I_BUDAT_TO);
		paramMap.put("I_MBLNRS", I_MBLNRS);

		resultList = buyerCowayRfcController.getRfc("ZMM_GSYS_DELIVERY_DISPLAY_SUM", "TI_IMPORT", "TE_EXPORT", paramMap, req);
		
		buyerMdAmGiCowayService.delGsysDeliveryDispaly(pMap);

		for(int i = 0 ; i < resultList.size() ; i++) {
			
			resultList.get(i).put("SCREEN_ID", pMap.get("st_screen_id"));
			resultList.get(i).put("USER_ID", pMap.get("st_user_id"));
		}
		
		if (resultList.size() > 0) {
			buyerMdAmGiCowayService.setGsysDeliveryDispalySumBatch(resultList);
			buyerMdAmGiCowayService.setGsysDeliveryDispalyPrInfo(pMap);
		}
		
		List<Map<String, String>> _data	= buyerMdAmGiCowayService.getGsysDeliveryDispalySum(pMap);

		return _data;
	}

	private List<Map<String, String>> getExcelListSAP(Map<String, String> pMap, HttpServletRequest req) {
		String I_BUDAT_FROM = pMap.get("st_from_date");
		String I_BUDAT_TO = pMap.get("st_to_date");
		String I_MBLNRS = pMap.get("st_mblnr");

		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		Map<String, String> paramMap = new HashMap<String, String>();

		paramMap.put("I_BUDAT_FROM", I_BUDAT_FROM);
		paramMap.put("I_BUDAT_TO", I_BUDAT_TO);
		paramMap.put("I_MBLNRS", I_MBLNRS);

		resultList = buyerCowayRfcController.getRfc("ZMM_GSYS_DELIVERY_DISPLAY_SUM", "TI_IMPORT", "TE_EXPORT", paramMap, req);

		String BUYER = "";
		String PR_NO = "";
		String BUYER_ITEM_NO = "";
		List<Map<String, String>> _data = new ArrayList<Map<String, String>>();
		Map<String, String> _newData = null;
		int i = 0;
		for (Map<String, String> map : resultList) {
			BUYER_ITEM_NO = map.get("MATNR");
			if(BUYER_ITEM_NO != null && BUYER_ITEM_NO.matches(".*[0-9].*"))
				BUYER_ITEM_NO = String.valueOf(Integer.parseInt(BUYER_ITEM_NO));
			BUYER = pMap.get("BUYER");
			Map<String, String> prInfo = new HashMap<String, String>();
			prInfo = buyerMdAmGiCowayService.getOriPrInfo(map);
			if(prInfo != null && prInfo.size()>0){
				BUYER = prInfo.get("BUYER");
				PR_NO = prInfo.get("PR_NO");
			}
			map.put("BUYER", BUYER);
			map.put("PR_NO", PR_NO);
			map.put("BUYER_ITEM_NO", BUYER_ITEM_NO);
			map.put("RN", String.valueOf(i));
			map.put("SEQ", String.valueOf(i+1));
			map.put("TOTNUM", String.valueOf(resultList.size()));
			_newData = new HashMap<String, String>();
			_newData.put("BUYER", BUYER);
			_newData.put("PR_NO", PR_NO);
			_newData.put("BUYER_ITEM_NO", BUYER_ITEM_NO);
			List<Map<String, String>> _prDetail = new ArrayList<Map<String, String>>();
			_prDetail = buyerMdAmGiCowayService.getPrDetail(_newData);
			_newData.clear();
			_newData.putAll(map);
			if (_prDetail != null && _prDetail.size() > 0) {
				_newData.put("s_item_nm", _prDetail.get(0).get("DESCRIPTION"));
				_newData.put("s_stnd_nm", _prDetail.get(0).get("SPECIFICATION"));
				_newData.put("s_user_nm", _prDetail.get(0).get("S_USER_NM"));
				_newData.put("s_user_tel", _prDetail.get(0).get("S_USER_TEL"));
				_newData.put("REQ_USER_NAME", _prDetail.get(0).get("REQ_USER_NAME"));
				_newData.put("UNIT_MEASURE", _prDetail.get(0).get("UNIT_MEASURE"));
			} else {
				_newData.put("s_item_nm", "");
				_newData.put("s_stnd_nm", "");
				_newData.put("s_user_nm", "");
				_newData.put("s_user_tel", "");
				_newData.put("REQ_USER_NAME", "");
				_newData.put("UNIT_MEASURE", "");
			}
			_data.add(i++, _newData);
		}

		return _data;
	}
	
	/**
	 * ZmmGsysDeliveryDisplaySum
	 * 
	 * @param pMap
	 * @return
	 */
	private List<Map<String, String>> getExcelReqList(Map<String, String> pMap, HttpServletRequest req) {
		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String I_BUYER = CommonUtil.nvl(String.valueOf(pMap.get("v_buyer")));
		String I_PR_NO = CommonUtil.nvl(String.valueOf(pMap.get("v_pr_no")));
		String I_PR_SEQ = CommonUtil.nvl(String.valueOf(pMap.get("v_pr_seq")));
		String[] V_BUYER = null;
		String[] V_PR_NO = null;
		String[] V_PR_SEQ = null;
		if (!I_BUYER.equals(""))
			V_BUYER = I_BUYER.split("@@");
		if (!I_PR_NO.equals(""))
			V_PR_NO = I_PR_NO.split("@@");
		if (!I_PR_SEQ.equals(""))
			V_PR_SEQ = I_PR_SEQ.split("@@");
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		Map<String, String> map = null;
		for (int i = 0; i < V_BUYER.length; i++) {
			map = new HashMap<String, String>();
			map.put("BUYER", V_BUYER[i]);
			map.put("PR_NO", V_PR_NO[i]);
			map.put("PR_SEQ", V_PR_SEQ[i]);
			list.add(i, map);
		}
		paramMap.put("PR_ARRAY", list);
		resultList = buyerMdAmGiCowayService.getGiReqExcelList(paramMap);
		
		return resultList;
	}
	

	/**
	 * 요청서조회(출고확정)
	 * @param pModel
	 * @param pMap
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/mdam/getBuyerMdAmGiCowayReqList.do", method = { RequestMethod.POST, RequestMethod.GET })
	public String getBuyerMdAmGiCowayReqList(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		pMap = CommonUtil.PagingPrc(pMap);

		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		List<Map<String, String>> _data = getList(formData, req);
		String startRow = pMap.get("startrow");
		String endRow = pMap.get("endrow");
		if (startRow == null || startRow.equals("0")) {
			startRow = "1";
			endRow = "10";
		}
		int fromIndex = Integer.parseInt(startRow) - 1;
		int toIndex = Integer.parseInt(endRow);
		if (_data != null)
			if (_data.size() < toIndex)
				toIndex = _data.size();
		List<Map<String, String>> _pagingData = new ArrayList<Map<String, String>>();
		if (_data != null)
			_pagingData.addAll(_data.subList(fromIndex, toIndex));
		pModel.addAttribute("data", CommonUtil.getListNvl(_pagingData));
		pModel.addAllAttributes(pMap);
		return "buyer/mdam/buyerMdAmGiCowayReqList";
	}
	
	/**
	 * EXCEL 다운로드
	 * 
	 * @param pModel
	 * @param pMap
	 * @param response
	 * @param outputStream
	 */
	@RequestMapping(value = "/mdam/excelBuyerMdAmGiCowayReqList.do", method = RequestMethod.POST)
	public void excelBuyerMdAmGiCowayReqList(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletResponse response, HttpServletRequest request, OutputStream outputStream) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap = CommonUtil.removeSlash(pMap);
		pMap.put("BUYER", _sessionInfo.getComCode());
		List<Map<String, String>> _data = getExcelReqList(pMap, request);
		String title = "요청일|요청번호|조직명|조직장명|품목코드|품목명|요청수량|확정수량|우편번호|주소|상세주소|전화번호|";
		String headers = "ERSDA|I_MBLNR|STEXT|ENAME|MATNR|MAKTX|GIMENGE|GIMENGE2|POST_CODE1|CITY1|STREET|TEL_NUMBER|";
		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "요청서리스트.xls");
	}
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmGiCowayReqDetailPop.do", method = { RequestMethod.POST, RequestMethod.GET })
	public String getBuyerMdAmGiCowayReqDetailPop(ModelMap pModel, HttpServletRequest request, @RequestParam MultiValueMap<String, String> multiMap,
			@RequestParam Map<String, String> pMap) {
		pMap = CommonUtil.removeSlash(pMap);
		pMap.put("BUYER", pMap.get("BUYER"));
		List<Map<String, String>> _deptData = buyerMdAmGiCowayService.getReqDeptInfo(pMap);
		List<Map<String, String>> _data = getExcelReqList(pMap, request);
		pModel.addAllAttributes(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("deptData", _deptData.get(0));
		return "buyer/mdam/buyerMdAmGiCowayReqDetailPop";
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdamHqUserInfoPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showHqUserInfoPop() {
		return "buyer/mdam/buyerMdamHqUserInfoPop";
	}
	
	@RequestMapping(value = "/mdam/getBuyerMdamHqUserInfoPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getHqUserInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		List<Map<String, String>> _data =  buyerMdAmGiCowayService.getHqUserInfo(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("result","S"); 
		return "buyer/mdam/buyerMdamHqUserInfoPop";
	}

	

	
	/***********************************************************************************************/
	/* 엑셀자료 수신 및 저장. */
	/***********************************************************************************************/

	@RequestMapping(value = "/mdam/getBuyerMdAmGiCowayExcelInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerMdAmGiCowayExcelInfo(ModelMap pModel, HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {
		
		Map<String, String> rtn = new HashMap<String, String>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap = CommonUtil.removeSlash(pMap);
		pMap.put("BUYER", _sessionInfo.getComCode());
		rtn = getExcelInfo(pMap, req);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("rfcMsg", rtn);
		return _response;
	}

	private Map<String, String> getExcelInfo(Map<String, String> pMap, HttpServletRequest req) {
		
		Map<String, String> rtn = new HashMap<String, String>();

		String I_BUDAT_FROM = pMap.get("st_from_date");
		String I_BUDAT_TO = pMap.get("st_to_date");
		String I_MBLNRS = pMap.get("st_mblnr");

		List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
		Map<String, String> paramMap = new HashMap<String, String>();

		paramMap.put("I_BUDAT_FROM", I_BUDAT_FROM);
		paramMap.put("I_BUDAT_TO", I_BUDAT_TO);
		paramMap.put("I_MBLNRS", I_MBLNRS);

		resultList = buyerCowayRfcController.getRfc("ZMM_GSYS_DELIVERY_DISPLAY_SUM", "TI_IMPORT", "TE_EXPORT", paramMap, req);
		
		for(int i = 0 ; i < resultList.size() ; i++) {
			
			resultList.get(i).put("SCREEN_ID", pMap.get("st_screen_id"));
			resultList.get(i).put("USER_ID", pMap.get("st_user_id"));
		}
		
		if (resultList.size() > 0) {
			buyerMdAmGiCowayService.updateExcelInfo(resultList);
			buyerMdAmGiCowayService.setGsysDeliveryDispalyPrInfo(pMap);

			rtn.put("MESSAGE", "엑셀자료 조회완료");
			rtn.put("MSGTYPE", "T");
		} else {
			rtn.put("MESSAGE", "엑셀자료 조회오류");
			rtn.put("MSGTYPE", "E");
		}
		
		return rtn;
	}
	

	@RequestMapping(value = "/mdam/getExcelBuyerMdAmGiCowayList.do", method = RequestMethod.POST)
	public void getExcelBuyerMdAmGiCowayList(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletResponse response, HttpServletRequest request, OutputStream outputStream) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap = CommonUtil.removeSlash(pMap);
		pMap.put("BUYER", _sessionInfo.getComCode());
		List<Map<String, String>> _data = buyerMdAmGiCowayService.getGsysDeliveryDispalySum(pMap);

		String title = "요청일|요청번호|조직명|조직장|품목코드|품목명|요청수량|확정수량|우편번호|주소|상세주소|전화번호|";
		String headers = "LAEDA|MBLNR|STEXT|S_USER_NM|MATNR|S_ITEM_NM|RQMENGE|RQCMENGE|POST_CODE1|CITY1|STREET|S_USER_TEL|";
		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "출고확정.xls");
	}
		
}
