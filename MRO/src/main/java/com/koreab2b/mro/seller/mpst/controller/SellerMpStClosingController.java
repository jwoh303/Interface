package com.koreab2b.mro.seller.mpst.controller;

import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetResponseUtil;
import com.koreab2b.mro.seller.mpst.service.SellerMpStClosingService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpStClosingController")
public class SellerMpStClosingController {

	@Autowired
	private SellerMpStClosingService sellerMpStClosingService;
	
	// 조회
	@RequestMapping(value = "/mpst/getSellerMpStClosingList.do", method = RequestMethod.POST)
	public String getSellerMpStClosingList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpStClosingService.getList(pMap);
		
		pModel.addAttribute("data", _data);
		
		return "seller/mpst/sellerMpStClosingList";
	}
	
	// 저장
//	@RequestMapping(value = "/mpst/saveSellerMpStClosingList.do", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> updateSellerMpStClosing(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
//
//		// gridData
//		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
//		// formData
//		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
//		
//		Map<String, Object> _response = new HashMap<String, Object>();
//		
//		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
//		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
//		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
//		
//		String flag = sellerMpStClosingService.updateSelectedData(_pMap, _list);
//		_response.put("msg", flag);
//
//		return  _response;
//	}
	
	
	// 리뉴얼 버전 JSON API 조회
	@RequestMapping(value = "/mpst/getSellerMpStClosingList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSellerMpStClosingList_v2(@RequestParam Map<String, String> pMap) {
		// 페이징 처리 (전체 데이터 조회)
		pMap.put("paging", "0");

		// st_buyer_name이 없는 경우 빈 문자열로 설정 (선택적 조건)
		if (!pMap.containsKey("st_buyer_name") || pMap.get("st_buyer_name") == null) {
			pMap.put("st_buyer_name", "");
		}

		// 기존 레거시 쿼리로 조회 (LIKE 조건 적용)
		List<Map<String, String>> data = sellerMpStClosingService.getList(pMap);

		// IBSheetResponseUtil을 사용하여 표준 DoSearch 응답 생성
		Map<String, Object> result = IBSheetResponseUtil.createSuccessResponse(data);

		// 디버깅용 로그 출력 (필요시 주석 처리)
		// IBSheetResponseUtil.logResponse(result, "[DoSearch] VMI 마감조회");

		return result;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpst/excelSellerMpStClosingList.do", method = RequestMethod.POST)
	public void excelSellerMpStClosing(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpStClosingService.getList(pMap); 
		   
		String title = "고객사명|고객사코드|발주번호|출고번호|품목명|규격|출고수량|단가|총금액|출고일자";
		String headers = "BUYER_NAME|BUYER_CODE|PO_NO|GR_NO|DESCRIPTION|SPECIFICATION|ITEM_QTY|AGENT_PRICE|AGENT_ITEM_AMT|GR_DATE";
		String excelHeader = title + "@@" + headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"재고현황조회.xls");
	}
	
}
