package com.koreab2b.mro.manager.user.dao;

import java.util.List;

import com.koreab2b.mro.manager.user.domain.UserAuth;

public interface UserAuthDao {
	List<UserAuth> selectUserAuthsByUserId(String pUserId);

	void insertUserAuth(UserAuth pUserAuth);

	void updateUserAuth(UserAuth pUserAuth);

	void deleteUserAuthByUserId(String pUserId);
}
