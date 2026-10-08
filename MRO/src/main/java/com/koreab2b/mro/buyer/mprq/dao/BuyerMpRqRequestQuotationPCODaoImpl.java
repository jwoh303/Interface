package com.koreab2b.mro.buyer.mprq.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;

@Repository("buyerMpRqRequestQuotationPCODao")
@Transactional
public class BuyerMpRqRequestQuotationPCODaoImpl implements BuyerMpRqRequestQuotationPCODao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqRequestQuotationImSList", formData);
	}
	
	// 임시저장
	@SuppressWarnings("unchecked")
	public Map<String,String> updateSelectedTempData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "";
		String _qNo = "";
		Integer _qSeq = 1;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		try{
				for(int i=0; i < gridData.size(); i++){
					
				formData.putAll((Map<String, String>)gridData.get(i));		
				if (i == 0){
					if (formData.get("st_save_flag").equals("TEMP")){
						_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "TM");
					}else{
						_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
					}
				}
				formData.put("QUOTATION_NO", _qNo);
				formData.put("QUOTATION_SEQ", _qSeq.toString());
				if (formData.get("st_save_flag").equals("TEMP")){
					formData.put("RECV_FLAG", "TS");
					_rtnMsg = _qNo + " 견적번호로 임시저장되었습니다.";
				} else {
					formData.put("RECV_FLAG", "NW");
					_rtnMsg = _qNo + " 견적번호가 생성되었습니다.";
				}
				sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReqPCO", formData);
				_qSeq++;

			}		
				
		}catch(Exception e){
			_rtnMsg = "견적생성에 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		_pReturnMap.put("MSG", _rtnMsg);
		
		return _pReturnMap;
	}
	// 삭제
	@SuppressWarnings("unchecked")
	public String deleteSelectedTempData(Map<String,String> formData) {

		String _rtnMsg = "정상적으로 삭제 되었습니다.";
		String _query = formData.get("st_query2").toString();
		String  _REQ[] = _query.split("&&");
		try{
			 if (_REQ.length >0){
				 for( int i=0 ; i < _REQ.length; i++){ 
			        String str[] =  _REQ[i].split("@@");    
			       
			        if (str != null ){
			        	 Map<String,String> _data = new HashMap<String,String>() ;
				        
				        _data.put("st_buyer", str[0]);
				        _data.put("st_quotation_no", str[1]);  
				        _data.put("st_quotation_seq", str[2]);
				        _data.put("st_revision", str[3]);
				        sqlSessionTemplate.insert("buyer.mp.rq.deleteQuotationReqPCO", _data);
					 }				         					  
				 }			
			}		
		}catch(Exception e){
			_rtnMsg = "임시저장 삭제에 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		
		return _rtnMsg;
	}
	// 임시저장견적의뢰
	@SuppressWarnings("unchecked")
	public String saveSelectedTempReqData(Map<String,String> formData) {

		String _rtnMsg = "정상적으로 견적 접수 되었습니다.";
		String _query = formData.get("st_query2").toString();
		String _qNo = "";
		Integer _qSeq = 1;
		String  _REQ[] = _query.split("&&");
		try{
			 if (_REQ.length >0){
				 for( int i=0 ; i < _REQ.length; i++){ 
			        String str[] =  _REQ[i].split("@@");    
			       
			        if (str != null ){
			        	 Map<String,String> _data = new HashMap<String,String>() ;
						if (i == 0){
							_qNo = masterMpRqBuyerReqDao.nextVal(str[0], "RE");
						}
						_data.put("QUOTATION_NO", _qNo);
						_data.put("QUOTATION_SEQ", _qSeq.toString());
				        _data.put("st_buyer", str[0]);
				        _data.put("st_quotation_no", str[1]);  
				        _data.put("st_quotation_seq", str[2]);
				        _data.put("st_user_id+", str[3]);
				        _data.put("st_item_qty", str[4]);
				        _data.put("st_specification", str[5]);
				        _data.put("st_btoa_end_date", str[6]);
				        _data.put("st_buyer_item_no", str[7]);
				        _data.put("st_unit_measure", str[8]);
				        _data.put("st_item_gubun_flag", str[9]);
				        _data.put("st_year_qty_text", str[10]);
				        _data.put("st_btoa_remark", str[11]);
				        _data.put("st_green_flag", str[12]);
				        _data.put("st_user_id", str[13]);
				        
				        sqlSessionTemplate.insert("buyer.mp.rq.saveSelectedTempReqData", _data);
				        _qSeq++;
					 }				         					  
				 }			
			}		
		}catch(Exception e){
			_rtnMsg = "견적의뢰 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		
		return _rtnMsg;
	}
	
}
