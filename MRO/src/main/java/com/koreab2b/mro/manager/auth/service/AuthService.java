package com.koreab2b.mro.manager.auth.service;

import java.util.List;

import com.koreab2b.mro.manager.auth.domain.Auth;

public interface AuthService {

	List<Auth> getAuths(Auth pAuth);

	Auth getAuth(String pAuthCode);

	void saveAuth(Auth pAuth);

	void deleteAuth(String[] pAuthCodes);

	List<String> getAuthIdsByUserId(String pUserId);

	List<String> getAuthIdsByMenuNo(String pMenuNo);
	
	List<String> getAuthIds();
}
