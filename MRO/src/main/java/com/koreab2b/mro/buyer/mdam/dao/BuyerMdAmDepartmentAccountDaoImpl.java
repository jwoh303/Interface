package com.koreab2b.mro.buyer.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerMdAmDepartmentAccountDao")
@Transactional
public class BuyerMdAmDepartmentAccountDaoImpl implements BuyerMdAmDepartmentAccountDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmDepartmentAccountDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmDepartmentAccountList", formData);
	}
	public List<Map<String,String>> getBuyerMdAmDepartmentAccountList_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.getBuyerMdAmDepartmentAccountList_v2", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "선택한 계정을 저장하였습니다.";
		
		try{
			sqlSessionTemplate.update("buyer.mdam.deleteBuyerMdAmDepartmentAccount", formData);
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmDepartmentAccount",formData);
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("계정 저장에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}
	@SuppressWarnings("unchecked")
	public String saveBuyerMdAmBudgetDepartmentAccountListPop_v2(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "저장하였습니다.";
		
		try{
			//DTOA 전부 delete
			sqlSessionTemplate.update("buyer.mdam.delBuyerMdAmBudgetDepartmentAccountListPop_v2", formData);
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				//DTOA insert
				if(formData.get("GUBUN").equals("Y:1|N:0")){
					formData.put("GUBUN", "Y");
				}else{
					formData.put("GUBUN", "N");
				}
				sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetDepartmentAccountListPop_v2",formData);
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("계정 저장에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String delBuyerMdAmBudgetDepartmentAccountList_v2(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "삭제하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//DTOA 삭제
				int chk = sqlSessionTemplate.update("buyer.mdam.delBuyerMdAmBudgetDepartmentAccountList_v2", formData);
				
				if(chk == 0 ){
					throw new RuntimeException("삭제에 실패하였습니다.");
				}
			}
		}catch(Exception e){
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error("SQL ERROR : ", e);
			_rtnMsg = e.getMessage();
			return _rtnMsg;	
		}
		
		return _rtnMsg;		
	}
}
