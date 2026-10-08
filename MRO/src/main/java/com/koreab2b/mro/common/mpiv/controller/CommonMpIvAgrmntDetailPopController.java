package com.koreab2b.mro.common.mpiv.controller;

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

import com.koreab2b.mro.common.mpiv.service.CommonMpIvAgrmntDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvAgrmntDetailPopController")
public class CommonMpIvAgrmntDetailPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvAgrmntDetailPopController.class);

	@Autowired
	private CommonMpIvAgrmntDetailPopService commonMpIvAgrmntDetailPopService;
	
	/**
	 * 합의내역 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvAgrmntDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvAgrmntDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvAgrmntDetailPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = commonMpIvAgrmntDetailPopService.getList(pMap);
		String _mainYn = commonMpIvAgrmntDetailPopService.getMailYn(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("mailYn", _mainYn);
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/commonMpIvAgrmntDetailPop";
	}	 

	@RequestMapping(value = "/mpiv/saveCommonMpIvAgrmntDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveCommonCoCoScmActionDetailPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
//		logger.debug("/mpiv/saveSellerMpIvDeliveryDelayReasonPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _response = new HashMap<String, String>();
		
		String flag = commonMpIvAgrmntDetailPopService.insertCommonCoCoScmActionDetailPop(pMap);
		
		_response.put("msg", flag);
		
		return _response;
	}
}
