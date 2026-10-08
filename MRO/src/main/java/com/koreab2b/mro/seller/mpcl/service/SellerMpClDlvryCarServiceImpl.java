package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.seller.mpcl.dao.SellerMpClDlvryCarDao;

@Service("sellerMpClDlvryCarService")
public class SellerMpClDlvryCarServiceImpl implements SellerMpClDlvryCarService {
	
	@Autowired
	private SellerMpClDlvryCarDao sellerMpClDlvryCarDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpClDlvryCarDao.selectList(formData);
	}	

}
