package com.koreab2b.mro.promote.controller;

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

import com.koreab2b.mro.promote.service.PromoteService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("promoteConrtroller")
public class PromoteController {

	@Autowired
	private PromoteService promoteService;

	@RequestMapping(value = "/promote/promoteHeader.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getPromoteHeaderList(ModelMap pModel, HttpServletRequest request) {
		pModel.addAttribute("KEYWORD", promoteService.getKeyWord());

		return "promote/include/promoteHeader";
	}
	
	@RequestMapping(value = "/promote/promote.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getPromoteMainList(ModelMap pModel, HttpServletRequest request) {

		pModel.addAttribute("planItem", promoteService.getCatalogItemPlan());
		pModel.addAttribute("mainItem", promoteService.getCatalogMainItem());
		
		return "promote/promote";
	}
/*	20220726 ISMS 불필요 페이지 삭제 HSJ
	@RequestMapping(value = "/promote/promote_PDSearch.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getPromoteSearchList(ModelMap pModel,@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		List<Map<String, String>> _data = promoteService.getPromoteCatalogList(pMap);

		pModel.addAttribute("searchItem", _data);
		pModel.addAllAttributes(pMap);
		
		return "promote/promote_PDSearch";
	}
*/	
	@RequestMapping(value = "/promote/promote_PDCategory.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getPromoteCategoryList(ModelMap pModel,@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		List<Map<String, String>> _data = promoteService.getPromoteCatalogList(pMap);

		pModel.addAttribute("searchItem", _data);
		pModel.addAttribute("recommandItem", promoteService.getCatalogItemRecommand(pMap));
		pModel.addAttribute("categPath", promoteService.getCategoryListThis(pMap));
		
		pModel.addAllAttributes(pMap);
		
		return "promote/promote_PDCategory";
	}
	
	@RequestMapping(value = "/promote/promote_PDDetail.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getPromoteDetailList(ModelMap pModel,@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		List<Map<String, String>> _data = promoteService.getPromoteDetailList(pMap);

		pModel.addAttribute("searchItem", _data);
		pModel.addAttribute("categPath", promoteService.getCategoryListThis(pMap));
		
		pModel.addAllAttributes(pMap);
		
		return "promote/promote_PDDetail";
	}
	
	// 견적의뢰
	@RequestMapping(value = "/promote/saveItemApproval.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveItemApproval(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String rtnMsg =  promoteService.saveItemApproval(pMap);

		_response.put("rtnMsg", rtnMsg);
		
		return _response;
		
	}

}
