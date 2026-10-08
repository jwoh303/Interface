package com.koreab2b.mro.master.wmgi.controller;

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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil; 
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.wmco.service.MasterWmCoMgService;
import com.koreab2b.mro.master.wmgi.service.MasterWmGiOrderDeletePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmGiOrderDeletePopController")
public class MasterWmGiOrderDeletePopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGiOrderDeletePopController.class);

	@Autowired
	private MasterWmGiOrderDeletePopService masterWmGiOrderDeletePopService;
	
	@Autowired
	private MasterWmCoMgService masterWmCoMgService;
	
	// 조회
	@RequestMapping(value = "/wmdl/getMasterWmGiOrderDeletePopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmDlDlvryConfirmList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		Map<String, Object> ppMap = new HashMap<String, Object>();
		ppMap.putAll(pMap);
		ppMap.put("com_code", pMap.get("com_code"));
		ppMap.put("user_id",pMap.get("user_id"));
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String whAdmin = _sessionInfo.getWhAdmin();
		ppMap.put("whAdmin", whAdmin);
		String _warehouse_agent = masterWmCoMgService.getForwarehouseAgent(ppMap);
		pMap.put("st_warehouse_agent", _warehouse_agent);
		
		List<Map<String,String>> _data = masterWmGiOrderDeletePopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	
	// 조회
	@RequestMapping(value ="/wmgi/showMasterWmGiOrderDeletePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiOrderDeletePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/wmgi/showMasterWmGiOrderDeletePop.do 요청 파라미터 for jsp : {}", pMap); 


		Map<String, Object> ppMap = new HashMap<String, Object>();
		ppMap.putAll(pMap);
		ppMap.put("com_code", pMap.get("com_code"));
		ppMap.put("user_id",pMap.get("user_id"));
		
		String _warehouse_agent = masterWmCoMgService.getForwarehouseAgent(ppMap);
		pMap.put("st_warehouse_agent", _warehouse_agent);
		List<Map<String, String>> _data = masterWmGiOrderDeletePopService.getPop(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("/wmgi/showMasterWmGiOrderDeletePop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmgi/masterWmGiOrderDeletePop";
	}
	

		
	// 저장
	@RequestMapping(value = "/wmdl/saveMasterWmGiOrderDeletePop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterWmGiOrderDeletePop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterWmGiOrderDeletePopService.updateSelectedData(formData, gridData);
		
		logger.debug("rtnMsg:"+rtnMsg);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if("OK".equals(rtnMsg)){

			mp.put("Code",1);
		}else{
			mp.put("Code",0);
		}

		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}


}
