package com.koreab2b.mro.manager.menu.controller;

import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.googlecode.ehcache.annotations.TriggersRemove;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.manager.main.service.MainService;
import com.koreab2b.mro.manager.menu.domain.Menu;
import com.koreab2b.mro.manager.menu.service.MenuService;
import com.koreab2b.mro.util.CommonUtil;
@Controller("menuConrtroller")
public class MenuController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MenuController.class);
	
	@Autowired
	private MenuService menuService;
	@Autowired
	private MainService mainService;
	@Autowired
	private MessageSource messageSource;
	
	@RequestMapping(value = "/menu/clearCache.do", method = RequestMethod.GET)
	@TriggersRemove(cacheName = "managerCache", removeAll=true)
	public String clearCache(HttpServletRequest request, ModelMap pModel) {
		return "redirect:/menu/getMenus.do";
	}
	
	@RequestMapping(value = "/menu/getMenus.do", method = RequestMethod.GET)
	public String getMenus(HttpServletRequest request, ModelMap pModel) {
		pModel.addAttribute("menus", menuService.getMenus());
		return "manager/menu/menuList";
	}

	@RequestMapping(value = "/menu/getMenu.do", method = RequestMethod.GET)
	public String getMenu(HttpServletRequest request, @RequestParam(value = "menuId") String pMenuId, ModelMap pModel) {
		pModel.addAttribute("menu", menuService.getMenu(pMenuId));
		return "manager/menu/menuForm";
	}

	@RequestMapping(value = "/menu/saveMenu.do", method = RequestMethod.POST)
	public String saveMenu(HttpServletRequest request, @ModelAttribute("menu") Menu pMenu, ModelMap pModel) {
		menuService.saveMenu(pMenu);
		return "redirect:/menu/getMenus.do";
	}

	@RequestMapping(value = "/menu/deleteMenu.do", method = RequestMethod.GET)
	public String deleteUser(HttpServletRequest request, @RequestParam(value = "checkedId", required = false) String[] pMenuIds, ModelMap pModel) {
		menuService.deleteMenu(pMenuIds);
		return "redirect:/menu/getMenus.do";
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/menu/menu.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getIncludeMenu(HttpServletRequest request, @RequestParam(value = "part") String pPart, @RequestParam(value = "page") String pPage,
			ModelMap pModel, RedirectAttributes redirectAttributes) throws UnsupportedEncodingException {
		List<String> _auths = (List<String>) request.getSession().getAttribute("authInfo");
		List<String> _roles = (List<String>) request.getSession().getAttribute("roleInfo");
		
		String _tUpperId = ""; // 최상위 부모 메뉴코드
		pPart = CommonUtil.nvl(request.getParameter("part"));
		String _upperId = CommonUtil.nvl(request.getParameter("upperId"));

		if (_upperId.length() > 4) {
			_tUpperId = _upperId.substring(0, 4);
		}
		String _script = CommonUtil.nvl(request.getParameter("script"));
		
		String SESSION_COWAY_FLAG = CommonUtil.nvl((String)request.getSession().getAttribute("SESSION_COWAY_FLAG"));
		if ("Y".equals(SESSION_COWAY_FLAG)){ // 코웨이일경우 
			if (request.getSession().getAttribute("SESSION_COWAY_SSO_LIST") != null){
				pModel.addAttribute("shotcutSsso", request.getSession().getAttribute("SESSION_COWAY_SSO_LIST"));
			}
		}
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		String authId = _sessionInfo.getUserAuth();  // authid를 이용하여 자기자신것만 가지고온다. - 메뉴속도개선을 위하여
		String empNo = _sessionInfo.getEmpNo();  // 타시스템 연동을 위해 사번을 넘겨줌
		String userId = _sessionInfo.getUserId();  // 타시스템 연동을 위해 사용자아이디을 넘겨줌
		String userName = _sessionInfo.getUserNameLoc();  // 타시스템 연동을 위해 사용자명을 넘겨줌
		String admin_ip = CommonUtil.nvl(_sessionInfo.getKepAdmIpList(), "N"); // 관리자메뉴 통제 IP 목록(ICOMCOD2.TYPE=ADMIP)
		//관리자메뉴 접근 제어 Default N이며 IP등록 된 사용자만 접근 가능.
		String AdimFlag = "N";
        try
        {
            String localhost = InetAddress.getLocalHost( ).toString( ); 
            StringTokenizer st = new StringTokenizer( localhost , "/" );
            st.nextToken( );
            String ip = CommonUtil.nvl(st.nextToken( ),"X");
            /* IP 가져오는 방식 체크
            String clientIp =  CommonUtil.nvl(request.getHeader("x-forwarded-for"),"X");
            String clientIp2 =  CommonUtil.nvl(request.getHeader("Proxy-Client-IP"),"X");
            String clientIp3 =  CommonUtil.nvl(request.getHeader("WL-Proxy-Client-IP"),"X");
            String clientIp4 =  CommonUtil.nvl(request.getHeader("HTTP_CLIENT_IP"),"X");
            String clientIp5 =  CommonUtil.nvl(request.getHeader("HTTP_X_FORWARDED_FOR"),"X");
            */
            String clientIp6 =  CommonUtil.nvl(request.getRemoteAddr(),"X");
            
            if(_sessionInfo.getBusinessCond().equals("M")){
	            //AdimFlag = "N"이면 관리자 화면 비활성화
	        	//ResourceBundle rb = ResourceBundle.getBundle("admin_menu_mng");
	        	//String adminIP = new String(rb.getString("ADMIN_IP").getBytes("ISO-8859-1"), "utf-8");
	        	String adminIP = admin_ip;
	        	//관리자메뉴 통제.
	        	if( adminIP.indexOf(ip) >-1 ||adminIP.indexOf(clientIp6) >-1){
	            	AdimFlag = "Y";
	            }else{
	            	AdimFlag = "N";
	            }
            	
	        	// 이철, 한애희, 홍지수 리뉴얼 분석 위해 임시. 발견한 사람 삭제 바람 HSJ 2025.04.30
	        	if(_sessionInfo.getUserId().equals("KEP200008") || _sessionInfo.getUserId().equals("KEP2109086") || _sessionInfo.getUserId().equals("KEP2229028")) {
	        		AdimFlag = "Y";
	        	}
            }
        }
        catch ( UnknownHostException e )
        {
            LOGGER.error(CommonUtil.printStackTraceToString(e));
        }
		String title = menuService.getLeftMenusByAuths(_auths, pPart,authId);
		String menu = menuService.getMenusByAuths(_auths, pPart, _tUpperId, _upperId, _roles, _script,authId, empNo, userId, userName, AdimFlag);
		if(pPart.equals("header_v2")){ //리뉴얼 협력사부분 헤더 메뉴 타이틀 + navi 뽑아야함
			String navi = menuService.getMenusByAuths(_auths, "navi", _tUpperId, _upperId, _roles, _script,authId, empNo, userId, userName, AdimFlag);
			pModel.addAttribute("navi",navi);
		}else if(pPart.equals("buyerHeader_v2")){ //리뉴얼 고객사 navi
			String navi = menuService.getMenusByAuths(_auths, "navi", _tUpperId, _upperId, _roles, _script,authId, empNo, userId, userName, AdimFlag);
			pModel.addAttribute("navi",navi);
			
			Map<String,String> tmpMap = new HashMap<String,String>();
			tmpMap.put("param1", _sessionInfo.getBycaComorgCode());
			tmpMap.put("param4", _sessionInfo.getComCode());
			tmpMap.put("param5", _sessionInfo.getUserId());
			String cateList = menuService.getMainCateList_v2(tmpMap); //카테고리 전체 만들어서 헤더로 넘김
			pModel.addAttribute("cateList", cateList);
		}
		// left 는 pPart 가 upperid 다
		pModel.addAttribute("title", title); 
		pModel.addAttribute("menu", menu);
		return "common/include/" + pPage;
	}
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/menu/buyerMainMenu.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String buyerMainMenu(HttpServletRequest request, @RequestParam(value = "part") String pPart, @RequestParam(value = "page") String pPage,
			ModelMap pModel, RedirectAttributes redirectAttributes) throws UnsupportedEncodingException {
		List<String> _auths = (List<String>) request.getSession().getAttribute("authInfo");
		List<String> _roles = (List<String>) request.getSession().getAttribute("roleInfo");
		
		String _tUpperId = ""; // 최상위 부모 메뉴코드
		pPart = CommonUtil.nvl(request.getParameter("part"));
		String _upperId = CommonUtil.nvl(request.getParameter("upperId"));

		if (_upperId.length() > 4) {
			_tUpperId = _upperId.substring(0, 4);
		}
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		String authId = _sessionInfo.getUserAuth();  // authid를 이용하여 자기자신것만 가지고온다. - 메뉴속도개선을 위하여
		String menu = menuService.getBuyerMainMenu(_auths, pPart, _tUpperId, _upperId, _roles,authId);
		// left 는 pPart 가 upperid 다
		pModel.addAttribute("menu", menu);
		return "common/include/buyerMainMenu";
	}
}
