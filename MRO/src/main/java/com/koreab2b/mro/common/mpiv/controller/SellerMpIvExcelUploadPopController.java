package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpiv.service.SellerMpIvExcelUploadPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvExcelUploadPopController")
public class SellerMpIvExcelUploadPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMpIvExcelUploadPopController.class);

	@Autowired
	private SellerMpIvExcelUploadPopService sellerMpIvExcelUploadPopService;
	@Autowired
	private CommonInfoService commonInfoService;
	/**
	 * 엑셀업로드  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvExcelUploadPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvExcelUploadPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mpiv/getSellerMpIvExcelUploadPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = sellerMpIvExcelUploadPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpiv/sellerMpIvExcelUploadPop";
	}	 
	// 업로드 후 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvExcelUploadPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpSoCartExcelUploadList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
//		pMap.put("st_com_code", _sessionInfo.getComCode());
//		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_excel_type", "MPIV_PARC");
		List<Map<String,String>> _data = sellerMpIvExcelUploadPopService.getSellerMpIvExcelUploadPop_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 엑셀업로드 
	 */
	@RequestMapping(value = "/mpiv/setMpIvExcelUp.do", method = RequestMethod.POST) 
	public String setMpIvExcelUp(HttpServletRequest request, ModelMap pModel,	@ModelAttribute("uploadForm") FileUploadForm uploadForm, @RequestParam Map<String, String> pMap){

		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		
		//LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("st_user_id", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("st_com_code", _sessionInfo.getComCode());
		pMap.put("st_excel_type", "MPIV_PARC");
		
		String result =  commonInfoService.excelFileUpload(request, pModel, uploadForm, pMap, "1");
		
		LOGGER.debug(" result {} " ,result);
		
		pMap.put("result", result);
		sellerMpIvExcelUploadPopService.setExcelUp(pMap);
		 
		// 화면 조회
		pMap.put("paging", "0"); 
		List<Map<String, String>> _data = sellerMpIvExcelUploadPopService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/mpiv/sellerMpIvExcelUploadPop";
	}
	@RequestMapping(value = "/mpiv/setMpIvExcelUp_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setMpIvExcelUp_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
//		formData.put("st_com_code", _sessionInfo.getComCode());
//		formData.put("st_user_id", _sessionInfo.getUserId());
		formData.put("st_excel_type", "MPIV_PARC");
		
		String rtnMsg = sellerMpIvExcelUploadPopService.setMpIvExcelUp_v2(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	/**
	 * 엑셀 TMP 테이블 삭제
	 */
	@RequestMapping(value = "/mpiv/delMpIvExcelUp.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMpIvExcelUp(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();

		pMap.put("st_excel_type", "MPIV_PARC");
		
		String flag = sellerMpIvExcelUploadPopService.delExcelUp(pMap);
			
		_response.put("msg", flag);
	
		return  _response;
	}
}
