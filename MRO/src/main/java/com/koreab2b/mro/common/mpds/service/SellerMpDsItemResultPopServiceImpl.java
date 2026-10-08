package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.SellerMpDsItemResultPopDao;

@Service("sellerMpDsItemResultPopService")
public class SellerMpDsItemResultPopServiceImpl implements SellerMpDsItemResultPopService {
	
	@Autowired
	private SellerMpDsItemResultPopDao sellerMpDsItemResultPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return sellerMpDsItemResultPopDao.selectList(formData);
	}	
	

}
