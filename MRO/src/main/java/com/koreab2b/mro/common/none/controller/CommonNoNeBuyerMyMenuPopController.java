package com.koreab2b.mro.common.none.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.none.service.CommonNoNeBuyerMyMenuPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonNoNeBuyerMyMenuPopController")
public class CommonNoNeBuyerMyMenuPopController {
	
	@Autowired
	private CommonNoNeBuyerMyMenuPopService commonNoNeBuyerMyMenuPopService;
	
	/**
	 * 나의 메뉴 지정 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/none/getCommonNoNeBuyerMyMenuPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonNoNeBuyerMyMenuPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		List<Map<String, String>> _data = commonNoNeBuyerMyMenuPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/none/commonNoNeBuyerMyMenuPop";
	}
	
	/**
	 * 나의 메뉴 저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/none/saveCommonNoNeBuyerMyMenu.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveCommonNoNeBuyerMyMenu(@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String msg = commonNoNeBuyerMyMenuPopService.saveCommonNoNeBuyerMyMenu(pMap);
		
		// 세션정보에 바뀐 나의 메뉴 정보를 저장 한다.
		if("INSERT_OK".equals(msg)){
			HttpSession _session = request.getSession(true);
			SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
			List<Map<String,String>> myMenuList = commonNoNeBuyerMyMenuPopService.getMyMenuList(pMap);
			_sessionInfo.setMyMenuList(myMenuList);
			_session.setAttribute("sessionInfo", _sessionInfo);
			_msg.put("MY_MENU_LIST", myMenuList);
		}
		
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}
