package com.koreab2b.mro.master.mpif.service;

import java.util.Map;

public interface MasterMpifExternService {

	public String getCAULoginCheck(Map<String, String> pMap);

	public Map<String, String> getHansLoginCheck(Map<String, String> pMap);

}