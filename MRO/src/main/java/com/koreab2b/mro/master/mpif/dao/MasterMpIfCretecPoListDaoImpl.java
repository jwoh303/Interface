package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpIfCretecPoListDao")
@Transactional
public class MasterMpIfCretecPoListDaoImpl implements MasterMpIfCretecPoListDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfCretecPoListDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	//리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectList(Map<String, Object> pMap) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		sqlSessionTemplate.select("master.mpif.selectMasterMpIfCretecPoList", pMap, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		return resultList;
	}
	
	//크레텍 발주 리스트 상세 팝업
	@Override
	public List<Map<String,String>> selectMpIfCretecPoListPop(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpif.selectMpIfCretecPoListPop", pMap);
	}

	//재전송 버튼 로직
	@Override
	public String submitMpIfCretecPoListPop(Map<String,String> pMap){
		try{
			String recvFlag=pMap.get("st_recv_flag");
			String resendReason=pMap.get("resendReason");
			String confirmResend=pMap.get("confirmResend");

			if(!"proc".equals(recvFlag)){
				throw new RuntimeException("올바르지 않은 요청입니다.");
			}
			if(resendReason==null||"".equals(resendReason.trim())){
				throw new RuntimeException("재전송 사유를 입력해 주세요.");
			}
			if(!"Y".equals(confirmResend)){
				throw new RuntimeException("기존 협력사 발주 상태와 필요한 후속 조치를 확인하고 체크 후 진행해 주세요.");
			}

			pMap.put("resendReason",resendReason.trim());

			Map<String,Object> checkData=sqlSessionTemplate.selectOne("master.mpif.selectMpIfCretecPoResendCheck",pMap);

			if(checkData==null){
				throw new RuntimeException("재전송 대상 정보를 찾을 수 없습니다.");
			}
			if(!"Y".equals(String.valueOf(checkData.get("LATEST_YN")))){
				throw new RuntimeException("최신 차수만 재전송할 수 있습니다.");
			}
			if("Y".equals(String.valueOf(checkData.get("WAIT_YN")))){
				throw new RuntimeException("이미 전송 대기 중인 건입니다.");
			}
			if(!"Y".equals(String.valueOf(checkData.get("ORDER_EXISTS_YN")))){
				throw new RuntimeException("삭제되었거나 존재하지 않는 주문입니다.");
			}
			if("Y".equals(String.valueOf(checkData.get("DELIVERY_EXISTS_YN")))){
				throw new RuntimeException("납품서가 생성된 주문은 재전송할 수 없습니다.");
			}
			if(!"Y".equals(String.valueOf(checkData.get("SELLER_ITEM_EXISTS_YN")))){
				throw new RuntimeException("현재 공급사 품목코드가 없어 재전송할 수 없습니다.");
			}

			pMap.put("new_revision",String.valueOf(checkData.get("NEXT_REVISION")));

			int updateCount=sqlSessionTemplate.update("master.mpif.updateMpIfCretecPoOld",pMap);
			if(updateCount!=1){
				throw new RuntimeException("기존 전송정보 상태가 변경되었습니다. 다시 조회해 주세요.");
			}

			int insertCount=sqlSessionTemplate.update("master.mpif.insertMpIfCretecPoNew",pMap);
			if(insertCount!=1){
				throw new RuntimeException("재전송 데이터를 생성하지 못했습니다.");
			}

			return "OK";
		}catch(RuntimeException e){
			throw e;
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ",e);
			throw new RuntimeException("처리 하던중 오류가 발생하였습니다.");
		}
	}
}
