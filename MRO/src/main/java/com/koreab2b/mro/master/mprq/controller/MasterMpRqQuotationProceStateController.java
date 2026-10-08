package com.koreab2b.mro.master.mprq.controller;

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
import com.koreab2b.mro.master.mprq.service.MasterMpRqQuotationProceStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqQuotationProceStateController")
public class MasterMpRqQuotationProceStateController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqQuotationProceStateController.class);

	@Autowired
	private MasterMpRqQuotationProceStateService masterMpRqQuotationProceStateService;
	
	// 조회
	@RequestMapping(value = "/mprq/getMasterMpRqQuotationProceStateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqQuotationProceStateList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMpRqQuotationProceStateService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	//MSDS 반려조회
	@RequestMapping(value = "/mprq/getMasterMpRqQuotationReturnMsds.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqQuotationReturnMsds(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMpRqQuotationProceStateService.getReturnMsdsList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqQuotationReturnMsds.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqQuotationReturnMsds(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpRqQuotationProceStateService.saveMasterMpRqQuotationReturnMsds(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	// 엑셀다운로드
	@RequestMapping(value = "/mprq/excelMasterMpRqQuotationProceStateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqQuotationProceStateService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqQuotationProceStateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqQuotationProceState(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpRqQuotationProceStateService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// MSDS 변경
		@RequestMapping(value = "/mprq/saveMasterMpRqQuotationProceStateList2.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> updateMasterMpRqQuotationProceState2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();
			
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
			 
			String rtnMsg = masterMpRqQuotationProceStateService.updateSelectedData2(formData, gridData);

			/* 성공시코드 1 , 실패시 0 */
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("Code",1);
			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
			
		}
		
		// 저장
		@RequestMapping(value = "/mprq/saveMasterMprqQuotationAtoA.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> saveMasterMprqQuotationAtoA(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();

			String _rtnMsg = masterMpRqQuotationProceStateService.saveMasterMprqQuotationAtoA(pMap);

			_response.put("msg", _rtnMsg);
			return _response;
		}		
		// ATOS_DATE 변경
		@RequestMapping(value = "/mprq/saveMasterMpRqQuotationAtoSDate.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> saveMasterMpRqQuotationAtoSDate(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();
			
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
			 
			String rtnMsg = masterMpRqQuotationProceStateService.saveMasterMpRqQuotationAtoSDate(formData, gridData);

			/* 성공시코드 1 , 실패시 0 */
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("Code",1);
			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
			
		}
		
		//일괄 추가라운드 요청
		@RequestMapping(value = "/mprq/saveMasterMpRqQuotationSelectedRound.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> saveMasterMpRqQuotationSelectedRound(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();
			
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
			 
			String rtnMsg = masterMpRqQuotationProceStateService.saveMasterMpRqQuotationSelectedRound(formData, gridData);
				
			/* 성공시코드 1 , 실패시 0 */
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("Code",1);
			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
				
		}
		// 협력사견적요청 메일 전송
		@RequestMapping(value = "/mprq/saveMasterMpRqQuotationMailList.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> updateMasterMpRqQuotationMailList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			String rtnMsg = masterMpRqQuotationProceStateService.saveMasterMpRqQuotationMailList(formData, gridData);
			/* 성공시코드 1 , 실패시 0 */
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("Code",1);
			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
		}
		// 고객사 제출 비고 저장
		@RequestMapping(value = "/mprq/saveMasterMprqQuotationAtoB.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> saveMasterMprqQuotationAtoB(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();

			String _rtnMsg = masterMpRqQuotationProceStateService.saveMasterMprqQuotationAtoB(pMap);

			_response.put("msg", _rtnMsg);
			return _response;
		}
		
		// ANY 정비 제출
		@RequestMapping(value = "/mprq/updateMasterMpRqAnyItmCheSend.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> updateMasterMpRqAnyItmCheSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			LOGGER.debug("요청 파라미터 : {}", pMap);
			Map<String, Object> _response = new HashMap<String, Object>();
			
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
			String rtnMsg = masterMpRqQuotationProceStateService.updateMasterMpRqAnyItmCheSend(formData, gridData);
			/* 성공시코드 1 , 실패시 0 */
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("Code",1);
			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
		}
		
		// DM발송 이력 팝업
		@RequestMapping(value = "/mprq/getMasterMpRqQuotationDmRemindHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
		@ResponseBody
		public Map<String, Object> getMasterMpRqQuotationDmRemindHistPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
			LOGGER.debug("요청 파라미터 : {}", pMap);
			pMap = IBSheetUtil.addParamForPaging3(pMap);
			List<Map<String,String>> _data = masterMpRqQuotationProceStateService.getQuotationDmRemindHistList(pMap);
			return IBSheetUtil.addResut(req, _data , pMap);
		}
		
		// 비고 조회 팝업
		@RequestMapping(value = "/mprq/getMasterRemarkPostPop.do", method = RequestMethod.POST)
		public String getMasterRemarkPostPop(ModelMap pModel, HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, String> pMap) {
			 
			// 화면 조회
			Map<String, String> _data = masterMpRqQuotationProceStateService.getRemarkPop(pMap);		
			pModel.addAttribute("data", _data);			
			pModel.addAllAttributes(pMap);
			
			return "/common/popup/mprq/remarkPostPop";
		}
		
		// 견적 비고 저장
		@RequestMapping(value = "/mprq/saveRemarkPop.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> saveRemarkPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			LOGGER.debug("요청 파라미터 : {}", pMap);
			Map<String, Object> _response = new HashMap<String, Object>();			
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
			String rtnMsg = masterMpRqQuotationProceStateService.saveRemarkPop(formData);
			/* 성공시코드 1 , 실패시 0 */
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("Code",1);
			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
		}		
		
}
