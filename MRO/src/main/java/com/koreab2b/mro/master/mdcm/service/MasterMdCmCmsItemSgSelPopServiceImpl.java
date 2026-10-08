package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCmsItemSgSelPopDao;

@Service("masterMdCmCmsItemSgSelPopService")
public class MasterMdCmCmsItemSgSelPopServiceImpl implements MasterMdCmCmsItemSgSelPopService {

	@Autowired
	private MasterMdCmCmsItemSgSelPopDao masterMdCmCmsItemSgSelPopDao;

	// 카테고리(KEPSGMG) 목록 조회 - 페이징 없음
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCmCmsItemSgSelPopDao.selectList(formData);
	}

}
