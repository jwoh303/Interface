package com.koreab2b.mro.common.coco.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.service.NoticeService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.DateTimeUtil;

/**
 * 공지사항 Controller
 * 테이블: ICOMBOARD_NOTICE, ICOMBOARD_NOTICE_DT
 */
@Controller("NoticeController")
public class NoticeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(NoticeController.class);

	@Autowired
	private NoticeService noticeService;

	/**
	 * 공지사항 목록 화면 (초기 진입)
	 */
	@RequestMapping(value = "/notice/noticeList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String noticeList(ModelMap pModel, HttpServletRequest request, @RequestParam Map<String, String> pMap) {
		
		// 세션 정보 전달
		boolean hasApprovalAuth = false;
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if (sessionInfo != null) {
			hasApprovalAuth = noticeService.hasApprovalAuth(sessionInfo.getUserId());
		}

		// 페이징 기본값 설정
		pMap.put("paging", "1");
		if (pMap.get("curPage") == null || "".equals(pMap.get("curPage"))) {
			pMap.put("curPage", "1");
		}
		if (pMap.get("onepagerow") == null || "".equals(pMap.get("onepagerow"))) {
			pMap.put("onepagerow", "50");
		}

		// 검색조건 기본값 설정
		if (pMap.get("BTYPE") == null || "".equals(pMap.get("BTYPE"))) {
			pMap.put("BTYPE", "NT");
		}

		// 날짜 기본값 설정 (1년 전 ~ 오늘)
		String today = DateTimeUtil.getFormatString("yyyy/MM/dd");
		String oneYearAgo = today;
		try {
			oneYearAgo = DateTimeUtil.addYears(today, -1);
		} catch (Exception e) {
			// 예외 발생 시 오늘 날짜 사용
		}

		if (pMap.get("startDate") == null || "".equals(pMap.get("startDate"))) {
			pMap.put("startDate", oneYearAgo);
		}
		if (pMap.get("endDate") == null || "".equals(pMap.get("endDate"))) {
			pMap.put("endDate", today);
		}

		// 기간유형 기본값 (POST: 게시기간)
		if (pMap.get("dateType") == null || "".equals(pMap.get("dateType"))) {
			pMap.put("dateType", "POST");
		}
		
		// 승인상태 기본값
		if (pMap.get("approvalStatus") == null || "".equals(pMap.get("approvalStatus"))) {
			pMap.put("approvalStatus", hasApprovalAuth ? "N" : "ALL");
		}

		pMap = CommonUtil.PagingPrc(pMap);
		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");

		List<Map<String, String>> _data = noticeService.noticeList(pMap);
		
		pModel.addAttribute("hasApprovalAuth", hasApprovalAuth);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);

		return "common/board/boardList_new";
	}

	/**
	 * 공지사항 등록 폼
	 */
	@RequestMapping(value = "/notice/noticeWriteForm.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String noticeWriteForm(ModelMap pModel, HttpServletRequest request, @RequestParam Map<String, String> pMap) {

		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

		// 등록 모드 설정
		pModel.addAttribute("mode", "write");
		pModel.addAttribute("BTYPE", CommonUtil.nvl(pMap.get("BTYPE"), "NT"));

		// 세션 정보 전달
		boolean hasApprovalAuth = false;
		if (sessionInfo != null) {
			pModel.addAttribute("REG_USER_ID", sessionInfo.getUserId());
			pModel.addAttribute("REG_USER_NAME", sessionInfo.getUserNameLoc());
			pModel.addAttribute("REG_DEP", sessionInfo.getDepartment());
			pModel.addAttribute("REG_DEP_NAME", sessionInfo.getDepartmentName());
			pModel.addAttribute("COMPANY", sessionInfo.getComCode());
			hasApprovalAuth = noticeService.hasApprovalAuth(sessionInfo.getUserId());
		}

		pModel.addAttribute("hasApprovalAuth", hasApprovalAuth);
		pModel.addAllAttributes(pMap);

		return "common/board/boardWriteForm_new";
	}

	/**
	 * 공지사항 상세/수정 폼
	 */
	@RequestMapping(value = "/notice/noticeDetail.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String noticeDetail(ModelMap pModel, HttpServletRequest request, @RequestParam Map<String, String> pMap) {

		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

		// 상세 정보 조회
		Map<String, String> detail = noticeService.noticeDetail(pMap);

		// 대상 고객사 목록 조회
		List<Map<String, String>> customers = noticeService.noticeDetailCustomers(pMap);

		// 본인 글 여부 체크
		boolean regflag = false;
		if (sessionInfo != null && detail != null) {
			String regUserId = CommonUtil.nvl(detail.get("REG_USER_ID"));
			if (regUserId.equals(sessionInfo.getUserId())) {
				regflag = true;
			}
		}

		// 승인 권한 체크
		boolean hasApprovalAuth = false;
		if (sessionInfo != null) {
			hasApprovalAuth = noticeService.hasApprovalAuth(sessionInfo.getUserId());
		}

		// 수정 모드 설정
		pModel.addAttribute("mode", "edit");
		pModel.addAttribute("detail", detail);
		pModel.addAttribute("customers", customers);
		pModel.addAttribute("regflag", regflag);
		pModel.addAttribute("hasApprovalAuth", hasApprovalAuth);
		pModel.addAllAttributes(pMap);

		return "common/board/boardWriteForm_new";
	}

	/**
	 * 공지사항 등록 처리
	 */
	@RequestMapping(value = "/notice/noticeWrite.do", method = RequestMethod.POST)
	public String noticeWrite(ModelMap pModel, HttpServletRequest request, @RequestParam Map<String, String> pMap) {

		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

		// 세션 정보 설정
		if (sessionInfo != null) {
			pMap.put("REG_USER_ID", sessionInfo.getUserId());
			pMap.put("REG_USER_NAME", sessionInfo.getUserNameLoc());
			pMap.put("REG_DEP", sessionInfo.getDepartment());
			pMap.put("REG_DEP_NAME", sessionInfo.getDepartmentName());
			pMap.put("COMPANY", sessionInfo.getComCode());
		}

		// BTYPE 기본값
		if (pMap.get("BTYPE") == null || "".equals(pMap.get("BTYPE"))) {
			pMap.put("BTYPE", "NT");
		}

		noticeService.noticeWrite(pMap);

		pModel.addAttribute("result", "S");
		pModel.addAttribute("mode", "write");
		pModel.addAllAttributes(pMap);

		return "common/board/boardWriteForm_new";
	}

	/**
	 * 공지사항 수정 처리
	 */
	@RequestMapping(value = "/notice/noticeUpdate.do", method = RequestMethod.POST)
	public String noticeUpdate(ModelMap pModel, HttpServletRequest request, @RequestParam Map<String, String> pMap) {

		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

		// 세션 정보 설정 (수정자)
		if (sessionInfo != null) {
			pMap.put("REG_USER_ID", sessionInfo.getUserId());
			pMap.put("COMPANY", sessionInfo.getComCode());
		}

		noticeService.noticeUpdate(pMap);

		// 수정 후 상세 정보 다시 조회
		Map<String, String> detail = noticeService.noticeDetail(pMap);
		List<Map<String, String>> customers = noticeService.noticeDetailCustomers(pMap);

		// 본인 글 여부 체크
		boolean regflag = false;
		if (sessionInfo != null && detail != null) {
			String regUserId = CommonUtil.nvl(detail.get("REG_USER_ID"));
			if (regUserId.equals(sessionInfo.getUserId())) {
				regflag = true;
			}
		}

		pModel.addAttribute("result", "U");
		pModel.addAttribute("mode", "edit");
		pModel.addAttribute("detail", detail);
		pModel.addAttribute("customers", customers);
		pModel.addAttribute("regflag", regflag);
		pModel.addAllAttributes(pMap);

		return "common/board/boardWriteForm_new";
	}

	/**
	 * 공지사항 삭제 처리
	 */
	@RequestMapping(value = "/notice/noticeDelete.do", method = RequestMethod.POST)
	public String noticeDelete(ModelMap pModel, HttpServletRequest request, @RequestParam Map<String, String> pMap) {
		
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		
		// 세션 정보 설정 (수정자)
		if (sessionInfo != null) {
			pMap.put("USER_ID", sessionInfo.getUserId());
		}

		noticeService.noticeDelete(pMap);

		pModel.addAttribute("result", "D");
		pModel.addAllAttributes(pMap);

		return "common/board/boardWriteForm_new";
	}

	/**
	 * 공지사항 승인/승인취소 (AJAX)
	 */
	@RequestMapping(value = "/notice/noticeConfirm.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> noticeConfirm(ModelMap pModel, HttpServletRequest request, @RequestParam Map<String, String> pMap) {

		Map<String, Object> response = new HashMap<String, Object>();

		// 세션에서 사용자 정보 가져오기
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

		if (sessionInfo == null) {
			response.put("result", "F");
			response.put("msg", "세션이 만료되었습니다. 다시 로그인해주세요.");
			return response;
		}

		// 승인 권한 체크
		if (!noticeService.hasApprovalAuth(sessionInfo.getUserId())) {
			response.put("result", "F");
			response.put("msg", "승인 권한이 없습니다.");
			LOGGER.warn("공지사항 승인 권한 없음 - 사용자: {}, BID: {}", sessionInfo.getUserId(), pMap.get("BID"));
			return response;
		}

		String msg = noticeService.noticeConfirm(pMap);
		response.put("msg", msg);
		response.put("result", "S");

		return response;
	}

}
