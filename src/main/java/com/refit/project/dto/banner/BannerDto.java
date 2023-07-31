package com.refit.project.dto.banner;

import lombok.*;

@Getter
@Setter
@ToString
public class BannerDto {
    private int banner_id;
    private int campaign_id;
    private String campaign_url;
    private String banner_photo;
    private String start_date;
    private String end_date;

}
