package com.koreab2b.mro.manager.auth.dao;

import java.util.List;

import com.koreab2b.mro.manager.auth.domain.Auth;

public interface AuthDao {
	List<Auth> selectAuths(Auth pAuth);

	Auth selectAuthByAuthId(String pAuthCode);

	void insertAuth(Auth pAuth);

	void updateAuth(Auth pAuth);

	void deleteAuth(String pAuthCode);

	List<String> selectAuthIdsByUserId(String pUserId);
	
	List<String> selectAuthIdsByMenuId(String pMenuNo);
	
	List<String> selectAuthIds();
}
