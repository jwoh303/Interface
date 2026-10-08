package com.koreab2b.mro.common.mpso.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.controller.BuyerMpSoCartUploadController;
import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;

@Repository("masterMpSoPrewarhsngRequestAllRegPopDao")
@Transactional
public class MasterMpSoPrewarhsngRequestAllRegPopDaoImpl implements MasterMpSoPrewarhsngRequestAllRegPopDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartUploadController.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	private String _rtnMsg = "";
	
	// 선입고요청 등록(일괄) : 엑셀파일 데이터 임시 테이블 저장 및 조회
	public String saveExcelUp(Map<String,String>  formData) {
		
		try{
			
			// 임시 데이터 삭제
			sqlSessionTemplate.update("common.mpso.deleteMasterMpSoPrewarhsngRequestAllReg", formData);
			
			String st_query = formData.get("result").toString();
			String buyer = formData.get("st_buyer_code");
			Map<String,String> _data = null;
			
			String  _ICOMCART[] = st_query.split("\\|"); 
			 if (_ICOMCART == null){
				 LOGGER.debug("_ICOMCART 미존재 ");
			 }else{
				 for( int i=0 ; i < _ICOMCART.length; i++){
					 if (i>0){
						 String str[] =  _ICOMCART[i].split("@@",-1);
						 _data = new HashMap<String,String>() ;
						 
						 _data.put("file_name", formData.get("file_name"));			//	파일이름
						 _data.put("upload_date", formData.get("upload_date"));		//	업로드일
						 _data.put("row_num", String.valueOf(i));							//	행번호
						 _data.put("buyer", buyer);												//	고객사코드
						 _data.put("req_user_id", str[0]);										//	요청자ID
						 _data.put("req_user_tel_no", str[1]);									//	요청자연락처
						 _data.put("req_user_dept_code", str[2]);							//	요청부서코드
						 _data.put("before_gr_date", str[3]);									//	선입고일
						 _data.put("buyer_item_no", str[4]);									//	품목코드
						 _data.put("description", str[5]);										//	품목명
						 _data.put("specification", str[6]);									//	규격
						 _data.put("maker_code", str[7]);										//	제조사(코드)
						 _data.put("origin_code", str[8]);										//	원산지(코드)
						 _data.put("unit_price", str[9]);										//	매출단가
						 _data.put("agent_price", str[10]);									//	매입단가
						 _data.put("item_qty", str[11]);										//	수량
						 _data.put("unit_measure", str[12]);									//	단위
						 _data.put("process_type", str[13]);									//	거래유형(코드)
						 _data.put("warehouse_code", str[14]);								//	물류센터(코드)
						 _data.put("agent_code", str[15]);									//	협력사코드
						 _data.put("agent_user_id", str[16]);									//	협력사담당자ID
						 _data.put("agent_tel_no", str[17]);									//	협력사담당자연락처
						 _data.put("kep_user_id", formData.get("kep_user_id"));		//	KeP담당자ID
						 _data.put("kep_user_name", formData.get("kep_user_name"));	//	KeP담당자명
						 _data.put("dely_to_location", str[18]);								//	배송지
						 _data.put("remark", str[19]);											//	비고

						 // 임시데이터 등록
						 sqlSessionTemplate.update("common.mpso.insertMasterMpSoPrewarhsngRequestRegTemp", _data);		  
					 }
				 }
			 }
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("선입고 요청 일괄 등록 업로드 실패하였습니다.");
		}
		
		return "OK";
	}

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoPrewarhsngRequestAllRegPopList", formData);
	}
	
	// 선입고 요청 등록
	@SuppressWarnings("unchecked")
	public String updateMasterMpSoPrewarhsngRequestAllRegPop(Map<String,String>  formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		_rtnMsg = "저장완료.";
		
		Map<String,String> tempMap = new HashMap<String, String>();
		tempMap.put("file_name", formData.get("file_name"));
		tempMap.put("upload_date", formData.get("upload_date"));
		
		try{
			String bs_no = "";
			String buyer_code = formData.get("st_buyer_code");
			
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				bs_no = buyerMpSoOrderInfoDao.getOrderNo(buyer_code,"BS");
				formData.put("BUYER_CODE", buyer_code);
				formData.put("BS_NO", bs_no);
				formData.put("CLOSE_ITEM_QTY", "");
				formData.put("STATUS", "");
				formData.put("PO_NO", "");
				
				sqlSessionTemplate.update("master.mpso.insertMasterMpSoPrewarhsngOrderManage", formData);
			}
			
			// 임시 데이터 삭제
			sqlSessionTemplate.update("common.mpso.deleteMasterMpSoPrewarhsngRequestAllReg", tempMap);
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
}
