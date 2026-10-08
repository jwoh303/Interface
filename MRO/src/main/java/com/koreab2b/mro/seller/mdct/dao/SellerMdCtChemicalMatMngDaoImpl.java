package com.koreab2b.mro.seller.mdct.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository("sellerMdCtChemicalMatMngDao")
@Transactional
public class SellerMdCtChemicalMatMngDaoImpl implements SellerMdCtChemicalMatMngDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtChemicalMatMngList", param);
	}

	// 리뉴얼 탭1 - MSDS 전체 조회
	public List<Map<String,String>> selectMSDSList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mdct.selectMSDSList", param);
	}

	// 리뉴얼 탭2 - MSDS 제출요청 조회
	public List<Map<String,String>> selectMSDSSubmitRequestList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("seller.mdct.selectMSDSSubmitRequestList", param);
	}

}
