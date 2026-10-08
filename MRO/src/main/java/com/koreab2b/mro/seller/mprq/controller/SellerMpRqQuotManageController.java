package com.koreab2b.mro.seller.mprq.controller;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.coco.service.CommonPopupService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.seller.mprq.service.SellerMpRqQuotManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpRqQuotManageController")
public class SellerMpRqQuotManageController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(SellerMpRqQuotManageController.class);
	
	@Autowired
	private SellerMpRqQuotManageService sellerMpRqQuotManageService;
	@Autowired
	private CommonPopupService commonPopupService;
	
	// 리뉴얼 > 전체탭 > 조회
	@RequestMapping(value = "/mprq/getSellerMpRqQuotaList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpRqQuotaList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpRqQuotaProceState_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = sellerMpRqQuotManageService.getSellerMpRqQuotaList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 리뉴얼 > 견적상세팝업 > 견적요청,포기
	@RequestMapping(value = "/mprq/saveSellerMpRqQuotaDetailReqList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpRqQuotaDetailReqList_v2(ModelMap pModel, HttpServletRequest request,@RequestParam Map<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>();
		
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		_response = sellerMpRqQuotManageService.saveSellerMpRqQuotaDetailReqList_v2(pMap);
		
		return  _response;
	}
	// 리뉴얼 > 견적상세팝업 > 저장
	@RequestMapping(value = "/mprq/saveSellerMpRqQuotaDetailProceList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpRqQuotaDetailProceList_v2(ModelMap pModel, HttpServletRequest request,@RequestParam Map<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>();
		
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		_response = sellerMpRqQuotManageService.saveSellerMpRqQuotaDetailProceList_v2(pMap);
		
		return  _response;
	}
	
	// 리뉴얼 > 견적요청탭 > 조회
	@RequestMapping(value = "/mprq/getSellerMpRqQuotaReqList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpRqQuotaReqList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpRqQuotaProceState_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = sellerMpRqQuotManageService.getSellerMpRqQuotaReqList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 리뉴얼 > 견적요청탭 > 견적요청,포기
	@RequestMapping(value = "/mprq/saveSellerMpRqQuotaReqList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpRqQuotaReqList_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = sellerMpRqQuotManageService.saveSellerMpRqQuotaReqList_v2(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	// 리뉴얼 > 견적제출탭 > 저장
	@RequestMapping(value = "/mprq/saveSellerMpRqQuotaList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpRqQuotaList_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = sellerMpRqQuotManageService.saveSellerMpRqQuotaList_v2(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
}
