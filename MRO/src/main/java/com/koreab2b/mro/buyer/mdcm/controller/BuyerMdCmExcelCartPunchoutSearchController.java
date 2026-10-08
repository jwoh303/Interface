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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmExcelCartPunchoutSearchService;
import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdCmExcelCartPunchoutSearchController")
public class BuyerMdCmExcelCartPunchoutSearchController {
	@Autowired
	private BuyerMdCmExcelCartPunchoutSearchService buyerMdCmExcelCartPunchoutSearchService;
	@Autowired
	private CommonInfoService commonInfoService;
  
	// 조회
	@RequestMapping(value = "/mdcm/getBuyerMdCmExcelCartPunchOutList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmCartPunchOutList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId()); 
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );

		 
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);  
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdCmExcelCartPunchoutSearchService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmExcelCartPunchoutSearchList";
	}
	/**
	 * 엑셀업로드 
	 */
	@RequestMapping(value = "/mdcm/setMdCmExcelUp.do", method = RequestMethod.POST) 
	public String setMdCmExcelUp(HttpServletRequest request, 
			ModelMap pModel, 
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
			@RequestParam Map<String, String> pMap)  {
 
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId()); // 사용자ID	
		pMap.put("st_buyer", _sessionInfo.getComCode());
		
		String result =  commonInfoService.excelFileUpload(request, pModel, uploadForm, pMap, "1");
		
		pMap.put("result", result);
		buyerMdCmExcelCartPunchoutSearchService.setExcelUp(pMap);
		 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");  
		List<Map<String, String>> _data =buyerMdCmExcelCartPunchoutSearchService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmExcelCartPunchoutSearchList";
	} 
	
}
