package com.koreab2b.mro.common.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mdcm.service.MasterMdCmBuyerCatalogAlterPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmBuyerCatalogAlterPopController")
public class MasterMdCmBuyerCatalogAlterPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmBuyerCatalogAlterPopController.class);

	@Autowired
	private MasterMdCmBuyerCatalogAlterPopService masterMdCmBuyerCatalogAlterPopService;
	
	/**
	 * 고객사 카탈로그 변경 화면 SHOW
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/showMasterMdCmBuyerCatalogAlterPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmBuyerCatalogAlterPopDetail(ModelMap pModel, HttpServletRequest pRequest) {
		SessionInfo _sessionInfo = (SessionInfo) pRequest.getSession().getAttribute("sessionInfo");
		
		String st_user_id = _sessionInfo.getUserId();
		String st_buyer_code = CommonUtil.nvl((String) pRequest.getParameter("st_buyer_code"),"");  //  (조회조건)
		String st_catalog_com_code = CommonUtil.nvl((String) pRequest.getParameter("st_catalog_com_code"),"");  //  (조회조건)
		String st_buyer_item_no = CommonUtil.nvl((String) pRequest.getParameter("st_buyer_item_no"),"");  //  (조회조건)
		
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("st_user_id", st_user_id);
		pMap.put("st_buyer_code", st_buyer_code);
		pMap.put("st_catalog_com_code", st_catalog_com_code);
		pMap.put("st_buyer_item_no", st_buyer_item_no);
		
		String strFlagCmsUser = masterMdCmBuyerCatalogAlterPopService.getCheckedCmsRoleUser(pMap); 
		
		List<Map<String, String>> _data = masterMdCmBuyerCatalogAlterPopService.getDetailList(pMap); 
		List<Map<String, String>> _userData = masterMdCmBuyerCatalogAlterPopService.getUserSelectkorea(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("userData", CommonUtil.getListNvl(_userData));
		pModel.addAttribute("bFlagCmsUser", strFlagCmsUser); 
		return "common/popup/mdcm/masterMdCmBuyerCatalogAlterPop";
	}
	
	/**
	 * 고객사 카탈로그 변경  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmBuyerCatalogAlterPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmBuyerCatalogAlterPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdCmBuyerCatalogAlterPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 고객사 카탈로그 수정
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmBuyerCatalogAlterPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmBuyerCatalogAlterPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		//CMS체크처리 제거.
		/*String strFlagCmsUser = formData.get("st_flag_cms_user");
		String isFlag = "";
		if(strFlagCmsUser.equals("Y")){
			isFlag = "true";
		}else{
			isFlag = masterMdCmBuyerCatalogAlterPopService.getIsModifyCatalogCheckedByBusinessTeam(formData);
		}
		formData.put("FLAG", isFlag);*/
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("saveMasterMdCmBuyerCatalogAlterPop MultiValueMap 요청 파라미터 : formData", formData); 
		
		Map<String,String> _result = masterMdCmBuyerCatalogAlterPopService.saveSelectedData(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg",_result.get("PM_NO"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	

	/**
	 * 고객사 카탈로그 삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/delMasterMdCmBuyerCatalogAlterPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCmBuyerCatalogAlterPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdCmBuyerCatalogAlterPop MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmBuyerCatalogAlterPopService.delSelectedData(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	/**
	 * 고객사 카탈로그 삭제취소
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/delCancelMasterMdCmBuyerCatalogAlterPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delCancelMasterMdCmBuyerCatalogAlterPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delCancelMasterMdCmBuyerCatalogAlterPop MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmBuyerCatalogAlterPopService.delCancelSelectedData(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	/**
	 * 고객사 카탈로그 승인/승인취소
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/confirmMasterMdCmBuyerCatalogAlterPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> confirmMasterMdCmBuyerCatalogAlterPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("confirmMasterMdCmBuyerCatalogAlterPop MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmBuyerCatalogAlterPopService.confirmSelectedData(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	/**
	 * 이미지 삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/delMasterMdCmCatalogImage.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmCmsMappping(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");		
		String st_user_id = _sessionInfo.getUserId();
		pMap.put("st_user_id", st_user_id);
		
		String rtnMsg = masterMdCmBuyerCatalogAlterPopService.delCatalogImagePop(pMap);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("RtnMsg", mp);
		
		return _response;
		
	}
	
	/**
	 * 이미지 등록/수정
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/addMasterMdCmBuyerCatalogAlterPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String addCatalogImagePop(HttpServletRequest request, 
												ModelMap pModel, 
												@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
												@RequestParam Map<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");		
		String st_user_id = _sessionInfo.getUserId();
		pMap.put("st_user_id", st_user_id);
		
		String docNo = masterMdCmBuyerCatalogAlterPopService.addCatalogImagePop(uploadForm, pMap);
		pModel.addAttribute("docNo", docNo);
		
		return "/common/popup/mdcm/masterMdCmBuyerCatalogAlterResultPop";

	}
	/**
	 * MSDS등록조회맵핑
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/showMasterMdCmBuyerMsdsPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmMsdsPopDetail(ModelMap pModel, HttpServletRequest pRequest) {
		SessionInfo _sessionInfo = (SessionInfo) pRequest.getSession().getAttribute("sessionInfo");
		
		String st_user_id = _sessionInfo.getUserId();
		String st_description = CommonUtil.nvl((String) pRequest.getParameter("st_description"),"");  //  (조회조건)
		String st_specification = CommonUtil.nvl((String) pRequest.getParameter("st_specification"),"");  //  (조회조건)
				
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("st_description", st_description);
		pMap.put("st_specification", st_specification);
		
		List<Map<String, String>> _data = masterMdCmBuyerCatalogAlterPopService.getMsDsDetailList(pMap); 

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mdcm/masterMdCmBuyerMsdsPop";
	}
	/**
	 * 고객사 품목별 납품가능 협력사
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/showMasterMdCmBuyerCatalogBtoaPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmBuyerCatalogBtoaPop(ModelMap pModel, HttpServletRequest pRequest) {
		SessionInfo _sessionInfo = (SessionInfo) pRequest.getSession().getAttribute("sessionInfo");
		
		String st_user_id = _sessionInfo.getUserId();
		String st_buyer_code = CommonUtil.nvl((String) pRequest.getParameter("st_buyer_code"),"");  //  (조회조건)
		String st_catalog_com_code = CommonUtil.nvl((String) pRequest.getParameter("st_catalog_com_code"),"");  //  (조회조건)
		String st_buyer_item_no = CommonUtil.nvl((String) pRequest.getParameter("st_buyer_item_no"),"");  //  (조회조건)
		
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("st_user_id", st_user_id);
		pMap.put("st_buyer_code", st_buyer_code);
		pMap.put("st_catalog_com_code", st_catalog_com_code);
		pMap.put("st_buyer_item_no", st_buyer_item_no);
			
		List<Map<String, String>> _data = masterMdCmBuyerCatalogAlterPopService.getBtoaDetailList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mdcm/masterMdCmBuyerCatalogBtoaPop";
	}
	
	/**
	 * 이미지 상세 등록/수정
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/addMasterMdCmBuyerCatalogAlterDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String addMasterMdCmBuyerCatalogAlterDetailPop(HttpServletRequest request, 
												ModelMap pModel, 
												@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
												@RequestParam Map<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		String docNo = masterMdCmBuyerCatalogAlterPopService.addCatalogImageDetailPop(uploadForm, pMap);
		pModel.addAttribute("docNo", docNo);
		
		return "/common/popup/mdcm/masterMdCmBuyerCatalogAlterResultPop";

	}
	/**
	 * 물질정보요청
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/reqMasterMdCmSellerChemicalMat.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> reqMasterMdCmSellerChemicalMat(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("reqMasterMdCmSellerChemicalMat MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmBuyerCatalogAlterPopService.reqMasterMdCmSellerChemicalMat(formData, gridData);
		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	/**
	 * 보관조건 저장(물질정보 담당자만)
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCatalogTempCond.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmCatalogTempCond(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");		
		String st_user_id = _sessionInfo.getUserId();
		pMap.put("st_user_id", st_user_id);
		
		String rtnMsg = masterMdCmBuyerCatalogAlterPopService.saveCatalogTempCond(pMap);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("RtnMsg", mp);
		
		return _response;
		
	}
}
