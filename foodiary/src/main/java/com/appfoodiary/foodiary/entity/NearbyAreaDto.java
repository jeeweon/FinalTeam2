package com.appfoodiary.foodiary.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class NearbyAreaDto {
	private int areaNo;
	private int nearbyNo;
}
