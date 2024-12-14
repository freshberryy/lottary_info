package lotto.DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import lotto.DTO.WinningStore;

public class WinningStoresDAO {

    private static final String DB_URL = "jdbc:mysql://ls-f8dc441f16b317431a0c626ef5cd85578e5485cc.c9awuy0mqmj5.ap-northeast-2.rds.amazonaws.com:3306/lotto"; // DB URL
    private static final String DB_USER = "dbmasteruser"; // DB 사용자명
    private static final String DB_PASSWORD = "98899889"; // DB 비밀번호

    // DB 연결 가져오기
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    // 데이터 삽입
    public void insertWinningStore(int id, String name, String region, int winCount) {
        String sql = "INSERT INTO winning_stores (id, name, region, win_count) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.setString(2, name);
            pstmt.setString(3, region);
            pstmt.setInt(4, winCount);
            pstmt.executeUpdate();
            System.out.println("데이터 삽입 성공: " + name);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 삽입 실패: " + e.getMessage());
        }
    }

    // 데이터 조회 (전체)
    public List<WinningStore> getAllWinningStores() {
        String sql = "SELECT * FROM winning_stores";
        List<WinningStore> stores = new ArrayList<>();
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                WinningStore store = new WinningStore(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("region"),
                    rs.getInt("win_count")
                );
                stores.add(store);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 조회 실패: " + e.getMessage());
        }
        return stores;
    }

    // 데이터 조회 (ID로 검색)
    public WinningStore getWinningStoreById(int id) {
        String sql = "SELECT * FROM winning_stores WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new WinningStore(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("region"),
                        rs.getInt("win_count")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 조회 실패: " + e.getMessage());
        }
        return null;
    }

    // 데이터 업데이트
    public void updateWinningStore(int id, String name, String region, int winCount) {
        String sql = "UPDATE winning_stores SET name = ?, region = ?, win_count = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            pstmt.setString(2, region);
            pstmt.setInt(3, winCount);
            pstmt.setInt(4, id);
            pstmt.executeUpdate();
            System.out.println("데이터 업데이트 성공: " + name);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 업데이트 실패: " + e.getMessage());
        }
    }

    // 데이터 삭제
    public void deleteWinningStore(int id) {
        String sql = "DELETE FROM winning_stores WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            System.out.println("데이터 삭제 성공: ID = " + id);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("데이터 삭제 실패: " + e.getMessage());
        }
    }
}

