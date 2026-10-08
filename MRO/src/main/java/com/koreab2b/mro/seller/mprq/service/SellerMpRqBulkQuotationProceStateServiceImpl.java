package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mprq.dao.SellerMpRqBulkQuotationProceStateDao;

@Service("sellerMpRqBulkQuotationProceStateService")
public class SellerMpRqBulkQuotationProceStateServiceImpl implements SellerMpRqBulkQuotationProceStateService {

	@Autowired
	private SellerMpRqBulkQuotationProceStateDao sellerMpRqBulklQuotationProceStateDao;
	
	/*조회*/
	public List<Map<String,String>> getList(Map<String,Object>  formData){
		return sellerMpRqBulklQuotationProceStateDao.selectList(formData);
	}

}
