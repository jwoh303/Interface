package com.koreab2b.mro.master.mpso.controller;

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
import com.koreab2b.mro.master.mpso.service.MasterMpSoProgressService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoProgressController")
public class MasterMpSoProgressController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoProgressController.class);

	@Autowired
	private MasterMpSoProgressService masterMpSoProgressService;
	
	// 조회
	@RequestMapping(value = "/mpso/masterMpSoProgress.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void masterMpSoProgress(HttpServletRequest pReq , HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {		
		logger.debug("요청 파라미터 : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) pReq.getSession().getAttribute("sessionInfo");
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(pReq)));
		
		List<Map<String,String>> _data = masterMpSoProgressService.getList(pMap);

		pReq.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(pReq, pRes);		
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpso/excelMasterMpSoProgress.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		
		List<Map<String,String>> _data = masterMpSoProgressService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}	
	
	// 저장(FeedBack)
	@RequestMapping(value = "/mpso/saveMasterMpSoProgress.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpSoProgress(HttpServletRequest pReq, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : _list", _list);
		logger.debug("saveMasterMpSoProgres MultiValueMap 요청 파라미터 : formData", _pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		int flag = masterMpSoProgressService.updateSelectedData(_pMap, _list);
		_response.put("resultFlag", flag);

		return _response;
	}
	
	// 저장(FeedBack)
	@RequestMapping(value = "/mpso/saveFileMasterMpSoProgress.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveFileMasterMpSoProgress(HttpServletRequest pReq, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : _list", _list);
		logger.debug("saveFileMasterMpSoProgress MultiValueMap 요청 파라미터 : formData", _pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		int flag = masterMpSoProgressService.updateFileData(_pMap, _list);
		_response.put("resultFlag", flag);

		return _response;
	}
	/**
	 *  IKEN저장
	 * @param pReq
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/saveIKENMasterMpSoProgress.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveIKENMasterMpSoProgress(HttpServletRequest pReq, @RequestParam MultiValueMap<String, String> pMap) {
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : _list", _list);
		logger.debug("saveMasterMpSoProgres MultiValueMap 요청 파라미터 : formData", _pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		int flag = masterMpSoProgressService.saveIKENSelectedData(_pMap, _list);
		_response.put("resultFlag", flag);
		
		return _response;
	}
	
	// 컬럼 설정 팝업 
	@RequestMapping(value = "/mpso/showMasterMpSoMyColManagePop.do", method = RequestMethod.GET)
	public String showMasterMpSoMyColManagePop(ModelMap pModel ,@RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if(_sessionInfo != null){
			pMap.put("st_user_id", CommonUtil.nvl(_sessionInfo.getUserId(), ""));
			String myColInfo = masterMpSoProgressService.getMasterMpSoMyColManagePopList(pMap);
			pModel.addAttribute("my_col_info", myColInfo);
		}
		return "common/popup/mpso/masterMpSoMyColManagePop";
	}
	
	/**
	 * 컬럼 설정 저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/saveMasterMpSoMyColManagePop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpSoMyColManagePop(@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String msg = masterMpSoProgressService.saveMasterMpSoMyColManagePop(pMap);
		
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	// 주문진행(다운로드)조회
	@RequestMapping(value = "/mpso/showMasterMpSoProgressDownLoad.do", method = RequestMethod.GET)
	public String showMasterMpSoProgressDownLoad(ModelMap pModel ,@RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if(_sessionInfo != null){
			pMap.put("st_user_id", CommonUtil.nvl(_sessionInfo.getUserId(), ""));
			
			String myColInfo = masterMpSoProgressService.getMasterMpSoMyColManagePopList(pMap);
			pModel.addAttribute("my_col_info", myColInfo);
		}
		return "master/mpso/masterMpSoProgressDownLoadList";
	}
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoProgressDownLoad.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void getMasterMpSoProgressDownLoad(HttpServletRequest pReq , HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {		
		logger.debug("요청 파라미터 : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) pReq.getSession().getAttribute("sessionInfo");
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(pReq)));
		
		List<Map<String,String>> _data = masterMpSoProgressService.getDownLoadList(pMap);

		pReq.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(pReq, pRes);		
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mpso/excelMasterMpSoProgressDownLoad.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMpSoProgressDownLoad(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		
		List<Map<String,String>> _data = masterMpSoProgressService.getDownLoadList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
}
