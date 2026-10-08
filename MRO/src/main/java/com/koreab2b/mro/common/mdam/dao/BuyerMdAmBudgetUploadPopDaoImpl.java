package com.koreab2b.mro.common.mdam.dao;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("buyerMdAmBudgetUploadPopDao")
@Transactional
public class BuyerMdAmBudgetUploadPopDaoImpl implements BuyerMdAmBudgetUploadPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMdAmBudgetUploadPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectList(Map<String, Object> formData) {
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		
		sqlSessionTemplate.select("buyer.mdam.selectBuyerMdAmBudgetUploadPopList", formData, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();

	}
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> getBuyerMdAmBudgetUploadPop_v2(Map<String, Object> formData) {
		
		return sqlSessionTemplate.selectList("buyer.mdam.getBuyerMdAmBudgetUploadPop_v2",formData);
	}
	
	
	// 엑셀 업로드
	@SuppressWarnings("unchecked")
	public String uploadSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		sqlSessionTemplate.update("buyer.mdam.delAllbudgetUploadData", formData);
		
		int _count = 0;
		
		_rtnMsg = "정상적으로 업로드 되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));

				formData.put("SEQ", String.valueOf(i+1));
				
				// 엑셀 업로드 결과 KEP_FILE_UPLOAD 삽입
				_count = sqlSessionTemplate.insert("buyer.mdam.insertBudgetUploadExcelUp", formData);
				
				if ( _count != 1 ) {
					throw new RuntimeException("업로드 중 오류가 발생하였습니다.");
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			throw new RuntimeException("업로드 중 오류가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String saveBuyerMdAmExcelUpload_v2(Map<String,String>  formData, List<Object> gridData) {
		
		sqlSessionTemplate.update("buyer.mdam.delAllbudgetUploadData", formData);
		
		int _count = 0;
		
		_rtnMsg = "정상적으로 업로드 되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));

				formData.put("SEQ", String.valueOf(i+1));
				
				// 엑셀 업로드 결과 KEP_FILE_UPLOAD 삽입
				_count = sqlSessionTemplate.insert("buyer.mdam.insertBudgetUploadExcelUp_v2", formData);
				
				if ( _count != 1 ) {
					throw new RuntimeException("업로드 중 오류가 발생하였습니다.");
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			throw new RuntimeException("업로드 중 오류가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
	
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {

		int _count = 0;
		
		_rtnMsg = "정상적으로 저장되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(checkAmt(formData)){
					_rtnMsg ="예산편성금액보다 사용금액이 큽니다. 재조회 후 이용하여 주시기 바랍니다.";
					throw new RuntimeException("예산편성금액보다 사용금액이 큽니다. 재조회 후 이용하여 주시기 바랍니다.");
				}
				
				if("Y".equals(formData.get("EXIST_YN")) ) {
					_count = sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmBudgetUpload", formData);
					
					// 예산이력 추가 2019.11.01 HSJ
					sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHistUpload", formData);
					
					if ( _count != 1 ) {
						throw new RuntimeException("저장 중 오류가 발생하였습니다.");
					}
				}else{
					_count = sqlSessionTemplate.insert("buyer.mdam.insertBuyerMdAmBudgetUpload", formData);
					if ( _count != 1 ) {
						throw new RuntimeException("저장 중 오류가 발생하였습니다.");
					}					
				}
			}
			
			// 완료 후 업로드 데이터 삭제
			sqlSessionTemplate.update("buyer.mdam.delAllbudgetUploadData", formData);
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			throw new RuntimeException("저장 중 오류가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String saveBuyerMdAmBudgetUpload_v2(Map<String,String>  formData, List<Object> gridData) {

		int _count = 0;
		
		_rtnMsg = "정상적으로 저장되었습니다.";
		
		try {
			Calendar cal = Calendar.getInstance();
			
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				
				//TERM 만들어주기
				String sYear = formData.get("st_year");
				int iYear = Integer.valueOf(sYear);
				int lastDay = 0;
				
				
				if(formData.get("st_term_type").equals("Y")){
					formData.put("TERM", sYear);
					formData.put("FROM_DATE", sYear+"0101");
					formData.put("TO_DATE", sYear+"1231");
					formData.put("PLAN_AMT", formData.get("Y_01_PLAN_AMT"));
					formData.put("ORG_PLAN_AMT", formData.get("Y_01_ORG_PLAN_AMT"));
					sqlSessionTemplate.update("buyer.mdam.mergeBuyerMdAmBudgetUpload_v2", formData);
					sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHistUpload_v2", formData);
				}else if(formData.get("st_term_type").equals("H")){
					for(int j = 1;j<=2; j++){
						if(j == 1){
							formData.put("TERM", sYear+"H1");
							formData.put("FROM_DATE", sYear+"0101");
							formData.put("TO_DATE", sYear+"0630");
						}else{
							formData.put("TERM", sYear+"H2");
							formData.put("FROM_DATE", sYear+"0701");
							formData.put("TO_DATE", sYear+"1231");
						}
						if(!formData.get("H_0"+j+"_PLAN_AMT").equals("0")){
							formData.put("PLAN_AMT", formData.get("H_0"+j+"_PLAN_AMT"));
							formData.put("ORG_PLAN_AMT", formData.get("H_0"+j+"_ORG_PLAN_AMT"));
							sqlSessionTemplate.update("buyer.mdam.mergeBuyerMdAmBudgetUpload_v2", formData);
							sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHistUpload_v2", formData);
						}
					}
				}else if(formData.get("st_term_type").equals("Q")){
					for(int j = 1;j<=4; j++){
						if(j == 1){
							formData.put("TERM", sYear+"Q1");
							formData.put("FROM_DATE", sYear+"0101");
							formData.put("TO_DATE", sYear+"0331");
						}else if(j == 2){
							formData.put("TERM", sYear+"Q2");
							formData.put("FROM_DATE", sYear+"0401");
							formData.put("TO_DATE", sYear+"0630");
						}else if(j == 3){
							formData.put("TERM", sYear+"Q3");
							formData.put("FROM_DATE", sYear+"0701");
							formData.put("TO_DATE", sYear+"0930");
						}else{
							formData.put("TERM", sYear+"Q4");
							formData.put("FROM_DATE", sYear+"1001");
							formData.put("TO_DATE", sYear+"1231");
						}
						if(!formData.get("Q_0"+j+"_PLAN_AMT").equals("0")){
							formData.put("PLAN_AMT", formData.get("Q_0"+j+"_PLAN_AMT"));
							formData.put("ORG_PLAN_AMT", formData.get("Q_0"+j+"_ORG_PLAN_AMT"));
							sqlSessionTemplate.update("buyer.mdam.mergeBuyerMdAmBudgetUpload_v2", formData);
							sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHistUpload_v2", formData);
						}
					}
					
				}else if(formData.get("st_term_type").equals("M")){
					for(int j = 1; j<=12 ; j++){
						String index = "";
						if(j < 10){
							index = "0"+j;
						}else{
							index = ""+j;
						}
						
						if(!formData.get("M_"+index+"_PLAN_AMT").equals("0")){
							formData.put("TERM", sYear+index);
							cal.set(iYear, j-1,1);
							lastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
							formData.put("FROM_DATE", sYear+index+"01");
							formData.put("TO_DATE", sYear+index+lastDay);
							formData.put("PLAN_AMT", formData.get("M_"+index+"_PLAN_AMT"));
							formData.put("ORG_PLAN_AMT", formData.get("M_"+index+"_ORG_PLAN_AMT"));
							sqlSessionTemplate.update("buyer.mdam.mergeBuyerMdAmBudgetUpload_v2", formData);
							sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHistUpload_v2", formData);
						}
					}
				}
				
//				if(checkAmt(formData)){
//					_rtnMsg ="예산편성금액보다 사용금액이 큽니다. 재조회 후 이용하여 주시기 바랍니다.";
//					throw new RuntimeException("예산편성금액보다 사용금액이 큽니다. 재조회 후 이용하여 주시기 바랍니다.");
//				}
//				
//				if("Y".equals(formData.get("EXIST_YN")) ) {
//					_count = sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmBudgetUpload", formData);
//					
//					// 예산이력 추가 2019.11.01 HSJ
//					sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHistUpload", formData);
//					
//					if ( _count != 1 ) {
//						throw new RuntimeException("저장 중 오류가 발생하였습니다.");
//					}
//				}else{
//					_count = sqlSessionTemplate.insert("buyer.mdam.insertBuyerMdAmBudgetUpload", formData);
//					if ( _count != 1 ) {
//						throw new RuntimeException("저장 중 오류가 발생하였습니다.");
//					}					
//				}
			}
			
			// 완료 후 업로드 데이터 삭제
			sqlSessionTemplate.update("buyer.mdam.delAllbudgetUploadData", formData);
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if ( e instanceof RuntimeException ) {
			    throw new RuntimeException(e.getMessage());
			}
			throw new RuntimeException("저장 중 오류가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 저장 전 금액 확인
	private boolean checkAmt(Map<String,String>  formData)throws RuntimeException{
		boolean isCompare = false;
		
		List<Map<String,Object>> checkUsedAmt  = sqlSessionTemplate.selectList("buyer.mdam.checkBuyerMdAmBudgetUploadAmt", formData);
		BigDecimal planAmt = new BigDecimal(checkUsedAmt.get(0).get("PLAN_AMT").toString());
		BigDecimal usedAmt = new BigDecimal(checkUsedAmt.get(0).get("USED_AMT").toString());

		if(planAmt.compareTo(usedAmt) ==-1){
			isCompare = true;
		}

		return isCompare;
	}
}
