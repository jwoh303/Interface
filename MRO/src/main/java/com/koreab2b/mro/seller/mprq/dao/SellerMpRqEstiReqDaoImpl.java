package com.koreab2b.mro.seller.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("sellerMpRqEstiReqDao")
@Transactional
public class SellerMpRqEstiReqDaoImpl implements SellerMpRqEstiReqDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 
 
	/*조회*/
	public List<Map<String,String>> selectList(Map<String,String>  param) {
		return sqlSessionTemplate.selectList("seller.mprq.selectSellerMpRqEstiReqList", param);
	}
	
	/*등록요청*/
	@SuppressWarnings("unchecked")
	public String updateData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "정상적으로 견적제출 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));	
				
				String msds_flag = formData.get("chk_msds");
				if("Y".equals(msds_flag)){
					sqlSessionTemplate.update("seller.mprq.delSellerMpRqEstiReq", formData);
					sqlSessionTemplate.update("seller.mprq.delSellerMpRqEstiReqMsds", formData);		
				}else{
					sqlSessionTemplate.update("seller.mprq.delSellerMpRqEstiReq", formData);
				}
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);

		  }
		}catch(Exception e){
				throw new RuntimeException( "견적제출중 오류가 발생하였습니다.");
		}
		return _rtnMsg;
	} 

	
	/*포기*/
	@SuppressWarnings("unchecked")
	public String sellerMpRqEstiReqGiveUp(Map<String,String> formData, List<Object> gridData) {
		
		String _rtnMsg = "정상적으로 견적포기 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));	
				sqlSessionTemplate.update("seller.mprq.delSellerMpRqEstiReq", formData);
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("st_image_key"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			}
		}catch(Exception e){
				throw new RuntimeException("견적포기를 하던중 오류가 발생하였습니다");
		}
		return _rtnMsg;
	} 
	

	
}
