package com.koreab2b.mro.tag.page;

import java.io.IOException;
import java.io.Writer;

import javax.servlet.jsp.JspException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Navigator extends Page {

	private static final Logger LOGGER = LoggerFactory.getLogger(Navigator.class);

	private int totalPages;

	@Override
	public void doTag() throws JspException {
		Writer _out = getWriter();

		boolean _lastPage = currPage == totalPages;
		int _pgStart = Math.max(currPage - linkSize / 2, 1);
		int _pgEnd = _pgStart + linkSize;
		if (_pgEnd > totalPages + 1) {
			int _diff = _pgEnd - totalPages;
			_pgStart -= _diff - 1;
			if (_pgStart < 1)
				_pgStart = 1;
			_pgEnd = totalPages + 1;
		}

		try {

			if (currPage > 1) {
				_out.write(constructLink(1, "<img src=\"/resources/images/btn_pageprev.gif\" alt=\"처음으로 이동\" />&nbsp;&nbsp;", "paginatorPrev"));
				_out.write(constructLink(currPage - 1, "<img src=\"/resources/images/btn_pageprev.gif\" alt=\"이전으로 이동\" />&nbsp;&nbsp;",
						"paginatorPrev"));
			}

			for (int i = _pgStart; i < _pgEnd; i++) {
				if (i == currPage) {
					_out.write("<b>" + constructLink(i) + "</b><font style=\"font-size:11\">&nbsp;|&nbsp;</font>");
				} else {
					_out.write(constructLink(i));
					if (i != _pgEnd) {
						_out.write("<font style=\"font-size:11\">&nbsp;|&nbsp;</font>");
					}
				}
			}

			if (totalPages > 0) {
				if (!_lastPage) {
					_out.write(constructLink(currPage + 1, "<img src=\"/resources/images/btn_pagenext.gif\" alt=\"다음으로 이동\" />", "paginatorNext"));
					_out.write(constructLink(totalPages, "<img src=\"/resources/images/btn_pagenext.gif\" alt=\"마지막으로 이동\" />&nbsp;&nbsp;",
							"paginatorNext"));
				}
			}
			_out.write(constructJavaScript());

		} catch (IOException pE) {
			LOGGER.error("네비게이터 테그 실행중 에러가 발생 했습니다.", pE);
			throw new JspException("Error in Navigator tag", pE);
		}
	}

	private String constructLink(int pPage) {
		return constructLink(pPage, String.valueOf(pPage), null);
	}

	/*
	 * pClassName 는 나중에 추가 요망
	 */
	private String constructLink(int pPage, String pText, String pClassName) {
		StringBuilder _link = new StringBuilder("<font style=\"font-size:11\">");
		_link.append("").append("<a href=\"#LINK\"").append("onclick=\"JavaScript:fnPage('" + pPage + "'); return false;\"").append(">")
				.append(pText).append("</a></font>");

		return _link.toString();
	}

	private String constructJavaScript() {
		StringBuilder _params = new StringBuilder();
		if (params.length() > 0) {
			for (String _tmp : params.split(",")) {
				_params.append("&");
				_params.append(_tmp.trim());
			}
		}

		StringBuilder _javaScript = new StringBuilder();
		_javaScript.append("<script type=\"text/javaScript\">");
		_javaScript.append("function fnPage(pPage) {");
		_javaScript.append("location.href='" + uri + "?displaySize=" + displaySize + "&linkSize=" + linkSize + "&currentPage='+pPage+'" + _params
				+ "';");
		_javaScript.append("}");
		_javaScript.append("</script>");

		return _javaScript.toString();
	}

	public void setTotalPages(int pTotalPages) {
		totalPages = pTotalPages;
	}

}
