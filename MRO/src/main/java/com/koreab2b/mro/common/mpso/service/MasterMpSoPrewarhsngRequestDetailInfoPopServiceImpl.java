package com.koreab2b.mro.common.mpso.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoPrewarhsngRequestDetailInfoPopDao;

@Service("masterMpSoPrewarhsngRequestDetailInfoPopService")
public class MasterMpSoPrewarhsngRequestDetailInfoPopServiceImpl implements MasterMpSoPrewarhsngRequestDetailInfoPopService {
	
	@Autowired
	private MasterMpSoPrewarhsngRequestDetailInfoPopDao masterMpSoPrewarhsngRequestDetailInfoPopDao;

	// 조회
	public Map<String,String> getDetail(Map<String,Object> formData) {
		return masterMpSoPrewarhsngRequestDetailInfoPopDao.getDetail(formData);
	}	
	

}
