package com.koreab2b.mro.extern.voc.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.extern.voc.dao.ExternVocDao;

@Service("externVocService")
public class ExternVocServiceImpl implements ExternVocService {
	
	@Autowired
	private ExternVocDao externVocDao;

	@Override
	public List<Map<String, String>> getDomainKeywordList() {
		return externVocDao.selectDomainKeywordList();
	}

	@Override
	public String saveExternVoc(Map<String, String> pMap) {
		return externVocDao.insertExternVoc(pMap);
	}

	@Override
	public List<Map<String, String>> getExternVocList(Map<String, String> pMap) {
		return externVocDao.selectExternVocList(pMap);
	}

	@Override
	public int getExternVocCount(Map<String, String> pMap) {
		return externVocDao.selectExternVocCount(pMap);
	}
}
