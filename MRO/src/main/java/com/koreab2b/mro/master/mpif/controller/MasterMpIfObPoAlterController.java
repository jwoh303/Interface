package com.koreab2b.mro.master.mpif.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpif.service.MasterMpIfObPoAlterService;
import com.koreab2b.mro.util.CommonUtil;


@Controller("masterMpIfObPoAlterController")
public class MasterMpIfObPoAlterController {
	@Autowired
	private MasterMpIfObPoAlterService masterMpIfObPoAlterService;
	private static final Logger logger = LoggerFactory.getLogger(MasterMpIfErrMngController.class);

	
	// 조회
		@RequestMapping(value = "/mpif/getmasterMpIfObPoAlterList.do",  method = {RequestMethod.GET,RequestMethod.POST})
		@ResponseBody
		public Map<String, Object> searchMasterMpIfOrderCreateList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
			
			// 페이징용 파라미터의 셋팅
			pMap = IBSheetUtil.addParamForPaging3(pMap);
			String[] _st_buyer_code_array = null;
			
			if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
				_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
			}
			
			pMap.put("buyer_code_array", _st_buyer_code_array);
			List<Map<String,String>> _data = masterMpIfObPoAlterService.getList(pMap);
			
			return IBSheetUtil.addResut(req, _data , pMap);
		}
		
		//excuteMasterMpIfObPoAltereList
		// 실행
		@RequestMapping(value = "/mpif/excuteMasterMpIfObPoAltereList.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> excuteMasterMpIfObPoAltereList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();
			
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
			String rtnMsg = masterMpIfObPoAlterService.executeDataList(formData, gridData);
			
			// 성공시 : 1 실패시 : 0
			Map<String, Object> mp = new HashMap<String, Object>();
			if("정상적으로 실행되었습니다.".equals(rtnMsg)){
				mp.put("Code",1);
			}else{
				mp.put("Code",0);
			}
			mp.put("Code",1);
			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
		}
		
		// 엑셀업로드 체크 및 업로드
		@RequestMapping(value = "/mpif/saveMasterMpIfObPoAlterListExcelCheck.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> saveMasterMpIfObPoAlterListExcelCheck(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();
			
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
			String rtnMsg = masterMpIfObPoAlterService.updateSelectedDataExcelCheck(formData, gridData);

			// 성공시 : 1 실패시 : 0
			Map<String, Object> mp = new HashMap<String, Object>();
			
			System.out.println("upload rtnMsg : "+rtnMsg);
			if(rtnMsg.equals("업로드가 완료되었습니다.")){
				mp.put("Code",1);
			}else{
				mp.put("Code",0);
			}
			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
		}	
		
		// 삭제
		@RequestMapping(value = "/mpif/delMasterMpIfObPoAltereList.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> delMasterMpIfObPoAltereList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();
			
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
			String rtnMsg = masterMpIfObPoAlterService.delSelectedData(formData, gridData);

			// 성공시 : 1 실패시 : 0
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("Code",1);
			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
		}
		
}
