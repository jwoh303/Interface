package com.koreab2b.mro.common.coco.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.service.CommonCoCoScmActionDetailPopService;

@Controller("CommonCoCoScmActionDetailPopController")
public class CommonCoCoScmActionDetailPopController {

//	private static final Logger LOGGER = LoggerFactory.getLogger(CommonCoCoScmActionDetailPopController.class);

	@Autowired
	private CommonCoCoScmActionDetailPopService commonCoCoScmActionDetailPopService;
	
	/**
	 * scm 조치내역 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getCommonCoCoScmActionDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoScmActionDetailPop(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) { 
//		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
//		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());				
//		pMap.put("USER_ID",_sessionInfo.getUserId());
		
		Map<String,String> _data = commonCoCoScmActionDetailPopService.getScmList(pMap);
		
		pModel.addAttribute("data", _data);
		pModel.addAllAttributes(pMap);
		
		return "common/popup/coco/commonCoCoScmActionDetailPop";
	}
	
	@RequestMapping(value = "/coco/saveCommonCoCoScmActionDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveCommonCoCoScmActionDetailPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
//		logger.debug("/mpiv/saveSellerMpIvDeliveryDelayReasonPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _response = new HashMap<String, String>();
		
		String flag = commonCoCoScmActionDetailPopService.updateCommonCoCoScmActionDetailPop(pMap);
		
		_response.put("msg", flag);
		
		return _response;
	}
}

