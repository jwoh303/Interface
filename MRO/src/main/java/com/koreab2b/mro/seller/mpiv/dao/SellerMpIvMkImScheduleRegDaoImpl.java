package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpIvMkImScheduleRegDao")
@Transactional
public class SellerMpIvMkImScheduleRegDaoImpl implements SellerMpIvMkImScheduleRegDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String, String>> selectList(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvMkImScheduleRegList", pMap);
	}

	@Override
	public List<Map<String, String>> selectPopupList(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvMkImScheduleRegDetailPop", pMap);
	}

	@Override
	public int saveMkImScheduleReg(List<Map<String, String>> list) {
		int cnt = 0;
		for (Map<String, String> map : list) {
			cnt += sqlSessionTemplate.insert("seller.mpiv.saveMkImScheduleReg", map);
		}
		return cnt;
	}

	@Override
	public int saveMkImScheduleUpdate(Map<String, String> formData) {
		return sqlSessionTemplate.update("seller.mpiv.saveMkImScheduleReg", formData);
	}

}
