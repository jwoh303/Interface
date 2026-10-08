package com.koreab2b.mro.common.mpso.controller;

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
import org.springframework.web.multipart.MultipartFile;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpso.service.MasterMpSoPrewarhsngRequestAllRegPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.DateTimeUtil;

@Controller("masterMpSoPrewarhsngRequestAllRegPopController")
public class MasterMpSoPrewarhsngRequestAllRegPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoPrewarhsngRequestAllRegPopController.class);

	@Autowired
	private MasterMpSoPrewarhsngRequestAllRegPopService masterMpSoPrewarhsngRequestAllRegPopService;
	
	@Autowired
	private CommonInfoService commonInfoService;
	
	/**
	 * 선입고요청 상세정보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoPrewarhsngRequestAllExcelUp.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoPrewarhsngRequestAllExcelUp(HttpServletRequest req,
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		List<MultipartFile> _files = uploadForm.getFiles();
		
		String _fileName = "";
		if (null != _files && _files.size() > 0) {
			MultipartFile _multipartFile = _files.get(0);
			_fileName = _multipartFile.getOriginalFilename();
			_fileName = _fileName.substring(0, _fileName.indexOf("."));
		}
		pMap.put("file_name", _fileName);
		pMap.put("upload_date", DateTimeUtil.getFormatString("yyyyMMdd"));
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String kep_user_id = _sessionInfo.getUserId();
		String kep_user_name = _sessionInfo.getUserNameLoc();
		 
		String result =  commonInfoService.excelFileUpload(req, pModel, uploadForm, pMap);
		pMap.put("result", result);
		pMap.put("kep_user_id", kep_user_id);
		pMap.put("kep_user_name", kep_user_name);
		
		
		String rtnMsg = masterMpSoPrewarhsngRequestAllRegPopService.setExcelUp(pMap);
		
		pModel.put("rtnMsg", rtnMsg);
		pModel.put("file_name", _fileName);
		pModel.put("upload_date", DateTimeUtil.getFormatString("yyyyMMdd"));
		return  "common/popup/mpso/masterMpSoPrewarhsngRequestAllExcelUpResult";
	}
	
	/**
	 * 선입고요청 등록(일괄) : 엑셀파일 데이터 임시 테이블 저장 및 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoPrewarhsngRequestAllRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoPrewarhsngRequestAllRegPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoPrewarhsngRequestAllRegPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 선입고 요청 등록 및 수정
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/saveMasterMpSoPrewarhsngRequestAllRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoPrewarhsngRequestAllRegPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterMpSoPrewarhsngRequestAllRegPopService.updateMasterMpSoPrewarhsngRequestAllRegPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
}
