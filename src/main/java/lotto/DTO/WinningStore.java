package lotto.DTO;

public class WinningStore {
	private int id;
    private String name;
    private String region;
    private int winCount;
    private Double latitude;
    private Double longitude;
	public WinningStore(int id, String name, String region, int winCount, Double latitude, Double longitude) {
		super();
		this.id = id;
		this.name = name;
		this.region = region;
		this.winCount = winCount;
		this.latitude = latitude;
		this.longitude = longitude;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public int getWinCount() {
		return winCount;
	}
	public void setWinCount(int winCount) {
		this.winCount = winCount;
	}
	public Double getLatitude() {
		return latitude;
	}
	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}
	public Double getLongitude() {
		return longitude;
	}
	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}
    
    
    
    
}
