package com.refit.project.controller.share;

import java.time.Instant;

public class Duration {

    public static String getDuration (long createdUnixTime) {

        long currentTimestamp = Instant.now().getEpochSecond();
        Instant createdAtInstant = Instant.ofEpochSecond(createdUnixTime);

        java.time.Duration duration = java.time.Duration.between(createdAtInstant, Instant.ofEpochSecond(currentTimestamp));
        long minutes = duration.toMinutes();
        long hours = duration.toHours();
        long days = duration.toDays();

        String formattedCreatedAt;
        if (minutes <= 5) {
            formattedCreatedAt = "방금 전";
        } else if (minutes < 60) {
            formattedCreatedAt = minutes + "분 전";
        } else if (hours < 24) {
            formattedCreatedAt = hours + "시간 전";
        } else {
            formattedCreatedAt = days + "일 전";
        }
        return formattedCreatedAt;
    }
}
