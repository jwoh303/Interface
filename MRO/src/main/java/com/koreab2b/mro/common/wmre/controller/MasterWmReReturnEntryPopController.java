package com.koreab2b.mro.common.wmre.controller;

import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.wmre.service.MasterWmReReturnEntryPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmReReturnEntryPopController")
public class MasterWmReReturnEntryPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmReReturnEntryPopController.class);

	@Autowired
	private MasterWmReReturnEntryPopService masterWmReReturnEntryPopService;
	
	/**
	 * 반품입력(협력사출고번) 팝업 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmre/getMasterWmReReturnEntryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmReReturnEntryPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmReReturnEntryPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	/**
	 * 반품입력(협력사출고번) 팝업 조회 _update
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmre/showMasterWmReReturnEntryPopForUpdate.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnEntryPopForUpdate(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String, String>> _data = masterWmReReturnEntryPopService.getUpdate(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return  "common/popup/wmre/masterWmReReturnEntryPop";
	}
	
	
	/**
	 * 반품입력(협력사출고번) 팝업 조회 _update
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmre/showMasterWmReReturnEntryPopForUpdateSeller.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnEntryPopForUpdateSeller(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String, String>> _data = masterWmReReturnEntryPopService.getUpdate(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return  "common/popup/wmre/masterWmReReturnEntrySellerPop";
	}
	@RequestMapping(value = "/wmre/showMasterWmReReturnEntryPopForUpdateSeller_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnEntryPopForUpdateSeller_v2(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String, String>> _data = masterWmReReturnEntryPopService.getMasterWmReReturnEntryPopForUpdateSeller_v2(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return  "common/popup/wmre/masterWmReReturnEntryPopForUpdateSeller_v2";
	}
	
	
	
	// 고객사 조회
	@RequestMapping(value = "/wmre/showMasterWmReReturnWmNoSellerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnWmNoSellerPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/wmre/showMasterWmReReturnWmNoPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = masterWmReReturnEntryPopService.getRegPop(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("/wmre/showMasterWmReReturnWmNoPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmre/masterWmReReturnWmNoSellerPop";
	}	
	
	
	// 고객사 조회
	@RequestMapping(value = "/wmre/showMasterWmReReturnWmNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnWmNoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/wmre/showMasterWmReReturnWmNoPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = masterWmReReturnEntryPopService.getRegPop(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("/wmre/showMasterWmReReturnWmNoPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmre/masterWmReReturnWmNoPop";
	}	
	
	// 고객사 조회
	@RequestMapping(value = "/wmco/showMasterWmDeptPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmDeptPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		//List<Map<String, String>> _data = masterWmReReturnEntryPopService.getPop(pMap);

		//pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		//logger.debug("/wmco/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/masterWmDeptPop";
	}	

	
	/**
	 * 반품조치 취소 
	 */
	@RequestMapping(value = "/wmre/cancelMasterWmReReturnWmNoPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancelMasterWmReReturnWmNoPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", pMap); 
		
//		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
//		pMap.put("userid", _sessionInfo.getUserId()); 
//		pMap.put("buyer", _sessionInfo.getComCode() );
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterWmReReturnEntryPopService.cancelMasterWmReReturnWmNoPop(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}		
	
	
	/**
	 * 반품조치
	 */
	@RequestMapping(value = "/wmre/saveMasterWmReReturnWmNoPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterWmReReturnWmNoPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// removeSlash 사용 위해 소문자로 전환(_date)
		pMap.put("st_s_rec_date", CommonUtil.nvl2(pMap.get("st_S_REC_DATE"),""));
		pMap.put("st_w_gr_date", CommonUtil.nvl2(pMap.get("st_W_GR_DATE"),""));
		pMap.put("st_w_riv_date", CommonUtil.nvl2(pMap.get("st_W_RIV_DATE"),""));
		pMap.put("st_s_gr_date", CommonUtil.nvl2(pMap.get("st_S_GR_DATE"),""));
		pMap.put("st_w_chgr_date", CommonUtil.nvl2(pMap.get("st_W_CHGR_DATE"),""));
		pMap.put("st_w_chdeli_date", CommonUtil.nvl2(pMap.get("st_W_CHDELI_DATE"),""));
		pMap.put("st_s_chdeli_date", CommonUtil.nvl2(pMap.get("st_S_CHDELI_DATE"),""));
		pMap.put("st_m_close_date", CommonUtil.nvl2(pMap.get("st_M_CLOSE_DATE"),""));
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		pMap.put("st_S_REC_DATE", pMap.get("st_s_rec_date"));
		pMap.put("st_W_GR_DATE", pMap.get("st_w_gr_date"));
		pMap.put("st_W_RIV_DATE", pMap.get("st_w_riv_date"));
		pMap.put("st_S_GR_DATE", pMap.get("st_s_gr_date"));
		pMap.put("st_W_CHGR_DATE", pMap.get("st_w_chgr_date"));
		pMap.put("st_W_CHDELI_DATE", pMap.get("st_w_chdeli_date"));
		pMap.put("st_S_CHDELI_DATE", pMap.get("st_s_chdeli_date"));
		pMap.put("st_M_CLOSE_DATE", pMap.get("st_m_close_date")); 
		
		String msg = masterWmReReturnEntryPopService.saveMasterWmReReturnWmNoPop(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	@RequestMapping(value = "/wmre/saveMasterWmReReturnWmNoPop_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterWmReReturnWmNoPop_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterWmReReturnEntryPopService.saveMasterWmReReturnWmNoPop_v2(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 반품입력 팝업 저장
	 */
	@RequestMapping(value = "/wmre/saveMasterWmReReturnEntryPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterWmReReturnEntryPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", pMap); 
		
//		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
//		pMap.put("userid", _sessionInfo.getUserId()); 
//		pMap.put("buyer", _sessionInfo.getComCode() );
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterWmReReturnEntryPopService.saveMasterWmReReturnEntryPop(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}	
	
	/**
	 * 반품입력 팝업 저장
	 */
	@RequestMapping(value = "/wmre/saveMasterWmReReturnEntryForBuyerCancelPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterWmReReturnEntryForBuyerCancelPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/wmre/saveMasterWmReReturnEntryForBuyerCancelPop.do MultiValueMap 요청 파라미터 : formData", pMap); 
		
//		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
//		pMap.put("userid", _sessionInfo.getUserId()); 
//		pMap.put("buyer", _sessionInfo.getComCode() );
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterWmReReturnEntryPopService.saveMasterWmReReturnEntryCancelPop(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}	
	
	/**
	 * 반품취소 입력 조회 
	 */
	@RequestMapping(value = "/wmre/showMasterWmReReturnEntryForBuyerCancelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnEntryForBuyerCancelPop(ModelMap pModel, @RequestParam Map<String, String> pMap,HttpServletRequest request) {
		logger.debug("/wmre/showMasterWmReReturnEntryForBuyerCancelPop.do 요청 파라미터 for jsp : {}", pMap); 
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			List<Map<String, String>> _data = masterWmReReturnEntryPopService.getPopBuyer_v2(pMap);

			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			return "common/popup/wmre/masterWmReReturnEntryForBuyerCancelPop_v2";
		}else{
			List<Map<String, String>> _data = masterWmReReturnEntryPopService.getPopBuyer(pMap);

			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			return "common/popup/wmre/masterWmReReturnEntryForBuyerCancelPop";
		}
	}
	
	/**
	 * 반품고객사입력 조회 
	 */
	@RequestMapping(value = "/wmre/showMasterWmReReturnEntryForBuyerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnEntryForBuyerPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("/wmre/showMasterWmReReturnEntryForBuyerPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			List<Map<String, String>> _data = masterWmReReturnEntryPopService.getPopBuyer_v2(pMap);

			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			return "common/popup/wmre/masterWmReReturnEntryForBuyerPop_v2";
		}else{
			List<Map<String, String>> _data = masterWmReReturnEntryPopService.getPopBuyer(pMap);

			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			return "common/popup/wmre/masterWmReReturnEntryForBuyerPop";
		}
	}
	
	/**
	 * 반품등록 po기준 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmre/showMasterWmReReturnPoInfo.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmReReturnPoInfo(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		//pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String, String>> _data = masterWmReReturnEntryPopService.getReReturnPoInfo(pMap);
		pModel.addAttribute("data_po", CommonUtil.getListNvl(_data));
		return  "common/popup/wmre/masterWmReReturnEntryPop";
	}
}
