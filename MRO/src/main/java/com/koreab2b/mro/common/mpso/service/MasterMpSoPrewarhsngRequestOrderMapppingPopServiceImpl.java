package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoPrewarhsngRequestOrderMapppingPopDao;

@Service("masterMpSoPrewarhsngRequestOrderMapppingPopService")
public class MasterMpSoPrewarhsngRequestOrderMapppingPopServiceImpl implements MasterMpSoPrewarhsngRequestOrderMapppingPopService {
	
	@Autowired
	private MasterMpSoPrewarhsngRequestOrderMapppingPopDao masterMpSoPrewarhsngRequestOrderMapppingPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoPrewarhsngRequestOrderMapppingPopDao.selectList(formData);
	}	
	

}
