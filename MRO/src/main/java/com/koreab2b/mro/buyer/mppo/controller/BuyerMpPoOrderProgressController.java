package com.koreab2b.mro.buyer.mppo.controller;

import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;
import java.net.URLDecoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.buyer.mppo.service.BuyerMpPoOrderProgressService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpPoOrderProgressController")
public class BuyerMpPoOrderProgressController {
 
	@Autowired
	private BuyerMpPoOrderProgressService buyerMpPoOrderProgressService;
	
	// 조회 PG_06_B_019_00
	@RequestMapping(value = "/mppo/getBuyerMpPoOrderProgressList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpPoOrderProgressList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mppo/getBuyerMpPoOrderProgressList.do 요청 파라미터 : {}", pMap);

		 SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		 


		// 조회일자 Convert
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpPoOrderProgressService.getList(pMap);
		
		pModel.addAttribute("data", _data);
		
		return "buyer/mppo/buyerMpPoOrderProgressList";
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mppo/excelBuyerMpPoOrderProgressList.do", method = RequestMethod.POST)
	public void excelBuyerMpPoOrderProgressList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpso/excelBuyerMpPoOrderProgressList.do 요청 파라미터 for jsp : {}", pMap);
		
		
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpPoOrderProgressService.getList(pMap); 
		     
		String title = "고객사코드|고객사명|주문번호|발주번호|요청번호|품목코드|진행상태|품목명|규격|수량|단위|발주일|단가|금액|납기요청일|납품예정일|송장수량|납품수량|협력사|관리번호|납품합의일|비고|요청부서|구매요청결재경로|구매발주결재경로|계정명|예산부서|제조사|발주자|";
		String headers = "BUYER|BUYER_NAME|REF_NO|PO_NO|PR_NO|BUYER_ITEM_NO|PO_STR|DESCRIPTION|SPECIFICATION|RECV_QTY|UNIT_MEASURE|PO_CREATE_DATE|TARGET_PRICE|TARGET_SUM_PRICE|RD_DATE|DS_DATE|IV_QTY|GR_QTY|COM_NAME_LOC|REF_PR_NO|HA_DATE|REMARK|REQ_DEPT_NAME|PR_NO_APPROVAL_URL|PX_NO_APPROVAL_URL|ACCOUNT_NAME|BUDGET_DEPT_NAME|MAKER_NAME|PURCHASER_NAME|";			
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"발주진행관리.xls");
		 
	}
	
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mppo/excelNewBuyerMpPoOrderProgressList.do", method = RequestMethod.POST)
	public String excelNewBuyerMpPoOrderProgressList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		//logger.debug("/mpso/excelBuyerMpPoOrderProgressList.do 요청 파라미터 for jsp : {}", pMap);
		
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpPoOrderProgressService.getList(pMap); 
		
		pModel.addAttribute("data", _data);

		return "buyer/mppo/buyerMpPoOrderProgressExcelList";
	}
	
	// 부서별 집계
	@RequestMapping(value = "/mppo/getBuyerMpPoOrderDeptTotalList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpPoOrderDeptTotalList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) throws UnsupportedEncodingException {	
		
		// 파라미터(부서명, 품명, 규격에 특수문자(&, /, +) 등이 포함될 수 있어 Decode
		pMap.put("st_dept_name", URLDecoder.decode(pMap.get("st_dept_name"), "UTF-8"));
		pMap.put("itemNo", URLDecoder.decode(pMap.get("itemNo"), "UTF-8"));
		pMap.put("orderNo", URLDecoder.decode(pMap.get("orderNo"), "UTF-8"));
		
		List<Map<String, String>> _data = buyerMpPoOrderProgressService.getDeptTotalList(pMap); 		
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAllAttributes(pMap);
		
		return "buyer/mppo/buyerMpPoOrderDeptTotalPop";
	}
	
	// 협력사별 집계
	@RequestMapping(value = "/mppo/getBuyerMpPoOrderSuplTotalList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpPoOrderSuplTotalList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) throws UnsupportedEncodingException {	
		
		// 파라미터(부서명, 품명, 규격에 특수문자(&, /, +) 등이 포함될 수 있어 Decode
		pMap.put("st_dept_name", URLDecoder.decode(pMap.get("st_dept_name"), "UTF-8"));
		pMap.put("itemNo", URLDecoder.decode(pMap.get("itemNo"), "UTF-8"));
		pMap.put("orderNo", URLDecoder.decode(pMap.get("orderNo"), "UTF-8"));
		
		List<Map<String, String>> _data = buyerMpPoOrderProgressService.getSuplTotalList(pMap); 		
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAllAttributes(pMap);
		
		return "buyer/mppo/buyerMpPoOrderSuplTotalPop";
	}
	// 관리번호별 집계
	@RequestMapping(value = "/mppo/getBuyerMpPoOrderRefTotalList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpPoOrderRefTotalList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) throws UnsupportedEncodingException {	
		
		// 파라미터(부서명, 품명, 규격에 특수문자(&, /, +) 등이 포함될 수 있어 Decode
		pMap.put("st_dept_name", URLDecoder.decode(pMap.get("st_dept_name"), "UTF-8"));
		pMap.put("itemNo", URLDecoder.decode(pMap.get("itemNo"), "UTF-8"));
		pMap.put("orderNo", URLDecoder.decode(pMap.get("orderNo"), "UTF-8"));
		
		List<Map<String, String>> _data = buyerMpPoOrderProgressService.getRefTotalList(pMap); 		
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAllAttributes(pMap);
		
		return "buyer/mppo/buyerMpPoOrderRefTotalPop";
	}
}
