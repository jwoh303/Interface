package com.koreab2b.mro.buyer.mdcm.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmCategoryPCOService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdCmCategoryPCOController")
public class BuyerMdCmCategoryPCOController {
	@Autowired
	private BuyerMdCmCategoryPCOService buyerMdCmCategoryPCOService;
  
	// 조회
	@RequestMapping(value = "/mdcm/getBuyerMdCmPCODLisList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmPCODLisList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getBycaComorgCode()); 
		pMap.put("st_categ_id", CommonUtil.onvl(pMap.get("st_categ_id") ,"") );
		pMap.put("st_sort_column", CommonUtil.onvl(pMap.get("st_sort_column") ,"ALL") );
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		/*
		* 고객사에 따라 카탈로그 검색기준이 다름
		* A: 두산엔진 KRHSDE0003
		*/
		String p060000055 = CommonUtil.getSpecialCheckReturn(_sessionInfo.getBycaComorgCode(),"P06-0000055","COL02_DATA"); // 검색조건변경
		if(p060000055==""||p060000055==null){
			pMap.put("st_s_logic", "R");
		}else{
			pMap.put("st_s_logic", p060000055);
		}
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);                              
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		
		List<Map<String, String>> _data = buyerMdCmCategoryPCOService.getList(pMap);
		List<Map<String, String>> _data_path = buyerMdCmCategoryPCOService.getCategoryPathPCO(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("_data_path", CommonUtil.getListNvl(_data_path));

		
		return "buyer/mdcm/buyerMdCmPCODLisList";
	}
	/**
	 * 카테고리 Path
	 * PG_06_B_001_00
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/getCategoryPathPCO.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCategoryPathPCO(@RequestParam Map<String, String> pMap,  HttpServletRequest req) {
		//logger.debug("getCategoriList 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		List<Map<String, String>> _data = buyerMdCmCategoryPCOService.getCategoryPathPCO(pMap);
		
		_response.put("data", _data);
		return _response;
	}
	
	/**
	 * 견적의뢰 사용자
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/getRqUserInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getRqUserInfo(@RequestParam Map<String, String> pMap,  HttpServletRequest req) {
		//logger.debug("getCategoriList 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		List<Map<String, String>> _data = buyerMdCmCategoryPCOService.getRqUserInfo(pMap);
		
		_response.put("data", _data);
		return _response;
	}
	
	/**
	 * 저장
	 *  desc ICOMCART
 		 USE_FLAG	NOT NULL	CHAR(1)	용도구분(C:장바구니,D:,R:나의상품)
	 * 
	 */
	@RequestMapping(value = "/mdcm/saveBuyerMdCmRqdtTemp.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdCmRqdtTemp(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("buyerComorg", _sessionInfo.getBycaComorgCode() );
		
		
		
		String msg = buyerMdCmCategoryPCOService.saveBuyerMdCmRqdtTemp(pMap);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	

}
