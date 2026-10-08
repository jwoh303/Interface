package com.koreab2b.mro.common.mpiv.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpiv.service.CommonMpIvBuyerOrderDetailInfoPopService;
import com.koreab2b.mro.common.mpiv.service.CommonMpIvOrderDetailInfoPopService;
import com.koreab2b.mro.common.mpiv.service.CommonMpIvOrderDetailPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvBuyerOrderDetailInfoPopController")
public class CommonMpIvBuyerOrderDetailInfoPopController {

	@Autowired
	private CommonMpIvOrderDetailInfoPopService commonMpIvOrderDetailInfoPopService;
	
	@Autowired
	private CommonMpIvOrderDetailPopService commonMpIvOrderDetailPopService;
	
	/**
	 * 고객사 발주 상세정보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvBuyerOrderDetailInfoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvBuyerOrderDetailInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, String> _dataMap = commonMpIvOrderDetailInfoPopService.getInfo(pMap);
		List<Map<String, String>> _data = commonMpIvOrderDetailPopService.getList(pMap);
		
		pModel.addAttribute("info", CommonUtil.getMapNvl(_dataMap)); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "/common/popup/mpiv/commonMpIvOrderDetailInfoPop";
	}
	@RequestMapping(value = "/mpiv/getCommonMpIvBuyerOrderDetailInfoPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvBuyerOrderDetailInfoPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, String> _dataMap = commonMpIvOrderDetailInfoPopService.getInfo_v2(pMap);
//		List<Map<String, String>> _data = commonMpIvOrderDetailPopService.getList(pMap);
		
		pModel.addAttribute("info", CommonUtil.getMapNvl(_dataMap)); 
//		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "/common/popup/mpiv/commonMpIvOrderDetailInfoPop_v2";
	}
	@RequestMapping(value = "/mpiv/getCommonMpIvBuyerOrderDetailListPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonMpIvBuyerOrderDetailListPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = commonMpIvOrderDetailPopService.getCommonMpIvBuyerOrderDetailListPop_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
}
