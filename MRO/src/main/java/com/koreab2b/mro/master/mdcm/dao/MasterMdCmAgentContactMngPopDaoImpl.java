package com.koreab2b.mro.master.mdcm.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

import oracle.net.aso.i;

@Repository("masterMdCmAgentContactMngDao")
@Transactional
public class MasterMdCmAgentContactMngPopDaoImpl implements MasterMdCmAgentContactMngPopDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	private String ORIGIN_PREFIX = "ORIGIN_";

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectList(Map<String, Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mdcm.selectMasterMdCmContactMngList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}
	
	// 협력사 연락처 설정 저장
	@SuppressWarnings("unchecked")
	public String saveMasterMdcmAgentContactMngPop(Map<String,String> formData, List<Object> gridData) {
		String separator = "@@";
		String[] delSeqArr = null;
		String pageTitle = "협력사 연락처 설정";
		
		_rtnMsg = pageTitle + " 저장이 완료되었습니다.";
		
		try {
			for ( int i = 0; i < gridData.size(); i++ ) {
				List<String> originKeyList = new ArrayList<String>();
				int chageCnt = 0;
				formData.putAll((Map<String, String>)gridData.get(i));

				// 관리자 정보가 들어온 경우 continue
				if(formData.get("MASTER_FLG") != null && formData.get("MASTER_FLG").toString().equals("0")) continue;

				// 협력사 연락처 기존 설정 가져오기
				Map<String, String> originMap = sqlSessionTemplate.selectOne("master.mdcm.getMasterMdCmContactMng", formData);

				// 협력사 연락처 설정 저장
				sqlSessionTemplate.update("master.mdcm.saveMasterMdcmAgentContactMng", formData);

				// origin data init
				String[] initOriginArray = {"ORIGIN_RECV_STATUS", "ORIGIN_RECV_MAIL", "ORIGIN_RECV_MOBILE_NUMBER", "ORIGIN_RECV_NAME", "ORIGIN_RECV_REMARK", "ORIGIN_RECV_OPTION"};
				for(String key : initOriginArray) {
					formData.put(key, ""); // 공백으로 초기값 입력
				}

				// 가져온 데이터가 없는 경우 신규 추가
				if(originMap == null) {
					formData.put("RECV_STATUS", "C");
					// 협력사 연락처 설정 신규 생성 이력 저장
					sqlSessionTemplate.update("master.mdcm.saveMasterMdcmAgentContactMngHistory", formData);
				} else { // 들어오면 변경 : 안들어오면 삭제
					formData.put("RECV_STATUS", "C");
					originKeyList.add(ORIGIN_PREFIX + "RECV_STATUS");
					// 변경 데이터 확인
					for(String key : originMap.keySet()) {
						// 기존값과 form값이 다르다면 origin 데이터 삽입
						if(formData.get(key) != null && !originMap.get(key).toString().equals(formData.get(key).toString())) {
							// formData에 이력용 origin 데이터 추가
							formData.put(ORIGIN_PREFIX+key, originMap.get(key));

							// 변경값이 1개라도 있다면 R로 업데이트
							formData.put("RECV_STATUS", "R");
							// origin status도 업데이트 
							formData.put(ORIGIN_PREFIX + "RECV_STATUS", originMap.get("RECV_STATUS"));
							
							// 삭제를 위한 key값 저장
							originKeyList.add(ORIGIN_PREFIX + key);
							chageCnt++;
						}else { // 이력용 기존 데이터도 origin과 함께 삭제
							formData.put(key, ""); // origin 데이터 공백으로 변경
						}
					}

					// 협력사 연락처 설정 변경 이력 저장
					if(chageCnt > 0) { // 상태값을 제외하고 변경이력이 1건 이상 있다면
						sqlSessionTemplate.update("master.mdcm.saveMasterMdcmAgentContactMngHistory", formData);
					}

					// 변경 이력용 param이 존재한다면 삭제
					for(String originKey : originKeyList) {
						formData.remove(originKey);
					}
				}
			}

			// 협력사 연락처 설정 삭제 및 이력 저장
			String delSeq = formData.get("del_SEQ");
			if(delSeq != null && delSeq != "") {
				formData.put("RECV_STATUS", "D");
				// 삭제건수가 복수인 경우
				if(delSeq.contains(separator)) {
					delSeqArr = delSeq.split(separator);
					for(String delSeqVal :delSeqArr) {
						// pk세팅
						formData.put("RECV_SEQ", delSeqVal);
						
						// 협력사 연락처 기존 설정 가져오기
						Map<String, String> originMap = sqlSessionTemplate.selectOne("master.mdcm.getMasterMdCmContactMng", formData);
						// origin status도 업데이트 
						formData.put(ORIGIN_PREFIX + "RECV_STATUS", originMap.get("RECV_STATUS"));

						// 삭제처리
						sqlSessionTemplate.update("master.mdcm.deleteMasterMdcmAgentContactMng", formData);
						// 이력용 flg 세팅
						formData.put("history_pk", delSeqVal);
						// 삭제 이력 저장
						sqlSessionTemplate.update("master.mdcm.saveMasterMdcmAgentContactMngHistory", formData);
						formData.remove("history_pk");
					}
				} else { // 단건인 경우
					// 협력사 연락처 기존 설정 가져오기
					formData.put("RECV_SEQ", delSeq);
					Map<String, String> originMap = sqlSessionTemplate.selectOne("master.mdcm.getMasterMdCmContactMng", formData);
					// origin status도 업데이트 
					formData.put(ORIGIN_PREFIX + "RECV_STATUS", originMap.get("RECV_STATUS"));
					// 삭제 처리
					formData.put("RECV_SEQ", delSeq);
					sqlSessionTemplate.update("master.mdcm.deleteMasterMdcmAgentContactMng", formData);
					// 이력용 flg 세팅
					formData.put("history_pk", delSeq);

					// 삭제 이력 저장
					sqlSessionTemplate.update("master.mdcm.saveMasterMdcmAgentContactMngHistory", formData);
					formData.remove("history_pk");
				}
			}
		} catch (Exception e){
			throw new RuntimeException(pageTitle + " 저장에 실패하였습니다.");
		}

		return _rtnMsg;
	}
}
