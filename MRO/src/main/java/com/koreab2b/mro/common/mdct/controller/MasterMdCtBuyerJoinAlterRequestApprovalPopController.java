package com.koreab2b.mro.common.mdct.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import com.koreab2b.mro.common.mdct.service.MasterMdCtBuyerJoinAlterRequestApprovalPopService;
import com.koreab2b.mro.common.mdcp.service.MasterMdCpAgntcmpyInfoAlterPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtBuyerJoinAlterRequestApprovalPopController")
public class MasterMdCtBuyerJoinAlterRequestApprovalPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtBuyerJoinAlterRequestApprovalPopController.class);
	@Autowired
	private MasterMdCtBuyerJoinAlterRequestApprovalPopService masterMdCtBuyerJoinAlterRequestApprovalPopService;
	@Autowired
	private MasterMdCpAgntcmpyInfoAlterPopService masterMdCpAgntcmpyInfoAlterPopService;
	/**
	 * 고객사 가입/변경요청 승인  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/showMasterMdCtBuyerJoinAlterRequestApprovalPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtBuyerJoinAlterRequestApprovalPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdct/getMasterMdCtBuyerJoinAlterRequestApprovalPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCtBuyerJoinAlterRequestApprovalPopService.getList(pMap);
		List<Map<String, String>> _dataDelyArea = masterMdCpAgntcmpyInfoAlterPopService.getDelyAreaList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("dataDelyArea", CommonUtil.getListNvl(_dataDelyArea)); //납품가능지역
		return "common/popup/mdct/masterMdCtBuyerJoinAlterRequestApprovalPop";
	}
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList 요청 파라미터 : {}", pMap);
	
		List<Map<String,String>> _data = masterMdCtBuyerJoinAlterRequestApprovalPopService.getChargeEntryList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장(FeedBack)
	@RequestMapping(value = "/mdct/saveMasterMdCtBuyerJoinAlterRequestApprovalPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtBuyerJoinAlterRequestApprovalPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
			String T_KEY  = "3972624753";
			LOGGER.debug("saveMasterMdCtBuyerJoinAlterRequestApprovalPop MultiValueMap 요청 파라미터 : formData", pMap); 
		
			Map<String, Object> _response = new HashMap<String, Object>();
			pMap.put("T_KEY", T_KEY);
			String _result = masterMdCtBuyerJoinAlterRequestApprovalPopService.updateSelectedData(pMap);

			
			
			//String flag = masterMdCtBuyerJoinAlterRequestApprovalPopService.updateSelectedData(_pMap, _list);
			/* 성공시코드 1 , 실패시 0 */
			//Map<String, Object> mp = new HashMap<String, Object>();
			//mp.put("Code",1);
			//_response.put("Result",mp);
			//_response.put("resultFlag", flag);
			
			/* 성공시코드 OK , 실패시 메세지 전송 */
			_response.put("msg", _result);
			return _response;
		}
	
	// 비밀번호 Valid Check
	@RequestMapping(value = "/mdct/pwdValidCheckMasterMdCtBuyerJoinAlterRequestApprovalPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> pwdValidCheckMasterMdCtBuyerJoinAlterRequestApprovalPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		LOGGER.debug("pwdValidCheckMasterMdCtBuyerJoinAlterRequestApprovalPop MultiValueMap 요청 파라미터 : formData {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();

		String _result = masterMdCtBuyerJoinAlterRequestApprovalPopService.getPwdValidCheck(pMap);
		
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}
	
	// KeP담당자 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("saveMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("saveMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCtBuyerJoinAlterRequestApprovalPopService.updateChargeEntryData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mdct/deleteMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("deleteMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("deletetMasterMdCtBuyerChargeEntryList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCtBuyerJoinAlterRequestApprovalPopService.deleteSelectedData(formData, gridData);
		_response.put("msg", rtnMsg);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
				
		return _response;
	}
	// SG별 매익율 조회
	@RequestMapping(value = "/mdct/getMasterMdCtBuyerJoinAlterMarginList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtBuyerJoinAlterMarginList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtBuyerJoinAlterMarginList 요청 파라미터 : {}", pMap);
	
		List<Map<String,String>> _data = masterMdCtBuyerJoinAlterRequestApprovalPopService.getSgMarginList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	// SG별 매익율저장
	@RequestMapping(value = "/mdct/saveMasterMdCtBuyerJoinAlterSgMarginList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtBuyerJoinAlterSgMarginList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCtBuyerJoinAlterRequestApprovalPopService.updateSgMargin(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
}
