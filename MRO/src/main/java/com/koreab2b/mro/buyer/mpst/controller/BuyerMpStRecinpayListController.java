package com.koreab2b.mro.buyer.mpst.controller;

import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.buyer.mpst.service.BuyerMpStRecinpayListService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpStRecinpayListController")
public class BuyerMpStRecinpayListController {

	@Autowired
	private BuyerMpStRecinpayListService buyerMpStRecinpayListService;
	
	// 페이지 호출
	@RequestMapping(value = "/mpst/showBuyerMpStRecinpayList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMpStRecinpayListList(ModelMap pModel ,HttpServletRequest req, @RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_com_code", _sessionInfo.getComCode()); // 사용자 회사코드	
		
		// 조회조건 조회
		List<Map<String, String>> _userList = buyerMpStRecinpayListService.getUserList(pMap);
		List<Map<String, String>> _deptList = buyerMpStRecinpayListService.getDeptList(pMap);
		
		pModel.addAttribute("userList", CommonUtil.getListNvl(_userList));
		pModel.addAttribute("deptList", CommonUtil.getListNvl(_deptList));
		
		return "buyer/mpst/buyerMpStRecinpayListList";
	}
	
	// 조회
	@RequestMapping(value = "/mpst/getBuyerMpStRecinpayListList.do", method = RequestMethod.POST)
	public String getBuyerMpStRecinpayListList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpStRecinpayListService.getList(pMap);
		List<Map<String, String>> _userList = buyerMpStRecinpayListService.getUserList(pMap);
		List<Map<String, String>> _deptList = buyerMpStRecinpayListService.getDeptList(pMap);
		
		pModel.addAttribute("data", _data);
		pModel.addAttribute("userList", CommonUtil.getListNvl(_userList));
		pModel.addAttribute("deptList", CommonUtil.getListNvl(_deptList));
		
		return "buyer/mpst/buyerMpStRecinpayListList";
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpst/excelBuyerMpStRecinpayListList.do", method = RequestMethod.POST)
	public void excelBuyerMpStRecinpayList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpStRecinpayListService.getList(pMap); 
		   
		String title = "수불명|수불번호|품목코드|품목명|규격|제조사|단위|작업일시|작업수량|작업자명|작업부서명|비고";
		String headers = "JOB_TYPE_TEXT|JOB_NO|ITEM_NO|DESCRIPTION|SPECIFICATION|MAKER_NAME|UNIT_MEASURE|JOB_DAY|ITEM_QTY|JOB_USER_NAME|JOB_DEPT_NAME|JOB_NOTE";
		String excelHeader = title + "@@" + headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"수불리스트.xls");
	}
	
}
