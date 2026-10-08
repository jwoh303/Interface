package com.koreab2b.mro.search.diquest.catalog;

import com.diquest.ir.common.msg.protocol.Protocol;
import com.diquest.ir.common.msg.protocol.query.SelectSet;

public class SelectPhrase {

	public SelectSet[] get() {
		SelectSet[] _selectSet = new SelectSet[] { 
				new SelectSet("DESCRIPTION_LOC", Protocol.SelectSet.NONE), // 상품명
				new SelectSet("SPECIFICATION", Protocol.SelectSet.NONE), // 규격
				new SelectSet("MAKER_NAME", Protocol.SelectSet.NONE), // 제조사(그룹)
				new SelectSet("BUYER_ITEM_NO", Protocol.SelectSet.NONE), // 상품코드
				new SelectSet("CATEGORY_TEXT", Protocol.SelectSet.NONE), // 카테고리명(그룹)
				new SelectSet("AGENT", Protocol.SelectSet.NONE), // 공급사
				new SelectSet("PRODUCT_CLOSE_FLAG", Protocol.SelectSet.NONE), //
				new SelectSet("BUYER", Protocol.SelectSet.NONE), //
				new SelectSet("CONTRACT_NO", Protocol.SelectSet.NONE), //
				new SelectSet("CONTRACT_SEQ", Protocol.SelectSet.NONE), //
				new SelectSet("COM_CODE", Protocol.SelectSet.NONE), //
				new SelectSet("MAKER_PART_NO", Protocol.SelectSet.NONE), // 제조사모델
				new SelectSet("TARGET_PRICE", Protocol.SelectSet.NONE), // 단가
				new SelectSet("IMGFILE_NAME", Protocol.SelectSet.NONE), //
				new SelectSet("IMGFILE_DIR", Protocol.SelectSet.NONE), //
				new SelectSet("OVER_SHORT_FLAG", Protocol.SelectSet.NONE), //
				new SelectSet("HS_NO", Protocol.SelectSet.NONE), //
				new SelectSet("ORIGIN_NAME", Protocol.SelectSet.NONE), // 원산지
				new SelectSet("UNIT_MEASURE", Protocol.SelectSet.NONE) // 단위
				// 추가
	            , new SelectSet("UNIT_MEASURE", Protocol.SelectSet.NONE) 			//단위
	            , new SelectSet("CATEGORY_NO", Protocol.SelectSet.NONE) 	
	            , new SelectSet("TARGET_PRICE_2", Protocol.SelectSet.NONE)
	            , new SelectSet("STDCATLG_ID", Protocol.SelectSet.NONE) 	
	            , new SelectSet("STDCATEG_ID", Protocol.SelectSet.NONE) 	
	            , new SelectSet("AGENT_2", Protocol.SelectSet.NONE) 			
	            , new SelectSet("AGENT_NAME", Protocol.SelectSet.NONE)
				, new SelectSet("ITEM_NO", Protocol.SelectSet.NONE) //재고코드
				, new SelectSet("STND_FLAG", Protocol.SelectSet.NONE) //표쥰카탈로그여부
				, new SelectSet("DESCRIPTION_ENG", Protocol.SelectSet.NONE) //영문 상품명
				, new SelectSet("SPECIFICATION_ENG", Protocol.SelectSet.NONE) //영문 규격
				, new SelectSet("LAST_PO_DATE", Protocol.SelectSet.NONE) //최근 발주일
				, new SelectSet("PUR_UNIT_QTY", Protocol.SelectSet.NONE) //발주배수
				, new SelectSet("MIN_ORDER_QTY", Protocol.SelectSet.NONE) //MOQ
				, new SelectSet("BUY_GREEN_ITEM_NM", Protocol.SelectSet.NONE) // 녹색구매제품
		};
		
		return _selectSet;
	}
}
