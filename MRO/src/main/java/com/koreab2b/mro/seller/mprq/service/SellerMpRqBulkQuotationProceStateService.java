package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

public interface SellerMpRqBulkQuotationProceStateService {
	
	/*조회*/
	public List<Map<String,String>> getList(Map<String, Object>  pMap);

}
