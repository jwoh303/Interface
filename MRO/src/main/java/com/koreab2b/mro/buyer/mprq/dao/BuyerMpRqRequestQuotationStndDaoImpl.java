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
import com.koreab2b.mro.master.mprq.dao.MasterMpRqBuyerReqDao;

@Repository("buyerMpRqRequestQuotationStndDao")
@Transactional
public class BuyerMpRqRequestQuotationStndDaoImpl implements BuyerMpRqRequestQuotationStndDao {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpRqRequestQuotationStndDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	@Autowired
	private MasterMpRqBuyerReqDao masterMpRqBuyerReqDao;
	
	// 견적의뢰(결재N)
	@SuppressWarnings("unchecked")
	public String updateSelectedDataNoPass(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "";
		String _qNo = "";
		Integer _qSeq = 1;
		
		try{
				for(int i=0; i < gridData.size(); i++){
					
					formData.putAll((Map<String, String>)gridData.get(i));		
					if (i == 0){
						_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
						_rtnMsg = _qNo;
					}
					formData.put("QUOTATION_NO", _qNo);
					formData.put("QUOTATION_SEQ", _qSeq.toString());
					formData.put("RECV_FLAG", "NW");
					formData.put("GW_NO", "");

					sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReqStnd", formData);
					_qSeq++;
					
					//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
					formData.put("DOC_NO", formData.get("st_image_key"));
					sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
				}		
				
				if (formData.get("excel_up").equals("Y")){
					sqlSessionTemplate.update("buyer.mprq.setMpRqAddDel", formData);
				}

		}catch(Exception e){
			_rtnMsg = "견적생성에 실패하였습니다.";
			logger.error(_rtnMsg, e);
			throw new RuntimeException(_rtnMsg, e);
		}
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String updateSelectedDataNoPass_v2(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "";
		String _qNo = "";
		Integer _qSeq = 1;
		
		try{
				for(int i=0; i < gridData.size(); i++){
					
					formData.putAll((Map<String, String>)gridData.get(i));		
					if (i == 0){
						_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
						_rtnMsg = _qNo;
					}
					formData.put("QUOTATION_NO", _qNo);
					formData.put("QUOTATION_SEQ", _qSeq.toString());
					formData.put("RECV_FLAG", "NW");
					formData.put("GW_NO", "");

					sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReqStnd_v2", formData);
					_qSeq++;
					
					//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
					formData.put("DOC_NO", formData.get("st_image_key"));
					sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
				}		
				
				if (formData.get("excel_up").equals("Y")){
					sqlSessionTemplate.update("buyer.mprq.setMpRqAddDel", formData);
				}

		}catch(Exception e){
			_rtnMsg = "견적생성에 실패하였습니다.";
			logger.error(_rtnMsg, e);
			throw new RuntimeException(_rtnMsg, e);
		}
		return _rtnMsg;
	}
	// 견적의뢰(결재Y)
	@SuppressWarnings("unchecked")
	public Map<String,String> updateSelectedDataPass(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "";
		String _qNo = "";
		String _gwNo = "";
		Integer _qSeq = 1;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		try{
			for(int i=0; i < gridData.size(); i++){
				
				formData.putAll((Map<String, String>)gridData.get(i));		
				if (i == 0){
					_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
					
					_gwNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "NG");
					
					_rtnMsg = _gwNo;
				}
				formData.put("QUOTATION_NO", _qNo);
				formData.put("QUOTATION_SEQ", _qSeq.toString());
				formData.put("RECV_FLAG", "TS");
				formData.put("GW_NO", _gwNo);
				
				sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReqStnd", formData);
				_qSeq++;
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			}		
			
			if (formData.get("excel_up").equals("Y")){
				sqlSessionTemplate.update("buyer.mprq.setMpRqAddDel", formData);
			}
			
		}catch(Exception e){
			_rtnMsg = "견적생성에 실패하였습니다.";
			logger.error(_rtnMsg, e);
			throw new RuntimeException(_rtnMsg, e);
		}

		_pReturnMap.put("MSG", _rtnMsg);
		_pReturnMap.put("GW_NO", _gwNo);

		return _pReturnMap;
	}
	@SuppressWarnings("unchecked")
	public Map<String,String> updateSelectedDataPass_v2(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "";
		String _qNo = "";
		String _gwNo = "";
		Integer _qSeq = 1;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		try{
			for(int i=0; i < gridData.size(); i++){
				
				formData.putAll((Map<String, String>)gridData.get(i));		
				if (i == 0){
					_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
					
					_gwNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "NG");
					
					_rtnMsg = _gwNo;
				}
				formData.put("QUOTATION_NO", _qNo);
				formData.put("QUOTATION_SEQ", _qSeq.toString());
				formData.put("RECV_FLAG", "TS");
				formData.put("GW_NO", _gwNo);
				
				sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReqStnd_v2", formData);
				_qSeq++;
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			}		
			
			if (formData.get("excel_up").equals("Y")){
				sqlSessionTemplate.update("buyer.mprq.setMpRqAddDel", formData);
			}
			
		}catch(Exception e){
			_rtnMsg = "견적생성에 실패하였습니다.";
			logger.error(_rtnMsg, e);
			throw new RuntimeException(_rtnMsg, e);
		}

		_pReturnMap.put("MSG", _rtnMsg);
		_pReturnMap.put("GW_NO", _gwNo);

		return _pReturnMap;
	}
	// 견적의뢰
	@SuppressWarnings("unchecked")
	public Map<String,String> updateSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "";
		String _qNo = "";
		String _gwNo = "N";
		Integer _qSeq = 1;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		String _passflag = "N";
		
		try{
			
			String passCheck = sqlSessionTemplate.selectOne("buyer.mp.rq.getPassCheck", formData);
			
			if (passCheck.equals("0")) { // 결재-N
				
			} else { // 결재-Y
				String passFlag = sqlSessionTemplate.selectOne("buyer.mp.rq.getPassFlag", formData);
				if (passFlag.equals("N")){
					_passflag = "C";
				} else {
					_passflag = "Y";
				}
			}
			
			if ("N".equals(_passflag) || "Y".equals(_passflag)){
					for(int i=0; i < gridData.size(); i++){

						formData.putAll((Map<String, String>)gridData.get(i));
						if (i == 0){
						_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
						_rtnMsg = _qNo;
						if ("Y".equals(_passflag)){
							_gwNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "NG");
						}
					}
					formData.put("QUOTATION_NO", _qNo);
					formData.put("QUOTATION_SEQ", _qSeq.toString());
					if ("N".equals(_passflag)){
						formData.put("RECV_FLAG", "NW");
					} else {
						formData.put("RECV_FLAG", "TS");
					}
					formData.put("GW_NO", _gwNo);
					sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReqStnd", formData);
					_qSeq++;
					
					//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
					formData.put("DOC_NO", formData.get("st_image_key"));
					sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
				}		
				
				if (formData.get("excel_up").equals("Y")){
					sqlSessionTemplate.update("buyer.mprq.setMpRqAddDel", formData);
				}
			}
			
		}catch(Exception e){
			_rtnMsg = "견적생성에 실패하였습니다.";
			logger.error(_rtnMsg, e);
			throw new RuntimeException(_rtnMsg, e);
		}

		_pReturnMap.put("MSG", _rtnMsg);
		_pReturnMap.put("GW_NO", _gwNo);
		_pReturnMap.put("passflag", _passflag);

		return _pReturnMap;
	}
	@SuppressWarnings("unchecked")
	public Map<String,String> updateSelectedData_v2(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "";
		String _qNo = "";
		String _gwNo = "N";
		Integer _qSeq = 1;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		String _passflag = "N";
		
		try{
			
			String passCheck = sqlSessionTemplate.selectOne("buyer.mp.rq.getPassCheck", formData);
			
			if (passCheck.equals("0")) { // 결재-N
				
			} else { // 결재-Y
				String passFlag = sqlSessionTemplate.selectOne("buyer.mp.rq.getPassFlag", formData);
				if (passFlag.equals("N")){
					_passflag = "C";
				} else {
					_passflag = "Y";
				}
			}
			
			if ("N".equals(_passflag) || "Y".equals(_passflag)){
					for(int i=0; i < gridData.size(); i++){

						formData.putAll((Map<String, String>)gridData.get(i));
						if (i == 0){
						_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
						_rtnMsg = _qNo;
						if ("Y".equals(_passflag)){
							_gwNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "NG");
						}
					}
					formData.put("QUOTATION_NO", _qNo);
					formData.put("QUOTATION_SEQ", _qSeq.toString());
					if ("N".equals(_passflag)){
						formData.put("RECV_FLAG", "NW");
					} else {
						formData.put("RECV_FLAG", "TS");
					}
					formData.put("GW_NO", _gwNo);
					sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReqStnd_v2", formData);
					_qSeq++;
					
					//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
					formData.put("DOC_NO", formData.get("st_image_key"));
					sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
				}		
				
				if (formData.get("excel_up").equals("Y")){
					sqlSessionTemplate.update("buyer.mprq.setMpRqAddDel", formData);
				}
			}
			
		}catch(Exception e){
			_rtnMsg = "견적생성에 실패하였습니다.";
			logger.error(_rtnMsg, e);
			throw new RuntimeException(_rtnMsg, e);
		}

		_pReturnMap.put("MSG", _rtnMsg);
		_pReturnMap.put("GW_NO", _gwNo);
		_pReturnMap.put("passflag", _passflag);

		return _pReturnMap;
	}

	// 견적의뢰 임시저장
	@SuppressWarnings("unchecked")
	public Map<String,String> updateSelectedDataTemp(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "";
		String _qNo = "";
		String _gwNo = "N";
		Integer _qSeq = 1;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		String _passflag = "N";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				if (i == 0){
					_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
					_rtnMsg = _qNo;
				}

				formData.put("QUOTATION_NO", _qNo);
				formData.put("QUOTATION_SEQ", _qSeq.toString());
				formData.put("RECV_FLAG", "TS");
				formData.put("GW_NO", _gwNo);
				sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReqStnd", formData);
				_qSeq++;
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			}
			
			if (formData.get("excel_up").equals("Y")){
				sqlSessionTemplate.update("buyer.mprq.setMpRqAddDel", formData);
			}
		}catch(Exception e){
			_rtnMsg = "견적 임시저장에 실패하였습니다.";
			logger.error(_rtnMsg, e);
			throw new RuntimeException(_rtnMsg, e);
		}

		_pReturnMap.put("MSG", _rtnMsg);
		_pReturnMap.put("GW_NO", _gwNo);
		_pReturnMap.put("passflag", _passflag);

		return _pReturnMap;
	}
	// 견적의뢰 임시저장
	@SuppressWarnings("unchecked")
	public Map<String,String> updateSelectedDataTemp_v2(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "";
		String _qNo = "";
		String _gwNo = "N";
		Integer _qSeq = 1;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		String _passflag = "N";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				if (i == 0){
					_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
					_rtnMsg = _qNo;
				}

				formData.put("QUOTATION_NO", _qNo);
				formData.put("QUOTATION_SEQ", _qSeq.toString());
				formData.put("RECV_FLAG", "TS");
				formData.put("GW_NO", _gwNo);
				sqlSessionTemplate.insert("buyer.mp.rq.insertQuotationReqStnd_v2", formData);
				_qSeq++;
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			}
			
			if (formData.get("excel_up").equals("Y")){
				sqlSessionTemplate.update("buyer.mprq.setMpRqAddDel", formData);
			}
		}catch(Exception e){
			System.out.println("테스트 : "+e.getMessage());
			_rtnMsg = "견적 임시저장에 실패하였습니다.";
			logger.error(_rtnMsg, e);
			throw new RuntimeException(_rtnMsg, e);
		}

		_pReturnMap.put("MSG", _rtnMsg);
		_pReturnMap.put("GW_NO", _gwNo);
		_pReturnMap.put("passflag", _passflag);

		return _pReturnMap;
	}
	// GPL, 미계약, 단종 건 견적의뢰 임시저장
	@SuppressWarnings("unchecked")
	public Map<String,String> updateSelectedDataTempGpl(Map<String,String> formData) {

		String createOk = "CREATE_OK";
		String _rtnMsg = "";
		String _qNo = "";
		String _query = formData.get("st_query").toString();

		
		Integer _qSeq = 1;
		Map<String, String> _pReturnMap = new HashMap<String, String>();
		
		String _passflag = "N";
		
		try{
			String  _ICOMCART[] = _query.split("&&");

			for(int i=0; i < _ICOMCART.length; i++){
				String str[] =  _ICOMCART[i].split("@@");
				if (i == 0){
					_qNo = masterMpRqBuyerReqDao.nextVal(formData.get("st_buyer"), "RE");
					_rtnMsg = _qNo;
				}
				
				formData.put("QUOTATION_NO", _qNo);
				formData.put("QUOTATION_SEQ", _qSeq.toString());
				formData.put("RECV_FLAG", "TS");
				formData.put("BUYER_ITEM_NO", str[0]);
				formData.put("ORDER_QTY", str[1]);  
				formData.put("AGENT", str[2]);
				formData.put("CONTRACT_NO", str[3]);
				formData.put("CONTRACT_SEQ", str[4]);
				formData.put("BYIT_COMORG_CODE", str[5]);
				formData.put("REQ_TYPE", str[6]);	// 상품 타입
				if(str[6].equals("R")){	// 추천상품
					sqlSessionTemplate.update("buyer.mp.rq.insertQuotationReqR", formData);
				}else{	// 미계약상품, 기등록상품(단종)
					sqlSessionTemplate.update("buyer.mp.rq.insertQuotationReqN", formData);
				}
				_qSeq++;
				
			}
			
		}catch(Exception e){
			_rtnMsg = "견적 임시저장에 실패하였습니다.";
			createOk = "";
			logger.error(_rtnMsg, e);
			throw new RuntimeException(_rtnMsg, e);
		}
		
		_pReturnMap.put("MSG2", _rtnMsg);
		_pReturnMap.put("passflag", _passflag);
		_pReturnMap.put("MSG", createOk);
		
		return _pReturnMap;
	}
}
