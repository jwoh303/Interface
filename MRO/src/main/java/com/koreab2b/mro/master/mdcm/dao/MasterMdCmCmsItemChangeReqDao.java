package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsItemChangeReqDao {

	// 상품정보 수정요청 현황 목록 (요청자 화면)
	public List<Map<String,String>> selectStatusList(Map<String,Object> param);

	// 상품정보 수정요청 승인 대기열 목록 (DB관리파트 화면)
	public List<Map<String,String>> selectReqList(Map<String,Object> param);

	// 처리 대기중(REQ)인 요청이 이미 있는지
	public int selectOpenReqCount(Map<String,Object> param);

	// 요청 등록 (헤더 1 + 변경항목 N). 채번한 요청번호를 돌려준다
	public String insertChangeReq(Map<String,Object> param, List<Map<String,String>> items);

	// 엑셀 일괄수정 경로의 요청 등록. 명칭→코드 복원까지 여기서 한다
	public String insertChangeReqFromExcel(Map<String,Object> param, List<Map<String,String>> items);

	// 요청취소. 실제로 취소된 건수를 돌려준다
	public int updateChangeReqCancel(Map<String,Object> param);

	// 비교 팝업 - 요청 헤더 1건 (요청 시점 스냅샷)
	public Map<String,String> selectHeader(Map<String,Object> param);

	// 비교 팝업 / 승인 반영 - 그 요청의 변경항목 전체
	public List<Map<String,String>> selectDtList(Map<String,Object> param);

	// 승인. 상태 전이 + CMSCATLG 반영 + 이력적재까지. 실제로 승인된 건수를 돌려준다
	public int approveChangeReq(Map<String,Object> param);

	// 반려. 실제로 반려된 건수를 돌려준다
	public int rejectChangeReq(Map<String,Object> param);
}
