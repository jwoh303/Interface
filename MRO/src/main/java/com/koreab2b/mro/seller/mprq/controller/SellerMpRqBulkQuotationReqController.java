package com.koreab2b.mro.seller.mprq.controller;

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
import com.koreab2b.mro.seller.mprq.service.SellerMpRqBulkQuotationReqService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpRqBulkQuotationReqController")
public class SellerMpRqBulkQuotationReqController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMpRqBulkQuotationReqController.class);

	@Autowired
	private SellerMpRqBulkQuotationReqService sellerMpRqBulkQuotationReqService;
	
	//프로젝트 조회
	@RequestMapping(value = "/mprq/showSellerProjectList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerProjectList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		return "common/popup/mprq/sellerMpRqBulkQuotationSelProjectPop";
	}
	@RequestMapping(value = "/mprq/getSellerProjectList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerProjectList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 회사코드 : {}", _sessionInfo.getComCode());		
		pMap.put("COM_CODE", _sessionInfo.getComCode()); // 사용자ID
		
		LOGGER.debug("showSellerProjectList 요청 파라미터 for jsp : {}", pMap);
		Map<String,String> tmp = new HashMap<String, String>();
		for (Map.Entry<String, Object> entry : pMap.entrySet()) {
            Object value = entry.getValue();
            tmp.put(entry.getKey(), value != null ? value.toString() : null);
        }
		List<Map<String, String>> _data = sellerMpRqBulkQuotationReqService.getProejctList(tmp);
		
		return IBSheetUtil.addResut(req, _data , pMap);
		
	}

	// 프로젝트 유의사항 조회(jsp 빨간부분 채우는 용)
	@RequestMapping(value = "/mprq/getProjectRemark.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getProjectRemark(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getProjectRemark 요청 파라미터 for jsp : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		List<Map<String, String>> list = sellerMpRqBulkQuotationReqService.getProjectRemark(pMap);
		
		_response.put("list", list);

		return  _response;
	}
		
	// 견적요청 건 조회
	@RequestMapping(value = "/mprq/getSellerMpRqBulkQuotationReqList.do", method = RequestMethod.POST)
	public void getSellerMpRqBulkQuotationReqList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getSellerMpRqBulkQuotationReqList 요청 파라미터 for jsp : {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 회사코드 : {}", _sessionInfo.getComCode());		
		pMap.put("COM_CODE", _sessionInfo.getComCode()); // 사용자ID
		
		List<Map<String,String>> _data = sellerMpRqBulkQuotationReqService.getList(pMap);

		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}	

	// (재계약) 동일단가 적용
	@RequestMapping(value = "/mprq/updateSellerMpRqBulkQuotationReqSamePrice.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpRqBulkQuotationReqSamePrice(ModelMap pModel, HttpServletRequest req,  @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 회사코드 : {}", _sessionInfo.getComCode());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		String flag = sellerMpRqBulkQuotationReqService.updateSellerMpRqBulkQuotationReqSamePrice(formData, gridData);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	// 견적 제출취소
	@RequestMapping(value = "/mprq/updateSellerMpRqBulkQuotationReqCancelSubmit.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpRqBulkQuotationReqCancelSubmit(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 회사코드 : {}", _sessionInfo.getComCode());		
		pMap.put("COM_CODE", _sessionInfo.getComCode()); 
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		String flag = sellerMpRqBulkQuotationReqService.updateSellerMpRqBulkQuotationReqCancelSubmit(pMap);
		
		_response.put("msg", flag);
		
		return  _response;
	}
	
	// 견적제출
	@RequestMapping(value = "/mprq/updateSellerMpRqBulkQuotationReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpRqBulkQuotationReq(ModelMap pModel, HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 회사코드 : {}", _sessionInfo.getComCode());		
		formData.put("COM_CODE", _sessionInfo.getComCode()); 
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		String flag = sellerMpRqBulkQuotationReqService.updateSellerMpRqBulkQuotationReq(formData, gridData);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	// 임시저장
	@RequestMapping(value = "/mprq/updateSellerMpRqBulkQuotationReqTemp.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpRqBulkQuotationReqTemp(ModelMap pModel, HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 회사코드 : {}", _sessionInfo.getComCode());		
		formData.put("COM_CODE", _sessionInfo.getComCode()); 
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		String flag = sellerMpRqBulkQuotationReqService.updateSellerMpRqBulkQuotationReqTemp(formData, gridData);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	// 견적포기
	@RequestMapping(value = "/mprq/giveupsellerMpRqBulkQuotation.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> giveupsellerMpRqBulkQuotation(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 회사코드 : {}", _sessionInfo.getComCode());		
		pMap.put("COM_CODE", _sessionInfo.getComCode()); 
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		String flag = sellerMpRqBulkQuotationReqService.giveupSellerMpRqBulklQuotationReq(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	// 상단 물류수수료율 가져오기
	@RequestMapping(value = "/mprq/getLogisFee.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getLogisFee(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("COM_CODE", _sessionInfo.getComCode()); 
		LOGGER.debug("로그인 사용자 회사코드 : {}", _sessionInfo.getComCode());		
		
		String fee = sellerMpRqBulkQuotationReqService.getLogisFee(pMap);
		
		_response.put("logis_fee", fee);

		return  _response;
	}
	
}
