package com.koreab2b.mro.common.coco.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.koreab2b.mro.util.CommonUtil;

@Repository("commonRefPrNoPopupDao")
public class CommonRefPrNoPopupDaoImpl implements CommonRefPrNoPopupDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 
	
	public List<Map<String,String>> buyerRefPrNoPopList_v2(Map<String, Object> formData){
		return sqlSessionTemplate.selectList("commonRefPrNoPopup."+formData.get("codeGubun"), formData);
	}
	public String getCostCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("commonRefPrNoPopup.selectCost", formData);
	}
	
	public String getAccountCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("commonRefPrNoPopup.selectAccount", formData);
	}
	
	public String getPlantCode(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("commonRefPrNoPopup.selectPlant", formData);
	}
	
	public String getDeptName(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("commonRefPrNoPopup.selectDeptName", formData);
	}
	
	public String getAccountName(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("commonRefPrNoPopup.selectAccountName", formData);
	}
	
	public String getCod2Text1(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("commonRefPrNoPopup.getCod2Text1", formData);
	}
	public List<Map<String,String>> getCod2CodeText1(Map<String, String> formData){
		return sqlSessionTemplate.selectList("commonRefPrNoPopup.getCod2CodeText1", formData);
	}
	
	
}
