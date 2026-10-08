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

import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqUnitpriceAgrmntNegoReqService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqUnitpriceAgrmntNegoReqController")
public class BuyerMpRqUnitpriceAgrmntNegoReqController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqUnitpriceAgrmntNegoReqController.class);

	@Autowired
	private BuyerMpRqUnitpriceAgrmntNegoReqService buyerMpRqUnitpriceAgrmntNegoReqService;
	
	// 조회
	@RequestMapping(value = "/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqList.do", method = RequestMethod.POST)
	public String getBuyerMpRqUnitpriceAgrmntNegoReqList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//LOGGER.debug("/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpRqUnitpriceAgrmntNegoReqService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mprq/buyerMpRqUnitpriceAgrmntNegoReqList";
	}
	@RequestMapping(value = "/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpRqUnitpriceAgrmntNegoReqList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_session_com_code",_sessionInfo.getComCode());
		List<Map<String, String>> _data = buyerMpRqUnitpriceAgrmntNegoReqService.getList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/mprq/saveBuyerMpRqUnitpriceAgrmntNegoReqList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMpRqUnitpriceAgrmntNegoReq(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _msg = new HashMap<String, Object>();		
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		String flag = buyerMpRqUnitpriceAgrmntNegoReqService.updateSelectedData(_pMap, _list);
		_msg.put("MSG", flag); 
		_response.put("msg", _msg);

		return  _response;
	}
	// 저장(네고요청)_v2
	@RequestMapping(value = "/mprq/saveBuyerMpRqUnitpriceAgrmntNegoReqList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMpRqUnitpriceAgrmntNegoReq_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		String flag = buyerMpRqUnitpriceAgrmntNegoReqService.updateSelectedData_v2(_pMap, _list);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		_response.put("Message", flag);

		return  _response;
	}
	// 취소
	@RequestMapping(value = "/mprq/saveBuyerMpRqUnitpriceAgrmntCancleReqList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMpRqUnitpriceAgrmntCancleReq(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _msg = new HashMap<String, Object>();		
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("st_confirm_user_id2",_sessionInfo.getUserId());
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		String flag = buyerMpRqUnitpriceAgrmntNegoReqService.updateSelectedCancleData(_pMap, _list);
		_msg.put("MSG", flag); 
		_response.put("msg", _msg);

		return  _response;
	}
	// 취소_v2
	@RequestMapping(value = "/mprq/saveBuyerMpRqUnitpriceAgrmntCancleReqList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMpRqUnitpriceAgrmntCancleReq_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("st_confirm_user_id2",_sessionInfo.getUserId());
		_pMap.put("st_buyer2",_sessionInfo.getComCode());
		
		LOGGER.debug("saveBuyerMpRqUnitpriceAgrmntCancleReqList_v2 요청 파라미터 pMap : {}", _pMap);
		LOGGER.debug("saveBuyerMpRqUnitpriceAgrmntCancleReqList_v2 요청 파라미터 _list : ", _list);
		
		String flag = buyerMpRqUnitpriceAgrmntNegoReqService.updateSelectedCancleData_v2(_pMap, _list);

		Map<String, Object> _response = new HashMap<String, Object>();
		
		_response.put("Message", flag);

		return  _response;
	}
	
	// 단가합의(최초) 화면 리턴 후 GW_NO 유무로 결재창 여부를 결정
	@RequestMapping(value = "/mprq/saveBuyerMpRqUnitpriceAgrmnt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqUnitpriceAgrmnt(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		_pMap.put("st_server_mode",CommonUtil.getDevRealLocalFlag(req));
		_pMap.put("st_legacy_user_id", _sessionInfo.getEmpNo());
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		Map<String,String> _result = buyerMpRqUnitpriceAgrmntNegoReqService.saveBuyerMpRqUnitpriceAgrmnt(_pMap, _list);

		_msg.put("msg", _result.get("MSG")); 
		_msg.put("usrmsg",_result.get("GW_NO")); 
		_msg.put("passflag",_result.get("passflag"));
		_msg.put("callurl", _result.get("callurl"));
		_msg.put("buyerpopflag", _result.get("buyerpopflag"));
		_response.put("msg", _msg);
		return  _response;
	}
	// 견적종료
	@RequestMapping(value = "/mprq/saveBuyerMpRqCloseRemark.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqCloseRemark(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		Map<String,String> _result = buyerMpRqUnitpriceAgrmntNegoReqService.saveBuyerMpRqCloseRemark(_pMap, _list);

		_msg.put("msg", _result.get("MSG")); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 단가합의(화면 리턴 후 결재 창이 떴다가 미결재 선택 시 처리 부분)
	@RequestMapping(value = "/mprq/saveBuyerMpRqUnitpriceAgrmntNonPass.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqUnitpriceAgrmntNonPass(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		Map<String,String> _result = buyerMpRqUnitpriceAgrmntNegoReqService.saveBuyerMpRqUnitpriceAgrmntNonPass(_pMap, _list);
		
		_msg.put("msg", _result.get("MSG")); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 결재상신
	@RequestMapping(value = "/mprq/getBuyerMpRqAppSend.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerMpRqAppSend(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		Map<String,String> _result = buyerMpRqUnitpriceAgrmntNegoReqService.getAppSendList(_pMap, _list);
		
		_response.put("APP", _result);
		
		System.out.println("_response : " + _response);
		return  _response;
	}

	// EXCEL 다운로드	
	@RequestMapping(value = "/mprq/excelBuyerMpRqUnitpriceAgrmntNegoReqList.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingLis(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {

		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 

		String docu_name = "단가합의및Nego요청조회"+pMap.get("st_from_date")+"_"+pMap.get("st_to_date")+".xls";
		String excelType = pMap.get("st_excel_type");
		String title = "";
		String headers  = "";
		List<Map<String, String>> _data = null;
		
		if("TYPE1".equals(excelType)){ // 휴젤 다운로드 양식
			_data = buyerMpRqUnitpriceAgrmntNegoReqService.getList(pMap);
			
			title = "견적번호|진행상태|실코드|품목코드|견적의뢰일|회신요청일|품목명|규격|제조사|원산지|수량|단위|단가구분|요청단가|협력사|조달일수|견적단가|요청자|요청부서|Kep담당자|운영사 비고|고객사 비고|지연사유|지연상세사유";
			
			headers = "QUOTATION_NO|SOURCING_STATUS|REG_ITEM_NO|BUYER_ITEM_NO|BTOA_DATE|BTOA_END_DATE|DESCRIPTION|SPECIFICATION|MAKER_NAME|ORIGIN_NAME|ITEM_QTY|UNIT_MEASURE|"+
			"REQ_PRICE_TYPE_TEXT|BUYER_TARGET_PRICE|EXCEL_AGENT_NAME|LEAD_TIME|ATOB_UNIT_PRICE|BTOA_USER_NAME|BTOA_USER_DEPT|KEP_USER_NAME|ATOB_REMARK|BTOA_REMARK|EXCEL_DELAY_REASON|EXCEL_DELAY_DETAIL_REASON|";				
		}
		
		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, docu_name);
	}
	
	// 단가합의 비고
	@RequestMapping(value = "/mprq/buyerSaveUnitpriceAgrmntNegoReqPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqUnitpriceAgrmntNegoReqPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
			
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		
		Map<String,String> _result = buyerMpRqUnitpriceAgrmntNegoReqService.saveBuyerMpRqUnitpriceAgrmntNegoReqPop(pMap);
	
		_response.put("msg", "OK");
		return  _response;
	}
}
