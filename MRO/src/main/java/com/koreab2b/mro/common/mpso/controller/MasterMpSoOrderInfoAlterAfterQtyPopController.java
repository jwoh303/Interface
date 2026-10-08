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

import com.koreab2b.mro.common.mpso.service.MasterMpSoOrderInfoAlterAfterQtyPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterMpSoOrderInfoAlterAfterQtyPopController")
public class MasterMpSoOrderInfoAlterAfterQtyPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoOrderInfoAlterAfterQtyPopController.class);

	@Autowired
	private MasterMpSoOrderInfoAlterAfterQtyPopService masterMpSoOrderInfoAlterAfterQtyPopService;
	
 
	
	/**
	 * 주문정보 수정-수주접수후(수량)  PG_06_M_006_03
	 * @param pModel
	 * @param pMap 
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterAfterQtyMainPop.do",  method = {RequestMethod.GET,RequestMethod.POST}) 
	public String getMasterMpSoOrderInfoAlterAfterQtyMainPop(ModelMap pModel  ,HttpServletRequest req, @RequestParam Map<String, String> pMap) { 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());  
		
		List<Map<String, String>> _data = masterMpSoOrderInfoAlterAfterQtyPopService.getSysopOrderChangePoAfterHDPop(pMap); 		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));   
		return "/common/popup/mpso/masterMpSoOrderInfoAlterBeforePop";
	}
	
	
	/**
	 * 주문정보 수정-수주접수후(수량)  PG_06_M_006_03 리스트
	 * @param pModel
	 * @param pMap 
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterAfterQtyListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoOrderInfoAlterAfterQtyListPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoOrderInfoAlterAfterQtyPopService.getSysopOrderChangePoAfterDTPop(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 납품예정수량 변경
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_after_qtychange.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeAfterQtyChange.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeAfterQtyChange(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId());  
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = masterMpSoOrderInfoAlterAfterQtyPopService.setSysopOrderChangeAfterQtyChange(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	
}
