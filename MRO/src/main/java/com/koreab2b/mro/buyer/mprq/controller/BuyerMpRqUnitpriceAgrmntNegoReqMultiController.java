package com.koreab2b.mro.buyer.mprq.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqUnitpriceAgrmntNegoReqMultiService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqUnitpriceAgrmntNegoReqMultiController")
public class BuyerMpRqUnitpriceAgrmntNegoReqMultiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqUnitpriceAgrmntNegoReqMultiController.class);

	@Autowired
	private BuyerMpRqUnitpriceAgrmntNegoReqMultiService buyerMpRqUnitpriceAgrmntNegoReqMultiService;
	
	// 조회
	@RequestMapping(value = "/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqMultiList.do", method = RequestMethod.POST)
	public String getBuyerMpRqUnitpriceAgrmntNegoReqMultiList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//LOGGER.debug("/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqMultiList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpRqUnitpriceAgrmntNegoReqMultiService.getListMulti(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mprq/buyerMpRqUnitpriceAgrmntNegoReqMultiList";
	}
	@RequestMapping(value = "/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqMultiList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpRqUnitpriceAgrmntNegoReqMultiList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerMpRqUnitpriceAgrmntNegoReqMultiService.getBuyerMpRqUnitpriceAgrmntNegoReqMultiList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 저장
	@RequestMapping(value = "/mprq/saveBuyerMpRqUnitpriceAgrmntNegoReqMultiList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMpRqUnitpriceAgrmntNegoReqMulti(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _msg = new HashMap<String, Object>();		
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		String flag = buyerMpRqUnitpriceAgrmntNegoReqMultiService.updateSelectedDataMulti(_pMap, _list);
		_msg.put("MSG", flag); 
		_response.put("msg", _msg);

		return  _response;
	}
	// 단가합의
	@RequestMapping(value = "/mprq/saveBuyerMpRqUnitpriceAgrmntMulti.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqUnitpriceAgrmntMulti(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		Map<String,String> _result = buyerMpRqUnitpriceAgrmntNegoReqMultiService.saveBuyerMpRqUnitpriceAgrmntMulti(_pMap, _list);

		_msg.put("msg", _result.get("MSG")); 
		_msg.put("usrmsg",_result.get("GW_NO")); 
		_msg.put("passflag",_result.get("passflag")); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 견적종료
	@RequestMapping(value = "/mprq/saveBuyerMpRqCloseRemarkMulti.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqCloseRemarkMulti(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		Map<String,String> _result = buyerMpRqUnitpriceAgrmntNegoReqMultiService.saveBuyerMpRqCloseRemarkMulti(_pMap, _list);

		_msg.put("msg", _result.get("MSG")); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 단가합의
	@RequestMapping(value = "/mprq/saveBuyerMpRqUnitpriceAgrmntNonPassMulti.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqUnitpriceAgrmntNonPassMulti(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		Map<String,String> _result = buyerMpRqUnitpriceAgrmntNegoReqMultiService.saveBuyerMpRqUnitpriceAgrmntNonPassMulti(_pMap, _list);
		
		_msg.put("msg", _result.get("MSG")); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	@RequestMapping(value = "/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqMultiExcelDown.do", method = RequestMethod.POST)
	public void getExcelDown(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletResponse response, OutputStream outputStream) {
		LOGGER.debug("getExcelDown 요청 파라미터 for jsp : {}", pMap);
		
		pMap = CommonUtil.PagingPrc(pMap);
		pMap.put("paging", "0"); // Excel Down을 위한 구분
		String filename = "단가합의및네고요청_" + pMap.get("st_from_date") + "_" + pMap.get("st_to_date") + ".xls";
		List<Map<String, String>> _data = buyerMpRqUnitpriceAgrmntNegoReqMultiService.getListMulti(pMap);

		String title = "";
		String headers = "";
		
		title = "견적번호|진행상태|MSDS상태|고객사명|품목코드|견적의뢰일|회신요청일|품목명|규격|제조사|원산지|수량|단위|단가구분|요청단가|협력사|견적단가|요청자|요청부서|KEP담당자|운영사비고|고객사비고";
		headers = "QUOTATION_NO|SOURCING_STATUS|MSDS_TYPE_TEXT|BUYER_NAME|BUYER_ITEM_NO|BTOA_DATE|BTOA_END_DATE|DESCRIPTION|SPECIFICATION|MAKER_NAME|ORIGIN_NAME|ITEM_QTY|UNIT_MEASURE|REQ_PRICE_TYPE_TEXT|BUYER_TARGET_PRICE|AGENT_NAME|ATOB_UNIT_PRICE|BTOA_USER_NAME|BTOA_USER_DEPT|KEP_USER_NAME|ATOB_REMARK|BTOA_REMARK|";
		
		String excelHeader = title +"@@"+headers;		
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,filename);
	}
}
