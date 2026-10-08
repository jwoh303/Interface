package com.koreab2b.mro.buyer.wmgr.controller;

import java.io.OutputStream;
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

import com.koreab2b.mro.buyer.wmgr.service.BuyerWmGrWarehousingTotService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerWmGrWarehousingTotController")
public class BuyerWmGrWarehousingTotController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerWmGrWarehousingTotController.class);

	@Autowired
	private BuyerWmGrWarehousingTotService buyerWmGrWarehousingTotService;
	
	// 화면 호출
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingTot.do", method = RequestMethod.GET)
	public String getBuyerWmGrWarehousingTotInit(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		return "buyer/wmgr/buyerWmGrWarehousingTotList";
	}
	
	// 조회
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingTotList.do", method = RequestMethod.POST)
	public String getBuyerWmGrWarehousingTotList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/wmgr/getBuyerWmGrWarehousingLisList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 

		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerWmGrWarehousingTotService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "buyer/wmgr/buyerWmGrWarehousingTotList";
	}
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingTotList_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrWarehousingTotList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerWmGrWarehousingTotService.getBuyerWmGrWarehousingTotList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// EXCEL 다운로드
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingTotList.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingTot(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletResponse response, OutputStream outputStream) {
		//logger.debug("/wmgr/excelBuyerWmGrWarehousingLisList.do 요청 파라미터 for jsp : {}", pMap);

		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerWmGrWarehousingTotService.getList(pMap); 
		   	
		String excelType = CommonUtil.nvl(pMap.get("st_excel_type"));
		String title = "";
		String headers = "";
		String gr_stts_type = CommonUtil.nvl(pMap.get("st_gr_stts_type"));
		
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size() + "///" + excelType + "///" + gr_stts_type);
		
		if(gr_stts_type.equals("A")){
			title = "고객사코드|고객사명|요청부서코드|요청부서명|예산부서코드|예산부서명|계정코드|계정명|입고집계금액|정산여부|";
			headers = "BUYER|BUYER_NAME|REQ_DEPT|REQ_DEPT_NAME|BUDGET_DEPT|BUDGET_DEPT_NAME|ACCOUNT_TYPE|ACCOUNT_NAME|GR_AMT|AR_BILL_FLAG|";
		}else if(gr_stts_type.equals("B")){
			title = "고객사코드|고객사명|요청부서코드|요청부서명|관리번호|입고집계금액|정산여부|";
			headers = "BUYER|BUYER_NAME|REQ_DEPT|REQ_DEPT_NAME|REF_PR_NO|GR_AMT|AR_BILL_FLAG|";
		}else{
			title = "고객사코드|고객사명|요청부서코드|요청부서명|입고집계금액|정산여부|";
			headers = "BUYER|BUYER_NAME|REQ_DEPT|REQ_DEPT_NAME|GR_AMT|AR_BILL_FLAG|";
		}
		
		String excelHeader = title +"@@"+headers;

		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "부서별_입고집계.xls");

	}
	
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingTotList_v2.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingTotList_v2(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletResponse response, OutputStream outputStream) {
		//logger.debug("/wmgr/excelBuyerWmGrWarehousingLisList.do 요청 파라미터 for jsp : {}", pMap);

		// 조회일 슬래시 제거
		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String, String>> _data = buyerWmGrWarehousingTotService.getBuyerWmGrWarehousingTotList_v2(pMap); 
		   	
		String excelType = CommonUtil.nvl((String)pMap.get("st_excel_type"));
		String title = "";
		String headers = "";
		String gr_stts_type = CommonUtil.nvl((String)pMap.get("st_gr_stts_type"));
		
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size() + "///" + excelType + "///" + gr_stts_type);
		
		if(gr_stts_type.equals("A")){
			title = "고객사코드|고객사명|요청부서코드|요청부서명|예산부서코드|예산부서명|계정코드|계정명|입고집계금액|정산여부|";
			headers = "BUYER|BUYER_NAME|REQ_DEPT|REQ_DEPT_NAME|BUDGET_DEPT|BUDGET_DEPT_NAME|ACCOUNT_TYPE|ACCOUNT_NAME|GR_AMT|AR_BILL_FLAG|";
		}else if(gr_stts_type.equals("B")){
			title = "고객사코드|고객사명|요청부서코드|요청부서명|관리번호|입고집계금액|정산여부|";
			headers = "BUYER|BUYER_NAME|REQ_DEPT|REQ_DEPT_NAME|REF_PR_NO|GR_AMT|AR_BILL_FLAG|";
		}else{
			title = "고객사코드|고객사명|요청부서코드|요청부서명|입고집계금액|정산여부|";
			headers = "BUYER|BUYER_NAME|REQ_DEPT|REQ_DEPT_NAME|GR_AMT|AR_BILL_FLAG|";
		}
		
		String excelHeader = title +"@@"+headers;

		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "부서별_입고집계.xls");

	}
	/**
	 * 고객사 발주 상세정보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerWmGrWarehousingDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "/common/popup/wmgr/buyerWmGrWarehousingDetailPop_v2";
		}else {
			List<Map<String, String>> _data = buyerWmGrWarehousingTotService.getPopList(pMap);
			
			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			pModel.addAllAttributes(pMap);
			
			return "/common/popup/wmgr/buyerWmGrWarehousingDetailPop";
		}
		
	}
	
	@RequestMapping(value = "/wmgr/getBuyerWmGrWarehousingPopList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrWarehousingPopList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 화면 조회
		List<Map<String, String>> _data = buyerWmGrWarehousingTotService.getPopList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 상세조회 EXCEL 다운로드	
	@RequestMapping(value = "/wmgr/excelBuyerWmGrWarehousingDetailPop.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletResponse response, OutputStream outputStream) {
		//logger.debug("/wmgr/excelBuyerWmGrWarehousingLisList.do 요청 파라미터 for jsp : {}", pMap);

		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerWmGrWarehousingTotService.getPopList(pMap); 
		   	
		String title = "";
		String headers = "";
		
		title = "고객사코드|고객사명|상태|발주일|요청번호|발주번호|송장번호|입고번호|품목코드|품명|규격|단위|발주수량|입고수량|단가|입고금액|입고일|발주자|협력사|요청부서|요청자명|예산부서코드|예산부서|계정코드|계정명|";
		headers = "BUYER|BUYER_NAME|GR_STATUS|PO_CREATE_DATE|PX_NO|PO_NO|INV_NO|GR_NO|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|PO_ITEM_QTY|GR_ITEM_QTY|UNIT_PRICE|ITEM_AMT|GR_DATE|PO_CREATOR|AGENT_NAME|REQ_DEPT_NAME|ADD_USER_NAME|BUDGET_DEPT|BUDGET_DEPT_NAME|ACCOUNT_TYPE|ACCOUNT_NAME|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "부서별_입고_상세.xls");	
		
	}
}
