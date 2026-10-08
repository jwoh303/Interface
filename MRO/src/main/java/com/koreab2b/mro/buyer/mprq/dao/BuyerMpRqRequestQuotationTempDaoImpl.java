package com.koreab2b.mro.buyer.mprq.dao;

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

import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;
import com.koreab2b.mro.util.CommonUtil;

@Repository("buyerMpRqRequestQuotationTempDao")
@Transactional
public class BuyerMpRqRequestQuotationTempDaoImpl implements BuyerMpRqRequestQuotationTempDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqRequestQuotationTempDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	// 조회
	public List<Map<String,String>> selectTempSaveList(Map<String,String> formData) {

		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);
		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) formData.get("st_query"), "@@");
		if (_list.size() > 0) {
			data.put("st_query", _list);
		}
		return sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqTempSaveList", data);
	}
	public List<Map<String,String>> selectTempSaveList_v2(Map<String,String> formData) {

		Map<String, Object> data = new HashMap<String, Object>();
		data.putAll(formData);
		List<String> _list = new ArrayList<String>();
		_list = CommonUtil.getStringArrary((String) formData.get("st_query"), "@@");
		if (_list.size() > 0) {
			data.put("st_query", _list);
		}
		return sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqTempSaveList_v2", data);
	}
	
	// 견적의뢰
	public Map<String,String> requestTempSaveList(Map<String,String>  formData){
		
		String _rtnMsg = "";
		String _gwNo = "N";
		String _passflag = "N";
		String _qNo = "";
		Integer _qSeq = 1;
		String _st_update = formData.get("st_update").toString();
		
		Map<String,String> _data = null;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		try{
			 String  _KEPRQDT[] = _st_update.split("&&",-1); 
			 if(_KEPRQDT == null){
				 LOGGER.debug("_KEPRQDT 미존재 ");
			 }else{
				 LOGGER.debug(" _KEPRQDT.length  " + _KEPRQDT.length );

				 // 법인정보 신규의뢰 결재 여부
				 String passCheck = sqlSessionTemplate.selectOne("buyer.mp.rq.getPassCheck", formData);
					
				 if(passCheck.equals("0")) { // 결재-N
				 } else { // 결재-Y
					// 회사정보 결재필수 여부
					String passFlag = sqlSessionTemplate.selectOne("buyer.mp.rq.getPassFlag", formData);
					if (passFlag.equals("N")){ // 결재 필수 아니면
						_passflag = "C";
					} else { // 결재 필수 일 때
						_passflag = "Y";
					}
				}
				 
				 if (_passflag.equals("N") || _passflag.equals("Y")){
					 _qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
					 _rtnMsg = _qNo;
					 if (_passflag.equals("Y")){
						 _gwNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "NG");
					 }
				 }

				 if (_KEPRQDT.length >0){
					 for( int i=0 ; i < _KEPRQDT.length; i++){ 
				        String str[] =  _KEPRQDT[i].split("@@",-1);  
				        	LOGGER.debug("str.length ==>" + str.length );
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
						
				        if (str != null && str.length == 25){
				        	_data = new HashMap<String,String>();
					        _data.put("st_quotation_no", str[0]);
					        _data.put("st_quotation_seq", str[1]);
					        _data.put("st_revision", str[2]);
					        
					        _data.put("st_buyer_item_no", str[3]);
					        _data.put("st_description", str[4]);
					        _data.put("st_specification", str[5]);
					        _data.put("st_unit_measure", str[6]);
					        _data.put("st_maker_name", str[7]);
					        _data.put("st_origin_code", str[8]);
					        _data.put("st_btoa_end_date", str[9]);
					        _data.put("st_buyer_target_price", str[10]);
					        _data.put("st_item_qty", str[11]);
					        _data.put("st_agent_name", str[12]);
					        _data.put("st_btoa_remark", str[13]);
					        _data.put("st_image_key", str[14]);
					        _data.put("st_req_price_type", str[15]);
					        _data.put("st_category_code", str[16]);
					        _data.put("st_cms_categ_id", str[17]); //표준카테고리 ID
					        _data.put("st_cms_catlg_id", str[18]); //표준카탈로그 코드
					        _data.put("st_req_type", str[19]); //견적의뢰 타입
					        _data.put("st_imgfile_dir", str[20]); //이미지 경로
					        _data.put("st_imgfile_name", str[21]); //이미지 파일
					        _data.put("st_safety_flag", str[22]); //안전인증서 여부
					        _data.put("st_msds_flag", str[23]); //MSDS 여부
					        _data.put("st_pre_gr_flag", str[24]); //선입고

					        _data.put("st_buyer", formData.get("st_buyer"));
					        _data.put("st_user_id", formData.get("st_user_id"));
					        _data.put("st_user_name", formData.get("st_user_name"));
					        _data.put("st_user_dept", formData.get("st_user_dept"));
					        _data.put("st_btoa_user_mail", formData.get("st_btoa_user_mail"));
					        _data.put("st_btoa_user_tel", formData.get("st_btoa_user_tel"));
					        _data.put("st_btoa_user_fax", formData.get("st_btoa_user_fax"));
					        
					        _data.put("QUOTATION_NO", _qNo);
					        _data.put("QUOTATION_SEQ", _qSeq.toString());
					        _data.put("GW_NO", _gwNo);
					        
					        if(passCheck.equals("0")){ // 법인정보 신규의뢰 결재 필요 없으면 NW
					        	_data.put("RECV_FLAG", "NW");	
					        }else{ // 법인정보 신규의뢰 결재 필요하면 TS(결재창에서 결재상신 시 상태 변경됨)
					        	_data.put("RECV_FLAG", "TS");
					        }
					        _qSeq++;
					        
					        // 결재를 바로 받는 경우만 새 견적번호로 생성
					        if (_passflag.equals("N") || _passflag.equals("Y")){
								 if (_passflag.equals("Y") || passCheck.equals("0")){ // 법인정보 신규의뢰 결재 필요 없으면)
									// 새로운 견적번호, 결재번호로 생성
							        sqlSessionTemplate.update("buyer.mp.rq.insertQuotationReqTempSaveList", _data);
								 }
							 }
					        
					        // 기존 건 RECV_FLAG = GD로 변경
					        sqlSessionTemplate.update("buyer.mp.rq.delBuyerMpRqTempSaveList", _data);  
					        
					        //첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
					        _data.put("DOC_NO", str[14]);
					        sqlSessionTemplate.update("common.fileUploadFlagUpdate", _data);
						 }
					 }
				 }
			 }
			  
		}catch(Exception e){
			_rtnMsg = "신규상품 견적의뢰 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		_pReturnMap.put("MSG", _rtnMsg);
		_pReturnMap.put("GW_NO", _gwNo);
		_pReturnMap.put("passflag", _passflag);
		
		return _pReturnMap;
	}
	public Map<String,String> requestTempSaveList_v2(Map<String,String>  formData){
		
		String _rtnMsg = "";
		String _gwNo = "N";
		String _passflag = "N";
		String _qNo = "";
		Integer _qSeq = 1;
		String _st_update = formData.get("st_update").toString();
		
		Map<String,String> _data = null;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		try{
			 String  _KEPRQDT[] = _st_update.split("&&",-1); 
			 if(_KEPRQDT == null){
				 LOGGER.debug("_KEPRQDT 미존재 ");
			 }else{
				 LOGGER.debug(" _KEPRQDT.length  " + _KEPRQDT.length );

				 // 법인정보 신규의뢰 결재 여부
				 String passCheck = sqlSessionTemplate.selectOne("buyer.mp.rq.getPassCheck", formData);
					
				 if(passCheck.equals("0")) { // 결재-N
				 } else { // 결재-Y
					// 회사정보 결재필수 여부
					String passFlag = sqlSessionTemplate.selectOne("buyer.mp.rq.getPassFlag", formData);
					if (passFlag.equals("N")){ // 결재 필수 아니면
						_passflag = "C";
					} else { // 결재 필수 일 때
						_passflag = "Y";
					}
				}
				 
				 if (_passflag.equals("N") || _passflag.equals("Y")){
					 _qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
					 _rtnMsg = _qNo;
					 if (_passflag.equals("Y")){
						 _gwNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "NG");
					 }
				 }

				 if (_KEPRQDT.length >0){
					 for( int i=0 ; i < _KEPRQDT.length; i++){ 
				        String str[] =  _KEPRQDT[i].split("@@",-1);  
				        	LOGGER.debug("str.length ==>" + str.length );
						for( int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
						
				        if (str != null && str.length == 26){
				        	_data = new HashMap<String,String>();
					        _data.put("st_quotation_no", str[0]);
					        _data.put("st_quotation_seq", str[1]);
					        _data.put("st_revision", str[2]);
					        
					        _data.put("st_buyer_item_no", str[3]);
					        _data.put("st_description", str[4]);
					        _data.put("st_specification", str[5]);
					        _data.put("st_unit_measure", str[6]);
					        _data.put("st_maker_name", str[7]);
					        _data.put("st_origin_code", str[8]);
					        _data.put("st_btoa_end_date", str[9]);
					        _data.put("st_buyer_target_price", str[10]);
					        _data.put("st_item_qty", str[11]);
					        _data.put("st_agent_name", str[12]);
					        _data.put("st_btoa_remark", str[13]);
					        _data.put("st_image_key", str[14]);
					        _data.put("st_req_price_type", str[15]);
					        _data.put("st_category_code", str[16]);
					        _data.put("st_cms_categ_id", str[17]); //표준카테고리 ID
					        _data.put("st_cms_catlg_id", str[18]); //표준카탈로그 코드
					        _data.put("st_req_type", str[19]); //견적의뢰 타입
					        _data.put("st_imgfile_dir", str[20]); //이미지 경로
					        _data.put("st_imgfile_name", str[21]); //이미지 파일
					        _data.put("st_safety_flag", str[22]); //안전인증서 여부
					        _data.put("st_msds_flag", str[23]); //MSDS 여부
					        _data.put("st_pre_gr_flag", str[24]); //선입고
					        _data.put("st_maker_part_no", str[25]); //모델번호

					        _data.put("st_buyer", formData.get("st_buyer"));
					        _data.put("st_user_id", formData.get("st_user_id"));
					        _data.put("st_user_name", formData.get("st_user_name"));
					        _data.put("st_user_dept", formData.get("st_user_dept"));
					        _data.put("st_btoa_user_mail", formData.get("st_btoa_user_mail"));
					        _data.put("st_btoa_user_tel", formData.get("st_btoa_user_tel"));
					        _data.put("st_btoa_user_fax", formData.get("st_btoa_user_fax"));
					        
					        _data.put("QUOTATION_NO", _qNo);
					        _data.put("QUOTATION_SEQ", _qSeq.toString());
					        _data.put("GW_NO", _gwNo);
					        
					        if(passCheck.equals("0")){ // 법인정보 신규의뢰 결재 필요 없으면 NW
					        	_data.put("RECV_FLAG", "NW");	
					        }else{ // 법인정보 신규의뢰 결재 필요하면 TS(결재창에서 결재상신 시 상태 변경됨)
					        	_data.put("RECV_FLAG", "TS");
					        }
					        _qSeq++;
					        
					        // 결재를 바로 받는 경우만 새 견적번호로 생성
					        if (_passflag.equals("N") || _passflag.equals("Y")){
								 if (_passflag.equals("Y") || passCheck.equals("0")){ // 법인정보 신규의뢰 결재 필요 없으면)
									// 새로운 견적번호, 결재번호로 생성
							        sqlSessionTemplate.update("buyer.mp.rq.insertQuotationReqTempSaveList_v2", _data);
								 }
							 }
					        
					        // 기존 건 RECV_FLAG = GD로 변경
					        sqlSessionTemplate.update("buyer.mp.rq.delBuyerMpRqTempSaveList", _data);  
					        
					        //첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
					        _data.put("DOC_NO", str[14]);
					        sqlSessionTemplate.update("common.fileUploadFlagUpdate", _data);
						 }
					 }
				 }
			 }
			  
		}catch(Exception e){
			_rtnMsg = "신규상품 견적의뢰 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		_pReturnMap.put("MSG", _rtnMsg);
		_pReturnMap.put("GW_NO", _gwNo);
		_pReturnMap.put("passflag", _passflag);
		
		return _pReturnMap;
	}
	
	// 삭제
	public String deleteTempSaveList(Map<String,String>  formData){
		String _st_update = formData.get("st_update").toString();
		 Map<String,String> _data = null;
		
		try{
			 String  _KEPRQDT[] = _st_update.split("&&",-1); 
			 if(_KEPRQDT == null){
				 LOGGER.debug("_KEPRQDT 미존재");
			 }else{
				 LOGGER.debug("_KEPRQDT.length " + _KEPRQDT.length );
				 if(_KEPRQDT.length >0){
					 for( int i=0 ; i < _KEPRQDT.length; i++){ 
				        String str[] = _KEPRQDT[i].split("@@",-1);  
				        	LOGGER.debug("str.length ==>" + str.length );
						for(int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
						
				        if (str != null && str.length == 3){
				        	_data = new HashMap<String,String>();
					        _data.put("st_quotation_no", str[0]);   
					        _data.put("st_quotation_seq", str[1]);
					        _data.put("st_revision", str[2]);

					        _data.put("st_buyer", formData.get("st_buyer"));
					        
					        sqlSessionTemplate.delete("buyer.mp.rq.deleteBuyerMpRqTempSaveList", _data);  
						 }
					 }
				 }
			 }
			  
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("신규견적 임시저장 삭제 실패하였습니다.");
		}
		return null;
	}

	// 저장
	public Map<String,String> saveTempSaveList(Map<String,String>  formData){
		
		String _rtnMsg = "";
		String _gwNo = "N";
		String _passflag = "N";
		String _st_update = formData.get("st_update").toString();
		
		Map<String,String> _data = null;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		try{
			 String  _KEPRQDT[] = _st_update.split("&&",-1); 
			 if(_KEPRQDT == null){
				 LOGGER.debug("_KEPRQDT 미존재");
			 }else{
				 LOGGER.debug("_KEPRQDT.length " + _KEPRQDT.length );
				 if(_KEPRQDT.length >0){
					 for(int i=0 ; i < _KEPRQDT.length; i++){ 
				        String str[] = _KEPRQDT[i].split("@@",-1);  
				        	LOGGER.debug("str.length ==>" + str.length );
						for(int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
						
				        if(str != null && str.length == 19){
				        	_data = new HashMap<String,String>();
					        _data.put("st_quotation_no", str[0]);
					        _data.put("st_quotation_seq", str[1]);
					        _data.put("st_revision", str[2]);
					        
					        _data.put("st_buyer_item_no", str[3]);
					        _data.put("st_description", str[4]);
					        _data.put("st_specification", str[5]);
					        _data.put("st_unit_measure", str[6]);
					        _data.put("st_maker_name", str[7]);
					        _data.put("st_origin_code", str[8]);
					        _data.put("st_btoa_end_date", str[9]);
					        _data.put("st_buyer_target_price", str[10]);
					        _data.put("st_item_qty", str[11]);
					        _data.put("st_agent_name", str[12]);
					        _data.put("st_btoa_remark", str[13]);
					        _data.put("st_image_key", str[14]);
					        _data.put("st_req_price_type", str[15]);
					        _data.put("st_category_code", str[16]);
					        _data.put("st_msds_flag", str[17]);
					        _data.put("st_pre_gr_flag", str[18]);

					        _data.put("st_buyer", formData.get("st_buyer"));
					        _data.put("st_user_id", formData.get("st_user_id"));
					        _data.put("st_user_name", formData.get("st_user_name"));
					        _data.put("st_user_dept", formData.get("st_user_dept"));
					        _data.put("st_btoa_user_mail", formData.get("st_btoa_user_mail"));
					        _data.put("st_btoa_user_tel", formData.get("st_btoa_user_tel"));
					        _data.put("st_btoa_user_fax", formData.get("st_btoa_user_fax"));
					        
					        sqlSessionTemplate.update("buyer.mp.rq.saveBuyerMpRqTempSaveList", _data);  
						 }
					 }
				 }
			 }
			  
		}catch(Exception e){
			_rtnMsg = "신규견적 임시저장 저장 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		_pReturnMap.put("MSG", _rtnMsg);
		_pReturnMap.put("GW_NO", _gwNo);
		_pReturnMap.put("passflag", _passflag);
		
		return _pReturnMap;
	}
	public Map<String,String> saveTempSaveList_v2(Map<String,String>  formData){
		
		String _rtnMsg = "";
		String _gwNo = "N";
		String _passflag = "N";
		String _st_update = formData.get("st_update").toString();
		
		Map<String,String> _data = null;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		try{
			 String  _KEPRQDT[] = _st_update.split("&&",-1); 
			 if(_KEPRQDT == null){
				 LOGGER.debug("_KEPRQDT 미존재");
			 }else{
				 LOGGER.debug("_KEPRQDT.length " + _KEPRQDT.length );
				 if(_KEPRQDT.length >0){
					 for(int i=0 ; i < _KEPRQDT.length; i++){ 
				        String str[] = _KEPRQDT[i].split("@@",-1);  
				        	LOGGER.debug("str.length ==>" + str.length );
						for(int k=0; k < str.length; k++){
							LOGGER.debug("str["+k+"]==>" + str[k] );
	                    } 
						
				        if(str != null && str.length == 20){
				        	_data = new HashMap<String,String>();
					        _data.put("st_quotation_no", str[0]);
					        _data.put("st_quotation_seq", str[1]);
					        _data.put("st_revision", str[2]);
					        
					        _data.put("st_buyer_item_no", str[3]);
					        _data.put("st_description", str[4]);
					        _data.put("st_specification", str[5]);
					        _data.put("st_unit_measure", str[6]);
					        _data.put("st_maker_name", str[7]);
					        _data.put("st_origin_code", str[8]);
					        _data.put("st_btoa_end_date", str[9]);
					        _data.put("st_buyer_target_price", str[10]);
					        _data.put("st_item_qty", str[11]);
					        _data.put("st_agent_name", str[12]);
					        _data.put("st_btoa_remark", str[13]);
					        _data.put("st_image_key", str[14]);
					        _data.put("st_req_price_type", str[15]);
					        _data.put("st_category_code", str[16]);
					        _data.put("st_msds_flag", str[17]);
					        _data.put("st_pre_gr_flag", str[18]);
					        _data.put("st_maker_part_no", str[19]);

					        _data.put("st_buyer", formData.get("st_buyer"));
					        _data.put("st_user_id", formData.get("st_user_id"));
					        _data.put("st_user_name", formData.get("st_user_name"));
					        _data.put("st_user_dept", formData.get("st_user_dept"));
					        _data.put("st_btoa_user_mail", formData.get("st_btoa_user_mail"));
					        _data.put("st_btoa_user_tel", formData.get("st_btoa_user_tel"));
					        _data.put("st_btoa_user_fax", formData.get("st_btoa_user_fax"));
					        
					        sqlSessionTemplate.update("buyer.mp.rq.saveBuyerMpRqTempSaveList_v2", _data);  
						 }
					 }
				 }
			 }
			  
		}catch(Exception e){
			_rtnMsg = "신규견적 임시저장 저장 실패하였습니다.";
			throw new RuntimeException(_rtnMsg);
		}
		
		_pReturnMap.put("MSG", _rtnMsg);
		_pReturnMap.put("GW_NO", _gwNo);
		_pReturnMap.put("passflag", _passflag);
		
		return _pReturnMap;
	}
	
	// 견적의뢰 결재 상신 후 KEPRQDT.RECV_FLAG = NG 로 변경
	public String setRqdtRecvFlagToNg(Map<String,String>  formData){
		try{
			sqlSessionTemplate.update("buyer.mp.rq.setRqdtRecvFlagToNg", formData);
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("신규견적 상태변경 실패하였습니다.");
		}
		return null;
	}
}
