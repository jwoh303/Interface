package com.koreab2b.mro.manager.auth.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.manager.auth.domain.Auth;

@Repository("authDao")
@Transactional
public class AuthDaoImpl implements AuthDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<Auth> selectAuths(Auth pAuth) {
		return sqlSessionTemplate.selectList("auth.selectAuths", pAuth);
	}

	public Auth selectAuthByAuthId(String pAuthCode) {
		return sqlSessionTemplate.selectOne("auth.selectAuthByAuthId", pAuthCode);
	}

	public void insertAuth(Auth pAuth) {
		sqlSessionTemplate.insert("auth.insertAuth", pAuth);
	}

	public void updateAuth(Auth pAuth) {
		sqlSessionTemplate.update("auth.updateAuth", pAuth);
		throw new RuntimeException();
	}

	public void deleteAuth(String pAuthCode) {
		sqlSessionTemplate.update("auth.deleteAuthByAuthId", pAuthCode);
	}

	public List<String> selectAuthIdsByUserId(String pUserId) {
		return sqlSessionTemplate.selectList("auth.selectAuthIdsByUserId", pUserId);
	}

	public List<String> selectAuthIdsByMenuId(String pMenuId) {
		return sqlSessionTemplate.selectList("auth.selectAuthIdsByMenuId", pMenuId);
	}

	public List<String> selectAuthIds() {
		return sqlSessionTemplate.selectList("auth.selectAuthIds");
	}
}
