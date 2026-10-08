package com.koreab2b.mro.seller.mpst.controller;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetResponseUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mpst.service.SellerMpStDeliveryRecordService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpStDeliveryRecordController")
public class SellerMpStDeliveryRecordController {
	
	@Autowired
	private SellerMpStDeliveryRecordService sellerMpStDeliveryRecordService;
	
	// 조회
	@RequestMapping(value = "/mpst/getSellerMpStDeliveryRecordList.do", method = RequestMethod.POST)
	public String getSellerMpStClosingList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		List<Map<String, String>> _data = sellerMpStDeliveryRecordService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/mpst/sellerMpStDeliveryRecordList";
	}
	
	// IBSheet DoSearch용 JSON 응답 조회 (리뉴얼 버전)
	@RequestMapping(value = "/mpst/getSellerMpStDeliveryRecordList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSellerMpStDeliveryRecordList_v2(HttpServletRequest request, @RequestParam Map<String, String> pMap) {		
		
		// 세션에서 회사 코드 가져오기
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if (sessionInfo != null) {
			pMap.put("st_com_code", sessionInfo.getComCode());
		}
		
		System.out.println("========== VMI 납품실적조회 Controller v2 (IBSheet DoSearch) ==========");
		System.out.println("st_com_code (from session): " + pMap.get("st_com_code"));
		System.out.println("st_check_date: " + pMap.get("st_check_date"));
		System.out.println("st_from_date: " + pMap.get("st_from_date"));
		System.out.println("st_to_date: " + pMap.get("st_to_date"));
		System.out.println("st_status_ing: " + pMap.get("st_status_ing"));
		System.out.println("전체 파라미터: " + pMap);
		
		// 페이징처리 (DoSearch에서는 보통 페이징 처리하지 않음)
		pMap.put("paging", "0");
		
		// 기존 레거시 쿼리로 조회
		List<Map<String, String>> _data = sellerMpStDeliveryRecordService.getList(pMap);
		
		// IBSheetResponseUtil을 사용하여 표준 DoSearch 응답 생성
		Map<String, Object> result = IBSheetResponseUtil.createSuccessResponse(_data);

		return result;
	}
	
	// EXCEL 다운로드
	@RequestMapping(value = "/mpst/excelSellerMpStDeliveryRecordList.do", method = RequestMethod.POST)
	public void excelSellerMpStClosing(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpStDeliveryRecordService.getList(pMap); 
		   
		String title = "물류센타명|구분|발주송장번호|자재코드|품명|규격|단위|입고수량|입고일자|발주수량|발주일자|송장수량|송장일자|비고";
		String headers = "WMS_NAME|RECV_FLAG_NAME|VPO_NO|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|GR_QTY|VGR_DATE|ITEM_QTY|VPO_DATE|IV_QTY|VIV_DATE|VPO_REMARK";
		String excelHeader = title + "@@" + headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"납품실적조회.xls");
	}
}
