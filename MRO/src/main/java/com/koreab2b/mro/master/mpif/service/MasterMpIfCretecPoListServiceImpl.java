package com.koreab2b.mro.master.mpif.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpif.dao.MasterMpIfCretecPoListDao;

@Service("masterMpIfCretecPoListService")
public class MasterMpIfCretecPoListServiceImpl implements MasterMpIfCretecPoListService {
	@Autowired
	private MasterMpIfCretecPoListDao masterMpIfCretecPoListDao;

	@Override
	public List<Map<String, String>> getList(Map<String, Object> pMap) {
		return masterMpIfCretecPoListDao.selectList(pMap);
	}

	@Override
	public List<Map<String,String>> getMpIfCretecPoListPop(Map<String, Object> pMap) {
		return masterMpIfCretecPoListDao.selectMpIfCretecPoListPop(pMap);
	}

	@Override
	public String submitMpIfCretecPoListPop(Map<String, String> pMap) {
		return masterMpIfCretecPoListDao.submitMpIfCretecPoListPop(pMap);
	}
}
