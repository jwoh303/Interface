package com.koreab2b.mro.common.wmgi.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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

import com.koreab2b.mro.common.wmgi.service.MasterWmGiDstbtrPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmGiDstbtrPopController")
public class MasterWmGiDstbtrPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGiDstbtrPopController.class);

	@Autowired
	private MasterWmGiDstbtrPopService masterWmGiDstbtrPopService;
	
	/**
	 * 출고지시 및 거래명세표(보급소별) 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgi/getMasterWmGiDstbtrPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmGiDstbtrPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmGiDstbtrPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	   // 저장
		@RequestMapping(value = "/wmgi/saveMasterWmGiDstbtrPop.do", method = RequestMethod.POST)
		@ResponseBody
		@Transactional
		public Map<String, Object> updateMasterWmGiDstbtrPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();
			
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
			logger.debug("요청 파라미터 : gridData{}", gridData);
			logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : pMap{}", pMap); 
			logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData{}", formData); 
			String rtnMsg = masterWmGiDstbtrPopService.updateSelectedData(formData, gridData);

			/* 성공시코드 1 , 실패시 0 */
			Map<String, Object> mp = new HashMap<String, Object>();
			logger.debug("리턴  파라미터 :"+ rtnMsg);
			if(rtnMsg.substring(0,2).equals("OK"))
			{
				mp.put("Code",1);
				
				//SLOGIC-BEGIN(P08-0000011)   화진 네트웍스이면 부서 조회까지 
				String pP08_0000011id  = "";
				Map<String, String> _map = CommonUtil.getSpecialCheckReturnSheetMap(formData.get("st_buyer"));
				if(_map!=null){
					
					pP08_0000011id = _map.get("SLG_ID");

				}
				if("P08-0000011-23".equals(pP08_0000011id)){
					formData.put("st_ik_no_temp", rtnMsg.substring(2));
					
					String  deptMap = CommonUtil.getSpecialCheckReturnSheetMapByDept( formData );
					rtnMsg= rtnMsg+"@@"+deptMap;
				}
				//SLOGIC-END
				
			}else{
				
				mp.put("Code",0);
			}

			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
			
		}
	
	
}
