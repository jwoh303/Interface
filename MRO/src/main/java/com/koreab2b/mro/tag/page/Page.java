package com.koreab2b.mro.tag.page;

import java.io.Writer;

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;

public class Page extends SimpleTagSupport {
	
	protected String uri;
	protected String params;
	protected int displaySize = 30;
	protected int currPage = 1;
	protected int linkSize = 10;

	protected Writer getWriter() {
		JspWriter _out = getJspContext().getOut();
		return _out;
	}
	
	public void setUri(String pUri) {
		uri = pUri;
	}

	public void setDisplaySize(int pDisplaySize) {
		displaySize = pDisplaySize;
	}

	public void setParams(String pParams) {
		params = pParams;
	}

	public void setCurrPage(int pCurrPage) {
		currPage = pCurrPage;
	}

	public void setLinkSize(int pLinkSize) {
		linkSize = pLinkSize;
	}

}
