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

import com.koreab2b.mro.buyer.wmgr.service.BuyerWmGrWarehousingLisService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerWmGrWarehousingLisController")
public class BuyerWmGrWarehousingLisController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerWmGrWarehousingLisController.class);

	@Autowired
	private BuyerWmGrWarehousingLisService buyerWmGrWarehousingLisService;
	
	// 특수로직 INIT
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingLis.do", method = RequestMethod.GET)
	public String getBuyerWmGrWarehousingLisInit(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_check_date", CommonUtil.onvl(pMap.get("st_check_date") ,"GR") );
		pMap.put("com_code", _sessionInfo.getComCode());	
		pMap.put("user_id", _sessionInfo.getUserId());
		
		Map<String, String> _data = buyerWmGrWarehousingLisService.getBuyerWmGrWarehousingLisInit(pMap);
		pModel.addAttribute("sLogicInfo", _data);
		
		boolean SolbComListYn = CommonUtil.getCodeCheckReturn("SOLB01", _sessionInfo.getComCode());
		
		if(SolbComListYn) {
			
			return "buyer/wmgr/buyerWmGrWarehousingSolbLisList"; // 솔브레인 전용 입고조회 화면
		} else {
			return "buyer/wmgr/buyerWmGrWarehousingLisList";
		}
		
	}
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingLis_v2.do", method = RequestMethod.GET)
	public String getBuyerWmGrWarehousingLis_v2(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_check_date", CommonUtil.onvl(pMap.get("st_check_date") ,"GR") );
		pMap.put("com_code", _sessionInfo.getComCode());	
		pMap.put("user_id", _sessionInfo.getUserId());
		
		Map<String, String> _data = buyerWmGrWarehousingLisService.getBuyerWmGrWarehousingLisInit(pMap);
		pModel.addAttribute("sLogicInfo", _data);
		
		boolean SolbComListYn = CommonUtil.getCodeCheckReturn("SOLB01", _sessionInfo.getComCode());
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			String menuId = pMap.get("menuId");
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			List<Map<String,String>> _tabData = CommonUtil.getMenuTabInfo_v2(menuId, sessionInfo.getUserId());
			pModel.addAttribute("tab_data", _tabData);
			
			int normal_index = -1;
			int solb_index = -1;
			
			String uiVersion2 = (String) req.getSession().getAttribute("uiVersion2");
			if("renewal_B".equals(uiVersion2)) { //매입마감 관련 flag
				for(int i = 0; i<_tabData.size(); i++){
					Map<String,String> tempMap = _tabData.get(i);
					if(tempMap.get("MENU_JSP").equals("buyerWmGrWarehousingLis_tab1_v2.jsp")){
						normal_index = i;
					}
					if(tempMap.get("MENU_JSP").equals("buyerWmGrWarehousingSolbLis_tab1_v2.jsp")){
						solb_index = i;
					}
				}
				if(normal_index != -1 || solb_index != -1){
					if(SolbComListYn) { //솔브레인은 일반 입고현황탭 날려주기
						_tabData.remove(normal_index);
					}else{//일반은 솔브레인 입고현황탭 날려주기
						_tabData.remove(solb_index);
					}
				}
			}else {
				for(int i = 0; i<_tabData.size(); i++){
					Map<String,String> tempMap = _tabData.get(i);
					if(tempMap.get("MENU_JSP").equals("buyerWmGrWarehousingLis_tab1.jsp")){
						normal_index = i;
					}
					if(tempMap.get("MENU_JSP").equals("buyerWmGrWarehousingSolbLis_tab1.jsp")){
						solb_index = i;
					}
				}
				if(normal_index != -1 || solb_index != -1){
					if(SolbComListYn) { //솔브레인은 일반 입고현황탭 날려주기
						_tabData.remove(normal_index);
					}else{//일반은 솔브레인 입고현황탭 날려주기
						_tabData.remove(solb_index);
					}
				}
			}
			
			
			return "buyer/wmgr/buyerWmGrWarehousingLisList_v2";
			
		}else{
			if(SolbComListYn) {
				return "buyer/wmgr/buyerWmGrWarehousingSolbLisList"; // 솔브레인 전용 입고조회 화면
			} else {
				return "buyer/wmgr/buyerWmGrWarehousingLisList";
			}
		}
		
		
	}
	
	// 조회
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingLisList.do", method = RequestMethod.POST)
	public String getBuyerWmGrWarehousingLisList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/wmgr/getBuyerWmGrWarehousingLisList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 

		// xss replace 필터
		pMap = CommonUtil.xss_kep_filter(pMap);
				
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerWmGrWarehousingLisService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "buyer/wmgr/buyerWmGrWarehousingLisList";
	}
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingLisList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrWarehousingLisList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerWmGrWarehousingLisService.getBuyerWmGrWarehousingLisList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingLisList_v3.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrWarehousingLisList_v3(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerWmGrWarehousingLisService.getBuyerWmGrWarehousingLisList_v3(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/wmgr/saveBuyerWmGrWarehousingLisList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerWmGrWarehousingLis(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/wmgr/saveBuyerWmGrWarehousingRegList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		String flag = buyerWmGrWarehousingLisService.updateSelectedData(pMap);
		
		_response.put("msg", flag);
		
		return  _response;
	}
	@RequestMapping(value = "/wmgr/saveBuyerWmGrWarehousingLisList_v3.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerWmGrWarehousingLis_v3(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/wmgr/saveBuyerWmGrWarehousingRegList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		String flag = buyerWmGrWarehousingLisService.updateSelectedData_v3(pMap);
		
		_response.put("msg", flag);
		
		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingLisList.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingLis(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/wmgr/excelBuyerWmGrWarehousingLisList.do 요청 파라미터 for jsp : {}", pMap);

		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = null;
	   	
		String excelType = CommonUtil.nvl(pMap.get("st_excel_type"));
		String title = "";
		String title2 = "";
		String headers = "";
		String docu_name = "입고조회.xls";
//		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size()+"///"+excelType);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String p060000080 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000080","COL01_DATA");
				
		if("TYPE1".equals(excelType)){
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			title = "상태|발주일|발주번호|입고번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청자|요청부서코드|카테고리ID|Category_TEXT|COST_CENTER_TEXT|ACCOUNT_TEXT|결재자|상신내용|";
			headers = "GR_STATUS|PO_CREATE_DATE|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|ITEM_QTY1|GR_DATE|PURCHASER_NAME|AGENT_NAME|REQ_DEPT_NAME|REQ_USER_NAME|CHANGE_USER_DEPT|CATEG_ID|PLANT_TEXT|COST_CENTER_TEXT|ACCOUNT_TEXT|PASS_USER_NM|PASS_DOC_NM|";
		} else if("TYPE2".equals(excelType)){
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			title = "소속|요구인|업체명|발의일|주문일|납품기한|납품일|품목명|규격|단위|수량|단가|상태|발주번호|입고번호|품목코드|관리번호|발주수량|입고금액|총입고수량|발주자|요청부서코드|카테고리ID|예산부서|계정명|카테고리명|기존/신규 구분|송장번호|";
			headers = "REQ_DEPT_NAME|REQ_USER_NAME|AGENT_NAME|PO_CREATE_DATE|PO_CREATE_DATE|RD_DATE|GR_DATE|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|ITEM_QTY|UNIT_PRICE|GR_STATUS|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|ITEM_QTY1|ITEM_AMT|GR_QTY|PURCHASER_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|";
		} else if("TYPE3".equals(excelType)){
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			title = "상태|발주일|주문번호|발주번호|입고번호|품목코드|요청번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|";
			headers = "GR_STATUS|PO_CREATE_DATE|PX_NO|PCO_LEGACY_PO_NO|GR_NO|BUYER_ITEM_NO|PCO_REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|";
		} else if("TYPE4".equals(excelType)){
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			title = "고객사|상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|귀속부서|관장부서|계정|세금|";
			headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|PR_REF_PR_NO1|PR_REF_PR_NO2|PR_REF_PR_NO3|PR_REF_PR_NO4|";
		} else if("TYPE5".equals(excelType)){
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			title = "고객사|상태|구매요청일자|발주일|구매요청번호|주문번호|발주번호|입고번호|품목코드|관리번호|품목명|규격|단위|발주수량|거래유형|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|요청자사번|결재경로|카테고리명|기존/신규 구분|송장번호|거래명세서생성일|납품확정일|";
			headers = "COM_NAME_LOC|GR_STATUS|PR_CHANGE_DATE|PO_CREATE_DATE|PR_NO|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|PROCESS_TYPE_NM|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|ADD_LEGACY_USER_ID|APRV_PATH|CATEG_NAME|SO_CA_GUBUN|INV_NO|INVOICE_DATE|DELIVERY_DATE|";
		} else if("TYPE6".equals(excelType)){ // 대한제분 그룹사 ERP업로드 양식  (KRWOOR0059, KRDH-V0001, KRBONA0001, KRVITI0001, KRDNB-0001)
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			title = "CD_PLANT|CD_PARTNER|CD_ITEM|DT_LIMIT|QT_PO|UM_EX_PO|AM_EX|DC2|CD_SL|CD_CC|CD_EXCH|CD_TPPO|FG_UM|CD_PJT|";
			title2 = "공장|거래처|품목코드|납기일|입고량|단가|금액|비고2|창고|CC|환정보|발주형태|단가유형|프로젝트코드|";
			headers = "CD_PLANT|CD_PARTNER|CD_ITEM|DT_LIMIT|QT_PO|UM_EX_PO|AM_EX|DC2|CD_SL|CD_CC|CD_EXCH|CD_TPPO|FG_UM|CD_PJT|";
			docu_name = "ERP다운로드.xls";
		} else if("TYPE7".equals(excelType)){ // 한화에어로스페이스 외 3개 (KRWOOR0059, KRDH-V0001, KRBONA0001, KRVITI0001, KRDNB-0001)
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			title = "품목코드|품목명|규격|단위|*출고수량|*차량번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|예산부서 코드|계정코드";
			headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|BUDGET_DEPT_CODE|ACCOUNT_TYPE";	
		} else if("TYPE8".equals(excelType)){ // 차파트너스
			docu_name = "차파트너스양식.xls";
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			title = "*품목코드|품목명|규격|단위|*출고수량|*차량번호";
			headers = "BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE";
		} else if("TYPE9".equals(excelType)){
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			title = "고객사|상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|계정|세금|";
			headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|PR_REF_PR_NO3|PR_REF_PR_NO4|";
		} else if("TYPE10".equals(excelType)){
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			title = "고객사|송장번호|순번|Vendor code|Supplier|품목코드|품목군|품목명|규격|제조사|송장수량|단위|단가|원산지|Currency|총금액|선입고|긴급발주|주문번호|주문번호항번|발주번호|발주번호항번|총발주수량|관리번호|주문일|배송희망일|납품예정일|배송상태|납품일|배송기사 이름|배송기사 전화번호|배송차량 번호|택배사|택배송장번호|주문기입고수량|발주자|요청부서|요청자(한글)|요청자(영문)|요청자(Email)|요청자 전화번호|ASN전송일자|";
			headers = "COM_NAME_LOC|INV_NO|INV_SEQ|ASN_VENDOR_CODE|AGENT_NAME|BUYER_ITEM_NO|CATEG_NAME|DESCRIPTION|SPECIFICATION|MAKER_NAME|INV_QTY|UNIT_MEASURE|UNIT_PRICE|ORIGIN_NAME|CUR|PO_TTL_AMT|PRE_GR_YN|FAST_PO_YN|PR_NO|PR_SEQ|PO_NO|PO_SEQ|PO_QTY|REF_PR_NO|PO_CREATE_DATE|RD_DATE|CD_DATE|STATUS_TEXT|INVOICE_DATE|DELIVERY_PERSON_NAME|DELIVERY_PERSON_PHONE|DELIVERY_CAR_NO|PARCEL_COM_NAME|PARCEL_INV_NO|GR_QTY|PO_CREATOR|REQ_DEPT_NAME|ADD_USER_NAME|ADD_USER_NAME_ENG|ADD_USER_EMAIL|ADD_USER_TEL|TODAY_DATE|";
		} else if("TYPE11".equals(excelType)){
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			title = "고객사|상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|회계단위|원가|코스트센터|계정|프로젝트코드|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|특이사항|품목비고|요청자|도착지|";
			headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|PR_REF_PR_NO0|PR_REF_PR_NO1|PR_REF_PR_NO2|PR_REF_PR_NO3|PR_REF_PR_NO4|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|PH_REMARK|PO_REMARK|PR_USER_NAME|DELY_TO_LOCATION|";
		} else if("TYPE11_2".equals(excelType)){
			_data = buyerWmGrWarehousingLisService.getHLCList(pMap);
			
			docu_name = "ERP업로드양식.xls";
			title = "ROW_ID|ROW_NO|NO_TAX|CD_PC|CD_WDEPT|NO_DOCU|NO_DOLINE|CD_COMPANY|ID_WRITE|CD_DOCU|DT_ACCT|ST_DOCU|TP_DRCR|CD_ACCT|AMT|CD_PARTNER|DT_START|DT_END|AM_TAXSTD|AM_ADDTAX|TP_TAX|NO_COMPANY|NM_NOTE|CD_BIZAREA|CD_DEPT|CD_CC|CD_PJT|CD_FUND|CD_BUDGET|NO_CASH|ST_MUTUAL|CD_CARD|NO_DEPOSIT|CD_BANK|UCD_MNG1|UCD_MNG2|UCD_MNG3|UCD_MNG4|UCD_MNG5|CD_EMPLOY|CD_MNG|NO_BDOCU|NO_BDOLINE|TP_DOCU|NO_ACCT|TP_TRADE|NO_CHECK3|NO_CHECK4|CD_EXCH|RT_EXCH|CD_TRADE|AM_EX|TP_EXPORT|NO_TO|DT_SHIPPING|TP_GUBUN|NO_INVOICE|NO_ITEM|MD_TAX1|NM_ITEM1|NM_SIZE1|QT_TAX1|AM_PRC1|AM_SUPPLY1|AM_TAX1|NM_NOTE1|CD_BIZPLAN|CD_BGACCT|CD_MNGD1|NM_MNGD1|CD_MNGD2|NM_MNGD2|CD_MNGD3|NM_MNGD3|CD_MNGD4|NM_MNGD4|CD_MNGD5|NM_MNGD5|CD_MNGD6|NM_MNGD6|CD_MNGD7|NM_MNGD7|CD_MNGD8|NM_MNGD8|YN_ISS|FINAL_STATUS|NO_BILL|NM_BIGO|TP_BILL|TP_RECORD|TP_ETCACCT|ST_GWARE|SELL_DAM_NM|SELL_DAM_EMAIL|SELL_DAM_MOBIL|SELL_DAM_TEL|NM_PUMM|JEONJASEND15_YN|DT_WRITE|ST_TAX|MD_TAX2|NM_ITEM2|NM_SIZE2|QT_TAX2|AM_PRC2|AM_SUPPLY2|AM_TAX2|NM_NOTE2|MD_TAX3|NM_ITEM3|NM_SIZE3|QT_TAX3|AM_PRC3|AM_SUPPLY3|AM_TAX3|NM_NOTE3|MD_TAX4|NM_ITEM4|NM_SIZE4|QT_TAX4|AM_PRC4|AM_SUPPLY4|AM_TAX4|NM_NOTE4|NM_PTR|EX_HP|EX_EMIL|NO_BIZTAX|NO_ASSET|TP_EVIDENCE|NO_CAR|NO_CARBODY|CD_BIZCAR|NM_PARTNER|YN_IMPORT|YN_FIXASSET|";
			headers = "ROW_ID|ROW_NO|NO_TAX|CD_PC|CD_WDEPT|NO_DOCU|NO_DOLINE|CD_COMPANY|ID_WRITE|CD_DOCU|DT_ACCT|ST_DOCU|TP_DRCR|CD_ACCT|AMT|CD_PARTNER|DT_START|DT_END|AM_TAXSTD|AM_ADDTAX|TP_TAX|NO_COMPANY|NM_NOTE|CD_BIZAREA|CD_DEPT|CD_CC|CD_PJT|CD_FUND|CD_BUDGET|NO_CASH|ST_MUTUAL|CD_CARD|NO_DEPOSIT|CD_BANK|UCD_MNG1|UCD_MNG2|UCD_MNG3|UCD_MNG4|UCD_MNG5|CD_EMPLOY|CD_MNG|NO_BDOCU|NO_BDOLINE|TP_DOCU|NO_ACCT|TP_TRADE|NO_CHECK3|NO_CHECK4|CD_EXCH|RT_EXCH|CD_TRADE|AM_EX|TP_EXPORT|NO_TO|DT_SHIPPING|TP_GUBUN|NO_INVOICE|NO_ITEM|MD_TAX1|NM_ITEM1|NM_SIZE1|QT_TAX1|AM_PRC1|AM_SUPPLY1|AM_TAX1|NM_NOTE1|CD_BIZPLAN|CD_BGACCT|CD_MNGD1|NM_MNGD1|CD_MNGD2|NM_MNGD2|CD_MNGD3|NM_MNGD3|CD_MNGD4|NM_MNGD4|CD_MNGD5|NM_MNGD5|CD_MNGD6|NM_MNGD6|CD_MNGD7|NM_MNGD7|CD_MNGD8|NM_MNGD8|YN_ISS|FINAL_STATUS|NO_BILL|NM_BIGO|TP_BILL|TP_RECORD|TP_ETCACCT|ST_GWARE|SELL_DAM_NM|SELL_DAM_EMAIL|SELL_DAM_MOBIL|SELL_DAM_TEL|NM_PUMM|JEONJASEND15_YN|DT_WRITE|ST_TAX|MD_TAX2|NM_ITEM2|NM_SIZE2|QT_TAX2|AM_PRC2|AM_SUPPLY2|AM_TAX2|NM_NOTE2|MD_TAX3|NM_ITEM3|NM_SIZE3|QT_TAX3|AM_PRC3|AM_SUPPLY3|AM_TAX3|NM_NOTE3|MD_TAX4|NM_ITEM4|NM_SIZE4|QT_TAX4|AM_PRC4|AM_SUPPLY4|AM_TAX4|NM_NOTE4|NM_PTR|EX_HP|EX_EMIL|NO_BIZTAX|NO_ASSET|TP_EVIDENCE|NO_CAR|NO_CARBODY|CD_BIZCAR|NM_PARTNER|YN_IMPORT|YN_FIXASSET|";
		} else if("TYPE12".equals(excelType)){
			_data = buyerWmGrWarehousingLisService.getList(pMap);
			
			docu_name = "마감데이터양식.xls";
			title = "회사코드|변경주문일자|주문번호|주문항번|변경입고일자|입고번호|품목코드|통화키|주문수량|판매단가|판매금액|주문자명|인수자명|공급업체또는채권자의계정번호|부서코드|코스트센터|자금관리센터|계정|WBS|품의URL|";
			headers = "회사코드|변경주문일자|주문번호|주문항번|변경입고일자|입고번호|품목코드|통화키|주문수량|판매단가|판매금액|주문자명|인수자명|공급업체또는채권자의계정번호|부서코드|코스트센터|자금관리센터|계정|WBS|품의URL|";
		} else if("TYPE13".equals(excelType)){	// 깨끗한나라 ERP양식
				_data = buyerWmGrWarehousingLisService.getList(pMap);
				
				docu_name = "ERP업로드양식.xls";
				title = "주문품목번호|주문상태명|상품ID|상품명|대표규격|주문수량|판매단위|판매단가|총금액|부가세액|부서코드|부서명|주문자명|배송메모|수령자명|주문생성일자|SO생성일자|배송완료일자|비용이체부서코드|비용이체부서명|계정코드|계정명|귀속부서코드|귀속부서명|고객사참조코드1|고객사참조코드명1|플랜트||구매사유(상품별)|";
				headers = "PO_NO_SEQ|GR_STATUS|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|ITEM_QTY|UNIT_MEASURE|UNIT_PRICE|ITEM_AMT|TAX_AMT|REQ_DEPT|REQ_DEPT_NAME|REQ_USER_NAME|PO_REMARK|RECIPIENT_NAME|PR_ADD_DATE|PO_ADD_DATE|DELIVERY_DATE|REQ_DEPT2|REQ_DEPT_NAME2|ACCOUNT_CODE|ACCOUNT_NAME|REQ_DEPT3|REQ_DEPT_NAME3|COST_CENTER_CODE|COST_CENTER_NAME|PLANT|NULL_VALUE1|NULL_VALUE2|";
		} else {
			if(p060000080.equals("TYPE1")){
				_data = buyerWmGrWarehousingLisService.getList(pMap);
				
				title = "상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|수량|길이|";
				headers = "GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|SIZE_QTY|SIZE_LEN|";				
			}else{
				_data = buyerWmGrWarehousingLisService.getList(pMap);
				
				title = "고객사|상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|특이사항|품목비고|요청자|도착지|";
				headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|PH_REMARK|PO_REMARK|PR_USER_NAME|DELY_TO_LOCATION|";				
			}
		}
		
		// 품목별 도착지가 설정된 경우 엑셀에 수령자 정보 추가
		String p060000100 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000100","COL01_DATA");
		if(!p060000100.isEmpty()) {
			title = title + "수령자|";
			headers = headers + "REQ_USER_INFO|";
		}
		
		if("TYPE6".equals(excelType)){ // 대한제분 그룹사 ERP업로드 양식  (KRWOOR0059, KRDH-V0001, KRBONA0001, KRVITI0001, KRDNB-0001) 헤더 2줄 사용
			String excelHeader = title + "@@" + title2 + "@@" + headers;
			CommonUtil.downloadExcel2Headers(_data, response, outputStream, excelHeader, docu_name);
		}else{
			String excelHeader = title + "@@" + headers;
			CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, docu_name);
		}
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingLisList_v2.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingLisList_v2(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		logger.debug("/wmgr/excelBuyerWmGrWarehousingLisList_v2.do 요청 파라미터 for jsp : {}", pMap);

		// 조회일 슬래시 제거
		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String, String>> _data = null;
	   	
		String excelType = CommonUtil.nvl((String)pMap.get("st_excel_type"));
		String title = "";
		String title2 = "";
		String headers = "";
		String docu_name = "입고현황.xls";
//			logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size()+"///"+excelType);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String p060000080 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000080","COL01_DATA");
		
		Map<String,String> param = new HashMap<String, String>();
		for(Map.Entry<String, Object> entry : pMap.entrySet()){
			param.put(entry.getKey(), (String)entry.getValue() == null ? null : (String)entry.getValue());
		}
		
		_data = buyerWmGrWarehousingLisService.getBuyerWmGrWarehousingLisList_v2(pMap);
		if("TYPE1".equals(excelType)){
			title = "상태|발주일|발주번호|입고번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청자|요청부서코드|카테고리ID|Category_TEXT|COST_CENTER_TEXT|ACCOUNT_TEXT|결재자|상신내용|";
			headers = "GR_STATUS|PO_CREATE_DATE|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|ITEM_QTY1|GR_DATE|PURCHASER_NAME|AGENT_NAME|REQ_DEPT_NAME|REQ_USER_NAME|CHANGE_USER_DEPT|CATEG_ID|PLANT_TEXT|COST_CENTER_TEXT|ACCOUNT_TEXT|PASS_USER_NM|PASS_DOC_NM|";
		} else if("TYPE2".equals(excelType)){
			title = "소속|요구인|업체명|발의일|주문일|납품기한|납품일|품목명|규격|단위|수량|단가|상태|발주번호|입고번호|품목코드|관리번호|발주수량|입고금액|총입고수량|발주자|요청부서코드|카테고리ID|예산부서|계정명|카테고리명|기존/신규 구분|송장번호|";
			headers = "REQ_DEPT_NAME|REQ_USER_NAME|AGENT_NAME|PO_CREATE_DATE|PO_CREATE_DATE|RD_DATE|GR_DATE|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|ITEM_QTY|UNIT_PRICE|GR_STATUS|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|ITEM_QTY1|ITEM_AMT|GR_QTY|PURCHASER_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|";
		}  else if("TYPE4".equals(excelType)){
			title = "고객사|상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|귀속부서|관장부서|계정|세금|";
			headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|PR_REF_PR_NO1|PR_REF_PR_NO2|PR_REF_PR_NO3|PR_REF_PR_NO4|";
		}  else if("TYPE6".equals(excelType)){ // 대한제분 그룹사 ERP업로드 양식  (KRWOOR0059, KRDH-V0001, KRBONA0001, KRVITI0001, KRDNB-0001)
			title = "CD_PLANT|CD_PARTNER|CD_ITEM|DT_LIMIT|QT_PO|UM_EX_PO|AM_EX|DC2|CD_SL|CD_CC|CD_EXCH|CD_TPPO|FG_UM|CD_PJT|";
			title2 = "공장|거래처|품목코드|납기일|입고량|단가|금액|비고2|창고|CC|환정보|발주형태|단가유형|프로젝트코드|";
			headers = "CD_PLANT|CD_PARTNER|CD_ITEM|DT_LIMIT|QT_PO|UM_EX_PO|AM_EX|DC2|CD_SL|CD_CC|CD_EXCH|CD_TPPO|FG_UM|CD_PJT|";
			docu_name = "ERP다운로드.xls";
		} else if("TYPE7".equals(excelType)){ // 한화에어로스페이스 외 3개 (KRWOOR0059, KRDH-V0001, KRBONA0001, KRVITI0001, KRDNB-0001)
			title = "품목코드|품목명|규격|단위|*출고수량|*차량번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|예산부서 코드|계정코드";
			headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|BUDGET_DEPT_CODE|ACCOUNT_TYPE";	
		}  else if("TYPE11".equals(excelType)){
			title = "고객사|상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|회계단위|원가|코스트센터|계정|프로젝트코드|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|특이사항|품목비고|요청자|도착지|";
			headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|PR_REF_PR_NO0|PR_REF_PR_NO1|PR_REF_PR_NO2|PR_REF_PR_NO3|PR_REF_PR_NO4|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|PH_REMARK|PO_REMARK|PR_USER_NAME|DELY_TO_LOCATION|";
		} else if("TYPE14".equals(excelType)){ // 종근당 계열 등 - 기본 서식 + 예산코드/계정코드 + 제조사/모델번호
			title = "고객사|상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|특이사항|품목비고|요청자|도착지|예산코드|계정코드|입고자|제조사|모델번호|";
			headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|PH_REMARK|PO_REMARK|PR_USER_NAME|DELY_TO_LOCATION|BUDGET_DEPT_CODE|ACCOUNT_TYPE|GR_ADD_USER_NAME|MAKER_NAME|MODEL_NO|";
		} else if("TYPE11_2".equals(excelType)){
			_data = buyerWmGrWarehousingLisService.getHLCList(param);

			docu_name = "ERP업로드양식.xls";
			title = "ROW_ID|ROW_NO|NO_TAX|CD_PC|CD_WDEPT|NO_DOCU|NO_DOLINE|CD_COMPANY|ID_WRITE|CD_DOCU|DT_ACCT|ST_DOCU|TP_DRCR|CD_ACCT|AMT|CD_PARTNER|DT_START|DT_END|AM_TAXSTD|AM_ADDTAX|TP_TAX|NO_COMPANY|NM_NOTE|CD_BIZAREA|CD_DEPT|CD_CC|CD_PJT|CD_FUND|CD_BUDGET|NO_CASH|ST_MUTUAL|CD_CARD|NO_DEPOSIT|CD_BANK|UCD_MNG1|UCD_MNG2|UCD_MNG3|UCD_MNG4|UCD_MNG5|CD_EMPLOY|CD_MNG|NO_BDOCU|NO_BDOLINE|TP_DOCU|NO_ACCT|TP_TRADE|NO_CHECK3|NO_CHECK4|CD_EXCH|RT_EXCH|CD_TRADE|AM_EX|TP_EXPORT|NO_TO|DT_SHIPPING|TP_GUBUN|NO_INVOICE|NO_ITEM|MD_TAX1|NM_ITEM1|NM_SIZE1|QT_TAX1|AM_PRC1|AM_SUPPLY1|AM_TAX1|NM_NOTE1|CD_BIZPLAN|CD_BGACCT|CD_MNGD1|NM_MNGD1|CD_MNGD2|NM_MNGD2|CD_MNGD3|NM_MNGD3|CD_MNGD4|NM_MNGD4|CD_MNGD5|NM_MNGD5|CD_MNGD6|NM_MNGD6|CD_MNGD7|NM_MNGD7|CD_MNGD8|NM_MNGD8|YN_ISS|FINAL_STATUS|NO_BILL|NM_BIGO|TP_BILL|TP_RECORD|TP_ETCACCT|ST_GWARE|SELL_DAM_NM|SELL_DAM_EMAIL|SELL_DAM_MOBIL|SELL_DAM_TEL|NM_PUMM|JEONJASEND15_YN|DT_WRITE|ST_TAX|MD_TAX2|NM_ITEM2|NM_SIZE2|QT_TAX2|AM_PRC2|AM_SUPPLY2|AM_TAX2|NM_NOTE2|MD_TAX3|NM_ITEM3|NM_SIZE3|QT_TAX3|AM_PRC3|AM_SUPPLY3|AM_TAX3|NM_NOTE3|MD_TAX4|NM_ITEM4|NM_SIZE4|QT_TAX4|AM_PRC4|AM_SUPPLY4|AM_TAX4|NM_NOTE4|NM_PTR|EX_HP|EX_EMIL|NO_BIZTAX|NO_ASSET|TP_EVIDENCE|NO_CAR|NO_CARBODY|CD_BIZCAR|NM_PARTNER|YN_IMPORT|YN_FIXASSET|";
			headers = "ROW_ID|ROW_NO|NO_TAX|CD_PC|CD_WDEPT|NO_DOCU|NO_DOLINE|CD_COMPANY|ID_WRITE|CD_DOCU|DT_ACCT|ST_DOCU|TP_DRCR|CD_ACCT|AMT|CD_PARTNER|DT_START|DT_END|AM_TAXSTD|AM_ADDTAX|TP_TAX|NO_COMPANY|NM_NOTE|CD_BIZAREA|CD_DEPT|CD_CC|CD_PJT|CD_FUND|CD_BUDGET|NO_CASH|ST_MUTUAL|CD_CARD|NO_DEPOSIT|CD_BANK|UCD_MNG1|UCD_MNG2|UCD_MNG3|UCD_MNG4|UCD_MNG5|CD_EMPLOY|CD_MNG|NO_BDOCU|NO_BDOLINE|TP_DOCU|NO_ACCT|TP_TRADE|NO_CHECK3|NO_CHECK4|CD_EXCH|RT_EXCH|CD_TRADE|AM_EX|TP_EXPORT|NO_TO|DT_SHIPPING|TP_GUBUN|NO_INVOICE|NO_ITEM|MD_TAX1|NM_ITEM1|NM_SIZE1|QT_TAX1|AM_PRC1|AM_SUPPLY1|AM_TAX1|NM_NOTE1|CD_BIZPLAN|CD_BGACCT|CD_MNGD1|NM_MNGD1|CD_MNGD2|NM_MNGD2|CD_MNGD3|NM_MNGD3|CD_MNGD4|NM_MNGD4|CD_MNGD5|NM_MNGD5|CD_MNGD6|NM_MNGD6|CD_MNGD7|NM_MNGD7|CD_MNGD8|NM_MNGD8|YN_ISS|FINAL_STATUS|NO_BILL|NM_BIGO|TP_BILL|TP_RECORD|TP_ETCACCT|ST_GWARE|SELL_DAM_NM|SELL_DAM_EMAIL|SELL_DAM_MOBIL|SELL_DAM_TEL|NM_PUMM|JEONJASEND15_YN|DT_WRITE|ST_TAX|MD_TAX2|NM_ITEM2|NM_SIZE2|QT_TAX2|AM_PRC2|AM_SUPPLY2|AM_TAX2|NM_NOTE2|MD_TAX3|NM_ITEM3|NM_SIZE3|QT_TAX3|AM_PRC3|AM_SUPPLY3|AM_TAX3|NM_NOTE3|MD_TAX4|NM_ITEM4|NM_SIZE4|QT_TAX4|AM_PRC4|AM_SUPPLY4|AM_TAX4|NM_NOTE4|NM_PTR|EX_HP|EX_EMIL|NO_BIZTAX|NO_ASSET|TP_EVIDENCE|NO_CAR|NO_CARBODY|CD_BIZCAR|NM_PARTNER|YN_IMPORT|YN_FIXASSET|";
		} else if("TYPE12".equals(excelType)){
			docu_name = "마감데이터양식.xls";
			title = "회사코드|변경주문일자|주문번호|주문항번|변경입고일자|입고번호|품목코드|통화키|주문수량|판매단가|판매금액|주문자명|인수자명|공급업체또는채권자의계정번호|부서코드|코스트센터|자금관리센터|계정|WBS|품의URL|";
			headers = "회사코드|변경주문일자|주문번호|주문항번|변경입고일자|입고번호|품목코드|통화키|주문수량|판매단가|판매금액|주문자명|인수자명|공급업체또는채권자의계정번호|부서코드|코스트센터|자금관리센터|계정|WBS|품의URL|";
		} else if("TYPE13".equals(excelType)){	// 깨끗한나라 ERP양식
			docu_name = "ERP업로드양식.xls";
			title = "주문품목번호|주문상태명|상품ID|상품명|대표규격|주문수량|판매단위|판매단가|총금액|부가세액|부서코드|부서명|주문자명|배송메모|수령자명|주문생성일자|SO생성일자|배송완료일자|비용이체부서코드|비용이체부서명|계정코드|계정명|귀속부서코드|귀속부서명|고객사참조코드1|고객사참조코드명1|플랜트||구매사유(상품별)|";
			headers = "PO_NO_SEQ|GR_STATUS|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|ITEM_QTY|UNIT_MEASURE|UNIT_PRICE|ITEM_AMT|TAX_AMT|REQ_DEPT|REQ_DEPT_NAME|REQ_USER_NAME|PO_REMARK|RECIPIENT_NAME|PR_ADD_DATE|PO_ADD_DATE|DELIVERY_DATE|REQ_DEPT2|REQ_DEPT_NAME2|ACCOUNT_CODE|ACCOUNT_NAME|REQ_DEPT3|REQ_DEPT_NAME3|COST_CENTER_CODE|COST_CENTER_NAME|PLANT|NULL_VALUE1|NULL_VALUE2|";
		} else {
			if(p060000080.equals("TYPE1")){
				title = "상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|수량|길이|";
				headers = "GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|SIZE_QTY|SIZE_LEN|";				
			}else{
				title = "고객사|상태|발주일|주문번호|발주번호|입고번호|품목코드|관리번호|품목명|규격|단위|발주수량|단가|입고금액|총입고수량|입고수량|입고일|발주자|협력사|요청부서|요청부서코드|카테고리ID|예산부서|계정명|요청자명|카테고리명|기존/신규 구분|송장번호|특이사항|품목비고|요청자|도착지|";
				headers = "COM_NAME_LOC|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|GR_NO|BUYER_ITEM_NO|REF_PR_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_QTY|GR_ITEM_QTY|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|CHANGE_USER_DEPT|CATEG_ID|BUDGET_DEPT|ACCOUNT_NAME|ADD_USER_NAME|CATEG_NAME|SO_CA_GUBUN|INV_NO|PH_REMARK|PO_REMARK|PR_USER_NAME|DELY_TO_LOCATION|";				
			}
		}
		
		// 품목별 도착지가 설정된 경우 엑셀에 수령자 정보 추가
		String p060000100 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000100","COL01_DATA");
		if(!p060000100.isEmpty()) {
			title = title + "수령자|";
			headers = headers + "REQ_USER_INFO|";
		}
		
		if("TYPE6".equals(excelType)){ // 대한제분 그룹사 ERP업로드 양식  (KRWOOR0059, KRDH-V0001, KRBONA0001, KRVITI0001, KRDNB-0001) 헤더 2줄 사용
			String excelHeader = title + "@@" + title2 + "@@" + headers;
			CommonUtil.downloadExcel2Headers(_data, response, outputStream, excelHeader, docu_name);
		}else{
			String excelHeader = title + "@@" + headers;
			CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, docu_name);
		}
	}
	
	// 마감 EXCEL 다운로드	
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingLisCloseList.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingLisCloseList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {

		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerWmGrWarehousingLisService.getCloseExcelList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		   
		String closeexcelType = CommonUtil.nvl(pMap.get("st_close_excel_type"));
		String title = "";
		String headers = "";
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		String p060000080 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000080","COL01_DATA");
		if("TYPE2".equals(closeexcelType)){
			title = "항목|입고일자|코스트센터|계정|예산부서|자재번호|자재내역|수량|금액|요청부서|요청자|구매담당자|세금계산서구분|";	//6
			
			headers = "RNUM|GR_DATE|CC_DEPT|ACCOUNT_TYPE|BUDGET_DEPT|BUYER_ITEM_NO|DESCRIPTION|ITEM_QTY|ITEM_AMT|ADD_USER_DEPT|ADD_USER_ID|PURCHASER_ID|BILL_FLAG|";
		} else {
			if(p060000080.equals("TYPE1")){
				//수량, 길이 추가 보여주도록
				title = "F_NO|청구일자|청구번호|담당자|발주번호|계산서번호|입고일자|발주업체|발주업체명|입고수량|입고단가|입고금액|단위|처리계정|계정과목|";	//15
				title += "부가세|적요|계산서일자|처리내역|전표발생일|처리_촤|IMSI_1|VAT_1|품목코드|품명|수불처리|관리항목1|관리항목2|관리항목3|관리항목4|";	//15
				title += "관리항목5|관리항목6|관리항목7|관리항목8|관리항목9|관리항목10|관리구분1|관리구분2|관리구분3|관리구분4|관리구분5|관리구분6|관리구분7|관리구분8|관리구분9|관리구분10|";	//16
				title += "항목명1|항목명2|항목명3|항목명4|항목명5|항목명6|항목명7|항목명8|항목명9|항목명10|현금영수증|승인번호|연구과제코드|연구과제명|수량|길이|";	//14
				
				headers = "F_NO|ADD_DATE|PR_NO|LEGACY_USER_ID|PO_NO|BILL_NO|GR_DATE|IRS_NO|IRS_NO_NAME|ITEM_QTY|UNIT_PRICE|ITEM_AMT|UNIT_MEASURE|PROCESS_ACCOUNT|ACCOUNT_TYPE|";
				headers += "VAT_AMT|REMARK|BILL_DATE|PROCESS_HISTORY|BILL_CREATE_DATE|PROCESS_1|IMSI_1|VAT_1|BUYER_ITEM_NO|DESCRIPTION|RECEIPTS_DIS|MG_ITEM1|MG_ITEM2|MG_ITEM3|MG_ITEM4|";
				headers += "MG_ITEM5|MG_ITEM6|MG_ITEM7|MG_ITEM8|MG_ITEM9|MG_ITEM10|MG_GUBUN1|MG_GUBUN2|MG_GUBUN3|MG_GUBUN4|MG_GUBUN5|MG_GUBUN6|MG_GUBUN7|MG_GUBUN8|MG_GUBUN9|MG_GUBUN10|";
				headers += "ITEM_NAME1|ITEM_NAME2|ITEM_NAME3|ITEM_NAME4|ITEM_NAME5|ITEM_NAME6|ITEM_NAME7|ITEM_NAME8|ITEM_NAME9|ITEM_NAME10|CASH_RECEIPT|APPROVAL_NO|RESEARCH_CODE|RESEARCH_NAME|SIZE_QTY|SIZE_LEN|";				
			}else{
				title = "F_NO|청구일자|청구번호|담당자|발주번호|계산서번호|입고일자|발주업체|발주업체명|입고수량|입고단가|입고금액|단위|처리계정|계정과목|";	//15
				title += "부가세|적요|계산서일자|처리내역|전표발생일|처리_촤|IMSI_1|VAT_1|품목코드|품명|수불처리|관리항목1|관리항목2|관리항목3|관리항목4|";	//15
				title += "관리항목5|관리항목6|관리항목7|관리항목8|관리항목9|관리항목10|관리구분1|관리구분2|관리구분3|관리구분4|관리구분5|관리구분6|관리구분7|관리구분8|관리구분9|관리구분10|";	//16
				title += "항목명1|항목명2|항목명3|항목명4|항목명5|항목명6|항목명7|항목명8|항목명9|항목명10|현금영수증|승인번호|연구과제코드|연구과제명|";	//14
				
				headers = "F_NO|ADD_DATE|PR_NO|LEGACY_USER_ID|PO_NO|BILL_NO|GR_DATE|IRS_NO|IRS_NO_NAME|ITEM_QTY|UNIT_PRICE|ITEM_AMT|UNIT_MEASURE|PROCESS_ACCOUNT|ACCOUNT_TYPE|";
				headers += "VAT_AMT|REMARK|BILL_DATE|PROCESS_HISTORY|BILL_CREATE_DATE|PROCESS_1|IMSI_1|VAT_1|BUYER_ITEM_NO|DESCRIPTION|RECEIPTS_DIS|MG_ITEM1|MG_ITEM2|MG_ITEM3|MG_ITEM4|";
				headers += "MG_ITEM5|MG_ITEM6|MG_ITEM7|MG_ITEM8|MG_ITEM9|MG_ITEM10|MG_GUBUN1|MG_GUBUN2|MG_GUBUN3|MG_GUBUN4|MG_GUBUN5|MG_GUBUN6|MG_GUBUN7|MG_GUBUN8|MG_GUBUN9|MG_GUBUN10|";
				headers += "ITEM_NAME1|ITEM_NAME2|ITEM_NAME3|ITEM_NAME4|ITEM_NAME5|ITEM_NAME6|ITEM_NAME7|ITEM_NAME8|ITEM_NAME9|ITEM_NAME10|CASH_RECEIPT|APPROVAL_NO|RESEARCH_CODE|RESEARCH_NAME|";				
			}
		}
				
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "입고마감조회.xls");	
		
	}
	// 관리번호별 집계
	@RequestMapping(value = "/wmgr/getBuyerWmGrRefTotalList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerWmGrRefTotalList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) { 	
		
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		List<Map<String, String>> _data = buyerWmGrWarehousingLisService.getRefTotalList(pMap); 		
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAllAttributes(pMap);
		
		return "buyer/wmgr/buyerWmGrWarehousingRefTotalPop";
	}
}
