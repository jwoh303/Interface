package com.koreab2b.mro.common.mpiv.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpiv.service.CommonMpIvOdrreqDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvOdrreqDetailPopController")
public class CommonMpIvOdrreqDetailPopController {
 

	@Autowired
	private CommonMpIvOdrreqDetailPopService commonMpIvOdrreqDetailPopService;
	
	/**
	 * 주문요청 상세조회 조회 PG_06_M_900_01
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvOdrreqDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvOdrreqDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		//LOGGER.debug("/mpiv/getCommonMpIvOdrreqDetailPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		
		
		List<Map<String, String>> _data = commonMpIvOdrreqDetailPopService.getList(pMap); 		
		List<Map<String, String>> _list = commonMpIvOdrreqDetailPopService.getBuyerPrDisplayDtListPop(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("list", CommonUtil.getListNvl(_list)); 
		
		
		return "common/popup/mpiv/commonMpIvOdrreqDetailPop";
	}
	
	@RequestMapping(value = "/mpiv/getCommonMpIvOdrreqDetailPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvOdrreqDetailPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = commonMpIvOdrreqDetailPopService.getList_v2(pMap); 		
		List<Map<String, String>> _list = commonMpIvOdrreqDetailPopService.getBuyerPrDisplayDtListPop_v2(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("list", CommonUtil.getListNvl(_list)); 
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/commonMpIvOdrreqDetailPop_v2";
	}
//	@RequestMapping(value = "/mpiv/getCommonMpIvOdrreqDetailListPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
//	@ResponseBody
//	public Map<String, Object> getCommonMpIvOdrreqDetailListPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
//		
//		pMap = IBSheetUtil.removeSlash(pMap);
//		//페이징용 파라미터의 셋팅
//		pMap = IBSheetUtil.addParamForPaging3(pMap);
//		// 화면 조회
//		List<Map<String, String>> _data = commonMpIvOdrreqDetailPopService.getBuyerPrDisplayDtListPop_v2(pMap);
//		
//		return IBSheetUtil.addResut(req, _data , pMap);
//	}
	
}
