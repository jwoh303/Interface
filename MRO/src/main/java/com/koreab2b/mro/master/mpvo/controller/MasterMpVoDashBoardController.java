package com.koreab2b.mro.master.mpvo.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mpvo.service.MasterMpVoDashBoardService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpVoDashBoardController")
public class MasterMpVoDashBoardController {

	@Autowired
	private MasterMpVoDashBoardService masterMpVoDashBoardService;
	
	// 조회
	@RequestMapping(value = "/mpvo/getMasterMpVoDashBoardList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoDashBoardList(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest request) {
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId()));
		
		String _buyerOwnCnt = CommonUtil.nvl(masterMpVoDashBoardService.getCountBuyerOwn(pMap), "0");
		
		pMap.put("st_buyer_type", CommonUtil.nvl((String) request.getParameter("st_buyer_type"), !"0".equals(_buyerOwnCnt) ? "OWN" : "" ));
		
		List<Map<String,String>> _data = masterMpVoDashBoardService.getList(pMap);
		List<Map<String,String>> _dash_board_data1 = masterMpVoDashBoardService.getDashBoardList1(pMap);
		List<Map<String,String>> _dash_board_data2 = masterMpVoDashBoardService.getDashBoardList2(pMap);
		List<Map<String,String>> _dash_board_data3 = masterMpVoDashBoardService.getDashBoardList3(pMap);
		List<Map<String,String>> _dash_board_data4 = masterMpVoDashBoardService.getDashBoardList4(pMap);
		
		pModel.addAttribute("buyer_own_cnt", _buyerOwnCnt); 
		pModel.addAttribute("_data", _data);
		pModel.addAttribute("_dash_board_data1", _dash_board_data1);
		pModel.addAttribute("_dash_board_data2", _dash_board_data2);
		pModel.addAttribute("_dash_board_data3", _dash_board_data3);
		pModel.addAttribute("_dash_board_data4", _dash_board_data4);
		
		return "master/mpvo/masterMpVoDashBoardList";
	}
	
}
