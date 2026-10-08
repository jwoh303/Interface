package com.koreab2b.mro.seller.mcsc.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mcsc.service.SellerMCSCNoticeService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("SellerMCSCNoticeController")
public class SellerMCSCNoticeController {

	@Autowired
	private SellerMCSCNoticeService sellerMCSCNoticeService;

	// 조회
	@RequestMapping(value = "/mcsc/getSellerMCSCNotice.do", method = RequestMethod.POST)
	public String getSellerMCSCNotice(ModelMap pModel ,@RequestParam Map<String, String> pMap) {

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);

		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		List<Map<String, String>> _data = sellerMCSCNoticeService.getList(pMap);

		pModel.addAttribute("data", _data);

		return "seller/mdam/sellerMdAmDeadlineAdventCntList";
	}

	// JSON 응답 - 공지사항 목록
	// notice_type 파라미터: COMMON(공통), COMPANY(거래사별), 없으면 전체
	@RequestMapping(value = "/mcsc/getSellerMCSCNoticeListJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSellerMCSCNoticeListJson(
			HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 세션 정보 추가
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			pMap.put("st_company", sessionInfo.getComCode());
			pMap.put("st_user_id", sessionInfo.getUserId());  // 읽음 여부 판단용

			// notice_type에 따라 분기 처리
			String noticeType = pMap.get("notice_type");
			List<Map<String, String>> dataList;

			if ("COMMON".equals(noticeType)) {
				// [공통 공지사항] - ALL_CUSTOMER_FLAG = 'Y'
				dataList = sellerMCSCNoticeService.getListCommon(pMap);
			} else if ("COMPANY".equals(noticeType)) {
				// [거래사별 공지사항] - ALL_CUSTOMER_FLAG = 'N'
				dataList = sellerMCSCNoticeService.getListCompany(pMap);
			} else {
				// 기본 - 전체 공지사항 (기존 호환성 유지)
				dataList = sellerMCSCNoticeService.getList(pMap);
			}

			result.put("success", true);
			result.put("data", dataList);
			result.put("totalCount", CommonUtil.nvlObj(dataList, "0"));

		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "조회 중 오류가 발생했습니다: " + e.getMessage());
		}

		return result;
	}

	// JSON 응답 - 공지사항 상세
	@RequestMapping(value = "/mcsc/getSellerMCSCNoticeDetailJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSellerMCSCNoticeDetailJson(@RequestParam Map<String, String> pMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			Map<String, String> detail = sellerMCSCNoticeService.getDetail(pMap);

			result.put("success", true);
			result.put("data", detail);

		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "조회 중 오류가 발생했습니다: " + e.getMessage());
		}

		return result;
	}

	// ========================================
	// 공지사항 읽음 처리 API
	// ========================================

	/**
	 * 공지사항 읽음 처리 (JSON)
	 * - 사용자가 공지사항을 펼쳐볼 때 호출
	 * - 중복 읽음 처리 방지 (Service에서 체크)
	 */
	@RequestMapping(value = "/mcsc/markNoticeAsRead.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> markNoticeAsRead(
			HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// ========== 디버깅 로그 ==========
			System.out.println("========== [markNoticeAsRead] 파라미터 확인 ==========");
			System.out.println("  - JSP에서 받은 bid: " + pMap.get("bid"));
			System.out.println("  - JSP에서 받은 btype: " + pMap.get("btype"));

			// 세션 정보에서 회사 코드, 사용자 ID 추가
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("comCode", sessionInfo.getComCode());
				pMap.put("userId", sessionInfo.getUserId());
				System.out.println("  - 세션에서 추가된 comCode: " + sessionInfo.getComCode());
				System.out.println("  - 세션에서 추가된 userId: " + sessionInfo.getUserId());
			} else {
				System.out.println("  - [경고] sessionInfo가 null입니다!");
			}
			System.out.println("  - 최종 pMap: " + pMap);
			System.out.println("====================================================");

			// 읽음 처리 (Service에서 중복 체크 후 INSERT)
			sellerMCSCNoticeService.markAsRead(pMap);

			result.put("success", true);

		} catch (Exception e) {
			System.out.println("  - [에러] " + e.getMessage());
			e.printStackTrace();
			result.put("success", false);
			result.put("message", "읽음 처리 중 오류가 발생했습니다: " + e.getMessage());
		}

		return result;
	}

	// ========================================
	// 1:1 문의 관련 API
	// ========================================

	/**
	 * 1:1 문의 목록 조회 (JSON)
	 */
	@RequestMapping(value = "/mcsc/getInquiryListJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getInquiryListJson(
			HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 세션 정보에서 회사 코드 추가
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_company", sessionInfo.getComCode());
			}

			// 문의 목록 조회
			List<Map<String, String>> dataList = sellerMCSCNoticeService.getInquiryList(pMap);

			result.put("success", true);
			result.put("data", dataList);
			result.put("totalCount", dataList != null ? dataList.size() : 0);

		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "1:1 문의 목록 조회 중 오류가 발생했습니다: " + e.getMessage());
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 1:1 문의 상세 조회 (JSON) - 문의 + 답변
	 */
	@RequestMapping(value = "/mcsc/getInquiryDetailJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getInquiryDetailJson(
			HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 세션 정보에서 회사 코드 추가
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_company", sessionInfo.getComCode());
			}

			// 문의 상세 조회 (문의 + 답변)
			List<Map<String, String>> dataList = sellerMCSCNoticeService.getInquiryDetail(pMap);

			result.put("success", true);
			result.put("data", dataList);

		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "1:1 문의 상세 조회 중 오류가 발생했습니다: " + e.getMessage());
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 문의유형 코드 조회 (JSON)
	 */
	@RequestMapping(value = "/mcsc/getQtypeCodeListJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getQtypeCodeListJson(@RequestParam Map<String, String> pMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 문의유형 코드 조회
			List<Map<String, String>> dataList = sellerMCSCNoticeService.getQtypeCodeList(pMap);

			result.put("success", true);
			result.put("data", dataList);

		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "문의유형 코드 조회 중 오류가 발생했습니다: " + e.getMessage());
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 1:1 문의 등록 (JSON)
	 */
	@RequestMapping(value = "/mcsc/registerInquiryJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> registerInquiryJson(
			HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 세션 정보에서 사용자 정보 추가
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_company", sessionInfo.getComCode());
				pMap.put("st_user_id", sessionInfo.getUserId());
				pMap.put("st_user_name", sessionInfo.getUserNameLoc());
			}

			// 문의 등록
			int insertCount = sellerMCSCNoticeService.registerInquiry(pMap);

			if (insertCount > 0) {
				result.put("success", true);
				result.put("message", "문의가 성공적으로 등록되었습니다.");
			} else {
				result.put("success", false);
				result.put("message", "문의 등록에 실패했습니다.");
			}

		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "문의 등록 중 오류가 발생했습니다: " + e.getMessage());
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 1:1 문의 취소 (JSON)
	 */
	@RequestMapping(value = "/mcsc/cancelInquiryJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancelInquiryJson(
			HttpServletRequest req,
			@RequestParam Map<String, String> pMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 세션 정보에서 회사 코드 추가
			SessionInfo sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (sessionInfo != null) {
				pMap.put("st_company", sessionInfo.getComCode());
			}

			// 문의 취소
			int updateCount = sellerMCSCNoticeService.cancelInquiry(pMap);

			if (updateCount > 0) {
				result.put("success", true);
				result.put("message", "문의가 취소되었습니다.");
			} else {
				result.put("success", false);
				result.put("message", "문의 취소에 실패했습니다. 이미 답변이 등록되었거나 취소된 문의입니다.");
			}

		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "문의 취소 중 오류가 발생했습니다: " + e.getMessage());
			e.printStackTrace();
		}

		return result;
	}

}
