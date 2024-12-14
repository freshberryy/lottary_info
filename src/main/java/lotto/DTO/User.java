package lotto.DTO;

public class User {
	private int id; // 유저 고유 ID (Primary Key)
    private String username; // 유저 이름 (로그인용 ID)
    private String password; // 유저 비밀번호
    private String role; // 역할 (user/admin)
    private String createdAt;
	public User(int id, String username, String password, String role, String createdAt) {
		super();
		this.id = id;
		this.username = username;
		this.password = password;
		this.role = role;
		this.createdAt = createdAt;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
    
    
}
