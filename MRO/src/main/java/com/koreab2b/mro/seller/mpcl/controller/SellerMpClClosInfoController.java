package com.koreab2b.mro.seller.mpcl.controller;

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
import com.koreab2b.mro.seller.mpcl.service.SellerMpClClosInfoService;

@Controller("sellerMpClClosInfoController")
public class SellerMpClClosInfoController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(SellerMpClClosInfoController.class);
	
	@Autowired
	private SellerMpClClosInfoService sellerMpClClosInfoService;
	
	// 조회
	@RequestMapping(value = "/mpcl/getSellerMpClClosInfoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpClClosInfoList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpClClosInfoList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = sellerMpClClosInfoService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 마감 확정 내역 조회
	@RequestMapping(value = "/mpcl/getSellerMpClClosInfoList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpClClosInfoList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpClClosInfoList 요청 파라미터 : {}", pMap);
		
		// 세션에서 UI 버전 확인
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		LOGGER.debug("UI 버전: {}", uiVersion);
		
		// 페이징 처리 제거
		List<Map<String,String>> _data;
		
		LOGGER.debug("리뉴얼 버전 쿼리 사용 (검색조건 추가)");
		_data = sellerMpClClosInfoService.getList_V2(pMap);  // 신규 쿼리 (검색조건 추가)
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	
	
	// 마감 대상 내역 조회
	@RequestMapping(value = "/mpcl/getSellerMpClClosTargetInfoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpClClosTargetInfoList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpClClosTargetInfoList 요청 파라미터 : {}", pMap);

		// 마감 대상 내역 조회
		List<Map<String,String>> _data = sellerMpClClosInfoService.getTargetList_V2(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/mpcl/getSellerMpClClosTargetInfoList_v3.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpClClosTargetInfoList_v3(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpClClosTargetInfoList 요청 파라미터 : {}", pMap);

		// 마감 대상 내역 조회
		List<Map<String,String>> _data = sellerMpClClosInfoService.getTargetList_V3(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	
	// 엑셀다운로드
	@RequestMapping(value = "/mpcl/excelSellerMpClClosInfoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = sellerMpClClosInfoService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}

	// 탭5 전용 조회
	@RequestMapping(value = "/mpcl/getSellerMpClClosInfoTab5List.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpClClosInfoTab5List(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpClClosInfoTab5List 요청 파라미터 : {}", pMap);

		// 탭5 전용 리스트 조회
		List<Map<String,String>> _data = sellerMpClClosInfoService.getTab5List(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/mpcl/getSellerMpClClosInfoTab5List_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpClClosInfoTab5List_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpClClosInfoTab5List_v2 요청 파라미터 : {}", pMap);

		// 탭5 전용 리스트 조회
		List<Map<String,String>> _data = sellerMpClClosInfoService.getTab5List_v2(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
