package com.koreab2b.lottecs.dao;

import java.util.Map;

public interface LottecsDao {

	// 입고
		public Map<String, Object> processLotteMpRqAppSend(Map<String, Object> pMap) throws Exception;
}
