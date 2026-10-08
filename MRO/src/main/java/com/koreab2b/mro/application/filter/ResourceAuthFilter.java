package com.koreab2b.mro.application.filter;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.filter.OncePerRequestFilter;

import com.koreab2b.mro.util.CommonUtil;

/**
 * /resources/excel/work/ 하위 파일(고객사 매뉴얼·업로드 양식 등)을 로그인 세션이 있는 사용자만
 * 내려받을 수 있도록 보호하는 필터.
 * *
 *  정책:  세션 속성 {@code sessionInfo} 가 없으면 차단하고,
 *  로그인 이전 공개 페이지(/main/**, 개인정보 팝업, FAQ 등)에서 정당하게 링크되는 공개 파일만
 *  통과시킨다. 공개 파일 목록은 하드코딩하지 않고 특수로직(slg) 공통설정을 DB 에서 조회한다
 *  (BNTSLGDEF/BNTSLGIMP, SLG_ID={@link #SLG_ID}, COM_CODE={@link #COM_CODE}, IMP_NOTE 컬럼의
 *  {@code @@} 구분 문자열). 신규 고객사 매뉴얼은 별도 조치없이 자동으로 보호된다.
 */
public class ResourceAuthFilter extends OncePerRequestFilter {

	/** LoginCheckHandler 와 동일한 세션 인증 키. */
	private static final String SESSION_KEY = "sessionInfo";

	/** 공개 파일 화이트리스트를 담는 특수로직 ID (BNTSLGDEF/BNTSLGIMP). */
	private static final String SLG_ID = "P01-1032-05";

	private static final String COM_CODE = "KRKORE0001";

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {

		// 로그인 사용자는 세션만 확인(공개목록 DB 조회 불필요) → 미인증일 때만 공개파일 화이트리스트 조회
		if (isAuthenticated(request) || isPublicFile(request)) {
			filterChain.doFilter(request, response);
			return;
		}

		// 미인증 접근 차단
		if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
		} else {
			response.sendRedirect(request.getContextPath() + "/main.do");
		}
	}

	private boolean isAuthenticated(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		return session != null && session.getAttribute(SESSION_KEY) != null;
	}

	private boolean isPublicFile(HttpServletRequest request) {
		String uri = request.getRequestURI();
		if (uri == null) {
			return false;
		}
		String fileName = uri.substring(uri.lastIndexOf('/') + 1);
		try {
			fileName = java.net.URLDecoder.decode(fileName, "UTF-8");
		} catch (Exception ignore) {
			// 디코딩 실패 시 원본 그대로 비교
		}
		fileName = fileName.toLowerCase();

		try {
			// 공개 파일 목록을 특수로직(slg) 공통설정 IMP_NOTE 컬럼(@@ 구분)에서 조회
			String data = CommonUtil.getSpecialCheckReturn(COM_CODE, SLG_ID, "IMP_NOTE");
			if (data == null || data.length() == 0) {
				return false;
			}
			String[] files = data.split("@@");
			for (int i = 0; i < files.length; i++) {
				if (fileName.equals(files[i].trim().toLowerCase())) {
					return true;
				}
			}
		} catch (Exception e) {
			// 조회 실패 시 비공개로 간주(로그인 요구) — fail-closed
			logger.warn("공개파일 화이트리스트(DB) 조회 실패 - 인증 요구로 처리", e);
			return false;
		}
		return false;
	}

}
