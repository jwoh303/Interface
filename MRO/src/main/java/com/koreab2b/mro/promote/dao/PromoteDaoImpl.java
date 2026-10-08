package com.koreab2b.mro.promote.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("promoteDao")
public class PromoteDaoImpl implements PromoteDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	public Map<String,String> getKeyWord(){
		return sqlSessionTemplate.selectOne("promote.getKeyWord");
	};
	
	public List<Map<String,String>> getCatalogItemPlan(){
		return sqlSessionTemplate.selectList("promote.getCatalogItemPlan");
	};
	
	public List<Map<String,String>> getCatalogMainItem(){
		return sqlSessionTemplate.selectList("promote.getCatalogMainItem");
	};
	
	public List<Map<String,String>> getPromoteCatalogList(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("promote.getPromoteCatalogList", formData);
	};
	
	public List<Map<String,String>> getCatalogItemRecommand(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("promote.getCatalogItemRecommand", formData);
	};
	
	public List<Map<String,String>> getCategoryListThis(Map<String,String>  formData){
		return sqlSessionTemplate.selectList("promote.getCategoryListThis", formData);
	};
	
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getPromoteDetailList(Map<String,String>  formData){
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("promote.getItemDetailDisplay", formData, _resultHander);
		
		return (List<Map<String, String>>)_resultHander.getList();
	};
	
	// 견적의뢰
	public String saveItemApproval(Map<String,String>  formData) {
		
		_rtnMsg = "정상적으로 판촉물 견적의뢰 되었습니다.";
		
		try{
			sqlSessionTemplate.insert("promote.saveItemApproval", formData);
			
		} catch (Exception e){
			throw new RuntimeException("판촉물 견적의뢰를 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
		}
		return _rtnMsg;
	}
	
}
