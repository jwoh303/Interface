package com.koreab2b.mro.master.mdam.controller;

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

import com.googlecode.ehcache.annotations.TriggersRemove;
import com.koreab2b.mro.master.mdam.service.MasterMdAmInfoReferenceService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdAmInfoReferenceController")
public class MasterMdAmInfoReferenceController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmInfoReferenceController.class);

	@Autowired
	private MasterMdAmInfoReferenceService masterMdAmInfoReferenceService;
	
	@RequestMapping(value = "/mdam/showMasterMdAmInfoReference.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showEbizNewsList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		//페이징시 필요한 default value
		pMap.put("paging", "1");
		pMap.put("curPage", "1");
		pMap.put("onepagerow", "10");
		pMap.put("sbtype", "ALL");
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		
		List<Map<String, String>> _data = masterMdAmInfoReferenceService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "master/mdam/masterMdAmInfoReferenceList";
	}
	
	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmInfoReference.do", method = RequestMethod.POST)
	public String getMasterMdAmInfoReference(ModelMap pModel ,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {		
		
		logger.debug("요청 파라미터 : {}", pMap);

		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		String isAdmin = _sessionInfo.getUserType().equals("A")?"Y":"N"; 
		pMap.put("isAdmin", isAdmin); 	
		
		
		List<Map<String, String>> _data = masterMdAmInfoReferenceService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "master/mdam/masterMdAmInfoReferenceList";
	}
	
	/**
	 * 상세
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/getMasterMdAmInfoReferenceDetail.do", method = RequestMethod.POST)
	public String getMasterMdAmInfoReferenceDetail(HttpServletRequest request, ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, String> _detailMap = masterMdAmInfoReferenceService.getDetailList(pMap);
		
		pModel.addAttribute("detail", _detailMap);
		
		return "master/mdam/masterMdAmInfoReferenceDetail";
	}	
	
	/**
	 * 수정처리
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/updateMasterMdAmInfoReferenceDetail.do", method = RequestMethod.POST)
	@TriggersRemove(cacheName = "boardCache", removeAll=true)
	public String updateMasterMdAmInfoReferenceDetail(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		masterMdAmInfoReferenceService.updateDetailList(pMap);
		
		pModel.addAttribute("result", "U");
		
		return "master/mdam/masterMdAmInfoReferenceDetail";
	}	
	
	/**
	 * 삭제처리
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/deleteMasterMdAmInfoReferenceDetail.do", method = RequestMethod.POST)
	@TriggersRemove(cacheName = "boardCache", removeAll=true)
	public String deleteMasterMdAmInfoReferenceDetail(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		masterMdAmInfoReferenceService.deleteDetailList(pMap);
		
		pModel.addAttribute("result", "D");
		
		return "master/mdam/masterMdAmInfoReferenceDetail";
	}	
	
	/**
	 * 등록처리
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/insertMasterMdAmInfoReferenceDetail.do", method = RequestMethod.POST)
	@TriggersRemove(cacheName = "boardCache", removeAll=true)
	public String boardWrite(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		masterMdAmInfoReferenceService.insertDetailList(pMap);
		
		pModel.addAttribute("result", "S");
		
		return "master/mdam/masterMdAmInfoReferenceWrite";
	}	
	
}
