package com.koreab2b.mro.buyer.mpso.controller;

import java.io.OutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderProgressService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoOrderProgressController")
public class BuyerMpSoOrderProgressController {
 

	@Autowired
	private BuyerMpSoOrderProgressService buyerMpSoOrderProgressService;
	
	// 조회 PG_06_B_014_00
	@RequestMapping(value = "/mpso/getBuyerMpSoOrderProgressList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoOrderProgressList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpso/getBuyerMpSoOrderProgressList.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_com_code",_sessionInfo.getComCode());
		//pMap.put("st_user_dept",_sessionInfo.getDepartment()); 
		String row_cnt = _sessionInfo.getRowCnt();
		String st_unit_part =  CommonUtil.onvl(pMap.get("st_unit_part") ,"ST_USER_ID");

		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,row_cnt) );
		pMap.put("fromDate", CommonUtil.onvl(pMap.get("fromDate") ,CommonUtil.addDate(new Date(),"M",-1,1)) );
		pMap.put("toDate", CommonUtil.onvl(pMap.get("toDate") ,CommonUtil.formatDateNoDateGubun(new Date(),1)) );
		pMap.put("st_pr_no", CommonUtil.onvl(pMap.get("st_pr_no") ,"") );		
		pMap.put("st_ref_no", CommonUtil.onvl(pMap.get("st_ref_no") ,"") );		
		pMap.put("st_search_no", CommonUtil.onvl(pMap.get("st_search_no") ,"") );
		pMap.put("st_search_type", CommonUtil.onvl(pMap.get("st_search_type") ,"") );		
		pMap.put("st_status", CommonUtil.onvl(pMap.get("st_status") ,"ALL") );
		pMap.put("st_sortType", CommonUtil.onvl(pMap.get("st_sortType") ,"DESC") ); 
		pMap.put("st_unit_part",st_unit_part);
		pMap.put("st_legacy_po_no", CommonUtil.onvl(pMap.get("st_legacy_po_no") ,"") );
		pMap.put("st_pur_user_id", CommonUtil.onvl(pMap.get("st_pur_user_id") ,"") );
		pMap.put("st_pur_user_name", CommonUtil.onvl(pMap.get("st_pur_user_name") ,"") );
		pMap.put("st_pur_dept_code", CommonUtil.onvl(pMap.get("st_pur_dept_code") ,"") );
		pMap.put("st_pur_dept_name", CommonUtil.onvl(pMap.get("st_pur_dept_name") ,"") );
		pMap.put("st_pr_mng_flag",_sessionInfo.getPrMngFlag());
		pMap.put("st_p060000114", CommonUtil.onvl(pMap.get("st_p060000114") ,"") );
		if(!st_unit_part.equals("ALL")){
			if(st_unit_part.equals("ST_USER_ID")){
				pMap.put("st_userid",_sessionInfo.getUserId());
			}else{
				pMap.put("st_userid",st_unit_part);
			}
		}else{
			pMap.put("st_userid",_sessionInfo.getUserId());
		}
		
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpSoOrderProgressService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpso/buyerMpSoOrderProgressList";
	}
	
	@RequestMapping(value = "/mpso/getBuyerMpSoOrderProgressList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpSoOrderProgressList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//pMap.put("st_user_dept",_sessionInfo.getDepartment()); 
		String st_unit_part =  CommonUtil.onvl(pMap.get("st_unit_part") ,"ST_USER_ID");

		if(!st_unit_part.equals("ALL")){
			if(st_unit_part.equals("ST_USER_ID")){
				pMap.put("st_userid",_sessionInfo.getUserId());
			}else{
				pMap.put("st_userid",st_unit_part);
			}
		}else{
			pMap.put("st_userid",_sessionInfo.getUserId());
		}
		
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerMpSoOrderProgressService.getBuyerMpSoOrderProgressList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
 
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpso/excelBuyerMpSoOrderProgressList.do", method = RequestMethod.POST)
	public void excelBuyerMpSoOrderProgress(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpso/excelBuyerMpSoOrderProgressList.do 요청 파라미터 for jsp : {}", pMap);
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String p060000080 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000080","COL01_DATA");
		pMap.put("p060000080", p060000080);
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpSoOrderProgressService.getList(pMap);  

		String title = "";
		String headers = "";
		if(p060000080.equals("TYPE1")){
			title = "주문번호|관리번호|품목코드|주문일|품목명|규격|단가|금액|배송희망일|납품예정일|단위|사유|발주일|요청수량|발주수량|협력사|발주번호|배송상태|입고수량|배송확정수량|고객사코드|주문항번|발주항번|공급사코드|도착지|예산부서명|계정명|카드여부|카드승인번호|수량|길이|";
			headers = "PR_NO|REF_PR_NO|BUYER_ITEM_NO|ADD_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|ITEM_AMT|RD_DATE|CD_DATE|UNIT_MEASURE|RETURN_REASON|PO_CREATE_DATE|TARGET_QTY|ITEM_QTY|AGENT_TEXT|PO_NO|STATUS_TEXT|GR_QTY|DI_QTY|BUYER|PR_SEQ|PO_SEQ|AGENT_CODE|DELY_TO_LOCATION_TEXT|BUDGET_DEPT_NAME|ACCOUNT_TYPE_NAME|CARD_USE_FLAG|CARD_CONFIRM_NO|SIZE_QTY|SIZE_LEN|";			
		}else if(p060000080.equals("TYPE11")) {
			title = "주문번호|관리번호|회계단위|원가|코스트센터|계정|프로젝트코드|품목코드|주문일|품목명|규격|단가|금액|배송희망일|납품예정일|단위|사유|발주일|요청수량|발주수량|협력사|발주번호|배송상태|입고수량|배송확정수량|고객사코드|주문항번|발주항번|공급사코드|도착지|예산부서명|계정명|카드여부|카드승인번호|요청부서|요청자|발주부서|발주자|택배회사|운송장번호|품목별 비고|발주 도착지|";
			headers = "PR_NO|REF_PR_NO|HLC_REF_PR_NO0|HLC_REF_PR_NO1|HLC_REF_PR_NO2|HLC_REF_PR_NO3|HLC_REF_PR_NO4|BUYER_ITEM_NO|ADD_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|ITEM_AMT|RD_DATE|CD_DATE|UNIT_MEASURE|RETURN_REASON|PO_CREATE_DATE|TARGET_QTY|ITEM_QTY|AGENT_TEXT|PO_NO|STATUS_TEXT|GR_QTY|DI_QTY|BUYER|PR_SEQ|PO_SEQ|AGENT_CODE|DELY_TO_LOCATION_TEXT|BUDGET_DEPT_NAME|ACCOUNT_TYPE_NAME|CARD_USE_FLAG|CARD_CONFIRM_NO|REQ_USER_DEPT|REQ_USER_NAME|PURCHASER_DEPT|PURCHASER_NAME|PARCEL_COM_NAME|PARCEL_INV_NO|PO_REMARK|DELY_TO_LOCATION|";
		}else if(p060000080.equals("TYPE35")) {
			title = "주문번호|관리번호|실사용자사번|실사용자명|관리자사번|관리자명|사용자코스트센터|사용자코스트센터명|입고일|품목코드|주문일|품목명|규격|단가|금액|배송희망일|납품예정일|단위|사유|발주일|요청수량|발주수량|협력사|발주번호|배송상태|입고수량|배송확정수량|고객사코드|주문항번|발주항번|공급사코드|도착지|예산부서명|계정명|카드여부|카드승인번호|요청부서|요청자|발주부서|발주자|택배회사|운송장번호|품목별 비고|발주 도착지|";
			headers = "PR_NO|REF_PR_NO|REF_PR_NO0|REF_PR_NO1|REF_PR_NO2|REF_PR_NO3|REF_PR_NO4|REF_PR_NO5|GR_DATE|BUYER_ITEM_NO|ADD_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|ITEM_AMT|RD_DATE|CD_DATE|UNIT_MEASURE|RETURN_REASON|PO_CREATE_DATE|TARGET_QTY|ITEM_QTY|AGENT_TEXT|PO_NO|STATUS_TEXT|GR_QTY|DI_QTY|BUYER|PR_SEQ|PO_SEQ|AGENT_CODE|DELY_TO_LOCATION_TEXT|BUDGET_DEPT_NAME|ACCOUNT_TYPE_NAME|CARD_USE_FLAG|CARD_CONFIRM_NO|REQ_USER_DEPT|REQ_USER_NAME|PURCHASER_DEPT|PURCHASER_NAME|PARCEL_COM_NAME|PARCEL_INV_NO|PO_REMARK|DELY_TO_LOCATION|";
		}else{
			title = "주문번호|관리번호|품목코드|주문일|품목명|규격|제조사|단가|금액|배송희망일|납품예정일|단위|사유|발주일|요청수량|발주수량|협력사|발주번호|배송상태|입고수량|배송확정수량|고객사코드|주문항번|발주항번|공급사코드|도착지|예산부서명|계정명|카드여부|카드승인번호|요청부서|요청자|발주부서|발주자|택배회사|운송장번호|품목별 비고|발주 도착지|";
			headers = "PR_NO|REF_PR_NO|BUYER_ITEM_NO|ADD_DATE|DESCRIPTION|SPECIFICATION|MAKER_NAME|UNIT_PRICE|ITEM_AMT|RD_DATE|CD_DATE|UNIT_MEASURE|RETURN_REASON|PO_CREATE_DATE|TARGET_QTY|ITEM_QTY|AGENT_TEXT|PO_NO|STATUS_TEXT|GR_QTY|DI_QTY|BUYER|PR_SEQ|PO_SEQ|AGENT_CODE|DELY_TO_LOCATION_TEXT|BUDGET_DEPT_NAME|ACCOUNT_TYPE_NAME|CARD_USE_FLAG|CARD_CONFIRM_NO|REQ_USER_DEPT|REQ_USER_NAME|PURCHASER_DEPT|PURCHASER_NAME|PARCEL_COM_NAME|PARCEL_INV_NO|PO_REMARK|DELY_TO_LOCATION|";			
		}
		
		// 품목별 도착지가 설정된 경우 엑셀에 수령자 정보 추가
		String p060000100 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000100","COL01_DATA");
		if(!p060000100.isEmpty()) {
			title = title + "수령자|";
			headers = headers + "REQ_USER_INFO|";
		}

		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"주문진행현황.xls");
		 
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpso/excelBuyerMpSoOrderProgressList_v2.do", method = RequestMethod.POST)
	public void excelBuyerMpSoOrderProgressList_v2(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpso/excelBuyerMpSoOrderProgressList_v2.do 요청 파라미터 for jsp : {}", pMap);
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String p060000080 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000080","COL01_DATA");
		pMap.put("p060000080", p060000080);
		pMap = IBSheetUtil.removeSlash(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerMpSoOrderProgressService.getBuyerMpSoOrderProgressList_v2(pMap);

		String title = "";
		String headers = "";
		if(p060000080.equals("TYPE1")){
			title = "주문번호|관리번호|품목코드|주문일|품목명|규격|단가|금액|배송희망일|납품예정일|단위|사유|발주일|요청수량|발주수량|협력사|발주번호|배송상태|입고수량|배송확정수량|고객사코드|주문항번|발주항번|공급사코드|도착지|예산부서명|계정명|카드여부|카드승인번호|수량|길이|";
			headers = "PR_NO|REF_PR_NO|BUYER_ITEM_NO|ADD_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|ITEM_AMT|RD_DATE|CD_DATE|UNIT_MEASURE|RETURN_REASON|PO_CREATE_DATE|TARGET_QTY|ITEM_QTY|AGENT_TEXT|PO_NO|STATUS_TEXT|GR_QTY|DI_QTY|BUYER|PR_SEQ|PO_SEQ|AGENT_CODE|DELY_TO_LOCATION_TEXT|BUDGET_DEPT_NAME|ACCOUNT_TYPE_NAME|CARD_USE_FLAG|CARD_CONFIRM_NO|SIZE_QTY|SIZE_LEN|";			
		}else if(p060000080.equals("TYPE11")) {
			title = "주문번호|관리번호|회계단위|원가|코스트센터|계정|프로젝트코드|품목코드|주문일|품목명|규격|단가|금액|배송희망일|납품예정일|단위|사유|발주일|요청수량|발주수량|협력사|발주번호|배송상태|입고수량|배송확정수량|고객사코드|주문항번|발주항번|공급사코드|도착지|예산부서명|계정명|카드여부|카드승인번호|요청부서|요청자|발주부서|발주자|택배회사|운송장번호|품목별 비고|발주 도착지|";
			headers = "PR_NO|REF_PR_NO|HLC_REF_PR_NO0|HLC_REF_PR_NO1|HLC_REF_PR_NO2|HLC_REF_PR_NO3|HLC_REF_PR_NO4|BUYER_ITEM_NO|ADD_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|ITEM_AMT|RD_DATE|CD_DATE|UNIT_MEASURE|RETURN_REASON|PO_CREATE_DATE|TARGET_QTY|ITEM_QTY|AGENT_TEXT|PO_NO|STATUS_TEXT|GR_QTY|DI_QTY|BUYER|PR_SEQ|PO_SEQ|AGENT_CODE|DELY_TO_LOCATION_TEXT|BUDGET_DEPT_NAME|ACCOUNT_TYPE_NAME|CARD_USE_FLAG|CARD_CONFIRM_NO|REQ_USER_DEPT|REQ_USER_NAME|PURCHASER_DEPT|PURCHASER_NAME|PARCEL_COM_NAME|PARCEL_INV_NO|PO_REMARK|DELY_TO_LOCATION|";
		}else if(p060000080.equals("TYPE35")) {
			title = "주문번호|관리번호|실사용자사번|실사용자명|관리자사번|관리자명|사용자코스트센터|사용자코스트센터명|입고일|품목코드|주문일|품목명|규격|단가|금액|배송희망일|납품예정일|단위|사유|발주일|요청수량|발주수량|협력사|발주번호|배송상태|입고수량|배송확정수량|고객사코드|주문항번|발주항번|공급사코드|도착지|예산부서명|계정명|카드여부|카드승인번호|요청부서|요청자|발주부서|발주자|택배회사|운송장번호|품목별 비고|발주 도착지|";
			headers = "PR_NO|REF_PR_NO|REF_PR_NO0|REF_PR_NO1|REF_PR_NO2|REF_PR_NO3|REF_PR_NO4|REF_PR_NO5|GR_DATE|BUYER_ITEM_NO|ADD_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|ITEM_AMT|RD_DATE|CD_DATE|UNIT_MEASURE|RETURN_REASON|PO_CREATE_DATE|TARGET_QTY|ITEM_QTY|AGENT_TEXT|PO_NO|STATUS_TEXT|GR_QTY|DI_QTY|BUYER|PR_SEQ|PO_SEQ|AGENT_CODE|DELY_TO_LOCATION_TEXT|BUDGET_DEPT_NAME|ACCOUNT_TYPE_NAME|CARD_USE_FLAG|CARD_CONFIRM_NO|REQ_USER_DEPT|REQ_USER_NAME|PURCHASER_DEPT|PURCHASER_NAME|PARCEL_COM_NAME|PARCEL_INV_NO|PO_REMARK|DELY_TO_LOCATION|";
		}else{
			title = "주문번호|관리번호|품목코드|주문일|품목명|규격|제조사|단가|금액|배송희망일|납품예정일|단위|사유|발주일|요청수량|발주수량|협력사|발주번호|배송상태|입고수량|배송확정수량|고객사코드|주문항번|발주항번|공급사코드|도착지|예산부서명|계정명|카드여부|카드승인번호|요청부서|요청자|발주부서|발주자|택배회사|운송장번호|품목별 비고|발주 도착지|";
			headers = "PR_NO|REF_PR_NO|BUYER_ITEM_NO|ADD_DATE|DESCRIPTION|SPECIFICATION|MAKER_NAME|UNIT_PRICE|ITEM_AMT|RD_DATE|CD_DATE|UNIT_MEASURE|RETURN_REASON|PO_CREATE_DATE|TARGET_QTY|ITEM_QTY|AGENT_TEXT|PO_NO|STATUS_TEXT|GR_QTY|DI_QTY|BUYER|PR_SEQ|PO_SEQ|AGENT_CODE|DELY_TO_LOCATION_TEXT|BUDGET_DEPT_NAME|ACCOUNT_TYPE_NAME|CARD_USE_FLAG|CARD_CONFIRM_NO|REQ_USER_DEPT|REQ_USER_NAME|PURCHASER_DEPT|PURCHASER_NAME|PARCEL_COM_NAME|PARCEL_INV_NO|PO_REMARK|DELY_TO_LOCATION|";			
		}
		
		// 품목별 도착지가 설정된 경우 엑셀에 수령자 정보 추가
		String p060000100 =  CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000100","COL01_DATA");
		if(!p060000100.isEmpty()) {
			title = title + "수령자|";
			headers = headers + "REQ_USER_INFO|";
		}

		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"주문배송조회.xls");
		 
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpso/excelBuyerMpSoOrderPunchOutProgressList.do", method = RequestMethod.POST)
	public void excelBuyerMpSoOrderPunchOutProgressList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		String st_unit_part =  CommonUtil.onvl(pMap.get("st_unit_part") ,"ALL");
		String st_userid =  CommonUtil.onvl(pMap.get("st_userid") ,"");
		pMap.put("st_pr_no", CommonUtil.onvl(pMap.get("st_pr_no") ,"") );		
		pMap.put("st_ref_no", CommonUtil.onvl(pMap.get("st_ref_no") ,"") );		
		pMap.put("st_search_no", CommonUtil.onvl(pMap.get("st_search_no") ,"") );
		pMap.put("st_search_type", CommonUtil.onvl(pMap.get("st_search_type") ,"") );		
		pMap.put("st_status", CommonUtil.onvl(pMap.get("st_status") ,"ALL") );
		pMap.put("st_sortType", CommonUtil.onvl(pMap.get("st_sortType") ,"DESC") ); 
		pMap.put("st_unit_part",st_unit_part);
		pMap.put("st_legacy_po_no", CommonUtil.onvl(pMap.get("st_legacy_po_no") ,"") );
		
		if(!st_unit_part.equals("ALL")){
			if(st_unit_part.equals("ST_USER_ID")){
				pMap.put("st_userid",st_userid);
			}else{
				pMap.put("st_userid",st_unit_part);
			}
		}else{
			pMap.put("st_userid",st_userid);
		}
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpSoOrderProgressService.getList(pMap);  
		   

		String title = "발주번호|요청번호|품목코드|재고코드|주문일|품목명|규격|단가|금액|배송희망일|배송확정일|단위|사유|발주일|요청수량|발주수량|협력사|발주번호|배송상태|입고수량|배송확정수량|고객사코드|주문항번|발주항번|협력사코드|도착지청구자|";
		String headers = "LEGACY_PO_NO|REF_PR_NO|BUYER_ITEM_NO|DOOS_ITEM_NO|ADD_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|ITEM_AMT|RD_DATE|CD_DATE|UNIT_MEASURE|RETURN_REASON|PO_CREATE_DATE|TARGET_QTY|ITEM_QTY|AGENT_TEXT|PO_NO|STATUS_TEXT|GR_QTY|DI_QTY|BUYER|PR_SEQ|PO_SEQ|AGENT_CODE|DELY_TO_LOCATION_TEXT|ADD_USER_NAME|";

		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"주문진행현황.xls");
		 
	}
	
	/**
	 * 고객사 요청취소
	 */
	@RequestMapping(value = "/mpso/saveBuyerPrCancel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerPrCancel(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		String msg = buyerMpSoOrderProgressService.saveBuyerPrCancel(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}
