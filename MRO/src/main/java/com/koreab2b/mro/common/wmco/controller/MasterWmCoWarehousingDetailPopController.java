package com.koreab2b.mro.common.wmco.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.wmco.service.MasterWmCoWarehousingDetailPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmCoWarehousingDetailPopController")
public class MasterWmCoWarehousingDetailPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmCoWarehousingDetailPopController.class);

	@Autowired
	private MasterWmCoWarehousingDetailPopService masterWmCoWarehousingDetailPopService;
	
	
	/**
	 * 입고번호(거래명세서상세) 조회(sheet , detail)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmco/showMasterWmCoWarehousingDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String commonList(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("commonList 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterWmCoWarehousingDetailPopService.getDetail(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("보낸값 for jsp : {}", pModel); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/wmco/masterWmCoWarehousingDetailPop";
	}
	@RequestMapping(value = "/wmco/showMasterWmCoWarehousingDetailPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String commonList_v2(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("commonList 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterWmCoWarehousingDetailPopService.getDetail(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("보낸값 for jsp : {}", pModel); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/wmco/masterWmCoWarehousingDetailPop_v2";
	}
	
	/**
	 * 입고번호(거래명세서상세) 조회(sheet , detail)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmco/getMasterWmCoWarehousingDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterWmCoWarehousingDetailPop(HttpServletRequest req, HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterWmCoWarehousingDetailPopService.getList(pMap);
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}
	
	// 출고지시
	@RequestMapping(value = "/wmco/saveMasterWmCoWarehousingDetail.do", method = RequestMethod.POST)
	@ResponseBody
	@Transactional
	public Map<String, Object> saveMasterWmCoWarehousingDetail(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		//출고일 셋팅
		String _st_ivk_date = ((String) formData.get("st_ivk_date")).replace("/", "");
		formData.put("st_ivk_date",_st_ivk_date);
		
		String rtnMsg = "";
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		
		//입고 확정 항목 
		rtnMsg = masterWmCoWarehousingDetailPopService.updateSelectedData(formData, gridData);
		
		//출고지시까지 일때 
		if("Y".equals(formData.get("st_ivk_yn")))
		{
			rtnMsg = masterWmCoWarehousingDetailPopService.updateSelectedDataIvt(formData, gridData);

		}
		
		if( "Y".equals(formData.get("st_ivk_yn")))
		{
			if("GR_IK_OK".equals(rtnMsg.substring(0, 8)))
			{
				mp.put("Code",1);
				//SLOGIC-BEGIN(P08-0000011)   화진 네트웍스이면 부서 조회까지 
				String pP08_0000011id  = "";
				Map<String, String> _map = CommonUtil.getSpecialCheckReturnSheetMap(formData.get("st_buyer"));
				if(_map!=null){
					
					pP08_0000011id = _map.get("SLG_ID");

				}
				if("P08-0000011-23".equals(pP08_0000011id)){
					formData.put("st_ik_no_temp", rtnMsg.substring(10));
					
					String  deptMap = CommonUtil.getSpecialCheckReturnSheetMapByDept( formData );
					rtnMsg= rtnMsg+deptMap;
				}
				
			   //SLOGIC-END	
			}
			else{
				mp.put("Code",0);
			}
		}else{		
			if("OK".equals(rtnMsg)){
				
				mp.put("Code",2);
				
			}
			else if("existStock".equals(rtnMsg.substring(0, 10))){
				mp.put("Code",5);
			}
			else{
				mp.put("Code",3);
			}
		}
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	@RequestMapping(value = "/wmco/saveMasterWmCoWarehousingDetail_v2.do", method = RequestMethod.POST)
	@ResponseBody
	@Transactional
	public Map<String, Object> saveMasterWmCoWarehousingDetail_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		//출고일 셋팅
		String _st_ivk_date = ((String) formData.get("st_ivk_date")).replace("/", "");
		formData.put("st_ivk_date",_st_ivk_date);
		
		String rtnMsg = "";
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		
		//입고 확정 항목 
		rtnMsg = masterWmCoWarehousingDetailPopService.updateSelectedData_v2(formData, gridData);
		
		//출고지시까지 일때 
		if("Y".equals(formData.get("st_ivk_yn")))
		{
			rtnMsg = masterWmCoWarehousingDetailPopService.updateSelectedDataIvt(formData, gridData);

		}
		
		if( "Y".equals(formData.get("st_ivk_yn")))
		{
			if("GR_IK_OK".equals(rtnMsg.substring(0, 8)))
			{
				mp.put("Code",1);
				//SLOGIC-BEGIN(P08-0000011)   화진 네트웍스이면 부서 조회까지 
				String pP08_0000011id  = "";
				Map<String, String> _map = CommonUtil.getSpecialCheckReturnSheetMap(formData.get("st_buyer"));
				if(_map!=null){
					
					pP08_0000011id = _map.get("SLG_ID");

				}
				if("P08-0000011-23".equals(pP08_0000011id)){
					formData.put("st_ik_no_temp", rtnMsg.substring(10));
					
					String  deptMap = CommonUtil.getSpecialCheckReturnSheetMapByDept( formData );
					rtnMsg= rtnMsg+deptMap;
				}
				
			   //SLOGIC-END	
			}
			else{
				mp.put("Code",0);
			}
		}else{		
			if("OK".equals(rtnMsg)){
				
				mp.put("Code",2);
				
			}
			else if("existStock".equals(rtnMsg.substring(0, 10))){
				mp.put("Code",5);
			}
			else{
				mp.put("Code",3);
			}
		}
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
}
