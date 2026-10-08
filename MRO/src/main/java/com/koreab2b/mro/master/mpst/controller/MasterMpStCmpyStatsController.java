package com.koreab2b.mro.master.mpst.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpst.service.MasterMpStCmpyStatsService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpStCmpyStatsController")
public class MasterMpStCmpyStatsController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStCmpyStatsController.class);

	@Autowired
	private MasterMpStCmpyStatsService masterMpStCmpyStatsService;
	
	// 고객사현황 조회
	// 협력사현황 조회
	@RequestMapping(value = "/mpst/getMasterMpStCmpyStatsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String searchMasterMpStCmpyStatsList(ModelMap pModel, HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		
		// 고객사현황 조회
		List<Map<String,String>> _data1 = masterMpStCmpyStatsService.selectList(pMap);
		// 그룹
		List<Map<String,String>> _dataG = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBNTBUYERGROUP(pMap);
		// 팀
		List<Map<String,String>> _dataT = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListICOMCOD2(pMap);
		
		int totalSum = 0;
		
		Map<String, String> _dateMap = null;
		Map<String, String> _dateMap2 = new HashMap<String, String>();		
		String KEP_DEPT = "";
		String GROUP_CODE = "";
		String CNT = "";
		_data1 =  CommonUtil.getListNvl(_data1);
		for (int i=0; i<_data1.size(); i++){
			_dateMap = _data1.get(i);
			KEP_DEPT = _dateMap.get("KEP_DEPT");
			GROUP_CODE = _dateMap.get("GROUP_CODE");
			CNT = _dateMap.get("CNT");			
			_dateMap2.put(GROUP_CODE+"_"+KEP_DEPT,CNT);
		} 
		
		
		
		// 그룹 SUM
		Map<String, String> _dateMapGSum = null;
		Map<String, String> _dateMapGSum2 = new HashMap<String, String>();		
		List<Map<String,String>> _dataGSum = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListSumGroup(pMap);
		_dataGSum =  CommonUtil.getListNvl(_dataGSum);
		for (int i=0; i<_dataGSum.size(); i++){
			_dateMapGSum = _dataGSum.get(i); 
			GROUP_CODE = _dateMapGSum.get("GROUP_CODE");
			CNT = _dateMapGSum.get("CNT");			
			_dateMapGSum2.put("GROUPSUM_"+GROUP_CODE,CNT);
		}  
		
		// 팀 SUM
		Map<String, String> _dateMapTSum = null;
		Map<String, String> _dateMapTSum2 = new HashMap<String, String>();		
		List<Map<String,String>> _dataTSum = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListSumTeam(pMap);
		_dataTSum =  CommonUtil.getListNvl(_dataTSum);
		for (int i=0; i<_dataTSum.size(); i++){
			_dateMapTSum = _dataTSum.get(i);
			KEP_DEPT = _dateMapTSum.get("KEP_DEPT"); 
			CNT = _dateMapTSum.get("CNT");
			totalSum = totalSum + Integer.parseInt(CNT);
			_dateMapTSum2.put("TEAMSUM_"+KEP_DEPT,CNT);
		} 
		_dateMapTSum2.put("GROUPSUM_TOTSUM",String.valueOf(totalSum));
		
		
		
		
		 
		pModel.addAttribute("dataG", CommonUtil.getListNvl(_dataG));
		pModel.addAttribute("dataT", CommonUtil.getListNvl(_dataT));
		pModel.addAttribute("dataM", _dateMap2);
		pModel.addAttribute("dataGSUM", _dateMapGSum2);
		pModel.addAttribute("dataTSUM", _dateMapTSum2);
		
		
		
		// 협력사현황 조회
		List<Map<String,String>> _dataBiz1 = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBiz(pMap);
		// 신용등급
		List<Map<String,String>> _dataS = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBizCMpy(pMap);
		// 유통레벨
		List<Map<String,String>> _dataL = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBizM110(pMap);
	
		
		int totalBizSum = 0;
		
		Map<String, String> _dateMapBiz = null;
		Map<String, String> _dateMapBiz2 = new HashMap<String, String>();		
		String BIZ_TYPE = "";
		String CREDIT_STATUS = "";
		String BIZ_CNT = "";
		_dataBiz1 =  CommonUtil.getListNvl(_dataBiz1);
		for (int i=0; i<_dataBiz1.size(); i++){
			_dateMapBiz = _dataBiz1.get(i);
			BIZ_TYPE = _dateMapBiz.get("BIZ_TYPE");
			CREDIT_STATUS = _dateMapBiz.get("CREDIT_STATUS");
			BIZ_CNT = _dateMapBiz.get("CNT");			
			_dateMapBiz2.put(CREDIT_STATUS+"_"+BIZ_TYPE,BIZ_CNT);
		} 
		
		
		
		// 유통레벨 SUM
		Map<String, String> _dateMapLSum = null;
		Map<String, String> _dateMapLSum2 = new HashMap<String, String>();		
		List<Map<String,String>> _dataLSum = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBizTypeSum(pMap);
		_dataLSum =  CommonUtil.getListNvl(_dataLSum);
		for (int i=0; i<_dataLSum.size(); i++){
			_dateMapLSum = _dataLSum.get(i); 
			CREDIT_STATUS = _dateMapLSum.get("BIZ_TYPE");
			BIZ_CNT = _dateMapLSum.get("CNT");			
			_dateMapLSum2.put("BIZ_TYPE_"+CREDIT_STATUS,BIZ_CNT);
		}  
		
		// 신용등급 SUM
		Map<String, String> _dateMapSSum = null;
		Map<String, String> _dateMapSSum2 = new HashMap<String, String>();		
		List<Map<String,String>> _dataSSum = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBizCreditStatusSum(pMap);
		_dataSSum =  CommonUtil.getListNvl(_dataSSum);
		for (int i=0; i<_dataSSum.size(); i++){
			_dateMapSSum = _dataSSum.get(i);
			BIZ_TYPE = _dateMapSSum.get("CREDIT_STATUS"); 
			BIZ_CNT = _dateMapSSum.get("CNT");
			totalBizSum = totalBizSum + Integer.parseInt(BIZ_CNT);
			_dateMapSSum2.put("CREDIT_STATUS_"+BIZ_TYPE,BIZ_CNT);
		} 
		_dateMapSSum2.put("CREDIT_STATUS_TOTSUM",String.valueOf(totalBizSum));
		
		
		
		pModel.addAttribute("dataS", CommonUtil.getListNvl(_dataS));
		pModel.addAttribute("dataL", CommonUtil.getListNvl(_dataL));
		pModel.addAttribute("dataBIZ", _dateMapBiz2);
		pModel.addAttribute("dataLSUM", _dateMapLSum2);
		pModel.addAttribute("dataSSUM", _dateMapSSum2);
		
		
		
		
		
		
		
		
		
		pModel.addAllAttributes(pMap);
		
		return "master/mpst/masterMpStCmpyStatsList";
	}
	
	
	
	// 고객사현황 조회Excel
		// 협력사현황 조회 Excel
		@RequestMapping(value = "/mpst/searchExcelMasterMpStCmpyStatsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
		public String searchExcelMasterMpStCmpyStatsList(ModelMap pModel, HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
			logger.debug("요청 파라미터 : {}", pMap);

			
			// 고객사현황 조회
			List<Map<String,String>> _data1 = masterMpStCmpyStatsService.selectList(pMap);
			// 그룹
			List<Map<String,String>> _dataG = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBNTBUYERGROUP(pMap);
			// 팀
			List<Map<String,String>> _dataT = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListICOMCOD2(pMap);
			
			int totalSum = 0;
			
			Map<String, String> _dateMap = null;
			Map<String, String> _dateMap2 = new HashMap<String, String>();		
			String KEP_DEPT = "";
			String GROUP_CODE = "";
			String CNT = "";
			_data1 =  CommonUtil.getListNvl(_data1);
			for (int i=0; i<_data1.size(); i++){
				_dateMap = _data1.get(i);
				KEP_DEPT = _dateMap.get("KEP_DEPT");
				GROUP_CODE = _dateMap.get("GROUP_CODE");
				CNT = _dateMap.get("CNT");			
				_dateMap2.put(GROUP_CODE+"_"+KEP_DEPT,CNT);
			} 
			
			
			
			// 그룹 SUM
			Map<String, String> _dateMapGSum = null;
			Map<String, String> _dateMapGSum2 = new HashMap<String, String>();		
			List<Map<String,String>> _dataGSum = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListSumGroup(pMap);
			_dataGSum =  CommonUtil.getListNvl(_dataGSum);
			for (int i=0; i<_dataGSum.size(); i++){
				_dateMapGSum = _dataGSum.get(i); 
				GROUP_CODE = _dateMapGSum.get("GROUP_CODE");
				CNT = _dateMapGSum.get("CNT");			
				_dateMapGSum2.put("GROUPSUM_"+GROUP_CODE,CNT);
			}  
			
			// 팀 SUM
			Map<String, String> _dateMapTSum = null;
			Map<String, String> _dateMapTSum2 = new HashMap<String, String>();		
			List<Map<String,String>> _dataTSum = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListSumTeam(pMap);
			_dataTSum =  CommonUtil.getListNvl(_dataTSum);
			for (int i=0; i<_dataTSum.size(); i++){
				_dateMapTSum = _dataTSum.get(i);
				KEP_DEPT = _dateMapTSum.get("KEP_DEPT"); 
				CNT = _dateMapTSum.get("CNT");
				totalSum = totalSum + Integer.parseInt(CNT);
				_dateMapTSum2.put("TEAMSUM_"+KEP_DEPT,CNT);
			} 
			_dateMapTSum2.put("GROUPSUM_TOTSUM",String.valueOf(totalSum));
			
			
			
			
			 
			pModel.addAttribute("dataG", CommonUtil.getListNvl(_dataG));
			pModel.addAttribute("dataT", CommonUtil.getListNvl(_dataT));
			pModel.addAttribute("dataM", _dateMap2);
			pModel.addAttribute("dataGSUM", _dateMapGSum2);
			pModel.addAttribute("dataTSUM", _dateMapTSum2);
			
			
			
			// 협력사현황 조회
			List<Map<String,String>> _dataBiz1 = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBiz(pMap);
			// 신용등급
			List<Map<String,String>> _dataS = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBizCMpy(pMap);
			// 유통레벨
			List<Map<String,String>> _dataL = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBizM110(pMap);
		
			
			int totalBizSum = 0;
			
			Map<String, String> _dateMapBiz = null;
			Map<String, String> _dateMapBiz2 = new HashMap<String, String>();		
			String BIZ_TYPE = "";
			String CREDIT_STATUS = "";
			String BIZ_CNT = "";
			_dataBiz1 =  CommonUtil.getListNvl(_dataBiz1);
			for (int i=0; i<_dataBiz1.size(); i++){
				_dateMapBiz = _dataBiz1.get(i);
				BIZ_TYPE = _dateMapBiz.get("BIZ_TYPE");
				CREDIT_STATUS = _dateMapBiz.get("CREDIT_STATUS");
				BIZ_CNT = _dateMapBiz.get("CNT");			
				_dateMapBiz2.put(CREDIT_STATUS+"_"+BIZ_TYPE,BIZ_CNT);
			} 
			
			
			
			// 유통레벨 SUM
			Map<String, String> _dateMapLSum = null;
			Map<String, String> _dateMapLSum2 = new HashMap<String, String>();		
			List<Map<String,String>> _dataLSum = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBizTypeSum(pMap);
			_dataLSum =  CommonUtil.getListNvl(_dataLSum);
			for (int i=0; i<_dataLSum.size(); i++){
				_dateMapLSum = _dataLSum.get(i); 
				CREDIT_STATUS = _dateMapLSum.get("BIZ_TYPE");
				BIZ_CNT = _dateMapLSum.get("CNT");			
				_dateMapLSum2.put("BIZ_TYPE_"+CREDIT_STATUS,BIZ_CNT);
			}  
			
			// 신용등급 SUM
			Map<String, String> _dateMapSSum = null;
			Map<String, String> _dateMapSSum2 = new HashMap<String, String>();		
			List<Map<String,String>> _dataSSum = masterMpStCmpyStatsService.selectMasterMpStCmpyStatsListBizCreditStatusSum(pMap);
			_dataSSum =  CommonUtil.getListNvl(_dataSSum);
			for (int i=0; i<_dataSSum.size(); i++){
				_dateMapSSum = _dataSSum.get(i);
				BIZ_TYPE = _dateMapSSum.get("CREDIT_STATUS"); 
				BIZ_CNT = _dateMapSSum.get("CNT");
				totalBizSum = totalBizSum + Integer.parseInt(BIZ_CNT);
				_dateMapSSum2.put("CREDIT_STATUS_"+BIZ_TYPE,BIZ_CNT);
			} 
			_dateMapSSum2.put("CREDIT_STATUS_TOTSUM",String.valueOf(totalBizSum));
			
			
			
			pModel.addAttribute("dataS", CommonUtil.getListNvl(_dataS));
			pModel.addAttribute("dataL", CommonUtil.getListNvl(_dataL));
			pModel.addAttribute("dataBIZ", _dateMapBiz2);
			pModel.addAttribute("dataLSUM", _dateMapLSum2);
			pModel.addAttribute("dataSSUM", _dateMapSSum2);
			
			
			
			
			
			
			
			
			
			pModel.addAllAttributes(pMap);
			
			return "master/mpst/masterMpStCmpyStatsExcelList";
		}
		
		
	
	// 협력사현황 조회
	@RequestMapping(value = "/mpst/getMasterMpStSupplierStatsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStSupplierStatsList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpStCmpyStatsService.getList2(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}

}
