package com.koreab2b.mro.master.wmgi.controller;

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
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.wmco.service.MasterWmCoMgService;
import com.koreab2b.mro.master.wmgi.service.MasterWmGiReleaseDirectionsTranService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmGiReleaseDirectionsTranController")
public class MasterWmGiReleaseDirectionsTranController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGiReleaseDirectionsTranController.class);

	@Autowired
	private MasterWmGiReleaseDirectionsTranService masterWmGiReleaseDirectionsTranService;
	
	@Autowired
	private MasterWmCoMgService masterWmCoMgService;
	
	// 조회
	@RequestMapping(value = "/wmgi/getMasterWmGiReleaseDirectionsTranList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmGiReleaseDirectionsTranList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _session_com_code = _sessionInfo.getComCode();
		String _session_user_id = _sessionInfo.getUserId();
		String whAdmin = _sessionInfo.getWhAdmin();
		
		 pMap.put("com_code", _session_com_code);
		 pMap.put("user_id", _session_user_id);
		 pMap.put("whAdmin", whAdmin);
		 
		String _warehouse_agent = masterWmCoMgService.getForwarehouseAgent(pMap);
		pMap.put("st_warehouse_agent", _warehouse_agent);
		
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterWmGiReleaseDirectionsTranService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 조회
	@RequestMapping(value = "/wmgi/getMasterWmGiBpReleaseDirectionsTranList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmGiReleaseBpDirectionsTranList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _session_com_code = _sessionInfo.getComCode();
		String _session_user_id = _sessionInfo.getUserId();
		String whAdmin = _sessionInfo.getWhAdmin();
		
		 pMap.put("com_code", _session_com_code);
		 pMap.put("user_id", _session_user_id);
		 pMap.put("whAdmin", whAdmin);
		 
		String _warehouse_agent = masterWmCoMgService.getForwarehouseAgent(pMap);
		pMap.put("st_warehouse_agent", _warehouse_agent);
		
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterWmGiReleaseDirectionsTranService.getBpList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 엑셀다운로드
	@RequestMapping(value = "/wmgi/excelMasterWmGiReleaseDirectionsTranList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmGiReleaseDirectionsTranService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/wmgi/excelMasterWmGiBpReleaseDirectionsTranList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList1(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		//페이징용 파라미터의 셋팅
		//pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmGiReleaseDirectionsTranService.getBpList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// 저장
	@RequestMapping(value = "/wmgi/saveMasterWmGiReleaseDirectionsTranList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterWmGiReleaseDirectionsTran(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterWmGiReleaseDirectionsTranService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/wmgi/delMasterWmGiReleaseDirectionsTranList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterWmGiReleaseDirectionsTran(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterWmGiReleaseDirectionsTran MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterWmGiReleaseDirectionsTranService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/wmgi/excelMasterWmGiBuyerReleaseList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterWmGiBuyerReleaseList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
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
		
		List<Map<String,String>> _data = masterWmGiReleaseDirectionsTranService.getExcelList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// 일양, 한진택배 여부 조회
	@RequestMapping(value = "/wmgi/getMasterWmGiBpReleaseDirectionsTranDeliCompany.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getMasterWmGiBpReleaseDirectionsTranDeliCompany(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
				
		logger.debug("요청 파라미터 : pMap", pMap);
		
		String rtnMsg = masterWmGiReleaseDirectionsTranService.getDeliCompany(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
