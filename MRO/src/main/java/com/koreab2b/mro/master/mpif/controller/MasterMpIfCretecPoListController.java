package com.koreab2b.mro.master.mpif.controller;

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
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mpif.service.MasterMpIfCretecPoListService;
import com.koreab2b.mro.util.CommonUtil;


@Controller("masterMpIfCretecPoListController")
public class MasterMpIfCretecPoListController {

	@Autowired
	private MasterMpIfCretecPoListService masterMpIfCretecPoListService;
	private static final Logger logger = LoggerFactory.getLogger(MasterMpIfErrMngController.class);

	// 조회
	@RequestMapping(value = "/mpif/getMasterMpIfCretecPoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpIfCretecPoList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String[] _st_buyer_code_array = null;
		
		if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
			_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
		}
		
		pMap.put("buyer_code_array", _st_buyer_code_array);
		List<Map<String,String>> _data = masterMpIfCretecPoListService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	//크레텍 발주 상세 팝업
	@RequestMapping(value = "/mpif/showMpIfCretecPoListPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMpIfCretecPoListPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest pRequest) {
		
		SessionInfo _sessionInfo = (SessionInfo) pRequest.getSession().getAttribute("sessionInfo");
		String st_user_id = _sessionInfo.getUserId();
		pMap.put("st_user_id", st_user_id);
		List<Map<String,String>> data = masterMpIfCretecPoListService.getMpIfCretecPoListPop(pMap);
	
		pModel.addAttribute("data", CommonUtil.getListNvl(data)); 
		pModel.addAttribute("st_user_id", st_user_id);
		return "common/popup/mpif/mpIfCretecPoListPop";
	}
	
	//크레텍 발주 상세 팝업 저장
	@RequestMapping(value = "/mpif/submitMpIfCretecPoListPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> submitMpIfCretecPoListPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		try {
			String _result = masterMpIfCretecPoListService.submitMpIfCretecPoListPop(pMap);
			_response.put("msg", _result);
		} catch (Exception e) {
			_response.put("msg",e.getMessage());
		}
		return _response;
	}
		
}
