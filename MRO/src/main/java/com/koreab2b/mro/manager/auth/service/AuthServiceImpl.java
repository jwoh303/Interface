package com.koreab2b.mro.manager.auth.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.manager.auth.dao.AuthDao;
import com.koreab2b.mro.manager.auth.domain.Auth;

@Service("authService")
public class AuthServiceImpl implements AuthService {
	@Autowired
	private AuthDao authDao;

	public List<Auth> getAuths(Auth pAuth) {
		return authDao.selectAuths(pAuth);
	}

	public Auth getAuth(String pAuthId) {
		return authDao.selectAuthByAuthId(pAuthId);
	}

	public void saveAuth(Auth pAuth) {
		Auth _auth = authDao.selectAuthByAuthId(pAuth.getAuthId());
		if (_auth != null) {
			authDao.updateAuth(pAuth);
		} else {
			authDao.insertAuth(pAuth);
		}
	}

	public void deleteAuth(String[] pAuthCodes) {
		for (String _tmpAuthCode : pAuthCodes) {
			authDao.deleteAuth(_tmpAuthCode);
		}
	}

	public List<String> getAuthIdsByUserId(String pUserId) {
		return authDao.selectAuthIdsByUserId(pUserId);
	}

	public List<String> getAuthIdsByMenuNo(String pMenuNo) {
		return authDao.selectAuthIdsByMenuId(pMenuNo);
	}

	public List<String> getAuthIds() {
		return authDao.selectAuthIds();
	}

}
