package com.koreab2b.mro.common.wmco.controller;

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

import com.koreab2b.mro.common.wmco.service.MasterWmCoMbrcmpyPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.wmco.service.MasterWmCoMgService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmCoMbrcmpyPopController")
public class MasterWmCoMbrcmpyPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmCoMbrcmpyPopController.class);

	@Autowired
	private MasterWmCoMbrcmpyPopService masterWmCoMbrcmpyPopService;
	
	@Autowired
	private MasterWmCoMgService masterWmCoMgService;
	
	/**
	 * 구매회원사 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmco/getMasterWmCoMbrcmpyCountSinglePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmCoMbrcmpyCountSinglePop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		String _session_com_code = _sessionInfo.getComCode();
		String _session_user_id = _sessionInfo.getUserId();
		String whAdmin = _sessionInfo.getWhAdmin();
		
		 pMap.put("com_code", _session_com_code);
		 pMap.put("user_id", _session_user_id);
		 pMap.put("whAdmin", whAdmin);
		String _warehouse_agent = masterWmCoMgService.getForwarehouseAgent(pMap);

		pMap.put("st_wareHouse_agent", _warehouse_agent);
		List<Map<String,String>> _data = masterWmCoMbrcmpyPopService.getSingleList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 구매회원사 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmco/getMasterWmCoMbrcmpyPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmCoMbrcmpyPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _session_com_code = _sessionInfo.getComCode();
		String _session_user_id = _sessionInfo.getUserId();
		String whAdmin = _sessionInfo.getWhAdmin();
		
		 pMap.put("com_code", _session_com_code);
		 pMap.put("user_id", _session_user_id);
		 pMap.put("whAdmin", whAdmin);
		 
		String _warehouse_agent = masterWmCoMgService.getForwarehouseAgent(pMap);

		pMap.put("st_wareHouse_agent", (_warehouse_agent != null && _warehouse_agent != "")? _warehouse_agent : pMap.get("st_wareHouse_agent"));
		List<Map<String,String>> _data = masterWmCoMbrcmpyPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 구매회원사 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmco/getMasterWmCoMbrcmpyCountPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmCoMbrcmpyCountPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _session_com_code = _sessionInfo.getComCode();
		String _session_user_id = _sessionInfo.getUserId();
		String whAdmin = _sessionInfo.getWhAdmin();
		// 선입고(입고등록, 출고등록, 배송확정)용 파라미터
		String _jobTyep = CommonUtil.nvl((String)pMap.get("st_job_type"));
		
		pMap.put("com_code", _session_com_code);
		pMap.put("user_id", _session_user_id);
		pMap.put("whAdmin", whAdmin);
		
		// 선입고가 아닐 경우만 실행
		if ( !"01".equals(_jobTyep) && !"02".equals(_jobTyep) && !"03".equals(_jobTyep) ) {
			String _warehouse_agent = masterWmCoMgService.getForwarehouseAgent(pMap);
			if(_warehouse_agent==null ){
				throw new RuntimeException("물류센터 agent code가 조회되지 않습니다. ");
				
			}
			pMap.put("st_wareHouse_agent", _warehouse_agent);
		}
		
		List<Map<String,String>> _data = masterWmCoMbrcmpyPopService.getCountList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 구매회원사 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmco/getMasterWmCoMbrcmpyIKPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmCoMbrcmpyIKPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _session_com_code = _sessionInfo.getComCode();
		String _session_user_id = _sessionInfo.getUserId();
		String whAdmin = _sessionInfo.getWhAdmin();
		
		 pMap.put("com_code", _session_com_code);
		 pMap.put("user_id", _session_user_id);
		 pMap.put("whAdmin", whAdmin);
		 
		String _warehouse_agent = masterWmCoMgService.getForwarehouseAgent(pMap);
	
		pMap.put("st_wareHouse_agent", _warehouse_agent);
		List<Map<String,String>> _data = masterWmCoMbrcmpyPopService.getIKList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 일괄출고지시 구매회원사 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmco/getMasterWmCoMbrcmpyBpIKPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmCoMbrcmpyBpIKPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _session_com_code = _sessionInfo.getComCode();
		String _session_user_id = _sessionInfo.getUserId();
		String whAdmin = _sessionInfo.getWhAdmin();
		 pMap.put("com_code", _session_com_code);
		 pMap.put("user_id", _session_user_id);
		 pMap.put("whAdmin", whAdmin);
		String _warehouse_agent = masterWmCoMgService.getForwarehouseAgent(pMap);
	
		pMap.put("st_wareHouse_agent", _warehouse_agent);
		List<Map<String,String>> _data = masterWmCoMbrcmpyPopService.getBpIKList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 구매회원사 조회 팝업(new) - 출고건수 미표기 ver.
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmco/getMasterWmCoMbrcmpyNewIKPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmCoMbrcmpyNewIKPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _session_com_code = _sessionInfo.getComCode();
		String _session_user_id = _sessionInfo.getUserId();
		String whAdmin = _sessionInfo.getWhAdmin();
		
		 pMap.put("com_code", _session_com_code);
		 pMap.put("user_id", _session_user_id);
		 pMap.put("whAdmin", whAdmin);
		 
		String _warehouse_agent = masterWmCoMgService.getForwarehouseAgent(pMap);
	
		pMap.put("st_wareHouse_agent", _warehouse_agent);
		List<Map<String,String>> _data = masterWmCoMbrcmpyPopService.getNewIKList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
