package com.koreab2b.mro.common.mpiv.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpiv.dao.SellerMpIvPrewarhsngOrderRegPopDao;

@Service("sellerMpIvPrewarhsngOrderRegPopService")
public class SellerMpIvPrewarhsngOrderRegPopServiceImpl implements SellerMpIvPrewarhsngOrderRegPopService {
	
	@Autowired
	private SellerMpIvPrewarhsngOrderRegPopDao sellerMpIvPrewarhsngOrderRegPopDao;

	//선입고 요청 등록
	public String saveSellerMpIvPrewarhsngOrderReg(Map<String,String> formData){
		return sellerMpIvPrewarhsngOrderRegPopDao.saveSellerMpIvPrewarhsngOrderReg(formData);
	}

}
