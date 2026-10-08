package com.koreab2b.mro.buyer.mppo.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("buyerMpPoOrderReqReceiptDao")
@Transactional
public class BuyerMpPoOrderReqReceiptDaoImpl implements BuyerMpPoOrderReqReceiptDao { 

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpPoOrderReqRejectDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		//return sqlSessionTemplate.selectList("buyer.mppo.getBuyerPrRecvSql", formData);
		
		
		String pageflag = (String) formData.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("buyer.mppo.getBuyerPrRecvSql", formData, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("buyer.mppo.getBuyerPrRecvSql", formData);
		}
		
		return resultList;
		
	}
	
	// 수량 변경 사유 저장
	@SuppressWarnings("unchecked")
	public String savePrRecvReturnReasonReg(Map<String,String> formData) {
 
		String st_budget_flag = formData.get("st_budget_flag").toString();
		 
		sqlSessionTemplate.update("buyer.mppo.changeRecvQty", formData);
        // 예산적용 여부
		if(st_budget_flag.equals("Y")) { 
			sqlSessionTemplate.update("buyer.mppo.UpdateBdgtTempAmt", formData);
		}
		
		return "OK";
		
	}
	
	// 부서이관
	public String saveDeptTramsfer(Map<String,String>  formData) {

		String[] st_query =  formData.get("st_query").split("\\|");
		String st_purchaserDept = formData.get("st_purchaserDept");
		String st_reqHold = formData.get("st_reqHold");
		
		String[] str0 = null;
		Map<String,String> _data = null;
		for (int i=0; i<st_query.length; i++){
			str0 = st_query[i].split("@@");
			_data = new HashMap<String,String>() ;
			 
			_data.put("BUYER", str0[0]);
			_data.put("PR_NO",  str0[1]);
			_data.put("PR_SEQ",  str0[2]); 
			
			String cnt =  "";			
			if ("REQ".equals(st_reqHold)){ // 발주요청
				cnt = sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRDTCheck", _data);	
				if ("0".equals(cnt)){
					return "DUP"; // 이미 발주 진행된 상태로 리턴후 화면에 메시지 출력한다.....
				}
			}
			// 발주 요청 발주보류
			cnt =  sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRDTCheck2", _data);	
			if ("1".equals(cnt)){
				return "DUP2"; // 이미 반려 진행된 상태로 리턴후 화면에 메시지 출력한다.....
			}
		}
		
		String[] str = null;
		for (int i=0; i<st_query.length; i++){
			str = st_query[i].split("@@");
			_data = new HashMap<String,String>() ;
			
			_data.put("PURCHASER_DEPT", st_purchaserDept);
			_data.put("BUYER", str[0]);
			_data.put("PR_NO",  str[1]);
			_data.put("PR_SEQ",  str[2]); 
			
			sqlSessionTemplate.update("buyer.mppo.setTransfer", _data);
		}
		
		
		return "OK";
	}
	
	// 반려
	public String saveSerPrReturn(Map<String,String>  formData) { 
		
		String[] st_query =  formData.get("st_query").split("\\|");
		String st_pr_return_type = formData.get("st_pr_return_type");
		String st_reqHold = formData.get("st_reqHold");
		
		String[] str0 = null;
		Map<String,String> _data = null;
		 
		  
		for (int i=0; i<st_query.length; i++){
			str0 = st_query[i].split("@@");
			_data = new HashMap<String,String>() ;			 
			_data.put("BUYER", str0[0]);
			_data.put("PR_NO",  str0[1]);
			_data.put("PR_SEQ",  str0[2]);  
			
			String cnt =  "";			
			if ("REQ".equals(st_reqHold)){ // 발주요청
				cnt = sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRDTCheck", _data);	
				if ("0".equals(cnt)){
					return "DUP"; // 이미 발주 진행된 상태로 리턴후 화면에 메시지 출력한다.....
				}
			}
			// 발주 요청 발주보류
			cnt =  sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRDTCheck2", _data);	
			if ("1".equals(cnt)){
				return "DUP2"; // 이미 반려 진행된 상태로 리턴후 화면에 메시지 출력한다.....
			}
		}
		 
		
		String[] str = null;
		for (int i=0; i<st_query.length; i++){
			str = st_query[i].split("@@");
			_data = new HashMap<String,String>() ;
			
			_data.put("ST_PR_RETURN_TYPE", st_pr_return_type);
			_data.put("BUYER", str[0]);
			_data.put("PR_NO",  str[1]);
			_data.put("PR_SEQ",  str[2]); 
			_data.put("RETURN_REASON", str[3]);  			
			sqlSessionTemplate.update("buyer.mppo.setPR_Return1", _data);
			
			
			String CHECK = sqlSessionTemplate.selectOne("buyer.mppo.setPR_Return2", _data);
			
			LOGGER.debug("saveSerPrReturn CHECK {} ",CHECK);
			
			if ("Y".equals(CHECK)) {			
				sqlSessionTemplate.update("buyer.mppo.setPR_Return3", _data);
			} 			
			
			
			LOGGER.debug("saveSerPrReturn str[7]) {} ",str[7]);
			
			if ("Y".equals(str[7])) {			// plan_amt_flag
				sqlSessionTemplate.update("buyer.mppo.setPR_Return4", _data);
			} 
			
		}  
		return "OK";
	}	 
	
	// 반려
	public String saveSerPrDetailReturn(Map<String,String>  formData) { 
		
		String[] st_query =  formData.get("st_query").split("\\|");
		String st_pr_return_type = formData.get("st_pr_return_type");
		String st_reqHold = formData.get("st_reqHold");
		
		String[] str0 = null;
		Map<String,String> _data = null;
		 
		  
		for (int i=0; i<st_query.length; i++){
			str0 = st_query[i].split("@@");
			_data = new HashMap<String,String>() ;			 
			_data.put("BUYER", str0[0]);
			_data.put("PR_NO",  str0[1]);
			_data.put("PR_SEQ",  str0[2]);  
			
			String cnt =  "";			
			if ("REQ".equals(st_reqHold)){ // 발주요청
				cnt = sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRDTCheck", _data);	
				if ("0".equals(cnt)){
					return "DUP"; // 이미 발주 진행된 상태로 리턴후 화면에 메시지 출력한다.....
				}
			}
			// 발주 요청 발주보류
			cnt =  sqlSessionTemplate.selectOne("buyer.mppo.selectICOMPRDTCheck2", _data);	
			if ("1".equals(cnt)){
				return "DUP2"; // 이미 반려 진행된 상태로 리턴후 화면에 메시지 출력한다.....
			}
		}
		 
		
		String[] str = null;
		for (int i=0; i<st_query.length; i++){
			str = st_query[i].split("@@");
			_data = new HashMap<String,String>() ;
			
			_data.put("ST_PR_RETURN_TYPE", st_pr_return_type);
			_data.put("BUYER", str[0]);
			_data.put("PR_NO",  str[1]);
			_data.put("PR_SEQ",  str[2]); 
			_data.put("RETURN_REASON", str[3]);  			
			sqlSessionTemplate.update("buyer.mppo.setPR_Return1", _data);
			
			
			String CHECK = sqlSessionTemplate.selectOne("buyer.mppo.setPR_Return2", _data);
			
			LOGGER.debug("saveSerPrReturn CHECK {} ",CHECK);
			
			if ("Y".equals(CHECK)) {			
				sqlSessionTemplate.update("buyer.mppo.setPR_Return3", _data);
			} 			
			
			
			LOGGER.debug("saveSerPrReturn str[7]) {} ",str[7]);
			
			if ("Y".equals(str[7])) {			// plan_amt_flag
				sqlSessionTemplate.update("buyer.mppo.setPR_Return4", _data);
			} 
			
		}  
		return "OK";
	}	 
	//발주보류 - 구매발주 구매사 > 발주 > 발주보류 > 저장버튼
	public String saveSetSavePR(Map<String,String>  formData) { 
		
		String[] st_query =  formData.get("st_query").split("\\|");
		String st_pr_return_type = formData.get("st_pr_return_type");		
		String[] str = null;
		Map<String,String> _data = null;		 
		   
		for (int i=0; i<st_query.length; i++){
			str = st_query[i].split("@@",-1);
			_data = new HashMap<String,String>() ;
			
			_data.put("ST_PR_RETURN_TYPE", st_pr_return_type);
			_data.put("BUYER", str[0]);
			_data.put("PR_NO",  str[1]);
			_data.put("PR_SEQ",  str[2]); 
			_data.put("RECV_QTY",  str[3]); 
			_data.put("RD_DATE",  str[4]); 
			_data.put("RETURN_REASON", str[5]);  			
			sqlSessionTemplate.update("buyer.mppo.setSavePR", _data); 			
		}  
		
		return "OK";
	}	
	//구매발주
	public String saveInsertMergePxPo(Map<String,String>  formData) { 
		return "OK"; // /MRO/src/main/java/com/koreab2b/mro/buyer/mpso/dao/BuyerMpSoOrderInfoDaoImpl.java 사용
	}	
	//발주보류(임시저장)
	public String saveChangeMergePxPo(Map<String,String>  formData) { 
		return "OK";// /MRO/src/main/java/com/koreab2b/mro/buyer/mpso/dao/BuyerMpSoOrderInfoDaoImpl.java 사용
	}	

	public List<Map<String,String>> getBuyerAdminBdgtTempQtyCheck(Map<String,String>  formData)  { 
		return sqlSessionTemplate.selectList("buyer.mppo.getRemainBdgtFlag", formData);	 
	}		
	 
	 
	public List<Map<String,String>> getBuyerAdminBdgtTempOrderCheck(Map<String,String>  formData) { 
				
		
		String[] st_query =  formData.get("st_query").split("\\|"); 
		
		String[] str = null;
		Map<String,String> _data = null;
		List< String > _list = new ArrayList< String >( );
		Map<String,Object> _listData = new HashMap<String,Object>();
		
		for (int i=0; i<st_query.length; i++){
			str = st_query[i].split("@@");
			_data = new HashMap<String,String>() ;
			
			_data.put("RECV_QTY", str[1]);
			_data.put("ACCOUNT_TYPE",  str[2]);
			_data.put("BUDGET_DEPT",  str[3]); 
			_data.put("BUYER", formData.get("buyer").toString());  		
			_data.put("PR_NO", str[4]);  
			_data.put("PR_SEQ", str[0]);  					
			sqlSessionTemplate.update("buyer.mppo.updateGetBdgtAmtCheckFinal", _data);		
		
			_list.add(str[4]);

		}
		
		if(_list.size() > 0){
			_listData.put("st_query_cart_array", _list);
		} 		
		_listData.put("BUYER", formData.get("buyer").toString());  		 
		
		LOGGER.debug("getBuyerAdminBdgtTempOrderCheck _listData {} ",_listData);
		
		return sqlSessionTemplate.selectList("buyer.mppo.getBdgtAmtCheckFinal", _listData);	 
	}
	public List<Map<String,String>> getBuyerAdminBdgtTempOrderDetailCheck(Map<String,String>  formData) { 
				
		
		String[] st_query =  formData.get("st_query").split("\\|"); 
		
		String[] str = null;
		Map<String,String> _data = null;
		List< String > _list = new ArrayList< String >( );
		Map<String,Object> _listData = new HashMap<String,Object>();
		String buyerCode = "";
		String budgetDeptCode = "";
		String AccountTypeCode = "";
		for (int i=0; i<st_query.length; i++){
			str = st_query[i].split("@@");
			_data = new HashMap<String,String>() ;
			
			_data.put("RECV_QTY", str[1]);
			_data.put("ACCOUNT_TYPE",  str[2]);
			_data.put("BUDGET_DEPT",  str[3]); 
			_data.put("BUYER", str[5]);  		
			_data.put("PR_NO", str[4]);  
			_data.put("PR_SEQ", str[0]);  					
			sqlSessionTemplate.update("buyer.mppo.updateGetBdgtAmtDetailCheckFinal", _data);		
			buyerCode +=  str[5]+"@";
			budgetDeptCode += str[3]+"@";
			AccountTypeCode += str[2]+"@";
			_list.add(str[4]);

		}
		List< String > _list2 = new ArrayList< String >( );
		LOGGER.debug("getBuyerAdminBdgtTempOrderDetailCheck _listData {} ",buyerCode);
		_list2 = CommonUtil.getStringArrary(buyerCode,"@");
		_listData.put("st_buyerArr", _list2);
		
		// 구매요청접수 구매발주시 체크된 주문의 부서만 예산 체크
		if(formData.get("st_budget_dept_flg") != null && "true".equals(formData.get("st_budget_dept_flg"))) {
			LOGGER.debug("getBuyerAdminBdgtTempOrderDetailCheck budgetDeptCode {} ",budgetDeptCode);
			List< String > _budgetDeptList = new ArrayList< String >( );
			_budgetDeptList = CommonUtil.getStringArrary(budgetDeptCode,"@");
			_listData.put("st_budgetDeptArr", _budgetDeptList);
			LOGGER.debug("getBuyerAdminBdgtTempOrderDetailCheck AccountTypeCode {} ",AccountTypeCode);
			List< String > _accountTypeList = new ArrayList< String >( );
			_accountTypeList = CommonUtil.getStringArrary(AccountTypeCode,"@");
			_listData.put("st_accountTypeArr", _accountTypeList);
		}
		return sqlSessionTemplate.selectList("buyer.mppo.getBdgtAmtDettailCheckFinal", _listData);	 
	}			 
	
	// 홍대용조회
	public List<Map<String,String>> selectHongikList(Map<String,String> formData) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null; 
		 sqlSessionTemplate.select("buyer.mppo.selectHongikList", formData, _resultHander);
		 resultList = (List<Map<String, String>>)_resultHander.getList();  
		return resultList;
	}
	
	// 구매요청PR기준 조회
	public List<Map<String,String>> selectMpPoOrdePrReqReceiptList(Map<String,String> formData) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null; 
		 sqlSessionTemplate.select("buyer.mppo.selectMpPoOrdePrReqReceiptList", formData, _resultHander);
		 resultList = (List<Map<String, String>>)_resultHander.getList();  
		return resultList;
	}
	
	//관리번호 저장
	public String saveRefPrNo(Map<String,String>  formData) { 
		
		String[] st_query =  formData.get("st_query").split("\\|");
		Map<String,String> _data = null;
		
		String[] str = null;
		for (int i=0; i<st_query.length; i++){
			str = st_query[i].split("@@");
			_data = new HashMap<String,String>() ;
			_data.put("BUYER", str[0]);
			_data.put("PR_NO",  str[1]);
			_data.put("PR_SEQ",  str[2]); 
			_data.put("REF_PR_NO", str[3]);  			
			sqlSessionTemplate.update("buyer.mppo.saveRefPrNo", _data);
		}  
		return "OK";
	}	 
}
