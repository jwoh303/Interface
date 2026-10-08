package com.koreab2b.mro.common.mprq.controller;

import java.io.OutputStream;
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
import com.koreab2b.mro.common.mprq.service.MasterMpRqBulkQuotationDetailPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMpRqBulkQuotationDetailPopController")
public class MasterMpRqBulkQuotationDetailPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationDetailPopController.class);

	@Autowired
	private MasterMpRqBulkQuotationDetailPopService MasterMpRqBulkQuotationDetailService;
	
	// 프로젝트 조회
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String searchMasterMpRqBulkQuotationDetailPopList(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest req) {
				
		Map<String, String> _data = MasterMpRqBulkQuotationDetailService.getProject(pMap);
		
		pModel.addAttribute("_data", _data);
		
		return "common/popup/mprq/masterMpRqBulkQuotationDetailPop";
	}

	// 유의사항 조회 -- 3 SM, 4 AGENT
	// 고객사정보  -- 1
	// SG별 품목수  -- 2 
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationDetailSheetPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqBulkQuotationDetailSheetPopList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMpRqBulkQuotationDetailNotice 요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = MasterMpRqBulkQuotationDetailService.getSheet(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 프로젝트 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqBulkQuotationDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqBulkQuotationDetail(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("saveMasterMpRqBulkQuotationNewProject param : {}", pMap);
		
		
		String rtnMsg = MasterMpRqBulkQuotationDetailService.updateData(pMap);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
	}
	
	// 유의사항 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqBulkQuotationDetailNotice.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqBulkQuotationDetailNotice(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		
		LOGGER.debug("saveMasterMpRqBulkQuotationNewProjectNotice gridData param : {}", gridData);
		String rtnMsg = MasterMpRqBulkQuotationDetailService.updateNoticeData(gridData, formData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
	}
	
	//  고객사코드 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqBulkQuotationDetailBuyer.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqBulkQuotationBuyerCode(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("saveMasterMpRqBulkQuotationNewProjectNotice gridData param : {}", gridData);
		String rtnMsg = MasterMpRqBulkQuotationDetailService.updateBuyerData(gridData, formData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
	}
}
