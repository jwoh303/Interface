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
import com.koreab2b.mro.common.mpso.service.MasterMpSoOrderInfoAlterBeforePopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoOrderInfoAlterBeforePopController")
public class MasterMpSoOrderInfoAlterBeforePopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoOrderInfoAlterBeforePopController.class);

	@Autowired
	private MasterMpSoOrderInfoAlterBeforePopService masterMpSoOrderInfoAlterBeforePopService;
	 
	
	/**
	 * 주문정보 수정-수주접수전(협력사외) 조회 PG_06_M_006_01
	 * 정보수정
	 * @param pModel
	 * @param pMap 
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterBeforeMainPop.do",  method = {RequestMethod.GET,RequestMethod.POST}) 
	public String getMasterMpSoOrderInfoAlterBeforeMainPop(ModelMap pModel  ,HttpServletRequest req, @RequestParam Map<String, String> pMap) { 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
	//	pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());  
		
		List<Map<String, String>> _data = masterMpSoOrderInfoAlterBeforePopService.getSysopOrderChangePoBeforeHDPop(pMap); 		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));    
		
		String cardUseCheck = masterMpSoOrderInfoAlterBeforePopService.getPrCardUseCheck(pMap); 		
		pModel.addAttribute("cardUseCheck", cardUseCheck);   
		 
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "/common/popup/mpso/masterMpSoOrderInfoAlterBeforePop_v2";
		}else {
			return "/common/popup/mpso/masterMpSoOrderInfoAlterBeforePop";
		}
	}
	
	/**
	* 주문진행 - 거래내역집계
	* @param pModel
	* @param pMap 
	* @return
	*/	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderTotalAmtMainPop.do",  method = {RequestMethod.GET,RequestMethod.POST}) 
	public String getMasterMpSoOrderTotalAmtMainPop(ModelMap pModel  ,HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		
		//pMap = CommonUtil.removeSlash(pMap);
		List<Map<String, String>> _data = masterMpSoOrderInfoAlterBeforePopService.getSysopOrderTotalAmtMainPop(pMap); 	
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));    
		
		
		return "/common/popup/mpso/masterMpSoOrderTotalAmtMainPop";
	}
	
	/**
	* 주문진행 - 고객사별거래내역집계
	* @param pModel
	* @param pMap 
	* @return
	*/	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderTotalBuyerAmtMainPop.do",  method = {RequestMethod.GET,RequestMethod.POST}) 
	public String getMasterMpSoOrderTotalBuyerAmtMainPop(ModelMap pModel  ,HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		
		//pMap = CommonUtil.removeSlash(pMap);
		List<Map<String, String>> _data = masterMpSoOrderInfoAlterBeforePopService.getSysopOrderTotalBuyerAmtMainPop(pMap); 	
		//System.out.print("getMasterMpSoOrderTotalBuyerAmtMainPop====================================="+_data);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));    
		
		
		return "/common/popup/mpso/masterMpSoOrderTotalBuyerAmtMainPop";
	}
	
	/**
	 * 주문정보 수정-수주접수전(협력사외) 조회 PG_06_M_006_01
	 * 수량분할
	 * @param pModel
	 * @param pMap 
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterBeforeMainDivisionPop.do",  method = {RequestMethod.GET,RequestMethod.POST}) 
	public String getMasterMpSoOrderInfoAlterBeforeMainDivisionPop(ModelMap pModel  ,HttpServletRequest req, @RequestParam Map<String, String> pMap) { 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
	//	pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());  
		
		List<Map<String, String>> _data = masterMpSoOrderInfoAlterBeforePopService.getSysopOrderChangePoBeforeHDPop(pMap); 		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));    
		
		String cardUseCheck = masterMpSoOrderInfoAlterBeforePopService.getPrCardUseCheck(pMap); 		
		pModel.addAttribute("cardUseCheck", cardUseCheck);   
		 
		
		return "/common/popup/mpso/masterMpSoOrderInfoAlterBeforeDivisionPop";
	}
	
	
	/**
	 * 주문정보 수정-수주접수전(협력사외) 조회 PG_06_M_006_01 리스트
	 * 정보수정
	 * @param pModel
	 * @param pMap 
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterBeforeListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoOrderInfoAlterBeforeListPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoOrderInfoAlterBeforePopService.getSysopOrderChangePoBeforeDTPop(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterBeforeListPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoOrderInfoAlterBeforeListPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoOrderInfoAlterBeforePopService.getSysopOrderChangePoBeforeDTPop_v2(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 주문정보 수정-수주접수전(협력사외) 조회 PG_06_M_006_01 리스트
	 * 수량분할
	 * @param pModel
	 * @param pMap 
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterBeforeListDivisionPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoOrderInfoAlterBeforeListDivisionPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoOrderInfoAlterBeforePopService.getSysopOrderChangePoBeforeDivisionDTPop(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	

	/**
	 * 주문정보수정 통합처리 로직 
	 */
	@RequestMapping(value = "/mpso/saveOrderChangeCombineLogic.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveOrderChangeCombineLogic(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() ); 
		formData.put("budgetFlag", _sessionInfo.getBudgetFlag() ); // 예산사용여부
		
		
		String msg = masterMpSoOrderInfoAlterBeforePopService.saveOrderChangeCombineLogic(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	/**
	 * 긴급발주변경
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/saveOrderUpdateEmegancyPo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveOrderUpdateEmegancyPo(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String msg = masterMpSoOrderInfoAlterBeforePopService.setSysopOrderUpdateEmegancyPo(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
		
	}	
	/* 조회 */
	
	/**
	 * 주문정보수정 수량분할
	 */
	@RequestMapping(value = "/mpso/saveOrderChangeDivisionCombineLogic.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveOrderChangeDivisionCombineLogic(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		formData.put("budgetFlag", _sessionInfo.getBudgetFlag() ); // 예산사용여부
		
		
		String msg = masterMpSoOrderInfoAlterBeforePopService.saveOrderChangeDivisionCombineLogic(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 발주초기화 --> saveOrderChangeCombineLogic 로 통합으로 사용안함
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_after_poinit.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeClear.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeClear(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		formData.put("budgetFlag", _sessionInfo.getBudgetFlag() ); // 예산사용여부
		
		
		String msg = masterMpSoOrderInfoAlterBeforePopService.saveSysopOrderChangeClear(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	

	
	/**
	 *  발주삭제 --> saveOrderChangeCombineLogic 로 통합으로 사용안함
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_before_delete.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeBeforeDelete(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		
		String msg = masterMpSoOrderInfoAlterBeforePopService.setSysopOrderChangeBeforeDelete(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	/**
	 *  발주 종결 --> saveOrderChangeCombineLogic 로 통합으로 사용안함
	 *  
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeEnd.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeEnd(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		
		String msg = masterMpSoOrderInfoAlterBeforePopService.saveSysopOrderChangeEnd(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	 
	

	/**
	 *  발주수량/단가/납기요청일/공급사품목코드/관리번호 변경 --> saveOrderChangeCombineLogic 로 통합으로 사용안함
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_before_save.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeBeforeSave.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeBeforeSave(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = masterMpSoOrderInfoAlterBeforePopService.setSysopOrderChangeBeforeSave(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	/**
	 *  거래유형 변경 --> saveOrderChangeCombineLogic 로 통합으로 사용안함
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_before_process_type_modify.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeBeforeProcessTypeModify.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeBeforeProcessTypeModify(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		
		String msg = masterMpSoOrderInfoAlterBeforePopService.setSysopOrderChangeBeforeProcessTypeModify(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	/**
	 *  공급사변경 --> saveOrderChangeCombineLogic 로 통합으로 사용안함
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_before_agent_modify.jsp
	 */
	@RequestMapping(value = "/mpso/saveSysopOrderChangeBeforeAgentModify.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSysopOrderChangeBeforeAgentModify(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		
		String msg = masterMpSoOrderInfoAlterBeforePopService.setSysopOrderChangeBeforeAgentModify(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	/**
	 *  사내매출 체크 -- 사용안함
	 * /kr/sysop/proxbuy/order/progress/sysop_order_progress_order_change_po_before_interbiz_check.jsp
	 */
	@RequestMapping(value = "/mpso/saveBeforeCheckInterBizPoStatus.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBeforeCheckInterBizPoStatus(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		
		String msg = masterMpSoOrderInfoAlterBeforePopService.setCheckInterBizPoStatus(formData,gridData);
		 
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	
	
	
	/**
	 *  getBuyerStandardRate -- 사용????????
	 * /kr/sysop/proxbuy/primecost/sysop_proxybuy_primecost_standard_rate.jsp
	 */
	@RequestMapping(value = "/mpso/getPrimecostStandardRate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPrimecostStandardRate(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>(); 		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("userid", _sessionInfo.getUserId()); 
		formData.put("buyer", _sessionInfo.getComCode() );
		
		
		
		double buyerRateInfo = masterMpSoOrderInfoAlterBeforePopService.getBuyerRateInfo(formData,gridData);
		double processTypeRateInfo = masterMpSoOrderInfoAlterBeforePopService.getProcessTypeRateInfo(formData,gridData);
		double buyerStandardRate = masterMpSoOrderInfoAlterBeforePopService.getBuyerStandardRate(formData,gridData);
		String betBuyerRateAdaptFlag = masterMpSoOrderInfoAlterBeforePopService.getBuyerRateAdaptFlag(formData,gridData);
		List<Map<String, String>> totProcessTypeRateInfo = masterMpSoOrderInfoAlterBeforePopService.getTotProcessTypeRateInfo(formData,gridData);
		
		String msg = "";
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", msg);
		return _response;
	}
	 
	/**
	 *  매출원가 Calc  getBuyerPrimeCostRate
	 * /kr/sysop/proxbuy/primecost/sysop_proxybuy_primecost_common.jsp
	 */
	@RequestMapping(value = "/mpso/getPrimecostCommon.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPrimecostCommon(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		

		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String agent_code = pMap.get("st_agent_code");
		
		LOGGER.debug("getPrimecostCommon pMap : {}", pMap);		
		double item_rate = 0;
		
		double buyer_rate = masterMpSoOrderInfoAlterBeforePopService.getBuyerRateInfo2(pMap);
		//double processTypeRateInfo = masterMpSoOrderInfoAlterBeforePopService.getKePBuyerRateInfo(pMap);
		String buyer_adapt_flag = masterMpSoOrderInfoAlterBeforePopService.getBuyerRateAdaptFlag2(pMap);
		double process_import_rate = masterMpSoOrderInfoAlterBeforePopService.getProcessTypeRateInfo2(pMap);
		
		
		if("Y".equals(buyer_adapt_flag)) {

			if("KRSESI0003".equals(agent_code)) {
				item_rate	= buyer_rate;
			}else {
				item_rate	= buyer_rate+process_import_rate;
			}

		}else {
			item_rate = 0;
		}
		LOGGER.debug("getPrimecostCommon item_rate : {}", item_rate);		
		_msg.put("MSG", item_rate); 
		_response.put("msg", _msg);
		return  _response;
	} 
	
	
	
	
}
