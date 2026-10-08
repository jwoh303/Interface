package com.kep.josu.dao;

import java.util.List;
import java.util.Map;

public interface JosuBudgetDao {

	//조선호텔 예산 조회
	void selectBudget(Map<String, Object> paramMap) throws Exception;

	//조선호텔 예산 업데이트
	void updateBudget(Map<String, Object> paramMap) throws Exception;

	//조선호텔 마감 전송
	void insertFiClose(Map<String, Object> map) throws Exception;

	//마감 seq 가져오기
	int selectSeqCnt() throws Exception;


}
