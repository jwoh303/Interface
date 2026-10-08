package com.koreab2b.mro.master.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCatalogByitService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCatalogByitController")
public class MasterMdCmCatalogByitController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogByitController.class);

	@Autowired
	private MasterMdCmCatalogByitService masterMdCmCatalogByitService;
	

	
	// 고객사카탈로그 조회
	@RequestMapping(value = "/mdcm/getMasterMdcmByitList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterMdcmByitList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		List<Map<String,String>> _data = masterMdCmCatalogByitService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}
	/**
	 *  견적카탈로그 품목코드 매핑하기
	 * @param pReq
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/saveMasterItemNoMapping.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterItemNoMapping(HttpServletRequest pReq, @RequestParam MultiValueMap<String, String> pMap) {
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		int flag = masterMdCmCatalogByitService.saveMasterItemNoMapping(formData, gridData);
		_response.put("resultFlag", flag);
		
		return _response;
	}


}
