package com.koreab2b.mro.buyer.mpso.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoCartUploadService;
import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoCartUploadController")
public class BuyerMpSoCartUploadController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartUploadController.class);

	@Autowired
	private BuyerMpSoCartUploadService buyerMpSoCartUploadService;
	
	@Autowired
	private CommonInfoService commonInfoService;
	
	// 조회 PG_06_B_013_00
	@RequestMapping(value = "/mpso/getBuyerMpSoCartUploadList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoCartUploadList(ModelMap pModel ,  HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		//LOGGER.debug("/mpso/getBuyerMpSoCartUploadList.do 요청 파라미터 : {}", pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("dept", _sessionInfo.getDepartment() );
		
		// 화면 조회
		pMap.put("paging", "0"); 
		List<Map<String, String>> _data = buyerMpSoCartUploadService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpso/buyerMpSoCartUploadList";
	}
	 
	/**
	 * 엑셀업로드 
	 */
	@RequestMapping(value = "/mpso/setExcelUp.do", method = RequestMethod.POST) 
	public String setExcelUp(HttpServletRequest request, 
			ModelMap pModel, 
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
			@RequestParam Map<String, String> pMap)  {
 
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		//LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("dept", _sessionInfo.getDepartment() );
		
		String result =  commonInfoService.excelFileUpload(request, pModel, uploadForm, pMap);
		
		//LOGGER.debug(" result {} " ,result);
		
		pMap.put("result", result);
		buyerMpSoCartUploadService.setExcelUp(pMap);

		pMap.put("st_cart_type", pMap.get("cart_type"));
		
		// 화면 조회
		pMap.put("paging", "0"); 
		List<Map<String, String>> _data = buyerMpSoCartUploadService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpso/buyerMpSoCartUploadList";
	} 
	
	 
	/**
	 * 장바구니담기
	 */
	@RequestMapping(value = "/mpso/setCartAddReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setCartAddReg(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("dept", _sessionInfo.getDepartment() );
		 
		buyerMpSoCartUploadService.setCartAddReg(pMap);

		 
		_msg.put("MSG", "UPDATE_OK"); 
		_response.put("msg", _msg);
		return  _response;
	} 
	
	/**
	 * 삭제
	 */
	@RequestMapping(value = "/mpso/setCartAddDel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setCartAddDel(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("dept", _sessionInfo.getDepartment() );
		
		buyerMpSoCartUploadService.setCartAddDel(pMap);

		 
		_msg.put("MSG", "UPDATE_OK"); 
		_response.put("msg", _msg);
		return  _response;
	} 
	
	
	
	
	
	
	
	
	
	
}
