package com.koreab2b.mro.manager.user.domain;

import java.io.Serializable;

@SuppressWarnings("serial")
public class Page  implements Serializable{

	private Integer no;
	private Integer currentPage = 1;
	private Integer displaySize = 30;
	private Integer linkSize = 5;
	private Integer totalPage;

	public Integer getNo() {
		return no;
	}

	public void setNo(Integer pNo) {
		no = pNo;
	}

	public Integer getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(Integer pCurrentPage) {
		currentPage = pCurrentPage;
	}

	public Integer getDisplaySize() {
		return displaySize;
	}

	public void setDisplaySize(Integer pDisplaySize) {
		displaySize = pDisplaySize;
	}

	public Integer getLinkSize() {
		return linkSize;
	}

	public void setLinkSize(Integer pLinkSize) {
		linkSize = pLinkSize;
	}

	public Integer getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(Integer pTotalPage) {
		totalPage = pTotalPage;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("no=");
		builder.append(no);
		builder.append("&currentPage=");
		builder.append(currentPage);
		builder.append("&displaySize=");
		builder.append(displaySize);
		builder.append("&linkSize=");
		builder.append(linkSize);
		builder.append("&totalPage=");
		builder.append(totalPage);
		return builder.toString();
	}

	
	
}
