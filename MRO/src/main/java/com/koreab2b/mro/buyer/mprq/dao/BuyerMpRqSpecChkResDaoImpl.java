package com.koreab2b.mro.buyer.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;


@Repository("buyerMpRqSpecChkResDao")
@Transactional
public class BuyerMpRqSpecChkResDaoImpl implements BuyerMpRqSpecChkResDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
 
	/*조회*/
	public List<Map<String,String>> selectList(Map<String,String>  param) {
		return sqlSessionTemplate.selectList("buyer.mp.rq.selectBuyerMpRqSpecChkResList", param);
	}
	
	/*등록요청*/
	@SuppressWarnings("unchecked")
	public String updateData(List<Object> gridData, Map<String, String> formData) {
		
		String _rtnMsg = "등록신청이 성공적으로 이루어 졌습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("buyer.mp.rq.updateBuyerMpRqSpecChkRes", formData);
			}
		}catch(Exception e){
				throw new RuntimeException("등록신청에 실패하였습니다.");
		}
		return _rtnMsg;
	} 

	/*장바구니 담기*/
	@SuppressWarnings("unchecked")
	public String insertData(List<Object> gridData, Map<String, String> formData) {
		
		String _rtnMsg = "장바구니 담기가 성공적으로 이루어 졌습니다.";
		List<Map<String,String>>_list = null;
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
//				sqlSessionTemplate.update("buyer.mp.rq.insertBuyerMpRqSpecChkRes", data);
				
				_list = sqlSessionTemplate.selectList("buyer.mp.rq.getItemNoCheck",formData);
				String check_flag = CommonUtil.getListKeyValue(_list,"DUP_CNT","0");
				if(check_flag.equals("0")){	
					sqlSessionTemplate.insert("buyer.mp.rq.insertBuyerMpRqSpecChkRes", formData);
					sqlSessionTemplate.update("buyer.mp.rq.endRequest",formData);
					
				}else{
					throw new RuntimeException("중복된 데이터가 존재합니다.");
				}		
			}
			
		}catch(Exception e){
				throw new RuntimeException("장바구니 담기에 실패하였습니다.");
		}
		return _rtnMsg;
	} 

	
	/*삭제*/
	@SuppressWarnings("unchecked")
	public String deleteData(List<Object> gridData, Map<String, String> formData) {
		
		String _rtnMsg = "삭제 작업이 성공적으로 이루어 졌습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("buyer.mp.rq.delBuyerMpRqSpecChkRes", formData);
			}
		}catch(Exception e){
				throw new RuntimeException("삭제에 실패하였습니다.");
		}
		return _rtnMsg;
	} 
}
