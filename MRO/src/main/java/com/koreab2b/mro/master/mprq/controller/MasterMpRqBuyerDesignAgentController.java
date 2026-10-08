package com.koreab2b.mro.master.mprq.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mprq.service.MasterMpRqBuyerDesignAgentService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMqRqBuyerDesignAgentController")
public class MasterMpRqBuyerDesignAgentController {

	@Autowired
	private MasterMpRqBuyerDesignAgentService masterMpRqBuyerDesignAgentService;
	
	// 조회	
	@RequestMapping(value = "/mprq/getMasterMpRqBuyerDesignAgentPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvBuyerDlvryDetailInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, String> _dataMap = masterMpRqBuyerDesignAgentService.getInfo(pMap);
		
		pModel.addAttribute("info", CommonUtil.getMapNvl(_dataMap)); 
		pModel.addAllAttributes(pMap);
		
		return "/common/popup/mprq/masterMpRqBuyerDesignAgentPop";
	}
	
	// 그리드 조회
	@RequestMapping(value = "/mprq/getMasterMpRqBuyerDesignAgentList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMqRqBuyerDesignAgentList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqBuyerDesignAgentService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 저장
	@RequestMapping(value = "/mprq/saveMasterMqRqBuyerDesignAgentList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqBuyerDesignAgent(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqBuyerDesignAgentService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}

	// 삭제
	@RequestMapping(value = "/mprq/delMasterMpRqBuyerDesignAgentList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpRqBuyerDesignAgent(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqBuyerDesignAgentService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}

}
