package com.koreab2b.mro.seller.mpcl.controller;

import java.io.OutputStream;
import java.util.HashMap;
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
import com.koreab2b.mro.seller.mpcl.service.SellerMpClTaxsheetIssueStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpClTaxsheetIssueStateController")
public class SellerMpClTaxsheetIssueStateController {

	@Autowired
	private SellerMpClTaxsheetIssueStateService sellerMpClTaxsheetIssueStateService;
	
	// 조회
	@RequestMapping(value = "/mpcl/getSellerMpClTaxsheetIssueStateList.do", method = RequestMethod.POST)
	public String getSellerMpClTaxsheetIssueStateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 

		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpClTaxsheetIssueStateService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/mpcl/sellerMpClTaxsheetIssueStateList";
	}
	
	// Ajax 전용 조회 (리뉴얼 화면용)
		@RequestMapping(value = "/mpcl/getSellerMpClTaxsheetIssueStateList_v2.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> getSellerMpClTaxsheetIssueStateListAjax(@RequestParam Map<String, String> pMap) {
			
			Map<String, Object> response = new HashMap<String, Object>();
			

				// 필수 파라미터 검증
				if (pMap.get("st_com_code") == null || pMap.get("st_cl_year") == null 
					|| pMap.get("st_cl_month") == null || pMap.get("st_site") == null) {
					response.put("Sheet1", new java.util.ArrayList<Map<String, String>>());
					return response;
				}
				
				// 페이징처리
				pMap = CommonUtil.PagingPrc(pMap);
				
				// 화면 조회
				pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
				List<Map<String, String>> _data = sellerMpClTaxsheetIssueStateService.getList_v2(pMap);
				
				// IBSheetResponseUtil을 사용하여 표준 DoSearch 응답 생성
				Map<String, Object> result = IBSheetResponseUtil.createSuccessResponse(_data);

				return result;
				

		}
	
	// EXCEL 다운로드 (레거시)
	@RequestMapping(value = "/mpcl/excelSellerMpClTaxsheetIssueStateList.do", method = RequestMethod.POST)
	public void excelSellerMpClTaxsheetIssueState(ModelMap pModel, @RequestParam Map<String, String> pMap , HttpServletResponse response , OutputStream outputStream    ) {

		// Excel Down을 위한 구분
		pMap.put("paging", "0");

		List<Map<String, String>> _data = sellerMpClTaxsheetIssueStateService.getList(pMap);

		String title = "당사사업장|당사사업자번호|사이트|발행일|거래처|사업자등록번호|공급가액|세액|합계|세무구분|발행조건|적요";
		String headers = "KEP_NAME|KEP_IRS_NO|KEP_SITE_NAME|ISSUE_DATE|AGENT_NAME|IRS_NO|TOT_SUPP_PRICE|TOT_TAX_PRICE|TOT_AMT|TAX_TYPE|BILL_TYPE|SUMMARY";
		String excelHeader = title +"@@"+headers;

		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "세금계산서발행현황.xls");

	}

	// EXCEL 다운로드 (리뉴얼)
	@RequestMapping(value = "/mpcl/excelSellerMpClTaxsheetIssueStateList_v2.do", method = RequestMethod.POST)
	public void excelSellerMpClTaxsheetIssueState_v2(ModelMap pModel, @RequestParam Map<String, String> pMap , HttpServletResponse response , OutputStream outputStream    ) {

		// Excel Down을 위한 구분
		pMap.put("paging", "0");

		List<Map<String, String>> _data = sellerMpClTaxsheetIssueStateService.getList_v2(pMap);

		String title = "당사사업장|당사사업자번호|사이트|발행일|거래처|사업자등록번호|공급가액|세액|합계|세무구분|발행조건|적요";
		String headers = "KEP_NAME|KEP_IRS_NO|KEP_SITE_NAME|ISSUE_DATE|AGENT_NAME|IRS_NO|TOT_SUPP_PRICE|TOT_TAX_PRICE|TOT_AMT|TAX_TYPE|BILL_TYPE|SUMMARY";
		String excelHeader = title +"@@"+headers;

		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "세금계산서발행현황.xls");

	}
}
