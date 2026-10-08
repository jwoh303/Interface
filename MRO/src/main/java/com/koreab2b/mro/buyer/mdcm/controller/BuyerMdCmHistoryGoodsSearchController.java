package com.koreab2b.mro.buyer.mdcm.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmHistoryGoodsSearchService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdCmHistoryGoodsSearchController")
public class BuyerMdCmHistoryGoodsSearchController {
  
	@Autowired
	private BuyerMdCmHistoryGoodsSearchService buyerMdCmHistoryGoodsSearchService;
	
	// 조회 PG_06_B_003_00
	@RequestMapping(value = "/mdcm/getBuyerMdCmHistoryGoodsSearchList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmHistoryGoodsSearchList(ModelMap pModel ,HttpServletRequest req, @RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mdcm/getBuyerMdCmHistoryGoodsSearchList.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		//pMap.put("st_user_dept",_sessionInfo.getDepartment());
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) { //리뉴얼에선 해당 값 없으면 디폴트 30
			String rowCntTmp = CommonUtil.onvl(pMap.get("onepagerow"),_sessionInfo.getRowCnt());
			String pageString = "30,50,100,200,500,1000";
			if(!Arrays.asList(pageString.split(",")).contains(rowCntTmp)){
				rowCntTmp = "30";
			}
			pMap.put("onepagerow",rowCntTmp);
			
		}else{
			pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		}
		pMap.put("st_buyer_item_no", CommonUtil.onvl(pMap.get("st_buyer_item_no") ,"") );
		pMap.put("st_description", CommonUtil.onvl(pMap.get("st_description") ,"") );
		pMap.put("st_specification", CommonUtil.onvl(pMap.get("st_specification") ,"") );
		pMap.put("st_maker_name", CommonUtil.onvl(pMap.get("st_maker_name") ,"") );
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun") ,"") );
		pMap.put("st_sort_change", CommonUtil.onvl(pMap.get("st_sort_change") ,"") );
		pMap.put("st_desc_spec", CommonUtil.onvl(pMap.get("st_desc_spec") ,"") );
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		if ("renewal".equals(uiVersion)) {
			pMap.put("st_keyword", CommonUtil.onvl(pMap.get("st_keyword") ,"") );
			pMap.put("st_from_date", CommonUtil.onvl(pMap.get("st_from_date") ,"") );
			pMap.put("st_to_date", CommonUtil.onvl(pMap.get("st_to_date") ,"") );
			List<Map<String, String>> _data = buyerMdCmHistoryGoodsSearchService.selectBuyerMdCmHistoryGoodsSearchList_v2(pMap);
			
			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			return "buyer/mdcm/buyerMdCmHistoryGoodsSearchList_v2";
		}else{
			List<Map<String, String>> _data = buyerMdCmHistoryGoodsSearchService.getList(pMap);
			
			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			return "buyer/mdcm/buyerMdCmHistoryGoodsSearchList";
		}
	}
	
	// 이력상품검색에서 삭제
	@RequestMapping(value = "/mdcm/removebuyerMdCmHistoryGoodsItem.do", method = RequestMethod.POST)
	@ResponseBody				
	public Map<String, Object> removebuyerMdCmHistoryGoodsItem(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
 
		pMap = CommonUtil.removeSlash(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = buyerMdCmHistoryGoodsSearchService.removebuyerMdCmHistoryGoodsItem(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
}
