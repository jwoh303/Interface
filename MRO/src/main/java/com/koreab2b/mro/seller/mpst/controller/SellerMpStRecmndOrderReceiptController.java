package com.koreab2b.mro.seller.mpst.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetResponseUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mpst.service.SellerMpStRecmndOrderReceiptService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpStRecmndOrderReceiptController")
public class SellerMpStRecmndOrderReceiptController {
	
	@Autowired
	private SellerMpStRecmndOrderReceiptService sellerMpStRecmndOrderReceiptService;
	
	// 조회
	@RequestMapping(value = "/mpst/getSellerMpStRecmndOrderReceiptList.do", method = RequestMethod.POST)
	public String getSellerMpStRecmndOrderReceiptList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		List<Map<String, String>> _data = sellerMpStRecmndOrderReceiptService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/mpst/sellerMpStRecmndOrderReceiptList";
	}
	
	// IBSheet DoSearch용 JSON 응답 조회 (날짜 파라미터 포함)
		@RequestMapping(value = "/mpst/getSellerMpStRecmndOrderReceiptList_v2.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> getSellerMpStRecmndOrderReceiptList_v2(HttpServletRequest request, @RequestParam Map<String, String> pMap) {		
			
			// 세션에서 회사 코드 가져오기 (JSP에서 전송하지 않고 서버에서 직접 처리)
			SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_com_code", sessionInfo.getComCode());
			}
			
			System.out.println("========== VMI 권고발주접수 Controller v2 (IBSheet DoSearch) ==========");
			System.out.println("st_com_code (from session): " + pMap.get("st_com_code"));
			System.out.println("st_from_date: " + pMap.get("st_from_date"));
			System.out.println("st_to_date: " + pMap.get("st_to_date"));
			System.out.println("전체 파라미터: " + pMap);
			
			// 페이징처리 (DoSearch에서도 필요시 사용)
			pMap = CommonUtil.PagingPrc(pMap);
			
			// 화면 조회
			pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
			
			// 날짜 파라미터 포함된 신규 쿼리로 조회
			List<Map<String, String>> _data = sellerMpStRecmndOrderReceiptService.getListWithDate(pMap);
			
			// IBSheetResponseUtil을 사용하여 표준 DoSearch 응답 생성
			Map<String, Object> result = IBSheetResponseUtil.createSuccessResponse(_data);

			return result;
		}
}
