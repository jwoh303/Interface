package com.koreab2b.mro.master.mpso.dao;

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

@Repository("masterMpSoClosingDetailDao")
@Transactional
public class MasterMpSoClosingDetailDaoImpl implements MasterMpSoClosingDetailDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoClosingDetailDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> searchMasterMpSoClosingDetailList(Map<String,Object> param) {
		
		//진행상태코드
		List<String> statusList = CommonUtil.getStringArrary((String) param.get("st_status"), ",");
		param.put("st_status_all", statusList);	
		 
		//고객사
		List<String> st_buyer_codeList = CommonUtil.getStringArrary((String) param.get("st_buyer_code"), "@");
		param.put("st_buyer_codeList", st_buyer_codeList);	
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpso.selectMasterMpSoClosingDetailList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	// 취소
	@SuppressWarnings("unchecked")
	@Transactional
	public String setNewGrDelChange_Item(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "입고취소 완료되었습니다.";
		List<Map<String,String>> list = null;
		Map<String,String> _data = null;
		String processType = "";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				list = sqlSessionTemplate.selectList("master.mpso.setNewGrDelChange_Item1", formData);
				list = CommonUtil.getListNvl(list);
				_data = new HashMap<String,String>() ;
				_data = list.get(0);
				formData.put("PROCESS_TYPE", _data.get("PROCESS_TYPE"));
				formData.put("WAREHOUSE_CODE", _data.get("WAREHOUSE_CODE"));
				processType =  _data.get("PROCESS_TYPE");
				 
				sqlSessionTemplate.update("master.mpso.setNewGrDelChange_Item3", formData);				
				sqlSessionTemplate.update("master.mpso.setNewGrDelChange_Item4", formData);
				
				
				LOGGER.debug("setNewGrDelChange_Item formData  {} " ,formData);
				
				 if("0".equals(processType)){ //  0:직납 1:물류창고 2:TR 3:VMI 4:고객위탁재고
					 sqlSessionTemplate.update("master.mpso.setNewGrDelChange_Item5", formData); // ICOMIVDT
				 }else{
					 sqlSessionTemplate.update("master.mpso.setNewGrDelChange_Item2", formData); // WMSIVDT
				 } 
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("입고취소에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional
	public String setNewPODelete_Item(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "발주삭제 완료되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				

				LOGGER.debug("setNewPODelete_Item formData  {} " ,formData);
				
				sqlSessionTemplate.update("master.mpso.setNewPODelete_Item1", formData);
				sqlSessionTemplate.update("master.mpso.setNewPODelete_Item2", formData);
				sqlSessionTemplate.update("master.mpso.setNewPODelete_Item3", formData);
				sqlSessionTemplate.update("master.mpso.setNewPODelete_Item4", formData);
				sqlSessionTemplate.update("master.mpso.setNewPODelete_Item5", formData);
				
				sqlSessionTemplate.update("master.mpso.setNewPODelete_Item6", formData);
				sqlSessionTemplate.update("master.mpso.setNewPODelete_Item7", formData);
			
				LOGGER.error("setNewPODelete_Item 실행 완료");

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("발주삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
