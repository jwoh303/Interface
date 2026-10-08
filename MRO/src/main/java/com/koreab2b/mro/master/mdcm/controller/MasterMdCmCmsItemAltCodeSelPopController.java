package com.koreab2b.mro.master.mdcm.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsItemAltCodeSelPopService;

// 상품정보 상태변경(미사용/중복존재) 시 [대체코드] 를 골라 오는 조회 팝업.
// 순수 뷰가 아니라 상단 [기존 상품 정보] 1행을 읽어 넘기므로 라우트도 여기에 둔다(PopUpViewController 아님).
@Controller("masterMdCmCmsItemAltCodeSelPopController")
public class MasterMdCmCmsItemAltCodeSelPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCmsItemAltCodeSelPopController.class);

	@Autowired
	private MasterMdCmCmsItemAltCodeSelPopService masterMdCmCmsItemAltCodeSelPopService;

	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemAltCodeSelPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsItemAltCodeSelPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("대체코드 조회 팝업 요청 파라미터 : {}", pMap);

		req.setAttribute("data", masterMdCmCmsItemAltCodeSelPopService.getBase(pMap));
		return "common/popup/mdcm/masterMdCmCmsItemAltCodeSelPop";
	}

	@RequestMapping(value = "/mdcm/getMasterMdCmCmsItemAltCodeSelPopList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsItemAltCodeSelPopList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("대체코드 목록 요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmCmsItemAltCodeSelPopService.getList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data, pMap);
	}

}
