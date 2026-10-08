package com.koreab2b.mro.application.filter;

import java.io.CharArrayWriter;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.FilterChain;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

import org.springframework.web.filter.OncePerRequestFilter;

/**
 * HTML 응답을 지나가며 /resources/*.js|css URL 에 파일 수정시각(?v=lastModified) 을 자동 부착한다.
 * 파일이 바뀌면 URL 이 바뀌어 브라우저가 새로 받고(cache-busting), 안 바뀌면 값이 동일해 캐시가 유지된다.
 * text/html 응답만 재작성하며, 다운로드/JSON 등은 원본 스트림으로 그대로 통과시킨다.
 */
public class ResourceVersionFilter extends OncePerRequestFilter {

	// src="/resources/....js" 또는 href="/resources/....css" 형태를 찾는다.
	// group1=src|href, group2='=', group3=따옴표(닫는쪽 \3 로 매칭), group4=경로.
	// 경로 문자셋에 ? # 를 제외해서 이미 쿼리스트링이 붙은 URL 은 대상에서 빠진다(?v= 이중부착 방지).
	// /resources/ 로 시작하는 것만 매칭하므로 외부 CDN·상대경로는 건드리지 않는다.
	private static final Pattern RESOURCE_PATTERN =
		Pattern.compile("(src|href)(\\s*=\\s*)([\"'])(/resources/[^\"'?#]+\\.(?:js|css))\\3",
			Pattern.CASE_INSENSITIVE);

	// 경로별 수정시각을 이 간격(ms) 안에서는 다시 stat 하지 않고 캐시값을 쓴다.
	private static final long RECHECK_INTERVAL_MS = 10000L;

	// 경로 -> {수정시각, 마지막 확인시각}. 요청마다 디스크 stat 하는 것을 막기 위한 캐시.
	private final ConcurrentHashMap<String, long[]> mtimeCache = new ConcurrentHashMap<String, long[]>();

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {

		// 응답을 래퍼로 감싸 실행. 래퍼는 text/html 일 때만 본문을 메모리에 모아두고,
		// 그 외(다운로드/JSON 등)는 원본 스트림으로 바로 흘려보낸다.
		CapturingResponseWrapper wrapper = new CapturingResponseWrapper(response);
		filterChain.doFilter(request, wrapper);

		// 캡처하지 않은 응답은 래퍼가 이미 원본에 그대로 썼으므로 아무것도 하지 않는다.
		if (!wrapper.isCaptured()) {
			return;
		}

		// 모아둔 HTML 에서 정적자원 URL 에 ?v= 를 붙여 실제 응답으로 내보낸다.
		String content = wrapper.getCapturedContent();
		String rewritten = rewrite(content, getServletContext());

		// 앱이 UTF-8 을 강제하지만, 혹시 비어있으면 UTF-8 로 폴백.
		String encoding = response.getCharacterEncoding();
		if (encoding == null || encoding.length() == 0) {
			encoding = "utf-8";
		}
		byte[] bytes = rewritten.getBytes(encoding);
		// ?v= 부착으로 본문 길이가 늘어나므로 최종 바이트 길이로 다시 설정한다.
		if (!response.isCommitted()) {
			response.setContentLength(bytes.length);
		}
		response.getOutputStream().write(bytes);
		response.getOutputStream().flush();
	}

	private String rewrite(String content, ServletContext ctx) {
		if (content == null || content.length() == 0) {
			return content == null ? "" : content;
		}
		Matcher m = RESOURCE_PATTERN.matcher(content);
		StringBuffer sb = new StringBuffer(content.length() + 256);
		while (m.find()) {
			String path = m.group(4);
			long mtime = getMtime(ctx, path);
			String replacement;
			if (mtime > 0L) {
				// src="/resources/js/kep_common.js" -> src="/resources/js/kep_common.js?v=1721534400000"
				replacement = m.group(1) + m.group(2) + m.group(3) + path + "?v=" + mtime + m.group(3);
			} else {
				// 파일을 못 찾으면(실경로 없음 등) 원본을 그대로 둔다.
				replacement = m.group(0);
			}
			// 치환문에 $ \ 가 있어도 그대로 들어가도록 quoteReplacement 로 감싼다.
			m.appendReplacement(sb, Matcher.quoteReplacement(replacement));
		}
		m.appendTail(sb);
		return sb.toString();
	}

	// 정적자원의 실제 파일 수정시각을 구한다(값이 버전으로 쓰인다). 캐시로 stat 빈도를 낮춘다.
	private long getMtime(ServletContext ctx, String path) {
		long now = System.currentTimeMillis();
		long[] entry = mtimeCache.get(path);
		// 최근에 확인한 값이면 다시 stat 하지 않고 캐시값 사용.
		if (entry != null && (now - entry[1]) < RECHECK_INTERVAL_MS) {
			return entry[0];
		}
		long mtime = 0L;
		try {
			String realPath = ctx.getRealPath(path);
			if (realPath != null) {
				File f = new File(realPath);
				if (f.exists()) {
					mtime = f.lastModified();
				}
			}
		} catch (Exception e) {
			mtime = 0L;
		}
		mtimeCache.put(path, new long[] { mtime, now });
		return mtime;
	}

	/**
	 * text/html 응답이 getWriter() 로 쓰일 때만 메모리에 캡처하고, 그 외에는 원본 스트림으로 통과시킨다.
	 */
	private static class CapturingResponseWrapper extends HttpServletResponseWrapper {

		private CharArrayWriter buffer;   // 캡처한 HTML 본문이 쌓이는 메모리 버퍼
		private PrintWriter captureWriter;
		private boolean decided = false;  // 캡처 여부를 이미 판정했는지
		private boolean captured = false; // 이 응답을 메모리에 모으는 중인지

		CapturingResponseWrapper(HttpServletResponse response) {
			super(response);
		}

		private boolean isHtml() {
			String ct = getContentType();
			return ct != null && ct.toLowerCase().indexOf("text/html") >= 0;
		}

		// JSP(Jasper)는 본문을 쓰기 직전에 contentType 을 text/html 로 먼저 설정한 뒤
		// getWriter() 를 호출한다. 그래서 이 시점의 content-type 으로 캡처 여부를 판정할 수 있다.
		@Override
		public PrintWriter getWriter() throws IOException {
			if (!decided) {
				decided = true;
				captured = isHtml();
			}
			if (captured) {
				// 실제 응답 대신 메모리 버퍼로 쓴다(뒤에서 ?v= 부착 후 한 번에 내보냄).
				if (captureWriter == null) {
					buffer = new CharArrayWriter();
					captureWriter = new PrintWriter(buffer);
				}
				return captureWriter;
			}
			return super.getWriter();
		}

		// 바이너리(엑셀/파일 다운로드 등)는 대개 OutputStream 으로 쓴다.
		// 이 경로는 캡처하지 않고 원본으로 통과시켜 바이너리 손상을 막는다.
		@Override
		public javax.servlet.ServletOutputStream getOutputStream() throws IOException {
			if (!decided) {
				decided = true;
				captured = false;
			}
			return super.getOutputStream();
		}

		// 캡처 중일 때 flush 가 실제 응답을 커밋해버리면 나중에 다시 쓸 수 없다.
		// 그래서 캡처 중에는 버퍼만 flush 하고 원본은 커밋하지 않는다.
		@Override
		public void flushBuffer() throws IOException {
			if (captured) {
				if (captureWriter != null) {
					captureWriter.flush();
				}
			} else {
				super.flushBuffer();
			}
		}

		// 에러 처리 등으로 버퍼를 비울 때 캡처 버퍼도 함께 비운다.
		@Override
		public void resetBuffer() {
			if (captured && buffer != null) {
				buffer.reset();
			} else {
				super.resetBuffer();
			}
		}

		boolean isCaptured() {
			return captured;
		}

		String getCapturedContent() {
			if (captureWriter != null) {
				captureWriter.flush();
			}
			return buffer == null ? "" : buffer.toString();
		}
	}
}
