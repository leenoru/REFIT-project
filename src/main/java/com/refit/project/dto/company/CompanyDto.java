package com.refit.project.dto.company;

import lombok.*;
@Getter
@Setter
@ToString
public class CompanyDto {
    private int company_id;
    private String company_name;
    private String company_url;
    private String company_email;
    private String company_phone;
    private String company_service_location;
}
