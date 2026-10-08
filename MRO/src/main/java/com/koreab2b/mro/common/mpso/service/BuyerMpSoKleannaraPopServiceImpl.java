package com.koreab2b.mro.common.mpso.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.BuyerMpSoKleannaraPopDao;

@Service("buyerMpSoKleannaraPopService")
public class BuyerMpSoKleannaraPopServiceImpl implements BuyerMpSoKleannaraPopService {
	
	@Autowired
	private BuyerMpSoKleannaraPopDao buyerMpSoKleannaraPopDao;

	public String getKleannaraCostCode(Map<String, String> formData) {
		return buyerMpSoKleannaraPopDao.getKleannaraCostCode(formData);
	}
	
	public String getKleannaraAccountCode(Map<String, String> formData) {
		return buyerMpSoKleannaraPopDao.getKleannaraAccountCode(formData);
	}
}
