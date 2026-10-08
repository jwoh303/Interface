package com.koreab2b.mro.common.mpiv.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.SellerMpIvProcessTypeChangePopDao;

@Service("sellerMpIvProcessTypeChangePopService")
public class SellerMpIvProcessTypeChangePopServiceImpl implements SellerMpIvProcessTypeChangePopService {
	
	@Autowired
	private SellerMpIvProcessTypeChangePopDao sellerMpIvProcessTypeChangePopDao;

	// 거래유형 변경 요청
	public String saveSellerMpIvProcessTypeChangeReq(Map<String,String> formData){
		return sellerMpIvProcessTypeChangePopDao.saveSellerMpIvProcessTypeChangeReq(formData);
	}

}
