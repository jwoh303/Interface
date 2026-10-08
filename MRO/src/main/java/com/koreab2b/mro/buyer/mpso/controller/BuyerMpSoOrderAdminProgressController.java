package com.koreab2b.mro.buyer.mpso.controller;

import java.io.OutputStream;
import java.util.Date;
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

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderAdminProgressService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("BuyerMpSoOrderAdminProgressController")
public class BuyerMpSoOrderAdminProgressController {
 

	@Autowired
	private BuyerMpSoOrderAdminProgressService BuyerMpSoOrderAdminProgressService;
	
	// 조회 PG_06_B_014_00
	@RequestMapping(value = "/mpso/getBuyerMpSoOrderAdminProgressList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoOrderAdminProgressList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpso/getBuyerMpSoOrderAdminProgressList.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment()); 
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
		List<Map<String, String>> _data = BuyerMpSoOrderAdminProgressService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpso/buyerMpSoOrderAdminProgressList";
	}
	
 
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpso/excelBuyerMpSoOrderAdminProgressList.do", method = RequestMethod.POST)
	public void excelBuyerMpSoOrderAdminProgress(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		
		List<Map<String, String>> _data = BuyerMpSoOrderAdminProgressService.getExcelList(pMap);  
		   
		String title = "고객사|주문번호|요청번호|요청항번|품목코드|품목명|규격|단위|수량|단가|발주금액|발주일|납기요청일|입고일|입고수량|입고금액|협력사명|요청부서코드|요청부서|요청자명|대분류|중분류|소분류|";
		String headers = "COM_NAME_LOC|LEGACY_PO_NO|REF_PR_NO|REF_PR_SEQ|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|ITEM_QTY|TARGET_PRICE|PO_AMT|PO_CREATE_DATE|RD_DATE|GR_DATE|GR_QTY|GR_AMT|AGENT_NAME|ADD_USER_DEPT|ADD_USER_DEPT2|ADD_USER_NAME|CATEG_DEPTH2|CATEG_DEPTH3|CATEG_DEPTH4|";

		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"발주현황.xls");
		 
	}
	
	/**
	 * 발주현황 부서별 집계 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mppo/getBuyerMpPoOrderDeptPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpPoOrderDeptPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		
		List<Map<String, String>> _data =  BuyerMpSoOrderAdminProgressService.getOrderDepttList(pMap);		  

		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mppo/buyerMpPoOrderDeptPop";
	}	 

	/**
	 * 발주현황 협력사별 집계 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mppo/getBuyerMpPoOrderAgentPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpPoOrderAgentPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		
		List<Map<String, String>> _data =  BuyerMpSoOrderAdminProgressService.getOrderAgentList(pMap);		  

		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mppo/buyerMpPoOrderAgentPop";
	}	 
}
