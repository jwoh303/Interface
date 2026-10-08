package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMpSoYuHanKimChonPopDao")
@Transactional
public class BuyerMpSoYuHanKimChonPopDaoImpl implements BuyerMpSoYuHanKimChonPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
 
	
	public List<Map<String,String>> selectLegacyUserIdList(Map<String,String> formData){
		return sqlSessionTemplate.selectList("common.mpso.selectLegacyUserIdList", formData);
	}
	public List<Map<String,String>> selectRefHdInfoList(Map<String,String> formData){
		return sqlSessionTemplate.selectList("common.mpso.selectRefHdInfoList", formData);
	}
	
 
	public String  selectUserNameLoc(Map<String,String>  formData){
		return sqlSessionTemplate.selectOne("common.mpso.selectUserNameLoc", formData);
	}
	public String  selectUserAddressLoc(Map<String,String>  formData){
		return sqlSessionTemplate.selectOne("common.mpso.selectUserAddressLoc", formData);
	}
	public String  selectCenterCode(Map<String,String>  formData){
		return sqlSessionTemplate.selectOne("common.mpso.selectCenterCode", formData);
	}
	public String  selectprofitSegmentCode(Map<String,String>  formData){
		return sqlSessionTemplate.selectOne("common.mpso.selectprofitSegmentCode", formData);
	}
	
	public String  saveBuyerYuhanRetUpdate(Map<String,String>  formData){
		sqlSessionTemplate.update("common.mpso.saveBuyerYuhanRetUpdate", formData);
		String st_zip_change = formData.get("st_zip_change");
		if("Y".equals(st_zip_change)){
			sqlSessionTemplate.update("common.mpso.saveUserAddressUpdate", formData);			
		}
		return"";
	}
}
