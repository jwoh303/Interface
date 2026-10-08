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
import com.koreab2b.mro.common.mpso.service.MasterMpSoIssueManageRemarkPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

@Controller("masterMpSoIssueManageRemarkPopController")
public class MasterMpSoIssueManageRemarkPopController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoIssueManageRemarkPopController.class);
	
	@Autowired
	private MasterMpSoIssueManageRemarkPopService masterMpSoIssueManageRemarkPopService;
	
	// 품목정보, pohd, 납품정보 조회
	@RequestMapping(value = "/mpso/masterMpSoIssueManageRemarkPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoUniformDetailPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("masterMpSoIssueManageRemarkPop 요청 파라미터 for jsp : {}", pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("st_user_id", _sessionInfo.getUserId()); // 사용자ID TEST
		
		Map<String, String> rpt_data = masterMpSoIssueManageRemarkPopService.RemakrRPTURL(pMap);
		Map<String, String> _data1 = masterMpSoIssueManageRemarkPopService.RemarkPopItem(pMap); 
		Map<String, String> _data2 = masterMpSoIssueManageRemarkPopService.RemarkPopPOHD(pMap);
		List<Map<String, String>> _data3 = masterMpSoIssueManageRemarkPopService.RemarkPopIVDT(pMap);
		List<Map<String, String>> _data4 = masterMpSoIssueManageRemarkPopService.RemarkPopPOMN(pMap);
		
		pModel.addAttribute("rpt_data", rpt_data);
		pModel.addAttribute("data1", _data1); 
		pModel.addAttribute("data2", _data2);
		pModel.addAttribute("data3", _data3); 
		pModel.addAttribute("data4", _data4);
		
		return "common/popup/mpso/masterMpSoIssueManageRemarkPop";
	}
	
	// IBSheet 조회
	@RequestMapping(value = "/mpso/getMasterMpSoIssueManageRemarkPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpSoIssueManageRemarkPopList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMpSoIssueManageRemarkPop 요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpSoIssueManageRemarkPopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 이슈 저장
	@RequestMapping(value = "/mpso/updatMasterMpSoIssueManageRemarkPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> updateMasterMpSoIssueManageRemarkPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("updatMasterMpSoIssueManageRemarkPop 요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMpSoIssueManageRemarkPopService.saveRemark(pMap);
		
		_response.put("msg", _result);
		return _response;
	}
	
	// 메뉴 - 이슈 저장
		@RequestMapping(value = "/mpso/insertMasterMpSoIssueManageMemo.do",  method = {RequestMethod.GET,RequestMethod.POST})
		@ResponseBody
		public Map<String, String> insertMasterMpSoIssueManageMemo(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
			LOGGER.debug("insertMasterMpSoIssueManageMemo 요청 파라미터 : {}", pMap);
			
			Map<String, String> _response = new HashMap<String, String>();
			String _result = masterMpSoIssueManageRemarkPopService.saveMemo(pMap);
			
			_response.put("msg", _result);
			return _response;
		}
}
