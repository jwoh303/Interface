package com.koreab2b.mro.master.mdpp.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdpp.dao.MasterMdPpPropDao;

@Service("masterMdPpPropService")
public class MasterMdPpPropServiceImpl implements MasterMdPpPropService {
	
	@Autowired
	private MasterMdPpPropDao masterMdPpPropDao;

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData) {
		return masterMdPpPropDao.updateSelectedData(formData);
	}	
}
