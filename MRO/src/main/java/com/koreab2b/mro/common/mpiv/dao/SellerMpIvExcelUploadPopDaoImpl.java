package com.koreab2b.mro.common.mpiv.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoCartUploadDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("sellerMpIvExcelUploadPopDao")
@Transactional
public class SellerMpIvExcelUploadPopDaoImpl implements SellerMpIvExcelUploadPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartUploadDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvExcelUploadPopList", formData);
	}
	public List<Map<String,String>> getSellerMpIvExcelUploadPop_v2(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvExcelUploadPop_v2", formData);
	}
	
	// 엑셀업로드 (TMP)
	public String saveExcelUp(Map<String,String>  formData) {
		try{
			// 기존 TMP 데이터 삭제
			sqlSessionTemplate.update("seller.mpiv.setMpIvAddDel", formData);

			String st_query = formData.get("result").toString();
			Map<String,String> _data = null;
		 
			String  _EXCELDATA[] = st_query.split("\\|"); 
			if (_EXCELDATA == null){
				LOGGER.debug("_EXCELDATA 미존재 ");
			}else{
				for( int i=0 ; i < _EXCELDATA.length; i++){ 					 
					if (i>0){
						String str[] =  _EXCELDATA[i].split("@@",-1);  					 
						_data = new HashMap<String,String>() ;
						_data.put("st_user_id", formData.get("st_user_id"));
						_data.put("st_com_code", formData.get("st_com_code"));
						_data.put("st_excel_type", formData.get("st_excel_type"));

						_data.put("BUYER_CODE", CommonUtil.nvl(str[0],""));
						_data.put("INV_NO", CommonUtil.nvl(str[1],""));
						_data.put("PARCEL_COM_CODE", CommonUtil.nvl(str[2],""));
						_data.put("PARCEL_INV_NO", CommonUtil.nvl(str[3],""));

						sqlSessionTemplate.update("seller.mpiv.insertMpIvAddTemp", _data);		  
					}
				}
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("엑셀 업로드를 실패하였습니다.");
		}
		return "OK";
	}
	
	@SuppressWarnings("unchecked")
	public String setMpIvExcelUp_v2(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "";
		sqlSessionTemplate.update("seller.mpiv.setMpIvAddDel", formData);
		
		int _count = 0;
		
		_rtnMsg = "정상적으로 업로드 되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				// 엑셀 업로드 결과 ICOMCART_TMP 삽입
				_count = sqlSessionTemplate.update("seller.mpiv.insertMpIvAddTemp", formData);
				
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
	// 엑셀 TMP 테이블 삭제
	public String delExcelUp(Map<String,String>  formData) {
		try{
			sqlSessionTemplate.update("seller.mpiv.setMpIvAddDel", formData);
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("임시테이블 내역 삭제를 실패하였습니다.");
		}
		return "OK";
	}
}
