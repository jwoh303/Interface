package com.koreab2b.mro.buyer.wmgr.controller;

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

import com.koreab2b.mro.buyer.wmgr.service.BuyerWmGrWarehousingRegService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerWmGrWarehousingRegController")
public class BuyerWmGrWarehousingRegController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerWmGrWarehousingRegController.class);

	@Autowired
	private BuyerWmGrWarehousingRegService buyerWmGrWarehousingRegService;

	// 특수로직 INIT
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingReg.do", method = RequestMethod.GET)
	public String getBuyerWmGrWarehousingRegInit(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		logger.debug("============== getBuyerWmGrWarehousingRegInit START ===============");
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		logger.debug("로그인 com_code : " + _sessionInfo.getComCode());
		
		pMap.put("com_code", _sessionInfo.getComCode());	
		pMap.put("user_id", _sessionInfo.getUserId());	
		
		Map<String, String> _data = buyerWmGrWarehousingRegService.getBuyerWmGrWarehousingRegInit(pMap);
		pModel.addAttribute("sLogicInfo", _data);
		
		logger.debug("============== getBuyerWmGrWarehousingRegInit END ===============");		
		
		return "buyer/wmgr/buyerWmGrWarehousingRegList";
	}
	
	// 조회
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingRegList.do", method = RequestMethod.POST)
	public String getBuyerWmGrWarehousingRegList(ModelMap pModel, @RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/wmgr/getBuyerWmGrWarehousingRegList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 

		// 조회일자 Convert
//		String _st_from_date = pMap.get("st_from_date").replace("/", "");
//		String _st_to_date = pMap.get("st_to_date").replace("/", "");
//		pMap.put("st_from_date",_st_from_date);
//		pMap.put("st_to_date",_st_to_date);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerWmGrWarehousingRegService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "buyer/wmgr/buyerWmGrWarehousingRegList";
	}
	
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingRegList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrWarehousingRegList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerWmGrWarehousingRegService.getBuyerWmGrWarehousingRegList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingRegList_v3.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrWarehousingRegList_v3(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerWmGrWarehousingRegService.getBuyerWmGrWarehousingRegList_v3(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	

	// 조회조건-userList 조회
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingRegUserList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerWmGrWarehousingRegUserList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/wmgr/saveBuyerWmGrWarehousingRegList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		String _searchType = CommonUtil.nvl(pMap.get("st_search_type"));
		String _poUserId = CommonUtil.nvl(pMap.get("st_po_user_id"));
		
		List<Map<String, String>> _data = buyerWmGrWarehousingRegService.getUserList(pMap);
		
		_response.put("userList", _data);
		_response.put("searchType", _searchType);
		_response.put("poUserId", _poUserId);
		
		_response.put("msg", "");
		
		return  _response;
	}
	
	// 저장
	@RequestMapping(value = "/wmgr/saveBuyerWmGrWarehousingRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerWmGrWarehousingReg(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/wmgr/saveBuyerWmGrWarehousingRegList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		String flag = buyerWmGrWarehousingRegService.updateSelectedData(pMap);
		
		_response.put("msg", flag);
		
		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingRegList.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingReg(ModelMap pModel, HttpServletRequest req,@RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/wmgr/excelBuyerWmGrWarehousingRegList.do 요청 파라미터 for jsp : {}", pMap);

		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerWmGrWarehousingRegService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		String p060000080 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000080","COL01_DATA");
		String p060000086 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000086","COL02_DATA");
		String title = "";
		String headers = "";
		if(p060000080.equals("TYPE1")){
			title = "발주번호|송장번호|품목코드|관리번호|품목명|규격|단위|발주수량|발주일|단가|금액|송장수량|기입고수량|입고수량|발주자|협력사|요청부서|수량|길이|";
			headers = "PO_NO|INV_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_QTY|PO_CREATE_DATE|UNIT_PRICE|PO_AMT|INV_QTY|GR_QTY|TEMP_GR_QTY|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|SIZE_QTY|SIZE_LEN|";
		}else if(p060000086.equals("TYPE1")) {
			title = "고객사|송장번호|순번|Vendor code|Supplier|품목코드|품목군|품목명|규격|제조사|송장수량|단위|단가|원산지|Currency|총금액|선입고|긴급발주|주문번호|주문번호항번|발주번호|발주번호항번|총발주수량|관리번호|주문일|배송희망일|납품예정일|배송상태|납품일|배송기사 이름|배송기사 전화번호|배송차량 번호|택배사|택배송장번호|주문기입고수량|발주자|요청부서|요청자(한글)|요청자(영문)|요청자(Email)|요청자 전화번호|ASN전송일자|";
			headers = "COM_NAME_LOC|INV_NO|INV_SEQ|ASN_VENDOR_CODE|AGENT_NAME|BUYER_ITEM_NO|CATEG_NAME|DESCRIPTION|SPECIFICATION|MAKER_NAME|INV_QTY|UNIT_MEASURE|UNIT_PRICE|ORIGIN_NAME|CUR|PO_TTL_AMT|PRE_GR_YN|FAST_PO_YN|PR_NO|PR_SEQ|PO_NO|PO_SEQ|PO_QTY|REF_PR_NO|PO_CREATE_DATE|RD_DATE|CD_DATE|STATUS_TEXT|INVOICE_DATE|DELIVERY_PERSON_NAME|DELIVERY_PERSON_PHONE|DELIVERY_CAR_NO|PARCEL_COM_NAME|PARCEL_INV_NO|GR_QTY|PO_CREATOR|REQ_DEPT_NAME|ADD_USER_NAME|ADD_USER_NAME_ENG|ADD_USER_EMAIL|ADD_USER_TEL|TODAY_DATE|";
		}else{
			title = "고객사|발주번호|송장번호|품목코드|관리번호|품목명|규격|단위|발주수량|발주일|단가|금액|송장수량|기입고수량|입고수량|발주자|협력사|요청부서|요청자|";
			headers = "COM_NAME_LOC|PO_NO|INV_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_QTY|PO_CREATE_DATE|UNIT_PRICE|PO_AMT|INV_QTY|GR_QTY|TEMP_GR_QTY|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|PR_USER_NAME|";			
		}
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "입고등록.xls");
		 
	}
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingRegList_v2.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingRegList_v2(ModelMap pModel, HttpServletRequest req,@RequestParam Map<String, Object> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/wmgr/excelBuyerWmGrWarehousingRegList.do 요청 파라미터 for jsp : {}", pMap);

		// 조회일 슬래시 제거
		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String, String>> _data = buyerWmGrWarehousingRegService.getBuyerWmGrWarehousingRegList_v2(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		String title = "";
		String headers = "";
			title = "고객사|발주번호|송장번호|품목코드|관리번호|품목명|규격|단위|발주수량|발주일|단가|금액|송장수량|기입고수량|입고수량|발주자|협력사|요청부서|요청자|";
			headers = "COM_NAME_LOC|PO_NO|INV_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_QTY|PO_CREATE_DATE|UNIT_PRICE|PO_AMT|INV_QTY|GR_QTY|TEMP_GR_QTY|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|PR_USER_NAME|";			
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "입고대상.xls");
		 
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingPCORegList.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingPCORegList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {

		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerWmGrWarehousingRegService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		
		String title = "발주번호|요청번호|품목코드|관리번호|품목명|규격|단위|발주수량|발주일|단가|금액|송장수량|기입고수량|입고수량|발주자|협력사|요청부서|";
		String headers = "PCO_LEGACY_PO_NO|PCO_REF_PR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_QTY|PO_CREATE_DATE|UNIT_PRICE|PO_AMT|INV_QTY|GR_QTY|TEMP_GR_QTY|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "입고현황.xls");
		 
	}
	
	// 롯데칠성 입고 결재 상신
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingRegGrAppSendList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerWmGrWarehousingRegGrAppSendList(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		Map<String, String> _APP_data = buyerWmGrWarehousingRegService.getGrAppSendList(pMap);
		
		_response.put("APP",_APP_data);
		
		System.out.println("_response = " + _response);
		return  _response;
	}
	
	//롯데칠성 입고 결재 상신 초기화
	@RequestMapping(value = "/wmgr/resetGrWarehousingReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> resetGrWarehousingReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
	
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		logger.debug("요청 파라미터 : _list", _list);
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		String rtnMsg = buyerWmGrWarehousingRegService.updateResetGrWarehousingReg(_pMap, _list);
	
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
	return _response;
	}
}
