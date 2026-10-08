package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mprq.dao.SellerMpRqQuotaProceStateDao;

@Service("sellerMpRqQuotaProceStateService")
public class SellerMpRqQuotaProceStateServiceImpl implements SellerMpRqQuotaProceStateService {

	@Autowired
	private SellerMpRqQuotaProceStateDao sellerMpRqQuotaProceStateDao;
	
	/*조회*/
	public List<Map<String,String>> getList(Map<String,String>  formData){
		return sellerMpRqQuotaProceStateDao.selectList(formData);
	}
 
	// 저장
	public String saveSellerMpRqQuotaProceState(Map<String,String> pMap) {
		return sellerMpRqQuotaProceStateDao.saveSellerMpRqQuotaProceState(pMap);
	}
}
