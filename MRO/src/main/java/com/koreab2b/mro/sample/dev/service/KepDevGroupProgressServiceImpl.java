package com.koreab2b.mro.sample.dev.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.sample.dev.dao.KepDevGroupProgressDao;

@Service("kepDevGroupProgressService")
public class KepDevGroupProgressServiceImpl implements KepDevGroupProgressService {
	
	@Autowired
	private KepDevGroupProgressDao kepDevGroupProgressDao;

	public int updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return kepDevGroupProgressDao.updateSelectedData(formData, gridData);
	}	

	
}
