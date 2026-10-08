package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfSeqDao;

@Service("masterMpIfSeqService")
public class MasterMpIfSeqServiceImpl implements MasterMpIfSeqService {
	
	@Autowired
	private MasterMpIfSeqDao masterMpIfSeqDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpIfSeqDao.selectList(param);
	}	
}
