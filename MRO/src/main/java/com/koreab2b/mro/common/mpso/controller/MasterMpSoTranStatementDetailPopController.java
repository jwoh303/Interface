package com.koreab2b.mro.common.mpso.controller;

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

import com.koreab2b.mro.common.mpso.service.MasterMpSoTranStatementDetailPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoTranStatementDetailPopController")
public class MasterMpSoTranStatementDetailPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoTranStatementDetailPopController.class);

	@Autowired
	private MasterMpSoTranStatementDetailPopService masterMpSoTranStatementDetailPopService;
	
	/**
	 * 거래명세서 상세조회 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoTranStatementDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoTranStatementDetailPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpso/getMasterMpSoTranStatementDetailPop.do 요청 파라미터 for jsp : {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String user_id = _sessionInfo.getUserId();
		
		pMap.put("USER_ID", user_id);

		// 거래명세서상세조회 기본정보조회
		Map<String,String> _detailInfo = masterMpSoTranStatementDetailPopService.getInfo(pMap);
		
		// 거래명세서작성 리스트조회
		List<Map<String, String>> _data = masterMpSoTranStatementDetailPopService.getList(pMap);
		
		// 물류센터 고객사 체크
		String w001Flag = masterMpSoTranStatementDetailPopService.getW001Flag(pMap); 
		pModel.addAttribute("w001flag", w001Flag);
		
		pModel.addAttribute("detailInfo", _detailInfo);
		pModel.addAttribute("detailList", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
				
		return "common/popup/mpso/masterMpSoTranStatementDetailPop";
	}
	@RequestMapping(value = "/mpso/getMasterMpSoTranStatementDetailPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoTranStatementDetailPop_v2(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpso/getMasterMpSoTranStatementDetailPop_v2.do 요청 파라미터 for jsp : {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String user_id = _sessionInfo.getUserId();
		
		pMap.put("USER_ID", user_id);

		// 거래명세서상세조회 기본정보조회
		Map<String,String> _detailInfo = masterMpSoTranStatementDetailPopService.getInfo_v2(pMap);
		
		// 거래명세서작성 리스트조회
		List<Map<String, String>> _data = masterMpSoTranStatementDetailPopService.getList(pMap);
		
		// 물류센터 고객사 체크
		String w001Flag = masterMpSoTranStatementDetailPopService.getW001Flag(pMap); 
		pModel.addAttribute("w001flag", w001Flag);
		
		pModel.addAttribute("detailInfo", _detailInfo);
		pModel.addAttribute("detailList", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
				
		return "common/popup/mpso/masterMpSoTranStatementDetailPop_v2";
	}
	
}
