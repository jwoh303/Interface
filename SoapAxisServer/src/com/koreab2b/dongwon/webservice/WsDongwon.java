package com.koreab2b.dongwon.webservice;

import com.koreab2b.dongwon.vo.Response;

public interface WsDongwon {

	/**
	 * 동원그룹 발주 인터페이스
	 * @param iMaps
	 * @return
	 */
	public Response savePo(
			String PLANT,
			String LEGACY_PO_NO,
			String LEGACY_PO_SEQ,
			String BUYER_ITEM_NO,
			String DESCRIPTION,
			String SPECIFICATION,
			String UNIT_MEASURE,
			String UNIT_PRICE,
			String ITEM_QTY,
			String ITEM_AMT,
			String ADD_DATE,
			String RD_DATE,
			String DELY_TO_LOCATION_TEXT,
			String LEGACY_PR_NO,
			String REQ_USER_ID,
			String REQ_USER_DEPT_NAME,
			String REQ_USER_NAME,
			String REQ_EMAIL_ADD,
			String REQ_EMAIL_NM
			);
}