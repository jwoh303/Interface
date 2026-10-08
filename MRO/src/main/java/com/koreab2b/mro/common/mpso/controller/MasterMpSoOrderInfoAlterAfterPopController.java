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
import org.springframework.util.MultiValueMap;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpso.service.MasterMpSoOrderInfoAlterAfterPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoOrderInfoAlterAfterPopController")
public class MasterMpSoOrderInfoAlterAfterPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoOrderInfoAlterAfterPopController.class);

	@Autowired
	private MasterMpSoOrderInfoAlterAfterPopService masterMpSoOrderInfoAlterAfterPopService; 
	
	/**
	 * 주문정보 수정-수주접수후(협력사외) 조회 PG_06_M_006_02
	 * @param pModel
	 * @param pMap 
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterAfterMainPop.do",  method = {RequestMethod.GET,RequestMethod.POST}) 
	public String getMasterMpSoOrderInfoAlterAfterMainPop(ModelMap pModel  ,HttpServletRequest req, @RequestParam Map<String, String> pMap) { 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());  
		
		List<Map<String, String>> _data = masterMpSoOrderInfoAlterAfterPopService.getSysopOrderChangePoAfterHDPop(pMap); 		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));   
		return "/common/popup/mpso/masterMpSoOrderInfoAlterBeforePop";
	}
	
	
	/**
	 * 주문정보 수정-수주접수후(협력사외) 조회 PG_06_M_006_02 리스트
	 * @param pModel
	 * @param pMap 
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterAfterListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoOrderInfoAlterAfterListPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoOrderInfoAlterAfterPopService.getSysopOrderChangePoAfterDTPop(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	
	

	/**
	 *  저장
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_after_save.jsp"
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeAfterSave.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeAfterSave(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		String msg = masterMpSoOrderInfoAlterAfterPopService.setSysopOrderChangeAfterSave(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	

	/**
	 *  거래유형 변경
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_after_process_type_modify.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeAfterProcessTypeModify.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeAfterProcessTypeModify(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 	
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = masterMpSoOrderInfoAlterAfterPopService.setSysopOrderChangeAfterProcessTypeModify(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	
	/**
	 *  공급사변경
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_after_agent_modify.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeAfterAgentModify.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeAfterAgentModify(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = masterMpSoOrderInfoAlterAfterPopService.setSysopOrderChangeAfterAgentModify(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	
	/**
	 *  발주삭제
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_after_delete.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeAfterDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeAfterDelete(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		String msg = masterMpSoOrderInfoAlterAfterPopService.setSysopOrderChangeAfterDelete(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	
	/**
	 *  단가 변경  마감여부확인
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_after_price_ar_check.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeAfterPrice.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeAfterPrice(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 	
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = masterMpSoOrderInfoAlterAfterPopService.setSysopOrderChangeAfterPrice(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	
	/**
	 *  납기요청일 변경
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_after_rddate.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeAfterRdDate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeAfterRdDate(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = masterMpSoOrderInfoAlterAfterPopService.setSysopOrderChangeAfterRdDate(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	
	/**
	 *  발주초기화
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_after_poinit.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeAfterPoInit.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeAfterPoInit(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = masterMpSoOrderInfoAlterAfterPopService.setSysopOrderChangeAfterPoInit(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	
	
	
	
	
	
	
	
	/**
	 *  단가 변경
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_after_price.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeAfterPrice2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeAfterPrice2(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		String msg = masterMpSoOrderInfoAlterAfterPopService.setSysopOrderChangeAfterPrice2(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	 
	
	
	/**
	 *  사내매출 체크
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_after_interbiz_check.jsp
	 */
	@RequestMapping(value = "/mpso/saveAfterCheckInterBizPoStatus.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveAfterCheckInterBizPoStatus(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = masterMpSoOrderInfoAlterAfterPopService.setCheckInterBizPoStatus(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	 
	
}
