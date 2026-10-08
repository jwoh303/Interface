package com.koreab2b.mro.buyer.mprq.controller;

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

import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqSpecChkResService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqSpecChkResController")
public class BuyerMpRqSpecChkResController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqSpecChkResController.class);

	@Autowired
	private BuyerMpRqSpecChkResService buyerMpRqSpecChkResService;
	
	
	/**
	 * 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMpRqSpecChkResList.do", method = RequestMethod.POST)
	public String getBuyerMpRqSpecChkResList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("buyerMpRqSpecChkRes 요청 파라미터 for jsp : {}", pMap);
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpRqSpecChkResService.getList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mprq/buyerMpRqSpecChkResList";
	}	

	
	
	/**
	 * 등록신청
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mprq/regReqBuyerMpRqSpecChkRes.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> regReqBuyerMpRqSpecChkRes( 
			ModelMap pModel,  
			@RequestParam MultiValueMap<String, String> pMap,
			 HttpServletRequest request) { 
		 
		LOGGER.debug("regReqBuyerMpRqSpecChkRes MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap); 			
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST
		
		String _ret =  buyerMpRqSpecChkResService.regData(gridData,formData); 
	 
		_response.put("msg", _ret);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}

	/**
	 * 장바구니 담기
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mprq/cartBuyerMpRqSpecChkRes.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> cartBuyerMpRqSpecChkRes( 
			ModelMap pModel,  
			@RequestParam MultiValueMap<String, String> pMap,
			 HttpServletRequest request) { 
		 
		LOGGER.debug("addReqBuyerMpRqSpecChkRes MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		List<Object>gridData = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap); 			
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST
		
		String _ret =  buyerMpRqSpecChkResService.addData(gridData,formData); 
	 
		_response.put("msg", _ret);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}

	
	/**
	 * 삭제
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mprq/delBuyerMpRqSpecChkRes.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> delBuyerMpRqSpecChkRes( 
			ModelMap pModel,  
			@RequestParam MultiValueMap<String, String> pMap,
			 HttpServletRequest request) { 
		 
		LOGGER.debug("delBuyerMpRqSpecChkRes MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		List<Object>gridData = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap); 			
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST
		
		String _ret =  buyerMpRqSpecChkResService.delData(gridData,formData); 
	 
		_response.put("msg", _ret);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}
	

}
