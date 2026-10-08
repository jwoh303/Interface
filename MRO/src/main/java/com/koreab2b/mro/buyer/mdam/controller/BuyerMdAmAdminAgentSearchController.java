package com.koreab2b.mro.buyer.mdam.controller;

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

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmAdminAgentSearchService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmAdminAgentSearchController")
public class BuyerMdAmAdminAgentSearchController {
	@Autowired
	private BuyerMdAmAdminAgentSearchService buyerMdAmAdminAgentSearchService;
  
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmAdminAgenttList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdAmAdminAgenttList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_buyer_org_code",_sessionInfo.getBycaComorgCode());
		pMap.put("fromDate", CommonUtil.onvl(pMap.get("fromDate") ,CommonUtil.addDate(new Date(),"M",-2,1)) );
		pMap.put("toDate", CommonUtil.onvl(pMap.get("toDate") ,CommonUtil.formatDateNoDateGubun(new Date(),1)) );
		pMap.put("st_agent_name", CommonUtil.onvl(pMap.get("st_agent_name") ,"") );
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);  
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdAmAdminAgentSearchService.getList(pMap);
		List<Map<String, String>> _agentList = buyerMdAmAdminAgentSearchService.getNewAgentList(pMap);
		  
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("agentList", CommonUtil.getListNvl(_agentList));
		
		return "buyer/mdam/buyerMdAmAdminAgentSearchList";
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mdam/excelBuyerMdAmAdminAgenttList.do", method = RequestMethod.POST)
	public void excelBuyerMdAmAdminAgenttList(ModelMap pModel,HttpServletRequest req, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date); 
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_buyer_org_code",_sessionInfo.getBycaComorgCode());
		pMap.put("st_agent_name", CommonUtil.onvl(pMap.get("st_agent_name") ,"") );
		
		List<Map<String, String>> _data = buyerMdAmAdminAgentSearchService.getExcelList(pMap);  
		   
		String title = "협력사명|사업자등록번호|우편번호|주소|대표자명|업태|종목|국가|설립일|대표번호|팩스번호|홈페이지|사용자|사용자전화번호|사용자팩스|사용자핸드폰|사용자이메일|지점|대표품목1|대표품목2|대표품목3|대표품목4|대표품목5|";
		String headers = "COM_NAME_LOC|IRS_NO|ZIP_CODE|ADDRESS_LOC|CEO_NAME_LOC|INDUSTRY_TYPE|BUSINESS_ITEMS|COUNTRY_CODE|ESTABLISH_DATE|TEL_NO|FAX_NO|HP_ADDRESS|SALES_PERSON|SALES_TEL|SALES_FAX|SALES_MOBILE|SALES_EMAIL||ITMG1_NM|ITMG2_NM|ITMG3_NM|ITMG4_NM|ITMG5_NM|";

		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"협력사현황.xls");
		 
	}
	
	/**
	 * 발주현황 부서별 집계 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/getBuyerMpAmAgentInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpAmAgentInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		
		List<Map<String, String>> _data =  buyerMdAmAdminAgentSearchService.getAgentInfo(pMap);
		List<Map<String, String>> _podata =  buyerMdAmAdminAgentSearchService.getAgentPoInfo(pMap);
		List<Map<String, String>> _dlydata =  buyerMdAmAdminAgentSearchService.getAgentDlvryInfo(pMap);
		

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("_podata", CommonUtil.getListNvl(_podata));
		pModel.addAttribute("_dlydata", CommonUtil.getListNvl(_dlydata));
		return "common/popup/mdam/buyerMpAmAgentInfoPop";
	}
}

