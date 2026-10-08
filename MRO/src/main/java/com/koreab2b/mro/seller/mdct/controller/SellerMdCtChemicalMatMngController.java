package com.koreab2b.mro.seller.mdct.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.seller.mdct.service.SellerMdCtChemicalMatMngService;

@Controller("sellerMdCtChemicalMatMngController")
public class SellerMdCtChemicalMatMngController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(SellerMdCtChemicalMatMngController.class);
	
	@Autowired
	private SellerMdCtChemicalMatMngService sellerMdCtChemicalMatMngService;
	
	// 조회
	@RequestMapping(value = "/mdct/getSellerMdCtChemicalMatMngList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMdCtChemicalMatMngList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMdCtChemicalMatMngList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = sellerMdCtChemicalMatMngService.getList(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 리뉴얼 탭1 - MSDS 전체 조회
	@RequestMapping(value = "/mdct/getMSDSList.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMSDSList(@RequestParam Map<String, Object> param) {
		LOGGER.debug("getMSDSList 요청 파라미터 : {}", param);
		LOGGER.debug("dateType: {}, fromDate: {}", param.get("dateType"), param.get("fromDate"));
		LOGGER.debug("toDate: {}, searchType: {}", param.get("toDate"), param.get("searchType"));
		LOGGER.debug("searchKeyword: {}, status: {}", param.get("searchKeyword"), param.get("status"));
		LOGGER.debug("requestNo: {}, sessionComCode: {}", param.get("requestNo"), param.get("sessionComCode"));
		LOGGER.debug("sessionUserId: {}", param.get("sessionUserId"));

		// 페이징 처리 안함 (DoSearch에서는 보통 페이징 처리하지 않음)
		List<Map<String,String>> data = sellerMdCtChemicalMatMngService.getMSDSList(param);

		// IBSheetResponseUtil을 사용하여 표준 DoSearch 응답 생성
		Map<String, Object> result = com.koreab2b.mro.common.ibsheet.IBSheetResponseUtil.createSuccessResponse(data);

		return result;
	}

	// 리뉴얼 탭2 - MSDS 제출요청 조회
	@RequestMapping(value = "/mdct/getMSDSSubmitRequestList.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMSDSSubmitRequestList(@RequestParam Map<String, Object> param) {
		LOGGER.debug("getMSDSSubmitRequestList 요청 파라미터 : {}", param);
		LOGGER.debug("dateType: {}, fromDate: {}", param.get("dateType"), param.get("fromDate"));
		LOGGER.debug("toDate: {}, searchType: {}", param.get("toDate"), param.get("searchType"));
		LOGGER.debug("searchKeyword: {}, reqStatus: {}", param.get("searchKeyword"), param.get("reqStatus"));
		LOGGER.debug("requestNo: {}, sessionComCode: {}", param.get("requestNo"), param.get("sessionComCode"));
		LOGGER.debug("sessionUserId: {}", param.get("sessionUserId"));

		// 페이징 처리 안함 (DoSearch에서는 보통 페이징 처리하지 않음)
		List<Map<String,String>> data = sellerMdCtChemicalMatMngService.getMSDSSubmitRequestList(param);

		// 실제 STATUS 값 확인을 위한 디버깅 로그
		if (data != null && !data.isEmpty()) {
			LOGGER.debug("조회된 데이터 건수: {}", data.size());
			for (int i = 0; i < Math.min(3, data.size()); i++) {
				Map<String,String> row = data.get(i);
				LOGGER.debug("샘플 데이터[{}] - STATUS: [{}], REQUEST_NO: [{}]",
					new Object[] {i, row.get("STATUS"), row.get("REQUEST_NO")});
			}
		}

		// IBSheetResponseUtil을 사용하여 표준 DoSearch 응답 생성
		Map<String, Object> result = com.koreab2b.mro.common.ibsheet.IBSheetResponseUtil.createSuccessResponse(data);

		return result;
	}

}
