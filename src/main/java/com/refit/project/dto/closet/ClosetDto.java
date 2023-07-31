package com.refit.project.dto.closet;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ClosetDto {
    private String cloth_path;
    private Integer id;
    private Integer closet_id;
    private String cloth_category;
    private String cloth_subcategory;
}
