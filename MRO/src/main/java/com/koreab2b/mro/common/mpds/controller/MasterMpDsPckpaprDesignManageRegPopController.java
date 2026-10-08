package com.koreab2b.mro.common.mpds.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpds.service.MasterMpDsPckpaprDesignManageRegPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterMpDsPckpaprDesignManageRegPopController")
public class MasterMpDsPckpaprDesignManageRegPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpDsPckpaprDesignManageRegPopController.class);

	@Autowired
	private MasterMpDsPckpaprDesignManageRegPopService masterMpDsPckpaprDesignManageRegPopService;
	
	/**
	 * 포장지 도안 관리 등록 (작물보호) 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getMasterMpDsPckpaprDesignManageRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpDsPckpaprDesignManageRegPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpDsPckpaprDesignManageRegPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	

	/*등록*/
	@RequestMapping(value = "/mpds/regMasterMpDsPckpaprDesignManageRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpDsPckpaprDesignManageRegPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		//날짜형식에서 '/' 제거
		formData = CommonUtil.removeSlash(formData);
		
		String rtnMsg = masterMpDsPckpaprDesignManageRegPopService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);

		_response.put("Message",rtnMsg);
		return _response;
		
	}
}
