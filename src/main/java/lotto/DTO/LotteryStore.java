package lotto.DTO;

public class LotteryStore {
	private int id;
    private String name;
    private String roadAddress;
    private String landAddress;
    private Double latitude;
    private Double longitude;
    private String region;
    private boolean isWinner;
	public LotteryStore(int id, String name, String roadAddress, String landAddress, Double latitude, Double longitude,
			String region, boolean isWinner) {
		super();
		this.id = id;
		this.name = name;
		this.roadAddress = roadAddress;
		this.landAddress = landAddress;
		this.latitude = latitude;
		this.longitude = longitude;
		this.region = region;
		this.isWinner = isWinner;
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
	public String getRoadAddress() {
		return roadAddress;
	}
	public void setRoadAddress(String roadAddress) {
		this.roadAddress = roadAddress;
	}
	public String getLandAddress() {
		return landAddress;
	}
	public void setLandAddress(String landAddress) {
		this.landAddress = landAddress;
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
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public boolean isWinner() {
		return isWinner;
	}
	public void setWinner(boolean isWinner) {
		this.isWinner = isWinner;
	}
    
    
}
