package com.koreab2b.mro.buyer.mpso.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoReturnProceStateService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoReturnProceStateController")
public class BuyerMpSoReturnProceStateController {
 

	@Autowired
	private BuyerMpSoReturnProceStateService buyerMpSoReturnProceStateService;
	
	// 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoReturnProceStateList.do", method = RequestMethod.POST)
	public String getBuyerMpSoReturnProceStateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpso/getBuyerMpSoReturnProceStateList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpSoReturnProceStateService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpso/buyerMpSoReturnProceStateList";
	}
	
	// 저장
	@RequestMapping(value = "/mpso/saveBuyerMpSoReturnProceStateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMpSoReturnProceState(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mpso/saveBuyerMpSoReturnProceStateList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String flag = buyerMpSoReturnProceStateService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpso/excelBuyerMpSoReturnProceStateList.do", method = RequestMethod.POST)
	public void excelBuyerMpSoReturnProceState(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpso/excelBuyerMpSoReturnProceStateList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpSoReturnProceStateService.getList(pMap); 
		   
		//logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		String headers = "";

		CommonUtil.downloadExcel(_data, response, outputStream, headers);
		 
	}
}
