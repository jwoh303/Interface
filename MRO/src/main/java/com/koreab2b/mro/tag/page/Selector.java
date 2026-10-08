package com.koreab2b.mro.tag.page;

import java.io.IOException;
import java.io.Writer;

import javax.servlet.jsp.JspException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Selector extends Page {

	private static final Logger LOGGER = LoggerFactory.getLogger(Selector.class);

	private String displayRange;

	@Override
	public void doTag() throws JspException {
		Writer _out = getWriter();
		
		try {
			_out.write(constructSelectBox());
			_out.write(constructJavaScript());

		} catch (IOException pE) {
			LOGGER.error("셀렉터 테그 실행중 에러가 발생 했습니다.", pE);
			throw new JspException("Error in Selector tag", pE);
		}
	}

	private String constructSelectBox() {
		StringBuilder _selectBox = new StringBuilder();
		String _selected = "selected='selected'";

		_selectBox.append("<select id=\"itemSize\" onchange=\"JavaScript:fnChange(); return false;\">");

		for (String _tmp : displayRange.split(",")) {
			if (_tmp.equals(String.valueOf(displaySize))) {
				_selectBox.append(" <option value=\"" + _tmp + "\" " + _selected + ">" + _tmp + "건</option>");
			} else {
				_selectBox.append(" <option value=\"" + _tmp + "\">" + _tmp + "건</option>");
			}
		}
		_selectBox.append("</select>");

		return _selectBox.toString();
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
		_javaScript.append("function fnChange() {");
		_javaScript.append("location.href='" + uri + "?currentPage=" + currPage + "&linkSize=" + linkSize
				+ "&displaySize='+document.getElementById('itemSize').options[document.getElementById('itemSize').selectedIndex].value+'" + _params
				+ "';");
		_javaScript.append("}");
		_javaScript.append("</script>");

		return _javaScript.toString();
	}

	public void setDisplayRange(String pDisplayRange) {
		displayRange = pDisplayRange;
	}
}
