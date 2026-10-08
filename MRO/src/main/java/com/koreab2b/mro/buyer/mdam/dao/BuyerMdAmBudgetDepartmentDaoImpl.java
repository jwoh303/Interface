package com.koreab2b.mro.buyer.mdam.dao;

import java.util.HashMap;
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

@Repository("buyerMdAmBudgetDepartmentDao")
@Transactional
public class BuyerMdAmBudgetDepartmentDaoImpl implements BuyerMdAmBudgetDepartmentDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBudgetDepartmentDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<Map<String,String>> getBuyerMdAmBudgetDepartmentListAll_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.getBuyerMdAmBudgetDepartmentListAll_v2", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmBudgetDepartmentList", formData);
	}
	public List<Map<String,String>> getBuyerMdAmBudgetDepartmentList_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.getBuyerMdAmBudgetDepartmentList_v2", formData);
	}
	
	//삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String delBuyerMdAmBudgetDepartmentList_v2(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "삭제하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				String connCheck = sqlSessionTemplate.selectOne("buyer.mdam.getBuyerMdAmConnBudgetDepartmentCodeCheck_v2",formData);
				if(connCheck.equals("Y")){
					throw new RuntimeException("연결된 예산부서가 있을 경우 삭제가 불가합니다.<br/>KeP담당자를 통해 시스템 문의 바랍니다.");
				}
				
				int chk = 0;
				if(formData.get("TYPE_FLAG").equals("A")){
					chk = sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmBudgetDepartmentList_v2", formData);
				}else if(formData.get("TYPE_FLAG").equals("B")){
					chk = sqlSessionTemplate.update("buyer.mdam.delBuyerMdAmBudgetDepartmentList_v2", formData);
				}
				if(chk == 0){
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
	//저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveBuyerMdAmBudgetDepartmentList_v2(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "저장하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				int chk = 0;
				if(!formData.get("sStatus").equals("U")){
					String dupChk = sqlSessionTemplate.selectOne("buyer.mdam.getBuyerMdAmBudgetDepartmentCodeCheck_v2",formData);
					if(dupChk.equals("Y")){
						throw new RuntimeException("동일한 부서코드가 존재합니다.<br/>부서코드를 예산부서코드로 이용하려면 [부서 불러오기]를 이용해주세요.");
					}
				}
				
				chk = sqlSessionTemplate.update("buyer.mdam.saveBuyerMdAmBudgetDepartmentList_v3", formData);
//				if(formData.get("sStatus").equals("I")){
//					chk = sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetDepartmentList_v2", formData);
//				}else{
//					chk = sqlSessionTemplate.update("buyer.mdam.saveBuyerMdAmBudgetDepartmentList_v2", formData);
//				}
				
				if(chk == 0){
					throw new RuntimeException("저장에 실패하였습니다.");
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
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "선택한 부서를 저장하였습니다.";
		
		try{
			sqlSessionTemplate.update("buyer.mdam.deleteBuyerMdAmBudgetDepartment", formData);
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmBudgetDepartment",formData);
			}

		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("부서 저장에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}
	
	//저장
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveBuyerMdAmDepartmentListPop_v2(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "저장하였습니다.";
		
		try{
			//모든 부서 TYPE_FLAG = 'D' 처리
			int chk = sqlSessionTemplate.update("buyer.mdam.saveBuyerMdAmDepartmentListPopFlagD_v2", formData);
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//예산부서로 옮긴 부서만 TYPE_FLAG = 'A' 처리
				int chk2 = sqlSessionTemplate.update("buyer.mdam.saveBuyerMdAmDepartmentListPopFlagA_v2", formData);
				//해당 부서는 같은 부서코드로 DTOD 연결해주기
				int chk3 = sqlSessionTemplate.update("buyer.mdam.saveBuyerMdAmDTODDepartment_v2", formData);
				if(chk == 0 || chk2 == 0){
					throw new RuntimeException("저장에 실패하였습니다.");
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
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String delBuyerMdAmBudgetDepartmentConList_v2(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "삭제하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//DTOD 삭제
				int chk = sqlSessionTemplate.update("buyer.mdam.delBuyerMdAmBudgetDepartmentConList_v2", formData);
				
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
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveBuyerMdAmBudgetDepartmentListPop_v2(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "저장하였습니다.";
		
		try{
			//모든 부서 DTOD delete
			int chk = sqlSessionTemplate.update("buyer.mdam.delBuyerMdAmBudgetDepartmentListPop_v2", formData);
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//DTOD insert
				int chk2 = sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetDepartmentListPop_v2", formData);
				
				if(chk2 == 0){
					throw new RuntimeException("저장에 실패하였습니다.");
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
