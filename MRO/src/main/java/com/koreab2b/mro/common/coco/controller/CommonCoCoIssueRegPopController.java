package com.koreab2b.mro.common.coco.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.common.coco.service.CommonCoCoIssueRegPopService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("CommonCoCoIssueRegPopController")
public class CommonCoCoIssueRegPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoIssueRegPopController.class);

	@Autowired
	private CommonCoCoIssueRegPopService commonCoCoIssueRegPopService;
		
	@RequestMapping(value = "/coco/saveCommonCoCoIssueRegPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveCommonCoCoIssueRegPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
//		logger.debug("/mpiv/saveSellerMpIvDeliveryDelayReasonPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _response = new HashMap<String, String>();
		
		String flag = commonCoCoIssueRegPopService.insertCommonCoCoIssueRegPop(pMap);
		
		_response.put("msg", flag);
		
		return _response;
	}
	
	// 조회
	@RequestMapping(value = "/coco/getCommonCoCoIssueHistList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonCoCoIssueHistList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = commonCoCoIssueRegPopService.getCommonCoCoIssueHistHistList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}

