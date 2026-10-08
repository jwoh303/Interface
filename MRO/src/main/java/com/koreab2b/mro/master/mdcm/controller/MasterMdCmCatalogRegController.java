package com.koreab2b.mro.master.mdcm.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCatalogRegService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCatalogRegController")
public class MasterMdCmCatalogRegController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCatalogRegController.class);

	@Autowired
	private MasterMdCmCatalogRegService masterMdCmCatalogRegService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMdCmCatalogRegList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		//pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCmCatalogRegService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mdcm/excelMasterMdCmCatalogRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		//pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmCatalogRegService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mdcm/saveMasterMdCmCatalogRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmCatalogReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMdCmCatalogRegService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mdcm/delMasterMdCmCatalogRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCmCatalogReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdCmCatalogReg MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCatalogRegService.delSelectedData(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	// 등록
	@RequestMapping(value = "/mdcm/regMasterMdCmCatalogRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> regMasterMdCmCatalogReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("regMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", formData); 
		//등록 수행.
		String rtnMsg = masterMdCmCatalogRegService.regSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
	
	// 품의상신
	@RequestMapping(value = "/mdcm/consMasterMdCmCatalogRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> consMasterMdCmCatalogReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("consMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", formData); 
		Map<String,String> _result = masterMdCmCatalogRegService.consSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg",_result.get("PM_NO"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
	
	// 일괄업로드
	@RequestMapping(value = "/mdcm/batchMasterMdCmCatalogRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMdCmCatalogReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("batchMasterMdCmCatalogReg MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCatalogRegService.batchSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
	
	// 복사
	@RequestMapping(value = "/mdcm/copyMasterMdCmCatalogRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> copyMasterMdCmCatalogReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("copyMasterMdCmCatalogReg MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCatalogRegService.copySelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
	
	// CMS등록
	@RequestMapping(value = "/mdcm/confirmMasterMdCmCatalogRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> confirmMasterMdCmCatalogReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("confirmMasterMdCmCatalogReg MultiValueMap 요청 파라미터 : formData", formData); 
		//등록 수행.
		String rtnMsg = masterMdCmCatalogRegService.confirmSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
	
	@RequestMapping(value = "/mdcm/getBuyerPrimeCostRate.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerPrimeCostRate(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		// 매출원가 적용 여부
		String buyer_adapt_flag	= CommonUtil.nvl(masterMdCmCatalogRegService.getBuyerRateAdaptFlag(pMap));

		double buyer_rate			= Double.parseDouble(CommonUtil.snvl(masterMdCmCatalogRegService.getBuyerRateInfo(pMap)));
		double buyer_standard_rate	= Double.parseDouble(CommonUtil.snvl(masterMdCmCatalogRegService.getBuyerStandardRate(pMap)));
		double process_import_rate	= Double.parseDouble(CommonUtil.snvl(masterMdCmCatalogRegService.getProcessTypeRateInfo(pMap)));
		double item_rate = 0;
		
		if(buyer_adapt_flag.equals("Y")){
			if(pMap.get("st_agent_code").equals("KRSESI0003")) {
				item_rate	= buyer_rate;
			}else {
				item_rate	= buyer_rate+process_import_rate;
			}
		}else{
			item_rate=0;
		}
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String,String> rtnMap = new HashMap<String,String>();
		rtnMap.put("ITEM_RATE", String.valueOf(item_rate));
		rtnMap.put("BUYER_STANDARD_RATE", String.valueOf(buyer_standard_rate));
		_response.put("data", rtnMap);
		
		return _response;
	}
	
	@RequestMapping(value = "/mdcm/getBuyerStandardRate.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerStandardRate(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		// 매출원가 적용 여부
		String buyer_adapt_flag	= CommonUtil.nvl(masterMdCmCatalogRegService.getBuyerRateAdaptFlag(pMap));

		double buyer_rate			= Double.parseDouble(CommonUtil.snvl(masterMdCmCatalogRegService.getBuyerRateInfo(pMap)));
		double buyer_standard_rate	= Double.parseDouble(CommonUtil.snvl(masterMdCmCatalogRegService.getBuyerStandardRate(pMap)));
		
		Map<String,String> rtnMap = masterMdCmCatalogRegService.getTotProcessTypeRateInfo(pMap);
		String rtnBelowComorgCode = masterMdCmCatalogRegService.getCatalogRegBottomOrgCodeMultiPop(pMap); // BELOW_COMORG_CODE 하위적용구분 추가 
		
		
		rtnMap.put("BELOW_COMORG_CODE", rtnBelowComorgCode);
		rtnMap.put("BUYER_ADAPT_FLAG", buyer_adapt_flag);
		rtnMap.put("BUYER_RATE", String.valueOf(buyer_rate));
		rtnMap.put("BUYER_STANDARD_RATE", String.valueOf(buyer_standard_rate));
		
		
		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("data", rtnMap);
		
		return _response;
	}
	

}
