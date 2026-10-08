package com.koreab2b.mro.master.wmpg.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmpg.dao.MasterWmPgPrewarhsngStateDao;

@Service("masterWmPgPrewarhsngStateService")
public class MasterWmPgPrewarhsngStateServiceImpl implements MasterWmPgPrewarhsngStateService {
	
	@Autowired
	private MasterWmPgPrewarhsngStateDao masterWmPgPrewarhsngStateDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterWmPgPrewarhsngStateDao.selectList(param);
	}
	
	// 저장
	@Transactional
	public String deleteMasterWmPgPrewarhsngState(Map<String,String>  formData, List<Object> gridData) {
		return masterWmPgPrewarhsngStateDao.updateMasterWmPgPrewarhsngState(formData, gridData);
	}

}
