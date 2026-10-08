package com.koreab2b.mro.master.mprq.controller;

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

import com.koreab2b.mro.master.mprq.service.MasterMpRqBuyerRemarkService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqBuyerRemarkController")
public class MasterMpRqBuyerRemarkController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBuyerRemarkController.class);

	@Autowired
	private MasterMpRqBuyerRemarkService masterMpRqBuyerRemarkService;
	
	// 조회
	@RequestMapping(value = "/mprq/getMasterMpRqBuyerRemarkList.do", method = RequestMethod.POST)
	public String getMasterMpRqBuyerRemarkList(ModelMap pModel, @RequestParam Map<String, String> pMap) {

		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		// 화면 조회
		List<Map<String, String>> _data = masterMpRqBuyerRemarkService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "/master/mprq/masterMpRqBuyerRemarkList";
	}
	
	// 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqBuyerRemarkList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqBuyerRemarkList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("saveMasterMpRqBuyerRemarkList MultiValueMap 요청 파라미터 : formData", pMap); 
	
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMpRqBuyerRemarkService.updateSelectedData(pMap);

		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}
}
