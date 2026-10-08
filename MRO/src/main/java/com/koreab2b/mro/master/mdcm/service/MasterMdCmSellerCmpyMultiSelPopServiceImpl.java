package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmSellerCmpyMultiSelPopDao;

@Service("masterMdCmSellerCmpyMultiSelPopService")
public class MasterMdCmSellerCmpyMultiSelPopServiceImpl implements MasterMdCmSellerCmpyMultiSelPopService {

	@Autowired
	private MasterMdCmSellerCmpyMultiSelPopDao masterMdCmSellerCmpyMultiSelPopDao;

	// 협력사 목록 조회 - 페이징 없음
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCmSellerCmpyMultiSelPopDao.selectList(formData);
	}

}
