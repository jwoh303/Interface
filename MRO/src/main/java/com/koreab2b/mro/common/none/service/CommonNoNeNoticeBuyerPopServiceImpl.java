package com.koreab2b.mro.common.none.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.none.dao.CommonNoNeNoticeBuyerPopDao;

@Service("commonNoNeNoticeBuyerPopService")
public class CommonNoNeNoticeBuyerPopServiceImpl implements CommonNoNeNoticeBuyerPopService {
	@Autowired
	private CommonNoNeNoticeBuyerPopDao commonNoNeNoticeBuyerPopDao;

	// 조회
	public List<Map<String,String>> getCommonNoNeNoticeBuyerPop(Map<String,String> formData) {
		return commonNoNeNoticeBuyerPopDao.getCommonNoNeNoticeBuyerPop(formData);
	}
}
