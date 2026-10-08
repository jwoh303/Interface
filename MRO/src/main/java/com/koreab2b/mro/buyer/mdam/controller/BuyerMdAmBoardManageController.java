package com.koreab2b.mro.buyer.mdam.controller;

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

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmBoardManageService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmBoardManageController")
public class BuyerMdAmBoardManageController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBoardManageController.class);

	@Autowired
	private BuyerMdAmBoardManageService buyerMdAmBoardManageService;
	
	@RequestMapping(value = "/mdam/showBuyerMdAmBoardManage.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showEbizNewsList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		//페이징시 필요한 default value
		pMap.put("paging", "1");
		pMap.put("curPage", "1");
		pMap.put("onepagerow", "10");
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		String isAdmin = _sessionInfo.getUserType().equals("A")?"Y":"N"; 
		pMap.put("isAdmin", isAdmin); 	
		pMap.put("st_byca_comorg_code", _sessionInfo.getBycaComorgCode());
		
		List<Map<String, String>> _data = buyerMdAmBoardManageService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "buyer/mdam/buyerMdAmBoardManageList";
	}
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmBoardManage.do", method = RequestMethod.POST)
	public String getBuyerMdAmBoardManage(ModelMap pModel ,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {		
		
		logger.debug("요청 파라미터 : {}", pMap);

		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		String isAdmin = _sessionInfo.getUserType().equals("A")?"Y":"N"; 
		pMap.put("isAdmin", isAdmin); 	
		
		
		List<Map<String, String>> _data = buyerMdAmBoardManageService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "buyer/mdam/buyerMdAmBoardManageList";
	}
	
	/**
	 * 상세
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/getBuyerMdAmBoardManageDetail.do", method = RequestMethod.POST)
	public String getBuyerMdAmBoardManageDetail(HttpServletRequest request, ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		// 일반 사용자용 화면일 경우 게시기간 끝난 공지사항 숨김. 
		String strWhere = _sessionInfo.getUserType().equals("A")?"":"AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN FROM_DATE AND TO_DATE"; 
		pMap.put("WHERE", strWhere); 	
		Map<String, String> _detailMap = buyerMdAmBoardManageService.getDetailList(pMap);
		
		pModel.addAttribute("detail", _detailMap);
		
		return "buyer/mdam/buyerMdAmBoardManageDetail";
	}	
	
	/**
	 * 수정처리
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/updateBuyerMdAmBoardManageDetail.do", method = RequestMethod.POST)
	public String updateBuyerMdAmBoardManageDetail(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		buyerMdAmBoardManageService.updateDetailList(pMap);
		
		pModel.addAttribute("result", "U");
		
		return "buyer/mdam/buyerMdAmBoardManageDetail";
	}	
	
	/**
	 * 삭제처리
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/deleteBuyerMdAmBoardManageDetail.do", method = RequestMethod.POST)
	public String deleteBuyerMdAmBoardManageDetail(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		buyerMdAmBoardManageService.deleteDetailList(pMap);
		
		pModel.addAttribute("result", "D");
		
		return "buyer/mdam/buyerMdAmBoardManageDetail";
	}	
	
	/**
	 * 등록처리
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/insertBuyerMdAmBoardManageDetail.do", method = RequestMethod.POST)
	public String boardWrite(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		buyerMdAmBoardManageService.insertDetailList(pMap);
		
		pModel.addAttribute("result", "S");
		
		return "buyer/mdam/buyerMdAmBoardManageWrite";
	}	
	
}
