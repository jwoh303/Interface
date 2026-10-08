package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoHiteJinroSiteConsmTeamPopDao;

@Service("buyerMpSoHiteJinroSiteConsmTeamPopService")
public class BuyerMpSoHiteJinroSiteConsmTeamPopServiceImpl implements BuyerMpSoHiteJinroSiteConsmTeamPopService {
	
	@Autowired
	private BuyerMpSoHiteJinroSiteConsmTeamPopDao buyerMpSoHiteJinroSiteConsmTeamPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpSoHiteJinroSiteConsmTeamPopDao.selectList(formData);
	}	
	

}
