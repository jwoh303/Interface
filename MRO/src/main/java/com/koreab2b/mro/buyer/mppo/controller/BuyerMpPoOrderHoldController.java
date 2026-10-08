package com.koreab2b.mro.buyer.mppo.controller;

import java.io.OutputStream;
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

import com.koreab2b.mro.buyer.mppo.service.BuyerMpPoOrderHoldService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderInfoService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpPoOrderHoldController")
public class BuyerMpPoOrderHoldController {
 
	@Autowired
	private BuyerMpPoOrderHoldService buyerMpPoOrderHoldService;
	@Autowired
	private BuyerMpSoOrderInfoService buyerMpSoOrderInfoService;
	// 조회
	@RequestMapping(value = "/mppo/getBuyerMpPoOrderHoldList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpPoOrderHoldList(ModelMap pModel ,HttpServletRequest req  ,@RequestParam Map<String, String> pMap) {		
		  

		// 조회일자 Convert
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpPoOrderHoldService.getList(pMap);
		
		//선입고발주 제외대상 업체 조회
		String pre_goods_count  = buyerMpSoOrderInfoService.getNotPreGoodsCompany(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("pre_goods_count", pre_goods_count); 
		return "buyer/mppo/buyerMpPoOrderHoldList";
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mppo/excelBuyerMpPoOrderHoldList.do", method = RequestMethod.POST)
	public void excelBuyerMpPoOrderHoldList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) { 
		
		
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpPoOrderHoldService.getList(pMap); 
		    
		String title = "요청부서|요청번호|품목코드|요청일|품목명|규격|요청수량|단위|승인수량|단가|금액|납기요청일|협력사|관리번호|결재유무|보류번호|상태|비고|";
		String headers = "REQ_DEPT|PR_NO|BUYER_ITEM_NO|CHANGE_DATE|DESCRIPTION|SPECIFICATION|TARGET_QTY|UNIT_MEASURE|RECV_QTY|UNIT_PRICE|AMT|RD_DATE|AGENT_NAME|REF_PR_NO|GUYLJAE_FLAG|REF_NO|PX_STATUS|REMARK|";
		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"발주보류조회.xls");
		 
	}
	
	 
}
