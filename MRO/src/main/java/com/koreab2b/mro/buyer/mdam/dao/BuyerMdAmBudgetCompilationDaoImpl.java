package com.koreab2b.mro.buyer.mdam.dao;

import java.util.Calendar;
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

@Repository("buyerMdAmBudgetCompilationDao")
@Transactional
public class BuyerMdAmBudgetCompilationDaoImpl implements BuyerMdAmBudgetCompilationDao {
	private static final Logger LOGGER  = LoggerFactory.getLogger(BuyerMdAmBudgetCompilationDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmBudgetCompilationList", formData);
	}
	public List<Map<String,String>> getBuyerMdAmBudgetCompilationList_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.getBuyerMdAmBudgetCompilationList_v2", formData);
	}
	
	// 예산 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		String _rtnMsg = "선택한 예산 목록을 저장하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				String flag = formData.get("db_flag");
				if("INSERT".equals(flag)){
					sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetCompilation", formData);
				}else{
					sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmBudgetCompilation", formData);
					
					// 예산이력 추가 2019.11.01 HSJ
					formData.put("SAVE_FLAG", "SAVE");
					sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHist", formData);
				}
			}
		}catch(Exception e){
			LOGGER .error("SQL ERROR : ", e);
			throw new RuntimeException("예산 목록 저장에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveBuyerMdAmBudgetCompilationList_v2(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "저장하였습니다.";
		
		try{
			Calendar cal = Calendar.getInstance();
			Calendar today = Calendar.getInstance();
	        int toYear = today.get(Calendar.YEAR);
	        int toMonth = today.get(Calendar.MONTH) + 1;
	        
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("SAVE_FLAG", "SAVE");
				
				//TERM 만들어주기
				String sYear = formData.get("st_year");
				int iYear = Integer.valueOf(sYear);
				int lastDay = 0;
				String termType = formData.get("TERM_TYPE");
				
				int endIdx = getEditableRange(termType, iYear, toYear, toMonth);
				
				if(formData.get("TERM_TYPE").equals("Y")){
					
					// 이미 지난 년도는 수정x
	                if(endIdx == 0){
	                    continue;
	                }
	                
					formData.put("TERM", sYear);
					formData.put("FROM_DATE", sYear+"0101");
					formData.put("TO_DATE", sYear+"1231");
					formData.put("PLAN_AMT", formData.get("MONTH_01_PLAN_AMT"));
					formData.put("ORG_PLAN_AMT", formData.get("MONTH_01_ORG_PLAN_AMT"));
					formData.put("REMARK", formData.get("MONTH_01_REMARK"));
					sqlSessionTemplate.update("buyer.mdam.mergeBuyerMdAmBudgetCompilation_v2", formData);
					sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHist_v2", formData);
				}else if(formData.get("TERM_TYPE").equals("H")){
					for(int j = 1;j<=2; j++){
						 if(j < endIdx){ // 이미 지난 반기는 수정x
		                        continue;
		                    }
						 
						if(j == 1){
							formData.put("TERM", sYear+"H1");
							formData.put("FROM_DATE", sYear+"0101");
							formData.put("TO_DATE", sYear+"0630");
						}else{
							formData.put("TERM", sYear+"H2");
							formData.put("FROM_DATE", sYear+"0701");
							formData.put("TO_DATE", sYear+"1231");
						}
//						if(!formData.get("MONTH_0"+j+"_PLAN_AMT").equals("0")){
							formData.put("PLAN_AMT", formData.get("MONTH_0"+j+"_PLAN_AMT"));
							formData.put("ORG_PLAN_AMT", formData.get("MONTH_0"+j+"_ORG_PLAN_AMT"));
							formData.put("REMARK", formData.get("MONTH_0"+j+"_REMARK"));
							sqlSessionTemplate.update("buyer.mdam.mergeBuyerMdAmBudgetCompilation_v2", formData);
							sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHist_v2", formData);
//						}
					}
				}else if(formData.get("TERM_TYPE").equals("Q")){
					for(int j = 1;j<=4; j++){
						if(j < endIdx){ // 이미 지난 분기는 수정x
	                        continue;
	                    }
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
//						if(!formData.get("MONTH_0"+j+"_PLAN_AMT").equals("0")){
							formData.put("PLAN_AMT", formData.get("MONTH_0"+j+"_PLAN_AMT"));
							formData.put("ORG_PLAN_AMT", formData.get("MONTH_0"+j+"_ORG_PLAN_AMT"));
							formData.put("REMARK", formData.get("MONTH_0"+j+"_REMARK"));
							sqlSessionTemplate.update("buyer.mdam.mergeBuyerMdAmBudgetCompilation_v2", formData);
							sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHist_v2", formData);
//						}
					}
					
				}else if(formData.get("TERM_TYPE").equals("M")){
					for(int j = 1; j<=12 ; j++){
						if(j < endIdx){ // 이미 지난 달은 수정x
	                        continue;
	                    }
						
						String index = "";
						if(j < 10){
							index = "0"+j;
						}else{
							index = ""+j;
						}
						
//						if(!formData.get("MONTH_"+index+"_PLAN_AMT").equals("0")){
							formData.put("TERM", sYear+index);
							cal.set(iYear, j-1,1);
							lastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
							formData.put("FROM_DATE", sYear+index+"01");
							formData.put("TO_DATE", sYear+index+lastDay);
							formData.put("PLAN_AMT", formData.get("MONTH_"+index+"_PLAN_AMT"));
							formData.put("ORG_PLAN_AMT", formData.get("MONTH_"+index+"_ORG_PLAN_AMT"));
							formData.put("REMARK", formData.get("MONTH_"+index+"_REMARK"));
							sqlSessionTemplate.update("buyer.mdam.mergeBuyerMdAmBudgetCompilation_v2", formData);
							sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHist_v2", formData);
//						}
					}
				}
			}
		}catch(Exception e){
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			LOGGER .error("SQL ERROR : ", e);
			_rtnMsg = e.getMessage();
			return _rtnMsg;	
		}
		
		return _rtnMsg;		
	}
	private int getEditableRange(String termType, int selYear, int toYear, int toMonth) {
		int maxPeriod = termType.equals("Y") ? 1 : termType.equals("H") ? 2 : termType.equals("Q") ? 4 : 12;
	    int endIndex = 0;

	    if (selYear < toYear) {// 과거년도는 전체 수정x
	        return maxPeriod + 1; 
	    }
	    if (selYear > toYear) {// 미래년도는 전체 수정
	        return 1; 
	    }
	    
	    if (selYear == toYear) {
	        if (termType.equals("Y")) {
	            endIndex = 1;
	        } else if (termType.equals("H")) {
	            endIndex = (toMonth < 7) ? 1 : 2;
	        } else if (termType.equals("Q")) {
	            if (toMonth < 4) {
	                endIndex = 1;
	            } else if (toMonth < 7) {
	                endIndex = 2;
	            } else if (toMonth < 10) {
	                endIndex = 3;
	            } else {
	                endIndex = 4;
	            }
	        } else { // "M"
	            endIndex = toMonth;
	        }
	    }

	    return endIndex;
	}

	// 예산 삭제
	@SuppressWarnings("unchecked")
	public String deleteSelectedData(Map<String,String> formData, List<Object> gridData) {
		String _rtnMsg = "선택한 예산 목록을 삭제하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("buyer.mdam.deleteBuyerMdAmBudgetCompilation", formData);
				
				// 예산이력 추가 2019.11.01 HSJ
				formData.put("SAVE_FLAG", "DEL");
				sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHist", formData);
			}
		}catch(Exception e){
			LOGGER .error("SQL ERROR : ", e);
			throw new RuntimeException("예산 목록 삭제에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String delBuyerMdAmBudgetCompilationList_v2(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "초기화하였습니다.";
		
		try{
			Calendar cal = Calendar.getInstance();
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				//예산이력
				formData.put("SAVE_FLAG", "DEL");
				
				//데이터 가져와서 이력 넣기
				List<Map<String,String>> tmpData = sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmBudgetCompilationListData_v2",formData);
				for(int j = 0 ; j<tmpData.size(); j++){
					tmpData.get(j).put("st_com_code", formData.get("st_com_code"));
					tmpData.get(j).put("st_user_id", formData.get("st_user_id"));
					tmpData.get(j).put("SAVE_FLAG", formData.get("SAVE_FLAG"));
					tmpData.get(j).put("REMARK", "");
					sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetHist_v2", tmpData.get(j));
				}
				//예산삭제
				int chk = sqlSessionTemplate.update("buyer.mdam.delBuyerMdAmBudgetCompilationList_v2", formData);
				if(chk == 0 ){
					throw new RuntimeException("편성초기화에 실패하였습니다.");
				}
			}
		}catch(Exception e){
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			_rtnMsg = e.getMessage();
			return _rtnMsg;	
		}
		
		return _rtnMsg;		
	}
}
