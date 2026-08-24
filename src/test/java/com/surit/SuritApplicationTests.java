package com.surit;

import static org.junit.jupiter.api.Assertions.assertFalse;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
=======
import org.junit.jupiter.api.Test;
>>>>>>> 2480897aac4b142965fa880747f9c964acee1ca7
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class SuritApplicationTests {
	@Autowired
	DataSource dataSource;

	@Test
	void testConnection() throws SQLException {
		try (Connection conn = dataSource.getConnection()) {
			System.out.println("연결 성공: " + conn.getMetaData().getURL());
			assertFalse(conn.isClosed());
		}

	}
}
