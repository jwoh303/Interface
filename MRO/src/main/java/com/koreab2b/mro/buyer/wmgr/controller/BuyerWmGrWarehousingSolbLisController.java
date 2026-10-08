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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.wmgr.service.BuyerWmGrWarehousingSolbLisService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerWmGrWarehousingSolbLisController")
public class BuyerWmGrWarehousingSolbLisController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerWmGrWarehousingSolbLisController.class);

	@Autowired
	private BuyerWmGrWarehousingSolbLisService buyerWmGrWarehousingSolbLisService;	
	
	// 조회
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingSolbLisList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerWmGrWarehousingLisList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/wmgr/getBuyerWmGrWarehousingSolbLisList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 

		// xss replace 필터
		pMap = CommonUtil.xss_kep_filter(pMap);
				
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerWmGrWarehousingSolbLisService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "buyer/wmgr/buyerWmGrWarehousingSolbLisList";
	}
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingSolbLisList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrWarehousingSolbLisList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerWmGrWarehousingSolbLisService.getBuyerWmGrWarehousingSolbLisList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingSolbLisList_v3.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrWarehousingSolbLisList_v3(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerWmGrWarehousingSolbLisService.getBuyerWmGrWarehousingSolbLisList_v3(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	
	// 저장
	@RequestMapping(value = "/wmgr/saveBuyerWmGrWarehousingSolbLisList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerWmGrWarehousingLis(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/wmgr/saveBuyerWmGrWarehousingRegList.do MultiValueMap 요청 파라미터 : formData", _pMap);
		
		String flag = buyerWmGrWarehousingSolbLisService.updateSelectedData(pMap);
		
		_response.put("msg", flag);
		
		return  _response;
	}
	@RequestMapping(value = "/wmgr/saveBuyerWmGrWarehousingSolbLisList_v3.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerWmGrWarehousingLis_v3(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/wmgr/saveBuyerWmGrWarehousingRegList.do MultiValueMap 요청 파라미터 : formData", _pMap);
		
		String flag = buyerWmGrWarehousingSolbLisService.updateSelectedData_v3(pMap);
		
		_response.put("msg", flag);
		
		return  _response;
	}
	
	// 관리번호 저장
	@RequestMapping(value = "/wmgr/saveBuyerWmGrWarehousingSolbRefNo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerWmGrWarehousingSolbRefNo(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();			
		
		String flag = buyerWmGrWarehousingSolbLisService.updateSolbRefNo(pMap);
		
		_response.put("msg", flag);
		
		return  _response;
	}
	
	// 입고 확정 및 취소
	@RequestMapping(value = "/wmgr/saveBuyerWmGrWarehousingSolbGrConfirm.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerWmGrWarehousingSolbGrConfirm(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();			
		
		String flag = buyerWmGrWarehousingSolbLisService.updateSolbGrConfirm(pMap);
		
		_response.put("msg", flag);
		
		return  _response;
	}
	
	// 회계 확정 및 취소
	@RequestMapping(value = "/wmgr/saveBuyerWmGrWarehousingSolbDlConfirm.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerWmGrWarehousingSolbDlConfirm(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();			
		
		String flag = buyerWmGrWarehousingSolbLisService.updateSolbDlConfirm(pMap);
		
		_response.put("msg", flag);
		
		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingSolbLisList.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingSolbLis(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {		

		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = null;
	   	
		String title = "";		
		String headers = "";
		String docu_name = "입고조회.xls";
		
		_data = buyerWmGrWarehousingSolbLisService.getList(pMap);
		
		title = "고객사|상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|플랜트명|코스트센터명|계정명|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|요청자명|카테고리명|기존/신규 구분|송장번호|특이사항|품목비고|요청자|도착지|";
		headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|REF_PR_NO_TEXT1|REF_PR_NO_TEXT2|REF_PR_NO_TEXT3|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|PH_REMARK|PO_REMARK|PR_USER_NAME|DELY_TO_LOCATION|";
		
		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, docu_name);
		
		
	}
	// EXCEL 다운로드	
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingSolbLisList_v2.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingSolbLis_v2(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {		

		// 조회일 슬래시 제거
		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String, String>> _data = null;
	   	
		String title = "";		
		String headers = "";
		String docu_name = "입고현황.xls";
		
		_data = buyerWmGrWarehousingSolbLisService.getBuyerWmGrWarehousingSolbLisList_v2(pMap);
		
		title = "고객사|상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|플랜트명|코스트센터명|계정명|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|요청자명|카테고리명|기존/신규 구분|송장번호|특이사항|품목비고|요청자|도착지|";
		headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|REF_PR_NO_TEXT1|REF_PR_NO_TEXT2|REF_PR_NO_TEXT3|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|PH_REMARK|PO_REMARK|PR_USER_NAME|DELY_TO_LOCATION|";
		
		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, docu_name);
		
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingSolbErpList.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingSolbErp(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = null;
	   	
		String title = "";
		String headers = "";
		String docu_name = "ERP업로드양식.xls";		
		_data = buyerWmGrWarehousingSolbLisService.getErpList(pMap);
		
		title = "순번|전기일|증빙일|전표유형|통화|참조|전기키|계정|조정계정|금액|세액|세금코드|사업장|코스트센터|WBS요소|지급방법|지급조건|지급기산일|지정|텍스트|소속부서(팀)|입고일|품목코드|발주번호|구매목적|";
		headers = "RNUM|||||||REF_PR_NO3|REF_PR_NO_TEXT3|ITEM_AMT|UNIT_TAX||REF_PR_NO1|REF_PR_NO2||||||DESCRIPTION|ADD_USER_DEPT_NAME|GR_DATE|BUYER_ITEM_NO|PO_NO|PURCHASE_PURPOSE|";
		
		String excelHeader = title + "@@" + headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, docu_name);
		
	}
	
}
