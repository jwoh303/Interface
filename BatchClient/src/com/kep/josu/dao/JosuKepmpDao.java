package com.kep.josu.dao;

import java.util.List;
import java.util.Map;

public interface JosuKepmpDao {

	//kepmp에서 조선호텔 예산 관련 정보 조회 
	public List<Map<String, String>> selectbdgtList() throws Exception;

	//kepmp에서 조선호텔 예산 관련 정보 insert
	public int insertBdgt(Map<String, Object> paramMap) throws Exception;

	//사용예산 조선호텔에 전송 후 결과 값 update
	public void updateResult(Map<String, Object> paramMap) throws Exception;

	//kepmp 에서 조선 호텔로 보낼 데이터 조회
	public List<Map<String, Object>> selectbdgtSendList(Map<String, Object> map) throws Exception;

	//kepmp.IF_JHTL_PRDT_SEND 에서 조선 호텔로 보낸 데이터 플래그 처리
	public void updateIfFlag(Map<String, Object> updateMap) throws Exception;

	//보낸 icomprdt 데이터 플래그 처리
	public void updateRevFlag(Map<String, Object> updateMap) throws Exception;

	//예산 동기화 후에 처리 프로시져 실행
	public void callProcBdgt() throws Exception;

	//kepmp 에서 조선 호텔로 보낼 헤더 데이터 조회 
	public List<Map<String, Object>> selectbdgtSendListHd() throws Exception;

	//조선 호텔 디비 컨넥션 체크 vpn 연결 이슈 
	public void insertJosuDbChk(Map<String, Object> selectMap) throws Exception;

	//전송될 마감 데이터 조회
	public List<Map<String, Object>> selectFiClose(Map<String, String> map) throws Exception;
}
