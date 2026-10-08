package com.koreab2b.mro.buyer.mprq.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;

import com.koreab2b.mro.buyer.mprq.controller.BuyerMpRqQuotaProceStateController;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("buyerMpRqQuotaProceStateDao")
@Transactional
public class BuyerMpRqQuotaProceStateDaoImpl implements BuyerMpRqQuotaProceStateDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqQuotaProceStateController.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		
		String pageflag = (String) formData.get("paging");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			if(formData.get("st_buyer").equals("KRCELL0008") || formData.get("st_buyer").equals("KRCELL0009") || formData.get("st_buyer").equals("KRCELL0010")){
				sqlSessionTemplate.select("buyer.mp.rq.selectBuyerMpRqQuotaProceStateNegoList", formData, _resultHander);				
			}else{
				sqlSessionTemplate.select("buyer.mp.rq.selectBuyerMpRqQuotaProceStateList", formData, _resultHander);	
			}
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			if(formData.get("st_buyer").equals("KRCELL0008") || formData.get("st_buyer").equals("KRCELL0009") || formData.get("st_buyer").equals("KRCELL0010")){
				resultList =  sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqQuotaProceStateNegoList", formData);				
			}else{
				resultList =  sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqQuotaProceStateList", formData);	
			}
		}
		return resultList;
		
	}
	
	// 장바구니 담기
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "장바구니에 저장되었습니다.";
		List<Map<String,String>>_list = null;
		
		try{
			//장바구니 중복 허용
			boolean st_dup_add_flag = CommonUtil.getSpecialCheckReturn(formData.get("st_buyer"),"P06-0000072");
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(st_dup_add_flag == true) {
					sqlSessionTemplate.insert("buyer.mp.rq.insertShpCartCreate", formData);
					sqlSessionTemplate.update("buyer.mp.rq.updateRqDt",formData);					
				}else {
					_list = sqlSessionTemplate.selectList("buyer.mp.rq.getItemCheck",formData);
					
					String check_flag = CommonUtil.getListKeyValue(_list,"DUP_CNT","0");
					if(check_flag.equals("0")){	
						sqlSessionTemplate.insert("buyer.mp.rq.insertShpCartCreate", formData);
						sqlSessionTemplate.update("buyer.mp.rq.updateRqDt",formData);
					}				
				}
	
			}
		}catch(Exception e){
			_rtnMsg = "장바구니 담기에 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
	return _rtnMsg;
		
	}
	
	// 견적삭제
	@SuppressWarnings("unchecked")
	public String deleteSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상적으로 삭제 되었습니다.";
		List<Map<String,String>>_list = null;
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.insert("buyer.mp.rq.deleteRqdtData", formData);
			}
		}catch(Exception e){
			_rtnMsg = "삭제를 하던중 오류가 발생되었습니다. 관리자에게 문의 바랍니다.";
			throw new RuntimeException(_rtnMsg);
		}
	return _rtnMsg;
		
	}
	
	// 엑셀 상세조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectDetailList(Map<String,String> formData) {
		String pageflag = (String) formData.get("paging");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		sqlSessionTemplate.select("buyer.mp.rq.selectBuyerMpRqQuotaProceStateDetailList", formData, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		
		return resultList;
		
	}

	// 전체 조회 _v2
	@Override
	public List<Map<String, String>> selectList_v2(Map<String, Object> pMap) {
		List<Map<String,String>>_list = null;
		try {
			_list = sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqQuotaProceStateList_v2", pMap);
			
		}catch (Exception e){
			throw new RuntimeException(e.getMessage());
		}

		return _list;
	}
	
	// 장바구니 담기_v2
	@SuppressWarnings("unchecked")
	public String updateSelectedData_v2(Map<String,String> pMap) {

		String _rtnMsg = "장바구니에 저장되었습니다.";
		String st_query = pMap.get("st_query");
		String[] queryArr = st_query.split("&&");
		Map<String,String> _pMap = pMap;
		List<Map<String,String>>_list = null;
		String dupItem = "";
		try{
			//장바구니 중복 허용
			boolean st_dup_add_flag = CommonUtil.getSpecialCheckReturn(pMap.get("st_buyer"),"P06-0000072");
			
			for(int i = 0; i < queryArr.length; i++){

				String[] _data = queryArr[i].split("@@");
				_pMap.put("st_quotation_no2",_data[0]);
				_pMap.put("st_quotation_seq2",_data[1]);
				_pMap.put("st_rivision",_data[2]);
				_pMap.put("st_buyer2",_data[3]);
				_pMap.put("st_buyer_item_no",_data[4]);
				_pMap.put("st_contract_no",_data[5]);
				_pMap.put("st_contract_seq",_data[6]);
				_pMap.put("st_agent",_data[7]);
				_pMap.put("st_byit_comorg_code",_data[8]);
				_pMap.put("st_item_qty",_data[9]);
				
				
				if(st_dup_add_flag == true) {
					sqlSessionTemplate.insert("buyer.mp.rq.insertShpCartCreate_v2", _pMap);
					sqlSessionTemplate.update("buyer.mp.rq.updateRqDt",_pMap);					
				}else {
					_list = sqlSessionTemplate.selectList("buyer.mp.rq.getItemCheck",_pMap);
					
					String check_flag = CommonUtil.getListKeyValue(_list,"DUP_CNT","0");
					if(check_flag.equals("0")){	
						sqlSessionTemplate.insert("buyer.mp.rq.insertShpCartCreate_v2", _pMap);
						sqlSessionTemplate.update("buyer.mp.rq.updateRqDt",_pMap);
					}else {
						dupItem += _pMap.get("st_buyer_item_no") + " ";
					}
				}
	
			}
			if(!dupItem.equals("")) {
				_rtnMsg = "품목코드 (" + dupItem +")은 이미 장바구니에 저장된 항목입니다.";
			} 
			
		}catch(Exception e){
			_rtnMsg = "장바구니 담기에 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
	return _rtnMsg;
		
	}

	// 견적요청 조회 _v2
	@Override
	public List<Map<String, String>> selectList_tab2_v2(Map<String, Object> pMap) {
		List<Map<String,String>>_list = null;
		try {
			_list = sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqQuotaProceStateListtab2_v2", pMap);
			
		}catch (Exception e){
			throw new RuntimeException(e.getMessage());
		}

		return _list;
	}
}
