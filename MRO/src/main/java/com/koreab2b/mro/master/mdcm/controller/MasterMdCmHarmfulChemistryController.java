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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmHarmfulChemistryService;

@Controller("masterMdCmHarmfulChemistryController")
public class MasterMdCmHarmfulChemistryController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmHarmfulChemistryController.class);

	@Autowired
	private MasterMdCmHarmfulChemistryService masterMdCmHarmfulChemistryService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmHarmfulChemistryList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmHarmfulChemistryList(HttpServletRequest req , @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmHarmfulChemistryService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 엑셀다운로드
	@RequestMapping(value = "/mdcm/excelMasterMdCmHarmfulChemistryList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmHarmfulChemistryService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	// 실적데이터 생성
	@RequestMapping(value = "/mdcm/createMasterMdCmHarmfulChemistry.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> createMasterMdCmHarmfulChemistry(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		String msg = masterMdCmHarmfulChemistryService.createMasterMdCmHarmfulChemistry(pMap);
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}
