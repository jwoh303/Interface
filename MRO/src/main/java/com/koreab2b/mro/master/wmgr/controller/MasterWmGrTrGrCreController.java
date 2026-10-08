package com.koreab2b.mro.master.wmgr.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.wmco.service.MasterWmCoMgService;
import com.koreab2b.mro.master.wmgr.service.MasterWmGrTrGrCreService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmGrTrGrCreController")
public class MasterWmGrTrGrCreController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrTrGrCreController.class);

	@Autowired
	private MasterWmGrTrGrCreService masterWmGrTrGrCreService;
	
	@Autowired
	private MasterWmCoMgService masterWmCoMgService;

	// 조회
	@RequestMapping(value = "/wmco/showMasterWmCoDelayPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoDelayPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", pMap); 

		List<Map<String, String>> _data = masterWmGrTrGrCreService.getPop(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmco/masterWmCoDelayPop";
	}
	
	
	// 조회
	@RequestMapping(value = "/wmgr/getMasterWmGrTrGrCreList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmGrTrGrCreList(HttpServletRequest req, HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterWmGrTrGrCreService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
		//req.setAttribute("SHEETDATA", _data);
		//new IBSheetUtil().getXml(req, pRes);	
	}

	// 엑셀다운로드
	@RequestMapping(value = "/wmgr/excelMasterWmGrTrGrCreList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){

		
		//페이징용 파라미터의 셋팅
		//pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = masterWmGrTrGrCreService.getList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 두산 인프라 코어  IF저장 
	@RequestMapping(value = "/wmgr/saveMasterWmGrTrGrCreDoosanIF.do", method = RequestMethod.POST)
	@ResponseBody
	@Transactional
	public Map<String, Object> saveMasterWmGrTrGrCreDoosanIF(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap){
		
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", pMap); 
		
//		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
//		pMap.put("userid", _sessionInfo.getUserId()); 
//		pMap.put("buyer", _sessionInfo.getComCode() );
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String opType	= CommonUtil.getDevRealLocalFlag(req);

		/*
		 * Doosan IF Server Type Check
		 */
		// TODO : Dooan If Check
		if ( "2".equals(CommonUtil.getDevRealLocalFlag(req)) ) {
			logger.debug("OP_TYPE : 운영");
			formData.put("OP_TYPE","3");	// 운영
		} else if ("1".equals(CommonUtil.getDevRealLocalFlag(req))) {
			logger.debug("OP_TYPE : 품질");
			formData.put("OP_TYPE","1");	// 품질
		} else {
			logger.debug("OP_TYPE : 개발");
			formData.put("OP_TYPE","1");	// 개발 
		}
		
		String msg = masterWmGrTrGrCreService.saveMasterWmGrTrGrCreDoosanIF(formData);
		
		return  _response;
		
	}
	
	// 출고지시
	@RequestMapping(value = "/wmgr/saveMasterWmGrTrGrCreList.do", method = RequestMethod.POST)
	@ResponseBody
	@Transactional
	public Map<String, Object> updateMasterWmGrTrGrCre(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		

		
		String rtnMsg = "";
		Map<String, String> rtnMap = new HashMap<String,String>();
		

		Map<String, Object> mp = new HashMap<String, Object>();
		
		//두산모트롤BG 창원공장) 납품요청일 익월 출고지시 불가 
		//SLOGIC-BEGIN(P08-0000002-02) 
		//출고지시까지 일때 
		if("Y".equals(formData.get("st_ivk_yn")))
		{
			boolean pP08_0000002_02 = false;
			for(int i= 0 ; i<gridData.size(); i++){
				

				pP08_0000002_02 = CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000002-02");
		
				
				if(pP08_0000002_02){
					_response.put("Message", "(주)두산 모트롤BG 창원공장은 출고지시에 제약이 있으므로,\n출고 메뉴를 통해서 출고지시 하시기 바랍니다.");
					mp.put("Code",4);
					_response.put("Result",mp);
					return _response;
				}
			}

		}
		//SLOGIC-END
		
		
		//출고일 셋팅
		String _st_ivk_date = ((String) formData.get("st_ivk_date")).replace("/", "");
		formData.put("st_ivk_date",_st_ivk_date);
		
		
		//입고 확정 항목 
		rtnMsg = masterWmGrTrGrCreService.updateSelectedData(formData, gridData);
		
		//출고지시까지 일때 
		if("Y".equals(formData.get("st_ivk_yn")))
		{
			rtnMsg = masterWmGrTrGrCreService.updateSelectedDataIvt(formData, gridData);
		}
		
		
		
		if( "Y".equals(formData.get("st_ivk_yn")))
		{
			if("GR_IK_OK".equals(rtnMsg.substring(0, 8)))
			{
				
				mp.put("Code",1);
				
			}
			else
			{
				mp.put("Code",0);
			}
			
			_response.put("Message", rtnMap.get("rtnMsg"));
		}
		else
		{		
			if("".equals(rtnMsg)){
				
				mp.put("Code",2);
	
			}
			else if("existStock".equals(rtnMsg.substring(0, 10))){
				mp.put("Code",5);
			}else{
				mp.put("Code",3);
			}
			
		}
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	@RequestMapping(value = "/wmgr/saveMasterWmGrTrGrCreList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	@Transactional
	public Map<String, Object> updateMasterWmGrTrGrCre_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		

		
		String rtnMsg = "";
		Map<String, String> rtnMap = new HashMap<String,String>();
		

		Map<String, Object> mp = new HashMap<String, Object>();
		
		//두산모트롤BG 창원공장) 납품요청일 익월 출고지시 불가 
		//SLOGIC-BEGIN(P08-0000002-02) 
		//출고지시까지 일때 
		if("Y".equals(formData.get("st_ivk_yn")))
		{
			boolean pP08_0000002_02 = false;
			for(int i= 0 ; i<gridData.size(); i++){
				

				pP08_0000002_02 = CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P08-0000002-02");
		
				
				if(pP08_0000002_02){
					_response.put("Message", "(주)두산 모트롤BG 창원공장은 출고지시에 제약이 있으므로,\n출고 메뉴를 통해서 출고지시 하시기 바랍니다.");
					mp.put("Code",4);
					_response.put("Result",mp);
					return _response;
				}
			}

		}
		//SLOGIC-END
		
		
		//출고일 셋팅
		String _st_ivk_date = ((String) formData.get("st_ivk_date")).replace("/", "");
		formData.put("st_ivk_date",_st_ivk_date);
		
		
		//입고 확정 항목 
		rtnMsg = masterWmGrTrGrCreService.updateSelectedData_v2(formData, gridData);
		
		//출고지시까지 일때 
		if("Y".equals(formData.get("st_ivk_yn")))
		{
			rtnMsg = masterWmGrTrGrCreService.updateSelectedDataIvt(formData, gridData);
		}
		
		
		
		if( "Y".equals(formData.get("st_ivk_yn")))
		{
			if("GR_IK_OK".equals(rtnMsg.substring(0, 8)))
			{
				
				mp.put("Code",1);
				
			}
			else
			{
				mp.put("Code",0);
			}
			
			_response.put("Message", rtnMap.get("rtnMsg"));
		}
		else
		{		
			if("".equals(rtnMsg)){
				
				mp.put("Code",2);
	
			}
			else if("existStock".equals(rtnMsg.substring(0, 10))){
				mp.put("Code",5);
			}else{
				mp.put("Code",3);
			}
			
		}
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	//지연사유저장 
	/**
	 * 등록처리
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgr/saveMasterWmCoDelayPop.do", method = RequestMethod.POST)
	public String saveMasterWmCoDelayPop(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("saveMasterWmCoDelayPop 요청 파라미터 for jsp : {}", pMap);
		 
//		boardService.boardWrite(pMap);.
		masterWmGrTrGrCreService.saveMasterWmCoDelayPop(pMap);
		pModel.addAttribute("result", "S");
		
		return "common/board/boardWriteForm";
	}	
}
