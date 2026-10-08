package com.koreab2b.mro.common.mprq.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.mprq.service.BuyerMpRqExcelUploadPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqExcelUploadPopController")
public class BuyerMpRqExcelUploadPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqExcelUploadPopController.class);

	@Autowired
	private BuyerMpRqExcelUploadPopService buyerMpRqExcelUploadPopService;
	@Autowired
	private CommonInfoService commonInfoService;
	/**
	 * 엑셀업로드  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMpRqExcelUploadPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpRqExcelUploadPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mprq/getBuyerMpRqExcelUploadPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpRqExcelUploadPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mprq/buyerMpRqExcelUploadPop";
	}	 
	
	/**
	 * 엑셀업로드 
	 */
	@RequestMapping(value = "/mprq/setMpRqExcelUp.do", method = RequestMethod.POST) 
	public String setMpRqExcelUp(HttpServletRequest request, 
			ModelMap pModel, 
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
			@RequestParam Map<String, String> pMap)  {
 
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		//LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("st_user_id", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("st_buyer", _sessionInfo.getComCode());
		
		String result =  commonInfoService.excelFileUpload(request, pModel, uploadForm, pMap, "1");
		
		LOGGER.debug(" result {} " ,result);
		
		pMap.put("result", result);
		buyerMpRqExcelUploadPopService.setExcelUp(pMap);
		 
		// 화면 조회
		pMap.put("paging", "0"); 
		List<Map<String, String>> _data = buyerMpRqExcelUploadPopService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/mprq/buyerMpRqExcelUploadPop";
	} 
	
	/**
	 * 엑셀업로드  조회_v2
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMpRqExcelUploadPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpRqExcelUploadPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mprq/getBuyerMpRqExcelUploadPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpRqExcelUploadPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mprq/buyerMpRqExcelUploadPop_v2";
	}	 
	
	/**
	 * 엑셀업로드 _v2
	 */
	@RequestMapping(value = "/mprq/setMpRqExcelUp_v2.do", method = RequestMethod.POST) 
	public String setMpRqExcelUp_v2(HttpServletRequest request,	ModelMap pModel, @ModelAttribute("uploadForm") FileUploadForm uploadForm, @RequestParam Map<String, String> pMap)  {
 		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		//LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("st_user_id", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("st_buyer", _sessionInfo.getComCode());
		
		String result =  commonInfoService.excelFileUpload(request, pModel, uploadForm, pMap, "1");
		
		LOGGER.debug(" result {} " ,result);
		
		//result 가 품목코드@@품목명@@ 뭐 이딴식으로 나오거나, 길이가 2안넘거나 등
		String[] resultArr = result.split("\\|");
		if(resultArr.length <=1 || !resultArr[0].equals("품목코드@@품목명@@규격@@단위@@제조사@@모델번호@@원산지명@@단가구분 코드@@요청단가@@수량@@지정협력사@@기존협력사@@비고@@")){
			pModel.addAttribute("result", "fail");
		}else{
			pMap.put("result", result);
			String setReturnString = buyerMpRqExcelUploadPopService.setExcelUp_v2(pMap);
			if(setReturnString.equals("error")){
				pModel.addAttribute("result", "error");
			}else{
				// 화면 조회
				pMap.put("paging", "0"); 
				List<Map<String, String>> _data = buyerMpRqExcelUploadPopService.getList_v2(pMap);
				pModel.addAttribute("data", CommonUtil.getListNvl(_data));
				pModel.addAttribute("result", "success");
			}
		}
		
		return "common/popup/mprq/buyerMpRqExcelUploadPop_v2";
	} 
}
