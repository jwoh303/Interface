package com.koreab2b.mro.buyer.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmCategoryGoodsSearchService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

@Controller("buyerMdCmCategoryGoodsSearchController")
public class BuyerMdCmCategoryGoodsSearchController { 

	@Autowired
	private BuyerMdCmCategoryGoodsSearchService buyerMdCmCategoryGoodsSearchService;
	
	
	/**
	 * 카테고리 조회
	 * PG_06_B_001_00
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/getCategoriList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCategoriList(@RequestParam Map<String, String> pMap,  HttpServletRequest req) {
		//logger.debug("getCategoriList 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		
		pMap.put("param1", _sessionInfo.getBycaComorgCode());
		pMap.put("param4", _sessionInfo.getComCode());
		pMap.put("param5", _sessionInfo.getUserId());
	
		
		List<Map<String, String>> _data = buyerMdCmCategoryGoodsSearchService.getCategoriList(pMap);
		
		

		// _msgList.addAll(_msg);
		// System.out.println("_data " +_data);
		_response.put("data", _data);
		// System.out.println("_response " +_response);
		return _response;
	}
	
	/**
	 * 펀치아웃카테고리 조회
	 * PG_06_B_001_00
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/getCategoryPCOList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCategoryPCOList(@RequestParam Map<String, String> pMap,  HttpServletRequest req) {
		//logger.debug("getCategoriList 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		
		pMap.put("param1", _sessionInfo.getBycaComorgCode());
		pMap.put("param4", _sessionInfo.getComCode());
	
		
		List<Map<String, String>> _data = buyerMdCmCategoryGoodsSearchService.getCategoryPCOList(pMap);
		
		

		// _msgList.addAll(_msg);
		// System.out.println("_data " +_data);
		_response.put("data", _data);
		// System.out.println("_response " +_response);
		return _response;
	}
	/**
	 * 카테고리 조회
	 * PG_06_B_001_00
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/getStdCategoriList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getStdCategoriList(@RequestParam Map<String, String> pMap,  HttpServletRequest req) {
		//logger.debug("getCategoriList 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		
		pMap.put("param1", _sessionInfo.getBycaComorgCode());
	
		
		List<Map<String, String>> _data = buyerMdCmCategoryGoodsSearchService.getStdCategoriList(pMap);
		
		

		// _msgList.addAll(_msg);
		// System.out.println("_data " +_data);
		_response.put("data", _data);
		// System.out.println("_response " +_response);
		return _response;
	}
	/*
	// 조회
	@RequestMapping(value = "/mdcm/getBuyerMdCmCategoryGoodsSearchList.do", method = RequestMethod.POST)
	public String getBuyerMdCmCategoryGoodsSearchList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mdcm/getBuyerMdCmCategoryGoodsSearchList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdCmCategoryGoodsSearchService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmCategoryGoodsSearchList";
	}
	
	// 저장
	@RequestMapping(value = "/mdcm/saveBuyerMdCmCategoryGoodsSearchList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMdCmCategoryGoodsSearch(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmCategoryGoodsSearchList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String flag = buyerMdCmCategoryGoodsSearchService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mdcm/excelBuyerMdCmCategoryGoodsSearchList.do", method = RequestMethod.POST)
	public void excelBuyerMdCmCategoryGoodsSearch(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mdcm/excelBuyerMdCmCategoryGoodsSearchList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMdCmCategoryGoodsSearchService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		String headers = "";

		CommonUtil.downloadExcel(_data, response, outputStream, headers);
		 
	}
	*/
}
