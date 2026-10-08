package com.koreab2b.mro.common.none.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import com.koreab2b.mro.common.none.service.CommonNoNeMyMenuPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mprq.controller.SellerMpRqQuotManageController;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonNoNeMyMenuPopController")
public class CommonNoNeMyMenuPopController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(SellerMpRqQuotManageController.class);
	
	@Autowired
	private CommonNoNeMyMenuPopService commonNoNeMyMenuPopService;
	
	/**
	 * 나의 메뉴 지정 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */		
	// 나의메뉴 > 전체메뉴 가져오기
	@RequestMapping(value = "/mprq/getCommonNoNeMyMenuAllList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonNoNeMyMenuAllList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpRqQuotaProceState_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = commonNoNeMyMenuPopService.getCommonNoNeMyMenuAllList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 나의메뉴 > 나의메뉴 가져오기
	@RequestMapping(value = "/mprq/getCommonNoNeMyMenuList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonNoNeMyMenuList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpRqQuotaProceState_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = commonNoNeMyMenuPopService.getCommonNoNeMyMenuList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 나의 메뉴 저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/none/saveCommonNoNeMyMenu.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveCommonNoNeMyMenu(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		LOGGER.debug("saveCommonNoNeMyMenu 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = commonNoNeMyMenuPopService.saveCommonNoNeMyMenu(formData, gridData);
		
		// 세션정보에 바뀐 나의 메뉴 정보를 저장 한다.
		if("INSERT_OK".equals(rtnMsg)){
			HttpSession _session = req.getSession(true);
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			Map<String,Object> tempMap = new HashMap<String, Object>();
			tempMap.put("st_user_id", pMap.getFirst("st_user_id"));
			List<Map<String,String>> myMenuList = commonNoNeMyMenuPopService.getCommonNoNeMyMenuList(tempMap);
			_sessionInfo.setMyMenuList(myMenuList);
			_session.setAttribute("sessionInfo", _sessionInfo);
			_response.put("MY_MENU_LIST", myMenuList);
			
			rtnMsg = "나의 메뉴 설정이 완료되었습니다.";
		}
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", rtnMsg);
		mp.put("menuList", _response.get("MY_MENU_LIST"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	@RequestMapping(value = "/none/saveCommonNoNeMyMenuAjax.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveCommonNoNeMyMenuAjax(ModelMap pModel, @RequestParam Map<String, String> pMap,HttpServletRequest req) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = commonNoNeMyMenuPopService.saveCommonNoNeMyMenuAjax(pMap);
		
		// 세션정보에 바뀐 나의 메뉴 정보를 저장 한다.
		if("INSERT_OK".equals(flag)){
			HttpSession _session = req.getSession(true);
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			Map<String,Object> tempMap = new HashMap<String, Object>();
			tempMap.put("st_user_id", pMap.get("st_user_id"));
			List<Map<String,String>> myMenuList = commonNoNeMyMenuPopService.getCommonNoNeMyMenuList(tempMap);
			_sessionInfo.setMyMenuList(myMenuList);
			_session.setAttribute("sessionInfo", _sessionInfo);
			_response.put("MY_MENU_LIST", myMenuList);
			
			flag = "나의 메뉴 설정이 완료되었습니다.";
		}
				
		_response.put("msg", flag);

		return  _response;
	}
	/**
	 * 나의 메뉴 저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/none/addCommonNoNeMyMenu.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addCommonNoNeMyMenu(ModelMap pModel, HttpServletRequest request,@RequestParam Map<String, String> pMap) {
	
		HttpSession _session = request.getSession(true);
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_user_id", _sessionInfo.getUserId());
		Map<String, Object> _response = new HashMap<String, Object>();
		
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		_response = commonNoNeMyMenuPopService.addCommonNoNeMyMenu(pMap);
		if(_response.get("code").equals("OK")){
			
			Map<String,Object> tempMap = new HashMap<String, Object>();
			tempMap.put("st_user_id", pMap.get("st_user_id"));
			List<Map<String,String>> myMenuList = commonNoNeMyMenuPopService.getCommonNoNeMyMenuList(tempMap);
			_sessionInfo.setMyMenuList(myMenuList);
			_session.setAttribute("sessionInfo", _sessionInfo);
			_response.put("MY_MENU_LIST", myMenuList);
		}
		
		return  _response;
	}
	
}
