package com.koreab2b.mro.common.mpso.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpso.service.MasterMpSoUniformDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoUniformDetailPopController")
public class MasterMpSoUniformDetailPopController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoUniformDetailPopController.class);
	
	@Autowired
	private MasterMpSoUniformDetailPopService masterMpSoUniformDetailPopService;
	
	// 상단 리스트 조회
	@RequestMapping(value = "/mpso/getMasterMpSoUniformDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoUniformDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data_hd = masterMpSoUniformDetailPopService.getHdList(pMap);
		pModel.addAttribute("data_hd", CommonUtil.getListNvl(_data_hd));
		return "common/popup/mpso/masterMpSoUniformDetailPop";
	}
	
	// 그리드 조회
	@RequestMapping(value = "/mpso/getMasterMpSoUniformDetailPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoUniformDetailPopList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoUniformDetailPopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/mpso/saveMasterMpSoUniformDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpSoUniformDetailPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String msg = masterMpSoUniformDetailPopService.updateSelectedData(pMap);
		
		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}
